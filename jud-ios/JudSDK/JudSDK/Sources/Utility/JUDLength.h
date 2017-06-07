/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JUDLengthTypeFixed,
    JUDLengthTypePercent,
    JUDLengthTypeAuto,
} JUDLengthType;

@interface JUDLength : NSObject

+ (instancetype)lengthWithValue:(float)value type:(JUDLengthType)type;

- (float)valueForMaximumValue:(float)maximumValue;

- (BOOL)isEqualToLength:(JUDLength *)length;

- (BOOL)isFixed;

- (BOOL)isPercent;

- (BOOL)isAuto;

@end
