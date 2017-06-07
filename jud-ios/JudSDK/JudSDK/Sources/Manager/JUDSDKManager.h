/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDSDKInstance.h"
#import "JUDBridgeManager.h"

@class JUDModuleManager;

@interface JUDSDKManager : NSObject

/**
 * @abstract Returns bridge manager
 **/
+ (JUDBridgeManager *)bridgeMgr;

/**
 * @abstract Returns jud instance for specific identifier
 **/
+ (JUDSDKInstance *)instanceForID:(NSString *)identifier;

/**
 * @abstract Returns jud instance for specific identifier
 **/
+ (void)storeInstance:(JUDSDKInstance *)instance forID:(NSString *)identifier;

/**
 * @abstract Returns jud instance for specific identifier
 **/
+ (void)removeInstanceforID:(NSString *)identifier;

/**
 * @abstract unload
 **/
+ (void)unload;

/**
 * @abstract Returns module manager
 **/
+ (JUDModuleManager *)moduleMgr DEPRECATED_MSG_ATTRIBUTE();

@end
