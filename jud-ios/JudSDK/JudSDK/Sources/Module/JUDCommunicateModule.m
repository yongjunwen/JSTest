//
//  JUDCommunicateModule.m
//  Pods
//
//  Created by Leo on 2017/6/2.
//
//

#import "JUDCommunicateModule.h"
#import "JUDThreadSafeMutableDictionary.h"

@interface JUDCommunicateModule()
@property (nonatomic, strong) JUDThreadSafeMutableDictionary *eventCallback;

@end

@implementation JUDCommunicateModule

JUD_EXPORT_METHOD(@selector(send:userInfo:callJSBack:))
JUD_EXPORT_METHOD(@selector(removeEvent:))
JUD_EXPORT_METHOD(@selector(listen:callJSBack:))

- (instancetype)init
{
    if (self = [super init])
    {
        self.eventCallback = [[JUDThreadSafeMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)send:(NSString *)eventName userInfo:(NSDictionary *)info callJSBack:(JUDModuleCallback)callBack
{
    NSDictionary *notiInfo;
    if(info && callBack)
    {
        notiInfo = @{@"UserInfo": info,
                     @"CallJS": callBack};
    }
    else if(info)
    {
        notiInfo = @{@"UserInfo": info};
    }
    else if(callBack)
    {
        notiInfo = @{@"CallJS": callBack};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JUDCommunicatePrefix(eventName)
                                                        object:nil
                                                      userInfo:notiInfo];
}

- (void)listen:(NSString *)eventName callJSBack:(JUDModuleCallback)callBack
{
    if(!callBack || !eventName)
    {
        return;
    }
    
    NSMutableArray *callBacks = self.eventCallback[eventName];
    if(!callBacks)
    {
        callBacks = [[NSMutableArray alloc] init];
    }
    
    [callBacks addObject:callBack];
    self.eventCallback[eventName] = callBacks;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fireEvent:)
                                                 name:JUDCommunicateListenPrefix(eventName)
                                               object:nil];
}

- (void)fireEvent:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if(!userInfo)
    {
        return;
    }
    
    NSDictionary *info = userInfo[@"UserInfo"];
    NSDictionary *event = userInfo[@"Event"];
    if(!event)
    {
        return;
    }
    
    NSMutableArray *callBacks = self.eventCallback[event];
    for(JUDModuleCallback callBack in callBacks)
    {
        callBack(info);
    }
}

- (void)remove:(NSString *)eventName
{
    if(!eventName)
    {
        return;
    }
    
    [self.eventCallback removeObjectForKey:eventName];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:JUDCommunicateListenPrefix(eventName)
                                                  object:nil];
}

@end
