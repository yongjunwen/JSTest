/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

@interface JUDCanvasModule : NSObject <JUDModuleProtocol>

- (UIImage *) getImage:(NSString *)imageURL;

@end
