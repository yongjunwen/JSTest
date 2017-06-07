/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBridgeMethod.h"
@class JUDComponent;

@interface JUDComponentMethod : JUDBridgeMethod

- (instancetype)initWithComponentRef:(NSString *)ref
                          methodName:(NSString *)methodName
                           arguments:(NSArray *)arguments
                            instance:(JUDSDKInstance *)instance;

- (void)invoke;

@end
