/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBridgeMethod.h"
#import "JUDSDKInstance.h"
#import "JUDMonitor.h"
#import "JUDAssert.h"
#import "JUDUtility.h"
#import "JUDSDKManager.h"
#import <objc/runtime.h>
#import "JUDConvert.h"

@implementation JUDBridgeMethod

- (instancetype)initWithMethodName:(NSString *)methodName arguments:(NSArray *)arguments instance:(JUDSDKInstance *)instance
{
    if (self = [super init]) {
        _methodName = methodName;
        _arguments = arguments;
        _instance = instance;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; instance = %@; method = %@; arguments= %@>", NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments];
}

//check parameter:NSNumber contains int,float,double;object contains nsarray,nsstring,nsdictionary ;block is block
//https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
-(id)parseArgument:(id)obj parameterType:(const char *)parameterType order:(int)order
{
#ifdef DEBUG
    BOOL check = YES;
#endif
    if (strcmp(parameterType,@encode(float))==0 || strcmp(parameterType,@encode(double))==0)
    {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSNumber class]];
        JUDAssert(check,@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be float or double>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
#endif
        CGFloat value = [JUDConvert CGFloat:obj];
        return [NSNumber numberWithDouble:value];
    } else if (strcmp(parameterType,@encode(int))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSNumber class]];
        JUDAssert(check,@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be int>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
#endif
        NSInteger value = [JUDConvert NSInteger:obj];
        return [NSNumber numberWithInteger:value];
    } else if(strcmp(parameterType,@encode(id))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]] ||[obj isKindOfClass:[NSString class]];
        JUDAssert(check,@"<%@: %p; instance = %@; method = %@; arguments= %@ ;the number %d parameter type is not right,it should be array ,map or string>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
#endif
        return obj;
    } else if(strcmp(parameterType,@encode(typeof(^{})))==0) {
#ifdef DEBUG
        check =  [obj isKindOfClass:[NSString class]]; // jsfm pass string if parameter type is block
        JUDAssert(check,@"<%@: %p; instance = %@; method = %@; arguments= %@; the number %d parameter type is not right,it should be block>",NSStringFromClass([self class]), self, _instance.instanceId, _methodName, _arguments,order);
#endif
        return obj;
    }
    return obj;
}

- (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector
{
    JUDAssert(target, @"No target for method:%@", self);
    JUDAssert(selector, @"No selector for method:%@", self);
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    if (!signature) {
        NSString *errorMessage = [NSString stringWithFormat:@"target:%@, selector:%@ doesn't have a method signature", target, NSStringFromSelector(selector)];
        JUD_MONITOR_FAIL(JUDMTJSBridge, JUD_ERR_INVOKE_NATIVE, errorMessage);
        return nil;
    }
    
    NSArray *arguments = _arguments;
    if (signature.numberOfArguments - 2 < arguments.count) {
        NSString *errorMessage = [NSString stringWithFormat:@"%@, the parameters in calling method [%@] and registered method [%@] are not consistent！", target, _methodName, NSStringFromSelector(selector)];
        JUD_MONITOR_FAIL(JUDMTJSBridge, JUD_ERR_INVOKE_NATIVE, errorMessage);
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    NSString *instanceId = _instance.instanceId;
    void **freeList = NULL;
    
    NSMutableArray *blockArray = [NSMutableArray array];
    JUD_ALLOC_FLIST(freeList, arguments.count);
    for (int i = 0; i < arguments.count; i ++ ) {
        id obj = arguments[i];
        const char *parameterType = [signature getArgumentTypeAtIndex:i + 2];
        obj = [self parseArgument:obj parameterType:parameterType order:i];
        static const char *blockType = @encode(typeof(^{}));
        id argument;
        if (!strcmp(parameterType, blockType)) {
            // callback
            argument = [^void(NSString *result, BOOL keepAlive) {
                [[JUDSDKManager bridgeMgr] callBack:instanceId funcId:(NSString *)obj params:result keepAlive:keepAlive];
            } copy];
            
            // retain block
            [blockArray addObject:argument];
            [invocation setArgument:&argument atIndex:i + 2];
        } else {
            argument = obj;
            JUD_ARGUMENTS_SET(invocation, signature, i, argument, freeList);
        }
    }
    [invocation retainArguments];
    JUD_FREE_FLIST(freeList, arguments.count);
    
    return invocation;
}

@end
