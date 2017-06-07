/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDSDKInstance.h"
#import "JUDSDKInstance_private.h"
#import "JUDSDKManager.h"
#import "JUDSDKError.h"
#import "JUDMonitor.h"
#import "JUDAppMonitorProtocol.h"
#import "JUDNetworkProtocol.h"
#import "JUDModuleFactory.h"
#import "JUDHandlerFactory.h"
#import "JUDDebugTool.h"
#import "JUDUtility.h"
#import "JUDAssert.h"
#import "JUDLog.h"
#import "JUDView.h"
#import "JUDRootView.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDResourceRequest.h"
#import "JUDResourceResponse.h"
#import "JUDResourceLoader.h"
#import "JUDSDKEngine.h"

NSString *const bundleUrlOptionKey = @"bundleUrl";

NSTimeInterval JSLibInitTime = 0;

typedef enum : NSUInteger {
    JUDLoadTypeNormal,
    JUDLoadTypeBack,
    JUDLoadTypeForward,
    JUDLoadTypeReload,
    JUDLoadTypeReplace
} JUDLoadType;

@implementation JUDSDKInstance
{
    NSDictionary *_options;
    id _jsData;
    
    JUDResourceLoader *_mainBundleLoader;
    JUDComponentManager *_componentManager;
    JUDRootView *_rootView;
    JUDThreadSafeMutableDictionary *_moduleEventObservers;
}

- (void)dealloc
{
    [_moduleEventObservers removeAllObjects];
    [self removeObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if(self){
        NSInteger instanceId = 0;
        @synchronized(self){
            static NSInteger __instance = 0;
            instanceId = __instance % (1024*1024);
            __instance++;
        }
        _instanceId = [NSString stringWithFormat:@"%ld", (long)instanceId];

        [JUDSDKManager storeInstance:self forID:_instanceId];
        
        _bizType = @"";
        _pageName = @"";

        _performanceDict = [JUDThreadSafeMutableDictionary new];
        _moduleInstances = [NSMutableDictionary new];
        _styleConfigs = [NSMutableDictionary new];
        _attrConfigs = [NSMutableDictionary new];
        _moduleEventObservers = [JUDThreadSafeMutableDictionary new];
        _trackComponent = NO;
       
        [self addObservers];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; id = %@; rootView = %@; url= %@>", NSStringFromClass([self class]), self, _instanceId, _rootView, _scriptURL];
}

#pragma mark Public Mehtods

- (UIView *)rootView
{
    return _rootView;
}


- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, _frame)) {
        _frame = frame;
        JUDPerformBlockOnMainThread(^{
            if (_rootView) {
                _rootView.frame = frame;
                JUDPerformBlockOnComponentThread(^{
                    [self.componentManager rootViewFrameDidChange:frame];
                });
            }
        });
    }
}

- (void)renderWithURL:(NSURL *)url
{
    [self renderWithURL:url options:nil data:nil];
}

- (void)renderWithURL:(NSURL *)url options:(NSDictionary *)options data:(id)data
{
    if (!url) {
        JUDLogError(@"Url must be passed if you use renderWithURL");
        return;
    }
    
    JUDResourceRequest *request = [JUDResourceRequest requestWithURL:url resourceType:JUDResourceTypeMainBundle referrer:@"" cachePolicy:NSURLRequestUseProtocolCachePolicy];
    [self _renderWithRequest:request options:options data:data];
}

- (void)renderView:(NSString *)source options:(NSDictionary *)options data:(id)data
{
    JUDLogDebug(@"Render source: %@, data:%@", self, [JUDUtility JSONString:data]);
    
    _options = options;
    _jsData = data;
    
    [self _renderWithMainBundleString:source];
}

- (void)_renderWithMainBundleString:(NSString *)mainBundleString
{
    if (!self.instanceId) {
        JUDLogError(@"Fail to find instance！");
        return;
    }
    
    if (self.pageName && ![self.pageName isEqualToString:@""]) {
        JUDLog(@"Start rendering page:%@", self.pageName);
    } else {
        JUDLogWarning(@"JUDSDKInstance's pageName should be specified.");
    }
    
    JUD_MONITOR_INSTANCE_PERF_START(JUDPTFirstScreenRender, self);
    JUD_MONITOR_INSTANCE_PERF_START(JUDPTAllRender, self);
    
    NSMutableDictionary *dictionary = [_options mutableCopy];
    if ([JUDLog logLevel] >= JUDLogLevelLog) {
        dictionary[@"debug"] = @(YES);
    }
    
    if ([JUDDebugTool getReplacedBundleJS]) {
        mainBundleString = [JUDDebugTool getReplacedBundleJS];
    }
    
    //TODO JUDRootView
    JUDPerformBlockOnMainThread(^{
        _rootView = [[JUDRootView alloc] initWithFrame:self.frame];
        _rootView.instance = self;
        if(self.onCreate) {
            self.onCreate(_rootView);
        }
    });
    
    // ensure default modules/components/handlers are ready before create instance
    [JUDSDKEngine registerDefaults];
    
    [[JUDSDKManager bridgeMgr] createInstance:self.instanceId template:mainBundleString options:dictionary data:_jsData];
    
    JUD_MONITOR_PERF_SET(JUDPTBundleSize, [mainBundleString lengthOfBytesUsingEncoding:NSUTF8StringEncoding], self);
}


