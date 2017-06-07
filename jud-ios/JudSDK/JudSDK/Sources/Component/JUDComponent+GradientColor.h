//
//  JUDComponent+GradientColor.h
//  Pods
//
//  Created by bobning on 16/12/23.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JUDComponent.h"
#import "JUDType.h"

@interface JUDComponent (GradientColor)

- (void)setGradientLayer;

- (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(JUDGradientType)gradientType imgSize:(CGSize)imgSize;

@end
