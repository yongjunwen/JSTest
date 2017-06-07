/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

// Global queue for displaying content
@interface JUDDisplayQueue : NSObject

+ (void)addBlock:(void(^)())block;

@end
