/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

/**
 *  @abstract a thread-safe counter
 */
@interface JUDThreadSafeCounter : NSObject

@property (atomic, readonly) int32_t value;

- (int32_t)increase;

@end
