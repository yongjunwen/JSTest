/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "JUDThreadSafeMutableDictionary.h"
#import "JUDSDKInstance.h"

@interface JUDRuleManager : NSObject

@property(nonatomic, weak)JUDSDKInstance *instance;

+ (JUDRuleManager *)sharedInstance;

- (void)addRule:(NSString *)type rule:(NSDictionary *)rule;

- (JUDThreadSafeMutableDictionary *)getRule:(NSString *)type;

- (void)removeRule:(NSString *)type rule:(NSDictionary *)rule;

@end
