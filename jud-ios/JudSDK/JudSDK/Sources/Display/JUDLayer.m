/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDLayer.h"
#import "JUDDefine.h"
#import "JUDComponent.h"
#import "JUDComponent_internal.h"

@implementation JUDLayer

- (void)display
{
    [self.jud_component _willDisplayLayer:self];
}

@end
