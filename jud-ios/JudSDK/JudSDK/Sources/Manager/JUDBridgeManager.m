/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBridgeManager.h"
#import "JUDBridgeContext.h"
#import "JUDLog.h"
#import "JUDAssert.h"
#import "JUDBridgeMethod.h"
#import "JUDCallJSMethod.h"
#import "JUDSDKManager.h"
#import "JUDServiceFactory.h"
#import "JUDResourceRequest.h"
#import "JUDResourceLoader.h"
#import "JUDDebugTool.h"

@interface JUDBridgeManager ()

@property (nonatomic, strong) JUDBridgeContext   *bridgeCtx;
@property (nonatomic, assign) BOOL  stopRunning;
@property (nonatomic, strong) NSMutableArray *instanceIdStack;

@end

static NSThread *JUDBridgeThread;

@implementation JUDBridgeManager

+ (instancetype)sharedManager
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _bridgeCtx = [[JUDBridgeContext alloc] init];
    }
    return self;
}

- (JUDSDKInstance *)topInstance
{
    return _bridgeCtx.topInstance;
}

- (void)unload
{
    _bridgeCtx = nil;
}

- (void)dealloc
{
   
}

#pragma mark Thread Management

- (void)_runLoopThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (!_stopRunning) {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

+ (NSThread *)jsThread
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        JUDBridgeThread = [[NSThread alloc] initWithTarget:[[self class]sharedManager] selector:@selector(_runLoopThread) object:nil];
        [JUDBridgeThread setName:JUD_BRIDGE_THREAD_NAME];
        if(JUD_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            [JUDBridgeThread setQualityOfService:[[NSThread mainThread] qualityOfService]];
        } else {
            [JUDBridgeThread setThreadPriority:[[NSThread mainThread] threadPriority]];
        }
        
        [JUDBridgeThread start];
    });
    
    return JUDBridgeThread;
}


void JUDPerformBlockOnBridgeThread(void (^block)())
{
    [JUDBridgeManager _performBlockOnBridgeThread:block];
}

+ (void)_performBlockOnBridgeThread:(void (^)())block
{
    if ([NSThread currentThread] == [self jsThread]) {
        block();
    } else {
        [self performSelector:@selector(_performBlockOnBridgeThread:)
                     onThread:[self jsThread]
                   withObject:[block copy]
                waitUntilDone:NO];
    }
}

#pragma mark JSBridge Management

- (void)createInstance:(NSString *)instance
              template:(NSString *)temp
               options:(NSDictionary *)options
                  data:(id)data
{
    if (!instance || !temp) return;
    if (![self.instanceIdStack containsObject:instance]) {
        if ([options[@"RENDER_IN_ORDER"] boolValue]) {
            [self.instanceIdStack addObject:instance];
        } else {
            [self.instanceIdStack insertObject:instance atIndex:0];
        }
    }
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx createInstance:instance
                                  template:temp
                                   options:options
                                      data:data];
    });
}

- (NSMutableArray *)instanceIdStack
{
    if (_instanceIdStack) return _instanceIdStack;
    
    _instanceIdStack = [NSMutableArray array];
    
    return _instanceIdStack;
}

- (NSArray *)getInstanceIdStack;
{
    return self.instanceIdStack;
}

- (void)destroyInstance:(NSString *)instance
{
    if (!instance) return;
    if([self.instanceIdStack containsObject:instance]){
        [self.instanceIdStack removeObject:instance];
    }
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx destroyInstance:instance];
    });
}

- (void)forceGarbageCollection
{
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx forceGarbageCollection];
    });
}

- (void)refreshInstance:(NSString *)instance
                   data:(NSDictionary *)data
{
    if (!instance) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx refreshInstance:instance data:data];
    });
}

- (void)updateState:(NSString *)instance data:(id)data
{
    if (!instance) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx updateState:instance data:data];
    });
}

- (void)executeJsFramework:(NSString *)script
{
    if (!script) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx executeJsFramework:script];
    });
}

- (void)callJsMethod:(JUDCallJSMethod *)method
{
    if (!method) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx executeJsMethod:method];
    });
}

