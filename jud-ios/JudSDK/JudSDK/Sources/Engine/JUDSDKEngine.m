/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDSDKEngine.h"
#import "JUDDebugTool.h"
#import "JUDModuleFactory.h"
#import "JUDHandlerFactory.h"
#import "JUDComponentFactory.h"
#import "JUDBridgeManager.h"

#import "JUDAppConfiguration.h"
#import "JUDResourceRequestHandlerDefaultImpl.h"
#import "JUDNavigationDefaultImpl.h"
#import "JUDURLRewriteDefaultImpl.h"
#import "JUDWebSocketDefaultImpl.h"
#import "JUDMTADefaultImpl.h"

#import "JUDSDKManager.h"
#import "JUDSDKError.h"
#import "JUDMonitor.h"
#import "JUDSimulatorShortcutManager.h"
#import "JUDAssert.h"
#import "JUDLog.h"
#import "JUDUtility.h"

@implementation JUDSDKEngine

# pragma mark Module Register

// register some default modules when the engine initializes.
+ (void)_registerDefaultModules
{
    [self registerModule:@"dom" withClass:NSClassFromString(@"JUDDomModule")];
    [self registerModule:@"navigator" withClass:NSClassFromString(@"JUDNavigatorModule")];
    [self registerModule:@"stream" withClass:NSClassFromString(@"JUDStreamModule")];
    [self registerModule:@"animation" withClass:NSClassFromString(@"JUDAnimationModule")];
    [self registerModule:@"modal" withClass:NSClassFromString(@"JUDModalUIModule")];
    [self registerModule:@"webview" withClass:NSClassFromString(@"JUDWebViewModule")];
    [self registerModule:@"instanceWrap" withClass:NSClassFromString(@"JUDInstanceWrap")];
    [self registerModule:@"timer" withClass:NSClassFromString(@"JUDTimerModule")];
    [self registerModule:@"storage" withClass:NSClassFromString(@"JUDStorageModule")];
    [self registerModule:@"clipboard" withClass:NSClassFromString(@"JUDClipboardModule")];
    [self registerModule:@"globalEvent" withClass:NSClassFromString(@"JUDGlobalEventModule")];
    [self registerModule:@"canvas" withClass:NSClassFromString(@"JUDCanvasModule")];
    [self registerModule:@"picker" withClass:NSClassFromString(@"JUDPickerModule")];
    [self registerModule:@"meta" withClass:NSClassFromString(@"JUDMetaModule")];
    [self registerModule:@"webSocket" withClass:NSClassFromString(@"JUDWebSocketModule")];
    [self registerModule:@"communicate" withClass:NSClassFromString(@"JUDCommunicateModule")];
    [self registerModule:@"mta" withClass:NSClassFromString(@"JUDMTAModule")];
}

+ (void)registerModule:(NSString *)name withClass:(Class)clazz
{
    JUDAssert(name && clazz, @"Fail to register the module, please check if the parameters are correct ！");
    
    NSString *moduleName = [JUDModuleFactory registerModule:name withClass:clazz];
    NSDictionary *dict = [JUDModuleFactory moduleMethodMapsWithName:moduleName];
    
    [[JUDSDKManager bridgeMgr] registerModules:dict];
}

# pragma mark Component Register

// register some default components when the engine initializes.
+ (void)_registerDefaultComponents
{
    [self registerComponent:@"container" withClass:NSClassFromString(@"JUDDivComponent") withProperties:nil];
    [self registerComponent:@"div" withClass:NSClassFromString(@"JUDComponent") withProperties:nil];
    [self registerComponent:@"text" withClass:NSClassFromString(@"JUDTextComponent") withProperties:nil];
    [self registerComponent:@"image" withClass:NSClassFromString(@"JUDImageComponent") withProperties:nil];
    [self registerComponent:@"scroller" withClass:NSClassFromString(@"JUDScrollerComponent") withProperties:nil];
    [self registerComponent:@"list" withClass:NSClassFromString(@"JUDListComponent") withProperties:nil];
    
    [self registerComponent:@"header" withClass:NSClassFromString(@"JUDHeaderComponent")];
    [self registerComponent:@"cell" withClass:NSClassFromString(@"JUDCellComponent")];
    [self registerComponent:@"embed" withClass:NSClassFromString(@"JUDEmbedComponent")];
    [self registerComponent:@"a" withClass:NSClassFromString(@"JUDAComponent")];
    
    [self registerComponent:@"select" withClass:NSClassFromString(@"JUDSelectComponent")];
    [self registerComponent:@"switch" withClass:NSClassFromString(@"JUDSwitchComponent")];
    [self registerComponent:@"input" withClass:NSClassFromString(@"JUDTextInputComponent")];
    [self registerComponent:@"video" withClass:NSClassFromString(@"JUDVideoComponent")];
    [self registerComponent:@"indicator" withClass:NSClassFromString(@"JUDIndicatorComponent")];
    [self registerComponent:@"slider" withClass:NSClassFromString(@"JUDSliderComponent")];
    [self registerComponent:@"web" withClass:NSClassFromString(@"JUDWebComponent")];
    [self registerComponent:@"loading" withClass:NSClassFromString(@"JUDLoadingComponent")];
    [self registerComponent:@"loading-indicator" withClass:NSClassFromString(@"JUDLoadingIndicator")];
    [self registerComponent:@"refresh" withClass:NSClassFromString(@"JUDRefreshComponent")];
    [self registerComponent:@"textarea" withClass:NSClassFromString(@"JUDTextAreaComponent")];
	[self registerComponent:@"canvas" withClass:NSClassFromString(@"JUDCanvasComponent")];
    [self registerComponent:@"slider-neighbor" withClass:NSClassFromString(@"JUDSliderNeighborComponent")];
}

