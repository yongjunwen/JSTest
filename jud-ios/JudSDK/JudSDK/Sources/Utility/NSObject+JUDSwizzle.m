/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "NSObject+JUDSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (JUDSwizzle)

+ (BOOL)jud_swizzle:(Class)originalClass Method:(SEL)originalSelector withMethod:(SEL)swizzledSelector
{
    if (!(originalClass && originalSelector && swizzledSelector)) {
        return NO;
    }
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    return YES;
}

@end
