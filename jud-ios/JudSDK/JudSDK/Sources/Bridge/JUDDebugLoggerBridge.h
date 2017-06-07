/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBridgeProtocol.h"

@interface JUDDebugLoggerBridge : NSObject <JUDBridgeProtocol>

- (instancetype)initWithURL:(NSURL *) URL;

@end
