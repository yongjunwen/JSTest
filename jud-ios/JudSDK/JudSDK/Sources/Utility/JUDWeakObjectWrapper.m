/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDWeakObjectWrapper.h"

@implementation JUDWeakObjectWrapper

- (id)initWithWeakObject:(id)weakObject
{
    if (self = [super init]) {
        _weakObject = weakObject;
    }
    
    return self;
}

@end
