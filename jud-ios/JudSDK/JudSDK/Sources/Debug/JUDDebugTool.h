/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

@interface JUDDebugTool : NSObject<JUDModuleProtocol>

+ (instancetype)sharedInstance;

//+ (void)showFPS;

+ (void)setDebug:(BOOL)isDebug;

+ (BOOL)isDebug;

+ (void)setDevToolDebug:(BOOL)isDevToolDebug;

+ (BOOL)isDevToolDebug;

+ (void)setReplacedBundleJS:(NSURL*)url;

+ (NSString*)getReplacedBundleJS;

+ (void)setReplacedJSFramework:(NSURL*)url;

+ (NSString*)getReplacedJSFramework;

+ (BOOL) cacheJsService: (NSString *)name withScript: (NSString *)script withOptions: (NSDictionary *) options;

+ (BOOL) removeCacheJsService: (NSString *)name;

+ (NSDictionary *) jsServiceCache;

@end