- (void)_renderWithRequest:(JUDResourceRequest *)request options:(NSDictionary *)options data:(id)data;
{
    NSURL *url = request.URL;
    _scriptURL = url;
    _jsData = data;
    NSMutableDictionary *newOptions = [options mutableCopy] ?: [NSMutableDictionary new];
    
    if (!newOptions[bundleUrlOptionKey]) {
        newOptions[bundleUrlOptionKey] = url.absoluteString;
    }
    // compatible with some wrong type, remove this hopefully in the future.
    if ([newOptions[bundleUrlOptionKey] isKindOfClass:[NSURL class]]) {
        JUDLogWarning(@"Error type in options with key:bundleUrl, should be of type NSString, not NSURL!");
        newOptions[bundleUrlOptionKey] = ((NSURL*)newOptions[bundleUrlOptionKey]).absoluteString;
    }
    _options = [newOptions copy];
  
    if (!self.pageName || [self.pageName isEqualToString:@""]) {
        self.pageName = [JUDUtility urlByDeletingParameters:url].absoluteString ? : @"";
    }
    
    request.userAgent = [JUDUtility userAgent];
    
    JUD_MONITOR_INSTANCE_PERF_START(JUDPTJSDownload, self);
    __weak typeof(self) weakSelf = self;
    _mainBundleLoader = [[JUDResourceLoader alloc] initWithRequest:request];;
    _mainBundleLoader.onFinished = ^(JUDResourceResponse *response, NSData *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode != 200) {
            NSError *error = [NSError errorWithDomain:JUD_ERROR_DOMAIN
                                        code:((NSHTTPURLResponse *)response).statusCode
                                    userInfo:@{@"message":@"status code error."}];
            if (strongSelf.onFailed) {
                strongSelf.onFailed(error);
            }
            return ;
        }

        if (!data) {
            NSString *errorMessage = [NSString stringWithFormat:@"Request to %@ With no data return", request.URL];
            JUD_MONITOR_FAIL_ON_PAGE(JUDMTJSDownload, JUD_ERR_JSBUNDLE_DOWNLOAD, errorMessage, strongSelf.pageName);

            if (strongSelf.onFailed) {
                strongSelf.onFailed(error);
            }
            return;
        }
        
        NSString *jsBundleString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!jsBundleString) {
            JUD_MONITOR_FAIL_ON_PAGE(JUDMTJSDownload, JUD_ERR_JSBUNDLE_STRING_CONVERT, @"data converting to string failed.", strongSelf.pageName)
            return;
        }

        JUD_MONITOR_SUCCESS_ON_PAGE(JUDMTJSDownload, strongSelf.pageName);
        JUD_MONITOR_INSTANCE_PERF_END(JUDPTJSDownload, strongSelf);

        [strongSelf _renderWithMainBundleString:jsBundleString];
    };
    
    _mainBundleLoader.onFailed = ^(NSError *loadError) {
        NSString *errorMessage = [NSString stringWithFormat:@"Request to %@ occurs an error:%@", request.URL, loadError.localizedDescription];
        JUD_MONITOR_FAIL_ON_PAGE(JUDMTJSDownload, JUD_ERR_JSBUNDLE_DOWNLOAD, errorMessage, weakSelf.pageName);
        
        if (weakSelf.onFailed) {
            weakSelf.onFailed(error);
        }
    };
    
    [_mainBundleLoader start];
}

- (void)reload:(BOOL)forcedReload
{
    // TODO: [self unload]
    if (!_scriptURL) {
        JUDLogError(@"No script URL found while reloading!");
        return;
    }
    
    NSURLRequestCachePolicy cachePolicy = forcedReload ? NSURLRequestReloadIgnoringCacheData : NSURLRequestUseProtocolCachePolicy;
    JUDResourceRequest *request = [JUDResourceRequest requestWithURL:_scriptURL resourceType:JUDResourceTypeMainBundle referrer:_scriptURL.absoluteString cachePolicy:cachePolicy];
    [self _renderWithRequest:request options:_options data:_jsData];
}

