/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDJSExceptionInfo.h"

@protocol JUDJSExceptionProtocol<NSObject>

/**
 * report js exception
 *
 * @param exception {@link JUDJSException}
 */

- (void)onJSException:(JUDJSExceptionInfo *)exception;

@end
