/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "NSArray+Jud.h"

@implementation NSArray (Jud)

- (id)jud_safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

@end

@implementation NSMutableArray (Jud)

// It's quite ingenius, using a Category to allow the creation of a mutable array that does no retain/release by backing it with a CFArray with proper callbacks.http://stackoverflow.com/questions/4692161/non-retaining-array-for-delegates
+ (id)jud_mutableArrayUsingWeakReferences {
    return [self jud_mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)jud_mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // We create a weak reference array
    return (__bridge id)(CFArrayCreateMutable(0, capacity, &callbacks));
}

+ (void)jud_releaseArray:(id)array {
    
    CFBridgingRelease((__bridge CFArrayRef _Nullable)(array));
}

@end
