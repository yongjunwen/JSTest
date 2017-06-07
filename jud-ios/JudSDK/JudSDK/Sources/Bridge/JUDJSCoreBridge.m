/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDJSCoreBridge.h"
#import "JUDDefine.h"
#import "JUDAssert.h"
#import "JUDLog.h"
#import "JUDDefine.h"
#import "JUDUtility.h"
#import "JUDSDKEngine.h"
#import "JUDSDKError.h"
#import "JUDMonitor.h"
#import "JUDAppMonitorProtocol.h"
#import "JUDHandlerFactory.h"
#import <sys/utsname.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "JUDPolyfillSet.h"
#import "JSValue+Jud.h"

#import <dlfcn.h>

#import <mach/mach.h>


@interface JUDJSCoreBridge ()

@property (nonatomic, strong)  JSContext *jsContext;

@end

@implementation JUDJSCoreBridge

- (instancetype)init
{
    self = [super init];
    
    if(self){
        _jsContext = [[JSContext alloc] init];
        if (JUD_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            _jsContext.name = @"Jud Context";
        }
        
        __weak typeof(self) weakSelf = self;
        
        NSDictionary *data = [JUDUtility getEnvironment];
        _jsContext[@"JUDEnvironment"] = data;
        
        _jsContext[@"setTimeout"] = ^(JSValue *function, JSValue *timeout) {
            // this setTimeout is used by internal logic in JS framework, normal setTimeout called by users will call JUDTimerModule's method;
            [weakSelf performSelector: @selector(triggerTimeout:) withObject:^() {
                [function callWithArguments:@[]];
            } afterDelay:[timeout toDouble] / 1000];
        };
        
        _jsContext[@"nativeLog"] = ^() {
            static NSDictionary *levelMap;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                levelMap = @{
                             @"__ERROR": @(JUDLogFlagError),
                             @"__WARN": @(JUDLogFlagWarning),
                             @"__INFO": @(JUDLogFlagInfo),
                             @"__DEBUG": @(JUDLogFlagDebug),
                             @"__LOG": @(JUDLogFlagLog)
                             };
            });
            NSMutableString *string = [NSMutableString string];
            [string appendString:@"jsLog: "];
            NSArray *args = [JSContext currentArguments];
            
            [args enumerateObjectsUsingBlock:^(JSValue *jsVal, NSUInteger idx, BOOL *stop) {
                if (idx == args.count - 1) {
                    NSNumber *flag = levelMap[[jsVal toString]];
                    if (flag) {
                        if ([flag isEqualToNumber:[NSNumber numberWithInteger:JUDLogFlagWarning]]) {
                            id<JUDAppMonitorProtocol> appMonitorHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDAppMonitorProtocol)];
                            if ([appMonitorHandler respondsToSelector:@selector(commitAppMonitorAlarm:monitorPoint:success:errorCode:errorMsg:arg:)]) {
                                [appMonitorHandler commitAppMonitorAlarm:@"jud" monitorPoint:@"jswarning" success:FALSE errorCode:@"99999" errorMsg:string arg:[JUDSDKEngine topInstance].pageName];
                            }
                        }
                        JUD_LOG([flag unsignedIntegerValue], @"%@", string);
                    } else {
                        [string appendFormat:@"%@ ", jsVal];
                        JUDLogInfo(@"%@", string);
                    }
                }
                [string appendFormat:@"%@ ", jsVal ];
            }];
        };
        
        _jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception){
            context.exception = exception;
            NSString *message = [NSString stringWithFormat:@"[%@:%@:%@] %@\n%@", exception[@"sourceURL"], exception[@"line"], exception[@"column"], exception, [exception[@"stack"] toObject]];
            
            JUD_MONITOR_FAIL(JUDMTJSBridge, JUD_ERR_JS_EXECUTE, message);
        };
        
        if (JUD_SYS_VERSION_LESS_THAN(@"8.0")) {
            // solve iOS7 memory problem
            _jsContext[@"nativeSet"] = [JUDPolyfillSet class];
        }
    }
    return self;
}

#pragma mark - JUDBridgeProtocol

- (void)executeJSFramework:(NSString *)frameworkScript
{
    JUDAssertParam(frameworkScript);
    if (JUD_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [_jsContext evaluateScript:frameworkScript withSourceURL:[NSURL URLWithString:@"main.js"]];
    }else{
        [_jsContext evaluateScript:frameworkScript];
    }
}

