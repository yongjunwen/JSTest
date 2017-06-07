/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
@class JUDSDKInstance;

@interface JUDBridgeMethod : NSObject

@property (nonatomic, strong, readonly) NSString *methodName;
@property (nonatomic, copy, readonly) NSArray *arguments;
@property (nonatomic, weak, readonly) JUDSDKInstance *instance;

- (instancetype)initWithMethodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(JUDSDKInstance *)instance;

- (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector;

@end