+ (void)registerComponent:(NSString *)name withClass:(Class)clazz
{
    [self registerComponent:name withClass:clazz withProperties: @{@"append":@"tree"}];
}

+ (void)registerComponent:(NSString *)name withClass:(Class)clazz withProperties:(NSDictionary *)properties
{
    if (!name || !clazz) {
        return;
    }

    JUDAssert(name && clazz, @"Fail to register the component, please check if the parameters are correct ！");
    
    [JUDComponentFactory registerComponent:name withClass:clazz withPros:properties];
    NSMutableDictionary *dict = [JUDComponentFactory componentMethodMapsWithName:name];
    dict[@"type"] = name;
    if (properties) {
        NSMutableDictionary *props = [properties mutableCopy];
        if ([dict[@"methods"] count]) {
            [props addEntriesFromDictionary:dict];
        }
        [[JUDSDKManager bridgeMgr] registerComponents:@[props]];
    } else {
        [[JUDSDKManager bridgeMgr] registerComponents:@[dict]];
    }
}


# pragma mark Service Register
+ (void)registerService:(NSString *)name withScript:(NSString *)serviceScript withOptions:(NSDictionary *)options
{
    [[JUDSDKManager bridgeMgr] registerService:name withService:serviceScript withOptions:options];
}

+ (void)registerService:(NSString *)name withScriptUrl:(NSURL *)serviceScriptUrl WithOptions:(NSDictionary *)options
{
    [[JUDSDKManager bridgeMgr] registerService:name withServiceUrl:serviceScriptUrl withOptions:options];
}

+ (void)unregisterService:(NSString *)name
{
    [[JUDSDKManager bridgeMgr] unregisterService:name];
}

# pragma mark Handler Register

// register some default handlers when the engine initializes.
+ (void)_registerDefaultHandlers
{
    [self registerHandler:[JUDResourceRequestHandlerDefaultImpl new] withProtocol:@protocol(JUDResourceRequestHandler)];
    [self registerHandler:[JUDNavigationDefaultImpl new] withProtocol:@protocol(JUDNavigationProtocol)];
    [self registerHandler:[JUDURLRewriteDefaultImpl new] withProtocol:@protocol(JUDURLRewriteProtocol)];
    [self registerHandler:[JUDWebSocketDefaultImpl new] withProtocol:@protocol(JUDWebSocketHandler)];
    [self registerHandler:[JUDMTADefaultImpl new] withProtocol:@protocol(JUDMTAProtocol)];
}

+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol
{
    JUDAssert(handler && protocol, @"Fail to register the handler, please check if the parameters are correct ！");
    
    [JUDHandlerFactory registerHandler:handler withProtocol:protocol];
}

+ (id)handlerForProtocol:(Protocol *)protocol
{
    JUDAssert(protocol, @"Fail to get the handler, please check if the parameters are correct ！");
    
    return  [JUDHandlerFactory handlerForProtocol:protocol];
}

# pragma mark SDK Initialize

+ (void)initSDKEnvironment
{
    JUD_MONITOR_PERF_START(JUDPTInitalize)
    JUD_MONITOR_PERF_START(JUDPTInitalizeSync)
    
    NSString *filePath = [[NSBundle bundleForClass:self] pathForResource:@"main" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [JUDSDKEngine initSDKEnvironment:script];
    
    JUD_MONITOR_PERF_END(JUDPTInitalizeSync)
    
#if TARGET_OS_SIMULATOR
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [JUDSimulatorShortcutManager registerSimulatorShortcutWithKey:@"i" modifierFlags:UIKeyModifierCommand | UIKeyModifierAlternate action:^{
            NSURL *URL = [NSURL URLWithString:@"http://localhost:8687/launchDebugger"];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                    completionHandler:
                                          ^(NSData *data, NSURLResponse *response, NSError *error) {
                                              // ...
                                          }];
            
            [task resume];
            JUDLogInfo(@"Launching browser...");
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self connectDebugServer:@"ws://localhost:8687/debugger/0/renderer"];
            });
            
        }];
    });
