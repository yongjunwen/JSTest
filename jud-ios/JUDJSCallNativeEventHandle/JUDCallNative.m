//
//  JUDCallNative.m
//  Jdipad
//
//  Created by Leo on 2017/5/24.
//  Copyright © 2017年 steven sun. All rights reserved.
//

#import "JUDCallNative.h"

@interface JUDCallNative()
@property (nonatomic, strong) NSMutableDictionary *judCallNativeHandles;

@end

@implementation JUDCallNative
+ (instancetype)sharedInstance
{
    static JUDCallNative *native;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        native = [[JUDCallNative alloc] init];
    });
    
    return native;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.judCallNativeHandles = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (void)registEvent:(NSString *)name callBack:(void(^)(NSDictionary *info, JUDModuleCallback callJS))callBack
{
    [[self sharedInstance] _registEvent:name callBack:callBack];
}

static inline bool validateString(NSString *string) {
    bool result = false;
    if (string && [string isKindOfClass:[NSString class]] && [string length]) {
        result = true;
    }
    return result;
}

- (void)_registEvent:(NSString *)name callBack:(void(^)(NSDictionary *info, JUDModuleCallback callJS))callBack
{
    if(!validateString(name) || !callBack)
    {
        return;
    }
    
    self.judCallNativeHandles[name] = [callBack copy];
}

+ (void)resignEvent:(NSString *)name
{
    [[self sharedInstance] _resignEvent:name];
}

- (void)_resignEvent:(NSString *)name
{
    if(!validateString(name))
    {
        return;
    }
    
    self.judCallNativeHandles[name] = nil;
}

+ (void)handleEvent:(NSString *)name userInfo:(NSDictionary *)info callJSBack:(JUDModuleCallback)callJS
{
    [[self sharedInstance] _handleEvent:name userInfo:info callJSBack:callJS];
}

- (void)_handleEvent:(NSString *)name userInfo:(NSDictionary *)info callJSBack:(JUDModuleCallback)callJS
{
    if(!validateString(name))
    {
        return;
    }
    
    void(^block)(NSDictionary *info, JUDModuleCallback callJS) = self.judCallNativeHandles[name];
    if(block)
    {
        block(info, callJS);
    }
}

@end
