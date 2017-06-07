/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDSDKManager.h"
#import "JUDThreadSafeMutableDictionary.h"

@interface JUDSDKManager ()

@property (nonatomic, strong) JUDBridgeManager *bridgeMgr;

@property (nonatomic, strong) JUDThreadSafeMutableDictionary *instanceDict;

@end

@implementation JUDSDKManager

static JUDSDKManager *_sharedInstance = nil;

+ (JUDSDKManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
            _sharedInstance.instanceDict = [[JUDThreadSafeMutableDictionary alloc] init];
        }
    });
    return _sharedInstance;
}

+ (JUDBridgeManager *)bridgeMgr
{
    JUDBridgeManager *bridgeMgr = [self sharedInstance].bridgeMgr;
    if (!bridgeMgr) {
        bridgeMgr = [[JUDBridgeManager alloc] init];
        [self sharedInstance].bridgeMgr = bridgeMgr;
    }
    return bridgeMgr;
}

+ (id)instanceForID:(NSString *)identifier
{
    return [[self sharedInstance].instanceDict objectForKey:identifier];
}

+ (void)storeInstance:(JUDSDKInstance *)instance forID:(NSString *)identifier
{
    [[self sharedInstance].instanceDict setObject:instance forKey:identifier];
}

+ (void)removeInstanceforID:(NSString *)identifier
{
    if (identifier) {
        [[self sharedInstance].instanceDict removeObjectForKey:identifier];
    }
}

+ (void)unload
{
    for (NSString *instanceID in [self sharedInstance].instanceDict) {
        JUDSDKInstance *instance = [[self sharedInstance].instanceDict objectForKey:instanceID];
        [instance destroyInstance];
    }
    
    [self sharedInstance].bridgeMgr = nil;
}

+ (JUDModuleManager *)moduleMgr
{
    return nil;
}

@end
