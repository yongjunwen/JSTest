/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern bool JUDTransform3DApproximateToTransform(CATransform3D a,CATransform3D b);

extern bool JUDRectApproximateToRect(CGRect a,CGRect b);

@interface TestSupportUtils : NSObject
/**
 *设置等待时间
 */
+(void)waitSecs:(NSTimeInterval)secs;

@end
