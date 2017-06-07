//
//  JUDCommunicate.m
//  Pods
//
//  Created by Leo on 2017/6/2.
//
//

#import "JUDCommunicate.h"
#import "JUDCommunicateModule.h"

@interface JUDCommunicate()
@property (nonatomic, strong) NSLock *lock;

@end

@implementation JUDCommunicate
+ (void)send:(NSString *)eventName userInfo:(NSDictionary *)info
{
    if(!eventName)
    {
        return;
    }
    
    NSDictionary *notiInfo;
    if(!info)
    {
        notiInfo = @{@"Event": eventName};
    }
    else
    {
        notiInfo = @{@"Event": eventName,
                     @"UserInfo": info};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JUDCommunicateListenPrefix(eventName)
                                                        object:nil
                                                      userInfo:notiInfo];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.lock = [[NSLock alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:JUDCommunicatePrefix(_eventName)
                                                  object:nil];
}

- (void)handleEvent:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSDictionary *userInfo = info[@"UserInfo"];
    JUDModuleCallback callBack = info[@"CallJS"];
    
    if(self.event)
    {
        self.event(userInfo, callBack);
    }
}

- (void)setEventName:(NSString *)eventName
{
    if(![_eventName isEqualToString:eventName])
    {
        if(_eventName)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:JUDCommunicatePrefix(_eventName)
                                                          object:nil];
        }
        
        _eventName = [eventName copy];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleEvent:)
                                                     name:JUDCommunicatePrefix(_eventName)
                                                   object:nil];
    }
}

@end
