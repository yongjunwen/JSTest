/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JUDScrollDirection) {
    JUDScrollDirectionVertical,
    JUDScrollDirectionHorizontal,
    JUDScrollDirectionNone,
};

typedef NS_ENUM(NSUInteger, JUDTextStyle) {
    JUDTextStyleNormal = 0,
    JUDTextStyleItalic
};

typedef NS_ENUM(NSInteger, JUDTextDecoration) {
    JUDTextDecorationNone = 0,
    JUDTextDecorationUnderline,
    JUDTextDecorationLineThrough
};

typedef NS_ENUM(NSInteger, JUDImageQuality) {
    JUDImageQualityOriginal = -1,
    JUDImageQualityLow = 0,
    JUDImageQualityNormal,
    JUDImageQualityHigh,
    JUDImageQualityNone,
};

typedef NS_ENUM(NSInteger, JUDImageSharp) {
    JUDImageSharpeningNone = 0,
    JUDImageSharpening
};

typedef NS_ENUM(NSInteger, JUDVisibility) {
    JUDVisibilityShow = 0,
    JUDVisibilityHidden
};

typedef NS_ENUM(NSInteger, JUDBorderStyle) {
    JUDBorderStyleNone = 0,
    JUDBorderStyleDotted,
    JUDBorderStyleDashed,
    JUDBorderStyleSolid
};

typedef NS_ENUM(NSInteger, JUDPositionType) {
    JUDPositionTypeRelative = 0,
    JUDPositionTypeAbsolute,
    JUDPositionTypeSticky,
    JUDPositionTypeFixed
};

typedef NS_ENUM(NSInteger, JUDGradientType) {
    JUDGradientTypeToTop = 0,
    JUDGradientTypeToBottom,
    JUDGradientTypeToLeft,
    JUDGradientTypeToRight,
    JUDGradientTypeToTopleft,
    JUDGradientTypeToBottomright,
};
