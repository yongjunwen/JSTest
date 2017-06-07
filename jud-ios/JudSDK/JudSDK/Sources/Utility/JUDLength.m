/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDLength.h"
#import "JUDAssert.h"

@implementation JUDLength
{
    float _value;
    JUDLengthType _type;
}

+ (instancetype)lengthWithValue:(float)value type:(JUDLengthType)type
{
    JUDLength *length = [JUDLength new];
    length->_value = value;
    length->_type = type;
    return length;
}

- (float)valueForMaximumValue:(float)maximumValue
{
    switch (_type) {
        case JUDLengthTypeFixed:
            return _value;
        case JUDLengthTypePercent:
            return maximumValue * _value / 100.0;
        case JUDLengthTypeAuto:
            return maximumValue;
        default:
            JUDAssertNotReached();
            return 0;
    }
}

- (BOOL)isEqualToLength:(JUDLength *)length
{
    return length && _type == length->_type && _value == length->_value;
}

- (BOOL)isFixed
{
    return _type == JUDLengthTypeFixed;
}

- (BOOL)isPercent
{
    return _type == JUDLengthTypePercent;
}

- (BOOL)isAuto
{
    return _type == JUDLengthTypeAuto;
}

@end
