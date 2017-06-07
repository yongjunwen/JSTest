/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface NSArray (Jud)

- (id)jud_safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (Jud)

+ (id)jud_mutableArrayUsingWeakReferences;

+ (id)jud_mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;
+ (void)jud_releaseArray:(id)array;

@end
