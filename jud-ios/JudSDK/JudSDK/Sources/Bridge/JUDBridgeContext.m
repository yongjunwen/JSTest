/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBridgeContext.h"
#import "JUDBridgeProtocol.h"
#import "JUDJSCoreBridge.h"
#import "JUDDebugLoggerBridge.h"
#import "JUDLog.h"
#import "JUDUtility.h"
#import "JUDModuleFactory.h"
#import "JUDModuleProtocol.h"
#import "JUDUtility.h"
#import "JUDSDKError.h"
#import "JUDMonitor.h"
#import "JUDAssert.h"
#import "JUDSDKManager.h"
#import "JUDDebugTool.h"
#import "JUDSDKInstance_private.h"
#import "JUDThreadSafeMutableArray.h"
#import "JUDAppConfiguration.h"
#import "JUDInvocationConfig.h"
#import "JUDComponentMethod.h"
#import "JUDModuleMethod.h"
#import "JUDCallJSMethod.h"
#import "JUDSDKInstance_private.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface JUDBridgeContext ()

@property (nonatomic, strong) id<JUDBridgeProtocol>  jsBridge;
@property (nonatomic, strong) JUDDebugLoggerBridge *devToolSocketBridge;
@property (nonatomic, assign) BOOL  debugJS;
//store the methods which will be executed from native to js
@property (nonatomic, strong) NSMutableDictionary   *sendQueue;
//the instance stack
@property (nonatomic, strong) JUDThreadSafeMutableArray    *insStack;
//identify if the JSFramework has been loaded
@property (nonatomic) BOOL frameworkLoadFinished;
//store some methods temporarily before JSFramework is loaded
@property (nonatomic, strong) NSMutableArray *methodQueue;
// store service
@property (nonatomic, strong) NSMutableArray *jsServiceQueue;

@end

@implementation JUDBridgeContext

- (instancetype) init
{
    self = [super init];
    if (self) {
        _methodQueue = [NSMutableArray new];
        _frameworkLoadFinished = NO;
        _jsServiceQueue = [NSMutableArray new];
    }
    return self;
}

- (id<JUDBridgeProtocol>)jsBridge
{
    JUDAssertBridgeThread();
    _debugJS = [JUDDebugTool isDevToolDebug];
    
    Class bridgeClass = _debugJS ? NSClassFromString(@"JUDDebugger") : [JUDJSCoreBridge class];
    
    if (_jsBridge && [_jsBridge isKindOfClass:bridgeClass]) {
        return _jsBridge;
    }
    
    if (_jsBridge) {
        [_methodQueue removeAllObjects];
        _frameworkLoadFinished = NO;
    }
    
    _jsBridge = _debugJS ? [NSClassFromString(@"JUDDebugger") alloc] : [[JUDJSCoreBridge alloc] init];
    
    [self registerGlobalFunctions];
    
    return _jsBridge;
}

- (void)registerGlobalFunctions
{
    __weak typeof(self) weakSelf = self;
    [_jsBridge registerCallNative:^NSInteger(NSString *instance, NSArray *tasks, NSString *callback) {
        return [weakSelf invokeNative:instance tasks:tasks callback:callback];
    }];
    [_jsBridge registerCallAddElement:^NSInteger(NSString *instanceId, NSString *parentRef, NSDictionary *elementData, NSInteger index) {
        
        // Temporary here , in order to improve performance, will be refactored next version.
        JUDSDKInstance *instance = [JUDSDKManager instanceForID:instanceId];
        
        if (!instance) {
            JUDLogInfo(@"instance not found, maybe already destroyed");
            return -1;
        }
        
        JUDPerformBlockOnComponentThread(^{
            JUDComponentManager *manager = instance.componentManager;
            if (!manager.isValid) {
                return;
            }
            [manager startComponentTasks];
            [manager addComponent:elementData toSupercomponent:parentRef atIndex:index appendingInTree:NO];
        });
        
        return 0;
    }];
    
    [_jsBridge registerCallNativeModule:^NSInvocation*(NSString *instanceId, NSString *moduleName, NSString *methodName, NSArray *arguments, NSDictionary *options) {
        
        JUDSDKInstance *instance = [JUDSDKManager instanceForID:instanceId];
        
        if (!instance) {
            JUDLogInfo(@"instance not found for callNativeModule:%@.%@, maybe already destroyed", moduleName, methodName);
            return nil;
        }
        
        JUDModuleMethod *method = [[JUDModuleMethod alloc] initWithModuleName:moduleName methodName:methodName arguments:arguments instance:instance];
        return [method invoke];
    }];
    
    [_jsBridge registerCallNativeComponent:^void(NSString *instanceId, NSString *componentRef, NSString *methodName, NSArray *args, NSDictionary *options) {
        JUDSDKInstance *instance = [JUDSDKManager instanceForID:instanceId];
        JUDComponentMethod *method = [[JUDComponentMethod alloc] initWithComponentRef:componentRef methodName:methodName arguments:args instance:instance];
        [method invoke];
    }];
}

