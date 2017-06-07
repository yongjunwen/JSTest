/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDView.h"
#import "JUDComponent.h"
#import "JUDLayer.h"

@implementation JUDView

+ (Class)layerClass
{
    return [JUDLayer class];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    /**
     *  Capturing touches on a subview outside the frame of its superview if it does not clips to bounds.
     */
    if (self.hidden || !self.userInteractionEnabled) {
        return nil;
    }
    
    UIView* result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    
    // if clips to bounds, no need to detect outside views.
    if (self.clipsToBounds) {
        return nil;
    }
    
    for (UIView* subView in [self.subviews reverseObjectEnumerator]) {
        if (subView.hidden) {
            continue;
        }
        CGPoint subPoint = [self convertPoint:point toView:subView];
        result = [subView hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    
    return nil;
}
@end