- (void)refreshInstance:(id)data
{
    JUDLogDebug(@"refresh instance: %@, data:%@", self, [JUDUtility JSONString:data]);
    
    if (!self.instanceId) {
        JUDLogError(@"Fail to find instance！");
        return;
    }
    
    [[JUDSDKManager bridgeMgr] refreshInstance:self.instanceId data:data];
}

- (void)destroyInstance
{
    if (!self.instanceId) {
        JUDLogError(@"Fail to find instance！");
        return;
    }
    
    [[JUDSDKManager bridgeMgr] destroyInstance:self.instanceId];

    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnComponentThread(^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.componentManager unload];
        dispatch_async(dispatch_get_main_queue(), ^{
            [JUDSDKManager removeInstanceforID:strongSelf.instanceId];
        });
    });
}

- (void)forceGarbageCollection
{
    [[JUDSDKManager bridgeMgr] forceGarbageCollection];
}

- (void)updateState:(JUDState)state
{
    if (!self.instanceId) {
        JUDLogError(@"Fail to find instance！");
        return;
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:[NSString stringWithFormat:@"%ld",(long)state] forKey:@"state"];
    //[[JUDSDKManager bridgeMgr] updateState:self.instanceId data:data];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JUD_INSTANCE_NOTIFICATION_UPDATE_STATE object:self userInfo:data];
}

- (id)moduleForClass:(Class)moduleClass
{
    if (!moduleClass)
        return nil;
    
    id<JUDModuleProtocol> moduleInstance = self.moduleInstances[NSStringFromClass(moduleClass)];
    if (!moduleInstance) {
        moduleInstance = [[moduleClass alloc] init];
        if ([moduleInstance respondsToSelector:@selector(setJudInstance:)])
            [moduleInstance setJudInstance:self];
        self.moduleInstances[NSStringFromClass(moduleClass)] = moduleInstance;
    }
    
    return moduleInstance;
}

- (JUDComponent *)componentForRef:(NSString *)ref
{
    JUDAssertComponentThread();
    
    return [_componentManager componentForRef:ref];
}

- (NSUInteger)numberOfComponents
{
    JUDAssertComponentThread();
    
    return [_componentManager numberOfComponents];
}

- (void)fireGlobalEvent:(NSString *)eventName params:(NSDictionary *)params
{
    if (!params){
        params = [NSDictionary dictionary];
    }
    NSDictionary * userInfo = @{
            @"judInstance":self.instanceId,
            @"param":params
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:self userInfo:userInfo];
}

- (void)fireModuleEvent:(Class)module eventName:(NSString *)eventName params:(NSDictionary*)params
{
    NSDictionary * userInfo = @{
                                @"moduleId":NSStringFromClass(module)?:@"",
                                @"param":params?:@{},
                                @"eventName":eventName
                                };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JUD_MODULE_EVENT_FIRE_NOTIFICATION object:self userInfo:userInfo];
}

- (CGFloat)pixelScaleFactor
{
    if (self.viewportWidth > 0) {
        return [JUDUtility portraitScreenSize].width / self.viewportWidth;
    } else {
        return [JUDUtility defaultPixelScaleFactor];
    }
}

- (NSURL *)completeURL:(NSString *)url
{
    if (!_scriptURL) {
        return [NSURL URLWithString:url];
    }
    if ([url hasPrefix:@"//"] && [_scriptURL isFileURL]) {
        return [NSURL URLWithString:url];
    }
    if (!url) {
        return nil;
    }
    
    return [NSURL URLWithString:url relativeToURL:_scriptURL];
}

- (BOOL)checkModuleEventRegistered:(NSString*)event moduleClassName:(NSString*)moduleClassName
{
    NSDictionary * observer = [_moduleEventObservers objectForKey:moduleClassName];
    return observer && observer[event]? YES:NO;
}

#pragma mark Private Methods

- (void)_addModuleEventObserversWithModuleMethod:(JUDModuleMethod *)method
{
    if ([method.arguments count] < 2) {
        JUDLogError(@"please check your method parameter!!");
        return;
    }
    if(![method.arguments[0] isKindOfClass:[NSString class]]) {
        // arguments[0] will be event name, so it must be a string type value here.
        return;
    }
    NSMutableArray * methodArguments = [method.arguments mutableCopy];
    if ([methodArguments count] == 2) {
        [methodArguments addObject:@{@"once": @false}];
    }
    if (![methodArguments[2] isKindOfClass:[NSDictionary class]]) {
        //arguments[2] is the option value, so it must be a dictionary.
        return;
    }
    Class moduleClass =  [JUDModuleFactory classWithModuleName:method.moduleName];
    NSMutableDictionary * option = [methodArguments[2] mutableCopy];
    [option setObject:method.moduleName forKey:@"moduleName"];
    // the value for moduleName in option is for the need of callback
    [self addModuleEventObservers:methodArguments[0] callback:methodArguments[1] option:option moduleClassName:NSStringFromClass(moduleClass)];
}

