/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface JUDWeakObjectWrapper : NSObject

@property (nonatomic, weak, readonly) id weakObject;

- (id)initWithWeakObject:(id)weakObject;

@end