-(void)registerService:(NSString *)name withServiceUrl:(NSURL *)serviceScriptUrl withOptions:(NSDictionary *)options
{
    if (!name || !serviceScriptUrl || !options) return;
    __weak typeof(self) weakSelf = self;
    JUDResourceRequest *request = [JUDResourceRequest requestWithURL:serviceScriptUrl resourceType:JUDResourceTypeServiceBundle referrer:@"" cachePolicy:NSURLRequestUseProtocolCachePolicy];
    JUDResourceLoader *serviceBundleLoader = [[JUDResourceLoader alloc] initWithRequest:request];;
    serviceBundleLoader.onFinished = ^(JUDResourceResponse *response, NSData *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *jsServiceString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [strongSelf registerService:name withService:jsServiceString withOptions:options];
    };
    
    serviceBundleLoader.onFailed = ^(NSError *loadError) {
        JUDLogError(@"No script URL found");
    };
    
    [serviceBundleLoader start];
}

- (void)registerService:(NSString *)name withService:(NSString *)serviceScript withOptions:(NSDictionary *)options
{
    if (!name || !serviceScript || !options) return;
    
    NSString *script = [JUDServiceFactory registerServiceScript:name withRawScript:serviceScript withOptions:options];
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        // save it when execute
        [JUDDebugTool cacheJsService:name withScript:serviceScript withOptions:options];
        [weakSelf.bridgeCtx executeJsService:script withName:name];
    });
}

- (void)unregisterService:(NSString *)name
{
    if (!name) return;
    
    NSString *script = [JUDServiceFactory unregisterServiceScript:name];
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        // save it when execute
        [JUDDebugTool removeCacheJsService:name];
        [weakSelf.bridgeCtx executeJsService:script withName:name];
    });
}

- (void)registerModules:(NSDictionary *)modules
{
    if (!modules) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx registerModules:modules];
    });
}

- (void)registerComponents:(NSArray *)components
{
    if (!components) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx registerComponents:components];
    });
}

- (void)fireEvent:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params
{
    [self fireEvent:instanceId ref:ref type:type params:params domChanges:nil];
}

- (void)fireEvent:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges
{
    if (!type || !ref) {
        JUDLogError(@"Event type and component ref should not be nil");
        return;
    }
    
    NSArray *args = @[ref, type, params?:@{}, domChanges?:@{}];
    JUDSDKInstance *instance = [JUDSDKManager instanceForID:instanceId];
    
    JUDCallJSMethod *method = [[JUDCallJSMethod alloc] initWithModuleName:nil methodName:@"fireEvent" arguments:args instance:instance];
    [self callJsMethod:method];
}

- (void)callBack:(NSString *)instanceId funcId:(NSString *)funcId params:(id)params keepAlive:(BOOL)keepAlive
{
    NSArray *args = nil;
    if (keepAlive) {
        args = @[[funcId copy], params? [params copy]:@"\"{}\"", @true];
    }else {
        args = @[[funcId copy], params? [params copy]:@"\"{}\""];
    }
    JUDSDKInstance *instance = [JUDSDKManager instanceForID:instanceId];

    JUDCallJSMethod *method = [[JUDCallJSMethod alloc] initWithModuleName:@"jsBridge" methodName:@"callback" arguments:args instance:instance];
    [self callJsMethod:method];
}

- (void)callBack:(NSString *)instanceId funcId:(NSString *)funcId params:(id)params
{
    [self callBack:instanceId funcId:funcId params:params keepAlive:NO];
}

- (void)connectToDevToolWithUrl:(NSURL *)url {
    [self.bridgeCtx connectToDevToolWithUrl:url];
}

- (void)connectToWebSocket:(NSURL *)url
{
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx connectToWebSocket:url];
    });
}

- (void)logToWebSocket:(NSString *)flag message:(NSString *)message
{
    if (!message) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx logToWebSocket:flag message:message];
    });
}

- (void)resetEnvironment
{
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx resetEnvironment];
    });
}

#pragma mark - Deprecated

- (void)executeJsMethod:(JUDCallJSMethod *)method
{
    if (!method) return;
    
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnBridgeThread(^(){
        [weakSelf.bridgeCtx executeJsMethod:method];
    });
}

@end