- (JSValue *)callJSMethod:(NSString *)method args:(NSArray *)args
{
    JUDLogDebug(@"Calling JS... method:%@, args:%@", method, args);
    return [[_jsContext globalObject] invokeMethod:method withArguments:args];
}

- (void)registerCallNative:(JUDJSCallNative)callNative
{
    JSValue* (^callNativeBlock)(JSValue *, JSValue *, JSValue *) = ^JSValue*(JSValue *instance, JSValue *tasks, JSValue *callback){
        NSString *instanceId = [instance toString];
        NSArray *tasksArray = [tasks toArray];
        NSString *callbackId = [callback toString];
        
        JUDLogDebug(@"Calling native... instance:%@, tasks:%@, callback:%@", instanceId, tasksArray, callbackId);
        return [JSValue valueWithInt32:(int32_t)callNative(instanceId, tasksArray, callbackId) inContext:[JSContext currentContext]];
    };
    
    _jsContext[@"callNative"] = callNativeBlock;
}

- (void)executeJavascript:(NSString *)script
{
    JUDAssertParam(script);
    [_jsContext evaluateScript:script];
}

- (void)registerCallAddElement:(JUDJSCallAddElement)callAddElement
{
    id callAddElementBlock = ^(JSValue *instanceId, JSValue *ref, JSValue *element, JSValue *index, JSValue *ifCallback) {
        
        NSString *instanceIdString = [instanceId toString];
        NSDictionary *componentData = [element toDictionary];
        NSString *parentRef = [ref toString];
        NSInteger insertIndex = [[index toNumber] integerValue];
        
         JUDLogDebug(@"callAddElement...%@, %@, %@, %ld", instanceIdString, parentRef, componentData, (long)insertIndex);
        
        return [JSValue valueWithInt32:(int32_t)callAddElement(instanceIdString, parentRef, componentData, insertIndex) inContext:[JSContext currentContext]];
    };

    _jsContext[@"callAddElement"] = callAddElementBlock;
}

- (void)registerCallNativeModule:(JUDJSCallNativeModule)callNativeModuleBlock
{
    _jsContext[@"callNativeModule"] = ^JSValue *(JSValue *instanceId, JSValue *moduleName, JSValue *methodName, JSValue *args, JSValue *options) {
        NSString *instanceIdString = [instanceId toString];
        NSString *moduleNameString = [moduleName toString];
        NSString *methodNameString = [methodName toString];
        NSArray *argsArray = [args toArray];
        NSDictionary *optionsDic = [options toDictionary];
        
        JUDLogDebug(@"callNativeModule...%@,%@,%@,%@", instanceIdString, moduleNameString, methodNameString, argsArray);
        
        NSInvocation *invocation = callNativeModuleBlock(instanceIdString, moduleNameString, methodNameString, argsArray, optionsDic);
        JSValue *returnValue = [JSValue jud_valueWithReturnValueFromInvocation:invocation inContext:[JSContext currentContext]];
        return returnValue;
    };
}

- (void)registerCallNativeComponent:(JUDJSCallNativeComponent)callNativeComponentBlock
{
    _jsContext[@"callNativeComponent"] = ^void(JSValue *instanceId, JSValue *componentName, JSValue *methodName, JSValue *args, JSValue *options) {
        NSString *instanceIdString = [instanceId toString];
        NSString *componentNameString = [componentName toString];
        NSString *methodNameString = [methodName toString];
        NSArray *argsArray = [args toArray];
        NSDictionary *optionsDic = [options toDictionary];
        
        JUDLogDebug(@"callNativeComponent...%@,%@,%@,%@", instanceIdString, componentNameString, methodNameString, argsArray);
        
        callNativeComponentBlock(instanceIdString, componentNameString, methodNameString, argsArray, optionsDic);
    };
}

- (JSValue*)exception
{
    return _jsContext.exception;
}

- (void)resetEnvironment
{
    NSDictionary *data = [JUDUtility getEnvironment];
    _jsContext[@"JUDEnvironment"] = data;
}

typedef void (*JUDJSCGarbageCollect)(JSContextRef);

- (void)garbageCollect
{
    // for dev and debug only!!
//    char str[80];
//    strcpy(str, "JSSynchron");
//    strcat(str, "ousGarbageColl");
//    strcat(str, "ectForDebugging");
//    JUDJSCGarbageCollect garbageCollect = dlsym(RTLD_DEFAULT, str);
//    
//    if (garbageCollect != NULL) {
//        garbageCollect(_jsContext.JSGlobalContextRef);
//    }
}

#pragma mark - Private

- (void)triggerTimeout:(void(^)())block
{
    block();
}

@end