- (void)addModuleEventObservers:(NSString*)event callback:(NSString*)callbackId option:(NSDictionary *)option moduleClassName:(NSString*)moduleClassName
{
    BOOL once = [[option objectForKey:@"once"] boolValue];
    NSString * moduleName = [option objectForKey:@"moduleName"];
    NSMutableDictionary * observer = nil;
    NSDictionary * callbackInfo = @{@"callbackId":callbackId,@"once":@(once),@"moduleName":moduleName};
    if(![self checkModuleEventRegistered:event moduleClassName:moduleClassName]) {
        //had not registered yet
        observer = [NSMutableDictionary new];
        [observer setObject:[@{event:[@[callbackInfo] mutableCopy]} mutableCopy] forKey:moduleClassName];
        [_moduleEventObservers addEntriesFromDictionary:observer];
    } else {
        observer = _moduleEventObservers[moduleClassName];
        [[observer objectForKey:event] addObject:callbackInfo];
    }
}

- (void)_removeModuleEventObserverWithModuleMethod:(JUDModuleMethod *)method
{
    if (![method.arguments count] && [method.arguments[0] isKindOfClass:[NSString class]]) {
        return;
    }
    Class moduleClass =  [JUDModuleFactory classWithModuleName:method.moduleName];
    [self removeModuleEventObserver:method.arguments[0] moduleClassName:NSStringFromClass(moduleClass)];
}

- (void)removeModuleEventObserver:(NSString*)event moduleClassName:(NSString*)moduleClassName
{
    if (![self checkModuleEventRegistered:event moduleClassName:moduleClassName]) {
        return;
    }
    [_moduleEventObservers[moduleClassName] removeObjectForKey:event];
}

- (void)moduleEventNotification:(NSNotification *)notification
{
    NSMutableDictionary *moduleEventObserversCpy = (NSMutableDictionary *)CFBridgingRelease(CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)_moduleEventObservers, kCFPropertyListMutableContainers));// deep
    NSDictionary * userInfo = notification.userInfo;
    NSMutableArray * listeners = [moduleEventObserversCpy[userInfo[@"moduleId"]] objectForKey:userInfo[@"eventName"]];
    if (![listeners isKindOfClass:[NSArray class]]) {
        return;
        // something wrong
    }
    for (int i = 0;i < [listeners count]; i ++) {
        NSDictionary * callbackInfo = listeners[i];
        NSString *callbackId = callbackInfo[@"callbackId"];
        BOOL once = [callbackInfo[@"once"] boolValue];
        NSDictionary * retData = @{@"type":userInfo[@"eventName"],
                                   @"module":callbackInfo[@"moduleName"],
                                   @"data":userInfo[@"param"]};
        [[JUDSDKManager bridgeMgr] callBack:self.instanceId funcId:callbackId params:retData keepAlive:!once];
        // if callback function is not once, then it is keepalive
        if (once) {
            NSMutableArray * moduleEventListener = [_moduleEventObservers[userInfo[@"moduleId"]] objectForKey:userInfo[@"eventName"]];
            [moduleEventListener removeObject:callbackInfo];
            if ([moduleEventListener count] == 0) {
                [self removeModuleEventObserver:userInfo[@"eventName"] moduleClassName:userInfo[@"moduleId"]];
            }
            // if callback function is once. clear it after fire it.
        }
    }
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleEventNotification:) name:JUD_MODULE_EVENT_FIRE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers
{
    [self removeObserver:self forKeyPath:@"state"];
}

- (void)applicationWillResignActive:(NSNotification*)notification
{
    [self fireGlobalEvent:JUD_APPLICATION_WILL_RESIGN_ACTIVE params:nil];
}

- (void)applicationDidBecomeActive:(NSNotification*)notification
{
    [self fireGlobalEvent:JUD_APPLICATION_DID_BECOME_ACTIVE params:nil];
}

- (JUDComponentManager *)componentManager
{
    if (!_componentManager) {
        _componentManager = [[JUDComponentManager alloc] initWithJudInstance:self];
    }
    
    return _componentManager;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"]) {
        JUDState state = [change[@"new"] longValue];
        [self updateState:state];
        
        if (state == JudInstanceDestroy) {
            [self destroyInstance];
        }
    }
}

@end

@implementation JUDSDKInstance (Deprecated)

# pragma mark - Deprecated

- (void)reloadData:(id)data
{
    [self refreshInstance:data];
}

- (void)finishPerformance
{
    //deprecated
}

- (void)creatFinish
{
    
}

@end
