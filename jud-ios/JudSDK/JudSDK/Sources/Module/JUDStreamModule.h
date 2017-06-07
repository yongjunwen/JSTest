/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

@interface JUDStreamModule : NSObject <JUDModuleProtocol>

- (void)fetch:(NSDictionary *)options callback:(JUDModuleCallback)callback progressCallback:(JUDModuleKeepAliveCallback)progressCallback;
- (void)sendHttp:(NSDictionary*)param callback:(JUDModuleCallback)callback DEPRECATED_MSG_ATTRIBUTE("Use fetch method instead.");

@end
