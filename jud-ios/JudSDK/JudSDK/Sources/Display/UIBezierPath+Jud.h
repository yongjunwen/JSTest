/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface UIBezierPath (Jud)

+ (instancetype)jud_bezierPathWithRoundedRect:(CGRect)rect
                                     topLeft:(CGFloat)topLeftRadius
                                    topRight:(CGFloat)topRightRadius
                                  bottomLeft:(CGFloat)bottomLeftRadius
                                 bottomRight:(CGFloat)bottomRightRadius;

@end
