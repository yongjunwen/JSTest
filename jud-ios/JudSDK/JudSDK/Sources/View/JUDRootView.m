/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDRootView.h"
#import "JUDSDKInstance.h"

@implementation JUDRootView

- (void)setFrame:(CGRect)frame
{
    BOOL shouldNotifyLayout = NO;
    if (_instance.onLayoutChange && !CGRectEqualToRect(self.frame, frame)) {
        shouldNotifyLayout = YES;
    }
    
    [super setFrame:frame];
    
    if (shouldNotifyLayout && _instance.onLayoutChange) {
        _instance.onLayoutChange(self);
    }
}

@end
