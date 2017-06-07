/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDDebugTool.h"
//#import "JUDFPSLabel.h"
#import "JUDHandlerFactory.h"
#import "JUDNetworkProtocol.h"
#import "JUDUtility.h"
#import "JUDSDKManager.h"
#import "JUDSDKEngine.h"
#import "JUDResourceRequest.h"
#import "JUDResourceResponse.h"
#import "JUDResourceLoader.h"

static BOOL JUDIsDebug;
static BOOL JUDIsDevToolDebug;
static NSString* JUDDebugrepBundleJS;
static NSString* JUDDebugrepJSFramework;


@interface JUDDebugTool ()
// store service
@property (nonatomic, strong) NSMutableDictionary *jsServiceDic;

@end

@implementation JUDDebugTool

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if(self = [super init]){
        _jsServiceDic = [NSMutableDictionary dictionary];
    }
    return self;
}

//+ (void)showFPS
//{
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    JUDFPSLabel *label = [[JUDFPSLabel alloc] initWithFrame:CGRectMake(window.frame.size.width-135, window.frame.size.height-35, 120, 20)];
//    label.layer.zPosition = MAXFLOAT;
//    [window addSubview:label];
//}

+ (void)setDebug:(BOOL)isDebug
{
    JUDIsDebug = isDebug;
}

+ (BOOL)isDebug
{
    return JUDIsDebug;
}

+ (void)setDevToolDebug:(BOOL)isDevToolDebug {
    JUDIsDevToolDebug = isDevToolDebug;
}

+ (BOOL)isDevToolDebug {
    return JUDIsDevToolDebug;
}

+ (void)setReplacedBundleJS:(NSURL*)url{
    [self getData:url key:@"bundlejs"];
}

+ (NSString*)getReplacedBundleJS{
    return JUDDebugrepBundleJS;
}

+ (void)setReplacedJSFramework:(NSURL*)url{
    [self getData:url key:@"jsframework"];
}

+ (NSString*)getReplacedJSFramework{
    
    return JUDDebugrepJSFramework;
}

+ (void)getData:(NSURL*)url key:(NSString*)key{
    void(^scriptLoadFinish)(NSString*, NSString*) = ^(NSString* key, NSString* script){
        if ([key isEqualToString:@"jsframework"]) {
            JUDDebugrepJSFramework = script;
            [JUDSDKEngine restartWithScript:script];
        }else {
            JUDDebugrepBundleJS = script;
        }
    };
    if ([url isFileURL]) {
        // File URL
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = [url path];
            NSData *scriptData = [[NSFileManager defaultManager] contentsAtPath:path];
            NSString *script = [[NSString alloc] initWithData:scriptData encoding:NSUTF8StringEncoding];
            if (!script || script.length <= 0) {
                NSString *errorDesc = [NSString stringWithFormat:@"File read error at url: %@", url];
                JUDLogError(@"%@", errorDesc);
            }
            scriptLoadFinish(key, script);
        });
    } else {
        // HTTP/HTTPS URL
        JUDResourceRequest *request = [JUDResourceRequest requestWithURL:url resourceType:JUDResourceTypeMainBundle referrer:nil cachePolicy:NSURLRequestUseProtocolCachePolicy];
        request.userAgent = [JUDUtility userAgent];
        JUDResourceLoader *loader = [[JUDResourceLoader alloc] initWithRequest:request];
        
        loader.onFinished = ^(const JUDResourceResponse * response, NSData *data) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]] && ((NSHTTPURLResponse *)response).statusCode != 200) {
                __unused NSError *error = [NSError errorWithDomain:JUD_ERROR_DOMAIN
                                                              code:((NSHTTPURLResponse *)response).statusCode
                                                          userInfo:@{@"message":@"status code error."}];
                
                return ;
            }
            
            NSString * script = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            scriptLoadFinish(key, script);
        };
        
        [loader start];
    }
}

+ (BOOL) cacheJsService: (NSString *)name withScript: (NSString *)script withOptions: (NSDictionary *) options
{
    if(JUDIsDebug) {
        [[[self sharedInstance] jsServiceDic] setObject:@{ @"name": name, @"script": script, @"options": options } forKey:name];
        return YES;
    }else {
        return NO;
    }
}

+ (BOOL) removeCacheJsService: (NSString *)name
{
    if(JUDIsDebug) {
        [[[self sharedInstance] jsServiceDic] removeObjectForKey:name];
        return YES;
    }else {
        return NO;
    }
}

+ (NSDictionary *) jsServiceCache
{
    return [NSDictionary dictionaryWithDictionary:[[self sharedInstance] jsServiceDic]];
}

@end
