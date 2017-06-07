/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */


#import <Foundation/Foundation.h>


@interface JUDRadii : NSObject

@property (nonatomic, assign) CGFloat topLeft;
@property (nonatomic, assign) CGFloat topRight;
@property (nonatomic, assign) CGFloat bottomLeft;
@property (nonatomic, assign) CGFloat bottomRight;

@end

@interface JUDRoundedRect : NSObject

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, strong) JUDRadii *radii;

- (instancetype)initWithRect:(CGRect)rect
                     topLeft:(CGFloat)topLeft
                    topRight:(CGFloat)topRight
                  bottomLeft:(CGFloat)bottomLeft
                 bottomRight:(CGFloat)bottomRight;

@end
