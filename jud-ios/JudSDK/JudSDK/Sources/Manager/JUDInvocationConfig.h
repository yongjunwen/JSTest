/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

#import "JUDBridgeMethod.h"

@interface JUDInvocationConfig : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *clazz;
/**
 *  The methods map
 **/
@property (nonatomic, strong) NSMutableDictionary *asyncMethods;
@property (nonatomic, strong) NSMutableDictionary *syncMethods;

+ (instancetype)sharedInstance;
- (instancetype)initWithName:(NSString *)name class:(NSString *)clazz;
- (void)registerMethods;

@end
