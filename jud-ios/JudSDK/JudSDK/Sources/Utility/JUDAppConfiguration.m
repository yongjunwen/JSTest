/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDAppConfiguration.h"

@interface JUDAppConfiguration ()

@property (nonatomic, strong) NSString * appGroup;
@property (nonatomic, strong) NSString * appName;
@property (nonatomic, strong) NSString * appVersion;
@property (nonatomic, strong) NSString * externalUA;
@property (nonatomic, strong) NSString * JSFrameworkVersion;
@property (nonatomic, strong) NSArray  * customizeProtocolClasses;
@end

@implementation JUDAppConfiguration

+ (instancetype)sharedConfiguration
{
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

+ (NSString *)appGroup
{
    return [JUDAppConfiguration sharedConfiguration].appGroup;
}

+ (void)setAppGroup:(NSString *)appGroup
{
    [JUDAppConfiguration sharedConfiguration].appGroup = appGroup;
}

+ (NSString *)appName
{
    return [JUDAppConfiguration sharedConfiguration].appName ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (void)setAppName:(NSString *)appName
{
    [JUDAppConfiguration sharedConfiguration].appName = appName;
}

+ (NSString *)appVersion
{
    return [JUDAppConfiguration sharedConfiguration].appVersion ?: [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (void)setAppVersion:(NSString *)appVersion
{
    [JUDAppConfiguration sharedConfiguration].appVersion = appVersion;
}

+ (NSString *)externalUserAgent
{
    return [JUDAppConfiguration sharedConfiguration].externalUA;
}

+ (void)setExternalUserAgent:(NSString *)userAgent
{
    [JUDAppConfiguration sharedConfiguration].externalUA = userAgent;
}

+ (NSString *)JSFrameworkVersion
{
    return [JUDAppConfiguration sharedConfiguration].JSFrameworkVersion ?: @"";
}

+ (void)setJSFrameworkVersion:(NSString *)JSFrameworkVersion
{
    [JUDAppConfiguration sharedConfiguration].JSFrameworkVersion = JSFrameworkVersion;
}

+ (NSArray*)customizeProtocolClasses{
    return [JUDAppConfiguration sharedConfiguration].customizeProtocolClasses;
}

+ (void)setCustomizeProtocolClasses:(NSArray *)customizeProtocolClasses{
    [JUDAppConfiguration sharedConfiguration].customizeProtocolClasses = customizeProtocolClasses;
}


@end
