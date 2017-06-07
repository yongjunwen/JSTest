/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDModuleMethod.h"
#import "JUDModuleFactory.h"
#import "JUDMonitor.h"
#import "JUDModuleProtocol.h"
#import "JUDAssert.h"
#import "JUDUtility.h"
#import "JUDSDKInstance_private.h"

@implementation JUDModuleMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(JUDSDKInstance *)instance
{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        _moduleName = moduleName;
    }
    
    return self;
}

- (NSInvocation *)invoke
{
    Class moduleClass =  [JUDModuleFactory classWithModuleName:_moduleName];
    if (!moduleClass) {
        NSString *errorMessage = [NSString stringWithFormat:@"Module：%@ doesn't exist, maybe it has not been registered", _moduleName];
        JUD_MONITOR_FAIL(JUDMTJSBridge, JUD_ERR_INVOKE_NATIVE, errorMessage);
        return nil;
    }
    
    id<JUDModuleProtocol> moduleInstance = [self.instance moduleForClass:moduleClass];
    JUDAssert(moduleInstance, @"No instance found for module name:%@, class:%@", _moduleName, moduleClass);
    BOOL isSync = NO;
    SEL selector = [JUDModuleFactory selectorWithModuleName:self.moduleName methodName:self.methodName isSync:&isSync];
   
    if (![moduleInstance respondsToSelector:selector]) {
        // if not implement the selector, then dispatch default module method
        if ([self.methodName isEqualToString:@"addEventListener"]) {
            [self.instance _addModuleEventObserversWithModuleMethod:self];
        } else if ([self.methodName isEqualToString:@"removeAllEventListeners"]) {
            [self.instance _removeModuleEventObserverWithModuleMethod:self];
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"method：%@ for module:%@ doesn't exist, maybe it has not been registered", self.methodName, _moduleName];
            JUD_MONITOR_FAIL(JUDMTJSBridge, JUD_ERR_INVOKE_NATIVE, errorMessage);
        }
        return nil;
    }
    
    NSInvocation *invocation = [self invocationWithTarget:moduleInstance selector:selector];
    
    if (isSync) {
        [invocation invoke];
        return invocation;
    } else {
        [self _dispatchInvocation:invocation moduleInstance:moduleInstance];
        return nil;
    }
}

- (void)_dispatchInvocation:(NSInvocation *)invocation moduleInstance:(id<JUDModuleProtocol>)moduleInstance
{
    // dispatch to user specified queue or thread, default is main thread
    dispatch_block_t dispatchBlock = ^ (){
        [invocation invoke];
    };
    
    NSThread *targetThread = nil;
    dispatch_queue_t targetQueue = nil;
    if([moduleInstance respondsToSelector:@selector(targetExecuteQueue)]){
        targetQueue = [moduleInstance targetExecuteQueue] ?: dispatch_get_main_queue();
    } else if([moduleInstance respondsToSelector:@selector(targetExecuteThread)]){
        targetThread = [moduleInstance targetExecuteThread] ?: [NSThread mainThread];
    } else {
        targetThread = [NSThread mainThread];
    }

    JUDAssert(targetQueue || targetThread, @"No queue or thread found for module:%@", moduleInstance);
    
    if (targetQueue) {
        dispatch_async(targetQueue, dispatchBlock);
    } else {
        JUDPerformBlockOnThread(^{
            dispatchBlock();
        }, targetThread);
    }
}

@end