- (NSMutableArray *)insStack
{
    if (_insStack) return _insStack;

    _insStack = [JUDThreadSafeMutableArray array];
    
    return _insStack;
}

- (JUDSDKInstance *)topInstance
{
    if (self.insStack.count > 0) {
        JUDSDKInstance *topInstance = [JUDSDKManager instanceForID:[self.insStack firstObject]];
        return topInstance;
    }
    
    return nil;
}

- (NSMutableDictionary *)sendQueue
{
    JUDAssertBridgeThread();
    
    if (_sendQueue) return _sendQueue;
    
    _sendQueue = [NSMutableDictionary dictionary];
    
    return _sendQueue;
}

#pragma mark JS Bridge Management

- (NSInteger)invokeNative:(NSString *)instanceId tasks:(NSArray *)tasks callback:(NSString __unused*)callback
{
    JUDAssertBridgeThread();
    
    if (!instanceId || !tasks) {
        JUD_MONITOR_FAIL(JUDMTNativeRender, JUD_ERR_JSFUNC_PARAM, @"JS call Native params error!");
        return 0;
    }

    JUDSDKInstance *instance = [JUDSDKManager instanceForID:instanceId];
    if (!instance) {
        JUDLogInfo(@"instance already destroyed, task ignored");
        return -1;
    }
    
    for (NSDictionary *task in tasks) {
        NSString *methodName = task[@"method"];
        NSArray *arguments = task[@"args"];
        if (task[@"component"]) {
            NSString *ref = task[@"ref"];
            JUDComponentMethod *method = [[JUDComponentMethod alloc] initWithComponentRef:ref methodName:methodName arguments:arguments instance:instance];
            [method invoke];
        } else {
            NSString *moduleName = task[@"module"];
            JUDModuleMethod *method = [[JUDModuleMethod alloc] initWithModuleName:moduleName methodName:methodName arguments:arguments instance:instance];
            [method invoke];
        }
    }
    
    [self performSelector:@selector(_sendQueueLoop) withObject:nil];
    
    return 1;
}

- (void)createInstance:(NSString *)instance
              template:(NSString *)temp
               options:(NSDictionary *)options
                  data:(id)data
{
    JUDAssertBridgeThread();
    JUDAssertParam(instance);
    
    if (![self.insStack containsObject:instance]) {
        if ([options[@"RENDER_IN_ORDER"] boolValue]) {
            [self.insStack addObject:instance];
        } else {
            [self.insStack insertObject:instance atIndex:0];
        }
    }
    
    //create a sendQueue bind to the current instance
    NSMutableArray *sendQueue = [NSMutableArray array];
    [self.sendQueue setValue:sendQueue forKey:instance];
    
    NSArray *args = nil;
    if (data){
        args = @[instance, temp, options ?: @{}, data];
    } else {
        args = @[instance, temp, options ?: @{}];
    }

    JUD_MONITOR_INSTANCE_PERF_START(JUDPTJSCreateInstance, [JUDSDKManager instanceForID:instance]);
    [self callJSMethod:@"createInstance" args:args];
    JUD_MONITOR_INSTANCE_PERF_END(JUDPTJSCreateInstance, [JUDSDKManager instanceForID:instance]);
}

- (void)destroyInstance:(NSString *)instance
{
    JUDAssertBridgeThread();
    JUDAssertParam(instance);
    
    //remove instance from stack
    if([self.insStack containsObject:instance]){
        [self.insStack removeObject:instance];
    }

    if(self.sendQueue[instance]){
        [self.sendQueue removeObjectForKey:instance];
    }
    
    [self callJSMethod:@"destroyInstance" args:@[instance]];
}

- (void)forceGarbageCollection
{
    if ([self.jsBridge respondsToSelector:@selector(garbageCollect)]) {
        [self.jsBridge garbageCollect];
    }
}

- (void)refreshInstance:(NSString *)instance
                   data:(id)data
{
    JUDAssertBridgeThread();
    JUDAssertParam(instance);
    
    if (!data) return;
    
    [self callJSMethod:@"refreshInstance" args:@[instance, data]];
}

- (void)updateState:(NSString *)instance data:(id)data
{
    JUDAssertBridgeThread();
    JUDAssertParam(instance);
    
    //[self.jsBridge callJSMethod:@"updateState" args:@[instance, data]];
}

