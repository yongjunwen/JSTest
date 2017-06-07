/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDRoundedRect.h"
#import "JUDAssert.h"

@implementation JUDRadii

- (instancetype)initWithTopLeft:(CGFloat)topLeft
                       topRight:(CGFloat)topRight
                     bottomLeft:(CGFloat)bottomLeft
                    bottomRight:(CGFloat)bottomRight
{
    if (self = [super init]) {
        _topLeft = topLeft;
        _topRight = topRight;
        _bottomLeft = bottomLeft;
        _bottomRight = bottomRight;
    }
    
    return self;
}

- (void)scale:(float)factor
{
    if (factor == 1) {
        return;
    }
    
    _topLeft *= factor;
    _topRight *= factor;
    _bottomLeft *= factor;
    _bottomRight *= factor;
}

@end

@interface JUDRoundedRect ()

@end

@implementation JUDRoundedRect

- (instancetype)initWithRect:(CGRect)rect
                     topLeft:(CGFloat)topLeft
                    topRight:(CGFloat)topRight
                  bottomLeft:(CGFloat)bottomLeft
                 bottomRight:(CGFloat)bottomRight
{
    if (self = [super init]) {
        _rect = rect;
        _radii = [[JUDRadii alloc] initWithTopLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight];
        [_radii scale:[self radiiConstraintScaleFactor]];
    }
    
    return self;
}

- (float)radiiConstraintScaleFactor
{
    // Constrain corner radii using CSS3 rules:
    // http://www.w3.org/TR/css3-background/#the-border-radius
    float factor = 1;
    CGFloat radiiSum;
    
    // top
    radiiSum = _radii.topLeft + _radii.topRight;
    if (radiiSum > _rect.size.width) {
        factor = MIN(_rect.size.width / radiiSum, factor);
    }
    
    // bottom
    radiiSum = _radii.bottomLeft + _radii.bottomRight;
    if (radiiSum > _rect.size.width) {
        factor = MIN(_rect.size.width / radiiSum, factor);
    }
    
    // left
    radiiSum = _radii.topLeft + _radii.bottomLeft;
    if (radiiSum > _rect.size.height) {
        factor = MIN(_rect.size.height / radiiSum, factor);
    }
    
    // right
    radiiSum = _radii.topRight + _radii.bottomRight;
    if (radiiSum > _rect.size.height) {
        factor = MIN(_rect.size.height / radiiSum, factor);
    }
    
    JUDAssert(factor <= 1, @"Wrong factor for radii constraint scale:%f", factor);
    return factor;
}

@end
