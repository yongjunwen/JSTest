/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */


#import <Foundation/Foundation.h>

@interface NSObject (JUDSwizzle)

+ (BOOL)jud_swizzle:(Class)originalClass Method:(SEL)originalSelector withMethod:(SEL)swizzledSelector;

@end