#endif
}

+ (void)initSDKEnvironment:(NSString *)script
{
    if (!script || script.length <= 0) {
        JUD_MONITOR_FAIL(JUDMTJSFramework, JUD_ERR_JSFRAMEWORK_LOAD, @"framework loading is failure!");
        return;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self registerDefaults];
        [[JUDSDKManager bridgeMgr] executeJsFramework:script];
    });
}

+ (void)registerDefaults
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _registerDefaultComponents];
        [self _registerDefaultModules];
        [self _registerDefaultHandlers];
    });
}

+ (NSString*)SDKEngineVersion
{
    return JUD_SDK_VERSION;
}

+ (JUDSDKInstance *)topInstance
{
    return [JUDSDKManager bridgeMgr].topInstance;
}


static NSDictionary *_customEnvironment;
+ (void)setCustomEnvironment:(NSDictionary *)environment
{
    _customEnvironment = environment;
}

+ (NSDictionary *)customEnvironment
{
    return _customEnvironment;
}

# pragma mark Debug

+ (void)unload
{
    [JUDSDKManager unload];
    [JUDComponentFactory unregisterAllComponents];
}

+ (void)restart
{
    NSString *filePath = [[NSBundle bundleForClass:self] pathForResource:@"main" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self restartWithScript:script];
}

+ (void)restartWithScript:(NSString*)script
{
    NSDictionary *components = [JUDComponentFactory componentConfigs];
    NSDictionary *modules = [JUDModuleFactory moduleConfigs];
    NSDictionary *handlers = [JUDHandlerFactory handlerConfigs];
    [JUDSDKManager unload];
    [JUDComponentFactory unregisterAllComponents];
    
    [self _originalRegisterComponents:components];
    [self _originalRegisterModules:modules];
    [self _originalRegisterHandlers:handlers];
    
    [[JUDSDKManager bridgeMgr] executeJsFramework:script];
    
    NSDictionary *jsSerices = [JUDDebugTool jsServiceCache];
    for(NSString *serviceName in jsSerices) {
        NSDictionary *service = [jsSerices objectForKey:serviceName];
        NSString *serviceName = [service objectForKey:@"name"];
        NSString *serviceScript = [service objectForKey:@"script"];
        NSDictionary *serviceOptions = [service objectForKey:@"options"];
        [JUDSDKEngine registerService:serviceName withScript:serviceScript withOptions:serviceOptions];
    }
}

+ (void)connectDebugServer:(NSString*)URL
{
    [[JUDSDKManager bridgeMgr] connectToWebSocket:[NSURL URLWithString:URL]];
}

+ (void)connectDevToolServer:(NSString *)URL
{
    [[JUDSDKManager bridgeMgr] connectToDevToolWithUrl:[NSURL URLWithString:URL]];
}

+ (void)_originalRegisterComponents:(NSDictionary *)components {
    void (^componentBlock)(id, id, BOOL *) = ^(id mKey, id mObj, BOOL * mStop) {
        
        NSString *name = mObj[@"name"];
        NSString *componentClass = mObj[@"clazz"];
        NSDictionary *pros = nil;
        if (mObj[@"pros"]) {
            pros = mObj[@""];
        }
        [self registerComponent:name withClass:NSClassFromString(componentClass) withProperties:pros];
    };
    [components enumerateKeysAndObjectsUsingBlock:componentBlock];
    
}

+ (void)_originalRegisterModules:(NSDictionary *)modules {
    void (^moduleBlock)(id, id, BOOL *) = ^(id mKey, id mObj, BOOL * mStop) {
        
        [self registerModule:mKey withClass:NSClassFromString(mObj)];
    };
    [modules enumerateKeysAndObjectsUsingBlock:moduleBlock];
}

+ (void)_originalRegisterHandlers:(NSDictionary *)handlers {
    void (^handlerBlock)(id, id, BOOL *) = ^(id mKey, id mObj, BOOL * mStop) {
        [self registerHandler:mObj withProtocol:NSProtocolFromString(mKey)];
    };
    [handlers enumerateKeysAndObjectsUsingBlock:handlerBlock];
}

@end

@implementation JUDSDKEngine (Deprecated)

+ (void)initSDKEnviroment
{
    [self initSDKEnvironment];
}

+ (void)initSDKEnviroment:(NSString *)script
{
    [self initSDKEnvironment:script];
}

@end
