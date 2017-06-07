/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDPolyfillSet.h"

@implementation JUDPolyfillSet
{
    NSMutableSet *_set;
}

+ (instancetype)create
{
    JUDPolyfillSet *jsSet = [JUDPolyfillSet new];
    jsSet->_set = [NSMutableSet set];
    return jsSet;
}

- (BOOL)has:(id)value
{
    return [_set containsObject:value];
}

- (NSUInteger)size
{
    return _set.count;
}

- (void)add:(id)value
{
    [_set addObject:value];
}

- (BOOL)delete:(id)value
{
    if ([_set containsObject:value]) {
        [_set removeObject:value];
        return YES;
    }
    
    return NO;
}

- (void)clear
{
    [_set removeAllObjects];
}

@end

