/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDTimerModule.h"
#import "JUDSDKManager.h"
#import "JUDLog.h"
#import "JUDAssert.h"

@interface JUDTimerTarget : NSObject

- (instancetype)initWithCallback:(NSString *)callbackID shouldRepeat:(BOOL)shouldRepeat judInstance:(JUDSDKInstance *)judInstance;

@end

@implementation JUDTimerTarget
{
    NSString * _callbackID;
    __weak JUDSDKInstance *_judInstance;
    BOOL _shouldRepeat;
}

- (instancetype)initWithCallback:(NSString *)callbackID shouldRepeat:(BOOL)shouldRepeat judInstance:(JUDSDKInstance *)judInstance
{
    if (self = [super init]) {
        _callbackID = callbackID;
        _judInstance = judInstance;
        _shouldRepeat = shouldRepeat;
    }
    
    return self;
}

- (void)trigger
{
    [[JUDSDKManager bridgeMgr] callBack:_judInstance.instanceId funcId:_callbackID params:nil keepAlive:_shouldRepeat];
}

@end

@implementation JUDTimerModule
{
    NSMutableDictionary *_timers;
}

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(setTimeout:time:))
JUD_EXPORT_METHOD(@selector(clearTimeout:))
JUD_EXPORT_METHOD(@selector(setInterval:time:))
JUD_EXPORT_METHOD(@selector(clearInterval:))

- (instancetype)init
{
    if (self = [super init]) {
        _timers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)createTimerWithCallback:(NSString *)callbackID time:(NSTimeInterval)milliseconds shouldRepeat:(BOOL)shouldRepeat
{
    JUDAssert(callbackID, @"callbackID for timer must not be nil.");
    
    if (milliseconds == 0 && !shouldRepeat) {
        [[JUDSDKManager bridgeMgr] callBack:self.judInstance.instanceId funcId:callbackID params:nil keepAlive:NO];
    }
    
    JUDTimerTarget *target = [[JUDTimerTarget alloc] initWithCallback:callbackID shouldRepeat:shouldRepeat judInstance:self.judInstance];
    
    [self createTimerWithCallback:callbackID time:milliseconds target:target selector:@selector(trigger) shouldRepeat:shouldRepeat];
}

# pragma mark Timer API

- (void)setTimeout:(NSString *)callbackID time:(NSTimeInterval)time
{
    [self createTimerWithCallback:callbackID time:time shouldRepeat:NO];
}

- (void)setInterval:(NSString *)callbackID time:(NSTimeInterval)time
{
    [self createTimerWithCallback:callbackID time:time shouldRepeat:YES];
}

- (void)clearTimeout:(NSString *)callbackID
{
    if (!callbackID) {
        JUDLogError(@"no callbackID for clearTimeout/clearInterval");
        return;
    }
    
    NSTimer *timer = _timers[callbackID];
    if (!timer) {
        JUDLogWarning(@"no timer found for callbackID:%@", callbackID);
        return;
    }

    [timer invalidate];
    [_timers removeObjectForKey:callbackID];
}

- (void)clearInterval:(NSString *)callbackID
{
    [self clearTimeout:callbackID];
}

- (void)dealloc
{
    if (_timers) {
        for (NSString *callbackID in _timers) {
            NSTimer *timer = _timers[callbackID];
            [timer invalidate];
        }
        [_timers removeAllObjects];
        _timers = nil;
    }
}

# pragma mark Unit Test

- (void)createTimerWithCallback:(NSString *)callbackID time:(NSTimeInterval)milliseconds target:(id)target selector:(SEL)selector shouldRepeat:(BOOL)shouldRepeat {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:milliseconds/1000.0f target:target selector:selector userInfo:nil repeats:shouldRepeat];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    if (!_timers[callbackID]) {
        _timers[callbackID] = timer;
    }
}

- (NSMutableDictionary *)timers
{
    return _timers;
}

@end
