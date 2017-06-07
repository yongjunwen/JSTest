/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

@interface JUDAnimationModule : NSObject <JUDModuleProtocol>

- (void)animation:(JUDComponent *)targetComponent args:(NSDictionary *)args callback:(JUDModuleCallback)callback;

@end
