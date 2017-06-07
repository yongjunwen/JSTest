//
//  JUDComponent+GradientColor.m
//  Pods
//
//  Created by bobning on 16/12/23.
//
//

#import "JUDComponent+GradientColor.h"
#import "JUDComponent_internal.h"
#import "JUDConvert.h"

@implementation  JUDComponent (GradientColor)

- (void)setGradientLayer {
    //parse gradient-color, linear-gradient(to right, #a80077,rgba(200, 54, 54, 0.5))
    if ([_backgroundImage hasPrefix:@"linear-gradient"] && [_backgroundImage hasSuffix:@")"] ) {
        NSRange range = NSMakeRange(16, _backgroundImage.length - 17);
        NSString *str = [_backgroundImage substringWithRange:range];
        NSArray *array = [str componentsSeparatedByString:@","];
        JUDGradientType gradientType;
        UIColor *startColor, *endColor;
        
        if ([array count] == 3) {
            gradientType = [JUDConvert gradientType:array[0]];
            startColor = [JUDConvert UIColor:array[1]];
            endColor = [JUDConvert UIColor:array[2]];
        }
        else if ([array count] > 3){
            NSString *gradientTypeStr = array[0];
            NSString *subStr = [str substringFromIndex:gradientTypeStr.length + 1];
            
            if ([subStr hasPrefix:@"rgb"]) {
                gradientType = [JUDConvert gradientType:gradientTypeStr];
                
                range = [subStr rangeOfString:@")"];
                NSString *startColorStr = [subStr substringToIndex:range.location + 1];
                NSString *endColorStr = [subStr substringFromIndex:range.location + 2];
                startColor = [JUDConvert UIColor:startColorStr];
                endColor = [JUDConvert UIColor:endColorStr];
            }
            else {
                gradientType = [JUDConvert gradientType:gradientTypeStr];
                
                startColor = [JUDConvert UIColor:array[1]];
                
                NSString *startColorStr = array[1];
                NSString *endColorStr = [subStr substringFromIndex:startColorStr.length + 1];
                endColor = [JUDConvert UIColor:endColorStr];
            }
        }
        else {
            return;
        }
    
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *bgImg = [weakSelf gradientColorImageFromColors:@[startColor, endColor] gradientType:gradientType imgSize:weakSelf.view.frame.size];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.view.backgroundColor = [UIColor colorWithPatternImage:bgImg];
            });
        });
    }
}

- (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(JUDGradientType)gradientType imgSize:(CGSize)imgSize;{
    NSMutableArray *array = [NSMutableArray array];
    for(UIColor *color in colors) {
        [array addObject:(id)color.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case JUDGradientTypeToTop:
            start = CGPointMake(0.0, imgSize.height);
            end = CGPointMake(0.0, 0.0);
            break;
        case JUDGradientTypeToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case JUDGradientTypeToLeft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, 0.0);
            break;
        case JUDGradientTypeToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case JUDGradientTypeToTopleft:
            start = CGPointMake(imgSize.width, imgSize.height);
            end = CGPointMake(0.0, 0.0f);
            break;
        case JUDGradientTypeToBottomright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
