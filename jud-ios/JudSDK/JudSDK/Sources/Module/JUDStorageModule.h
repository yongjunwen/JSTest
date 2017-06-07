/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDModuleProtocol.h"

@interface JUDStorageModule : NSObject <JUDModuleProtocol>

- (void)length:(JUDModuleCallback)callback;

- (void)getAllKeys:(JUDModuleCallback)callback;

- (void)setItem:(NSString *)key value:(NSString *)value callback:(JUDModuleCallback)callback;

- (void)setItemPersistent:(NSString *)key value:(NSString *)value callback:(JUDModuleCallback)callback;

- (void)getItem:(NSString *)key callback:(JUDModuleCallback)callback;

- (void)removeItem:(NSString *)key callback:(JUDModuleCallback)callback;

@end
