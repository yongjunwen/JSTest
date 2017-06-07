/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "JUDLog.h"
#import "JUDLayoutDefine.h"
#import "JUDType.h"

@interface JUDConvert : NSObject

+ (BOOL)BOOL:(id)value;
+ (CGFloat)CGFloat:(id)value;
+ (NSUInteger)NSUInteger:(id)value;
+ (NSInteger)NSInteger:(id)value;
+ (NSString *)NSString:(id)value;

/**
 *  750px Adaptive
 */
typedef CGFloat JUDPixelType;
// @parameter scaleFactor: please use judInstance's pixelScaleFactor property
+ (JUDPixelType)JUDPixelType:(id)value scaleFactor:(CGFloat)scaleFactor;

+ (css_flex_direction_t)css_flex_direction_t:(id)value;
+ (css_align_t)css_align_t:(id)value;
+ (css_wrap_type_t)css_wrap_type_t:(id)value;
+ (css_justify_t)css_justify_t:(id)value;
+ (css_position_type_t)css_position_type_t:(id)value;

+ (UIViewContentMode)UIViewContentMode:(id)value;
+ (JUDImageQuality)JUDImageQuality:(id)value;
+ (JUDImageSharp)JUDImageSharp:(id)value;

+ (UIColor *)UIColor:(id)value;
+ (CGColorRef)CGColor:(id)value;
+ (JUDBorderStyle)JUDBorderStyle:(id)value;
typedef BOOL JUDClipType;
+ (JUDClipType)JUDClipType:(id)value;
+ (JUDPositionType)JUDPositionType:(id)value;

+ (JUDTextStyle)JUDTextStyle:(id)value;
/**
 * @abstract UIFontWeightRegular ,UIFontWeightBold,etc are not support by the system which is less than 8.2. jud sdk set the float value.
 *
 * @param value support normal,blod,100,200,300,400,500,600,700,800,900
 *
 * @return A float value.
 *
 */
+ (CGFloat)JUDTextWeight:(id)value;
+ (JUDTextDecoration)JUDTextDecoration:(id)value;
+ (NSTextAlignment)NSTextAlignment:(id)value;
+ (UIReturnKeyType)UIReturnKeyType:(id)value;

+ (JUDScrollDirection)JUDScrollDirection:(id)value;
+ (UITableViewRowAnimation)UITableViewRowAnimation:(id)value;

+ (UIViewAnimationOptions)UIViewAnimationTimingFunction:(id)value;
+ (CAMediaTimingFunction *)CAMediaTimingFunction:(id)value;

+ (JUDVisibility)JUDVisibility:(id)value;

+ (JUDGradientType)gradientType:(id)value;

@end

@interface JUDConvert (Deprecated)

+ (JUDPixelType)JUDPixelType:(id)value DEPRECATED_MSG_ATTRIBUTE("Use [JUDConvert JUDPixelType:scaleFactor:] instead");

@end
