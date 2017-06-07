/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "TestSupportUtils.h"


bool JUDIsDoubleApproximate(double x, double y) {
    return fabs(x - y) < 0.001;
}

bool JUDTransform3DApproximateToTransform(CATransform3D a,CATransform3D b)
{
    return
    JUDIsDoubleApproximate(a.m11, b.m11) &&
    JUDIsDoubleApproximate(a.m12, b.m12) &&
    JUDIsDoubleApproximate(a.m13, b.m13) &&
    JUDIsDoubleApproximate(a.m14, b.m14) &&
    JUDIsDoubleApproximate(a.m21, b.m21) &&
    JUDIsDoubleApproximate(a.m22, b.m22) &&
    JUDIsDoubleApproximate(a.m23, b.m23) &&
    JUDIsDoubleApproximate(a.m24, b.m24) &&
    JUDIsDoubleApproximate(a.m31, b.m31) &&
    JUDIsDoubleApproximate(a.m32, b.m32) &&
    JUDIsDoubleApproximate(a.m33, b.m33) &&
    JUDIsDoubleApproximate(a.m34, b.m34) &&
    JUDIsDoubleApproximate(a.m41, b.m41) &&
    JUDIsDoubleApproximate(a.m42, b.m42) &&
    JUDIsDoubleApproximate(a.m43, b.m43) &&
    JUDIsDoubleApproximate(a.m44, b.m44);
}

bool JUDRectApproximateToRect(CGRect a,CGRect b)
{
    return
    JUDIsDoubleApproximate(a.origin.x, b.origin.x) &&
    JUDIsDoubleApproximate(a.origin.y, b.origin.y) &&
    JUDIsDoubleApproximate(a.size.width, b.size.width) &&
    JUDIsDoubleApproximate(a.size.height, b.size.height);
}


@implementation TestSupportUtils

+(void)waitSecs:(NSTimeInterval)secs{
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:secs];
    while ( [timeoutDate timeIntervalSinceNow] > 0) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
    }
}

@end