- (void)executeJsFramework:(NSString *)script
{
    JUDAssertBridgeThread();
    JUDAssertParam(script);
    
    JUD_MONITOR_PERF_START(JUDPTFrameworkExecute);
    
    [self.jsBridge executeJSFramework:script];
    
    JUD_MONITOR_PERF_END(JUDPTFrameworkExecute);
    
    if ([self.jsBridge exception]) {
        NSString *message = [NSString stringWithFormat:@"JSFramework executes error: %@", [self.jsBridge exception]];
        JUD_MONITOR_FAIL(JUDMTJSFramework, JUD_ERR_JSFRAMEWORK_EXECUTE, message);
    } else {
        JUD_MONITOR_SUCCESS(JUDMTJSFramework);
        //the JSFramework has been load successfully.
        self.frameworkLoadFinished = YES;
        
        [self executeAllJsService];
        
        JSValue *frameworkVersion = [self.jsBridge callJSMethod:@"getJSFMVersion" args:nil];
        if (frameworkVersion && [frameworkVersion isString]) {
            [JUDAppConfiguration setJSFrameworkVersion:[frameworkVersion toString]];
        }
        
        //execute methods which has been stored in methodQueue temporarily.
        for (NSDictionary *method in _methodQueue) {
            [self callJSMethod:method[@"method"] args:method[@"args"]];
        }
        
        [_methodQueue removeAllObjects];
        
        JUD_MONITOR_PERF_END(JUDPTInitalize);
    };
}

- (void)executeJsMethod:(JUDCallJSMethod *)method
{
    JUDAssertBridgeThread();
    
    if (!method.instance) {
        JUDLogError(@"Instance doesn't exist!");
        return;
    }
    
    NSMutableArray *sendQueue = self.sendQueue[method.instance.instanceId];
    if (!sendQueue) {
        JUDLogInfo(@"No send queue for instance:%@, may it has been destroyed so method:%@ is ignored", method.instance, method.methodName);
        return;
    }
    
    [sendQueue addObject:method];
    [self performSelector:@selector(_sendQueueLoop) withObject:nil];
}

- (void)executeAllJsService
{
    for(NSDictionary *service in _jsServiceQueue) {
        NSString *script = [service valueForKey:@"script"];
        NSString *name = [service valueForKey:@"name"];
        [self executeJsService:script withName:name];
    }
    
    [_jsServiceQueue removeAllObjects];
}

- (void)executeJsService:(NSString *)script withName:(NSString *)name
{
    if(self.frameworkLoadFinished) {
        JUDAssert(script, @"param script required!");
        [self.jsBridge executeJavascript:script];
        
        if ([self.jsBridge exception]) {
            NSString *message = [NSString stringWithFormat:@"JSService executes error: %@", [self.jsBridge exception]];
            JUD_MONITOR_FAIL(JUDMTJSService, JUD_ERR_JSFRAMEWORK_EXECUTE, message);
        } else {
            // success
        }
    }else {
        [_jsServiceQueue addObject:@{
                                     @"name": name,
                                     @"script": script
                                     }];
    }
}

- (void)registerModules:(NSDictionary *)modules
{
    JUDAssertBridgeThread();
    
    if(!modules) return;
    
    [self callJSMethod:@"registerModules" args:@[modules]];
}

- (void)registerComponents:(NSArray *)components
{
    JUDAssertBridgeThread();
    
    if(!components) return;
    
    [self callJSMethod:@"registerComponents" args:@[components]];
}

- (void)callJSMethod:(NSString *)method args:(NSArray *)args
{
    if (self.frameworkLoadFinished) {
        [self.jsBridge callJSMethod:method args:args];
    } else {
        [_methodQueue addObject:@{@"method":method, @"args":args}];
    }
}

- (void)resetEnvironment
{
    [_jsBridge resetEnvironment];
}

#pragma mark JS Debug Management

- (void)connectToDevToolWithUrl:(NSURL *)url
{
    id webSocketBridge = [NSClassFromString(@"JUDDebugger") alloc];
    if(!webSocketBridge || ![webSocketBridge respondsToSelector:NSSelectorFromString(@"connectToURL:")]) {
        return;
    } else {
        SuppressPerformSelectorLeakWarning(
           [webSocketBridge performSelector:NSSelectorFromString(@"connectToURL:") withObject:url]
        );
    }
}

- (void)connectToWebSocket:(NSURL *)url
{
    _devToolSocketBridge = [[JUDDebugLoggerBridge alloc] initWithURL:url];
}

- (void)logToWebSocket:(NSString *)flag message:(NSString *)message
{
    [_devToolSocketBridge callJSMethod:@"__logger" args:@[flag, message]];
}

#pragma mark Private Mehtods

- (void)_sendQueueLoop
{
    JUDAssertBridgeThread();
    
    BOOL hasTask = NO;
    NSMutableArray *tasks = [NSMutableArray array];
    NSString *execIns = nil;
    
    for (NSString *instance in self.insStack) {
        NSMutableArray *sendQueue = self.sendQueue[instance];
        if(sendQueue.count > 0){
            hasTask = YES;
            for(JUDCallJSMethod *method in sendQueue){
                [tasks addObject:[method callJSTask]];
            }
            
            [sendQueue removeAllObjects];
            execIns = instance;
            break;
        }
    }
    
    if ([tasks count] > 0 && execIns) {
        [self callJSMethod:@"callJS" args:@[execIns, tasks]];
    }
    
    if (hasTask) {
        [self performSelector:@selector(_sendQueueLoop) withObject:nil];
    }
}

@end
