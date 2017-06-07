/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDGlobalEventModule.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDThreadSafeMutableArray.h"
#import "JUDLog.h"
#import "JUDSDKManager.h"

@interface JUDGlobalEventModule()
@property JUDThreadSafeMutableDictionary *eventCallback;
@end
@implementation JUDGlobalEventModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(addEventListener:callback:))
JUD_EXPORT_METHOD(@selector(removeEventListener:))

- (instancetype)init {
    if (self = [super init]) {
        _eventCallback = [JUDThreadSafeMutableDictionary new];
    }
    return self;
}

- (void)addEventListener:(NSString *)event callback:(JUDModuleKeepAliveCallback)callback
{
    JUDThreadSafeMutableArray * array = nil;
    if (_eventCallback[event]) {
        if (callback) {
            [_eventCallback[event] addObject:callback];
        }
    } else {
        array = [[JUDThreadSafeMutableArray alloc] init];
        if (callback) {
            [array addObject:callback];
        }
        _eventCallback[event] = array;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fireGlobalEvent:) name:event object:nil];
    }
}

- (void)removeEventListener:(NSString *)event
{
    if (_eventCallback[event]) {
        [_eventCallback removeObjectForKey:event];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:event object:nil];
    } else {
        JUDLogWarning(@"eventName \"%@\" doesn't exist", event);
    }
}

- (void)fireGlobalEvent:(NSNotification *)notification
{
    NSDictionary * userInfo = notification.userInfo;
    NSString * userJudInstanceId = userInfo[@"judInstance"];
    /*
     1. The userJudInstanceId param will be passed by globalEvent module notification.
     2. The notification is posted by native user using NotificationCenter, native user don't need care about what the userJudInstanceId is. What you do is to addEventListener in jud file using globalEvent module, and then post notification anywhere.
     */
    JUDSDKInstance * userJudInstance = [JUDSDKManager instanceForID:userJudInstanceId];
     // In case that userInstanceId exists but instance has been dealloced
    if (!userJudInstanceId || userJudInstance == judInstance) {
        
        for (JUDModuleKeepAliveCallback callback in _eventCallback[notification.name]) {
            callback(userInfo[@"param"], true);
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_eventCallback removeAllObjects];
}

@end
