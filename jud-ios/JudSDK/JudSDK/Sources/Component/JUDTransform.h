/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JUDSDKInstance;
@class JUDLength;

@interface JUDTransform : NSObject

@property (nonatomic, assign, readonly) float rotateAngle;
@property (nonatomic, strong, readonly) JUDLength *translateX;
@property (nonatomic, strong, readonly) JUDLength *translateY;
@property (nonatomic, assign, readonly) float scaleX;
@property (nonatomic, assign, readonly) float scaleY;

- (instancetype)initWithCSSValue:(NSString *)cssValue origin:(NSString *)origin instance:(JUDSDKInstance *)instance;

- (void)applyTransformForView:(UIView *)view;

@end
