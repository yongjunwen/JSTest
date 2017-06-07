/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDAnimationModule.h"
#import "JUDSDKInstance_private.h"
#import "JUDComponent_internal.h"
#import "JUDConvert.h"
#import "JUDTransform.h"
#import "JUDUtility.h"
#import "JUDLength.h"

@interface JUDAnimationInfo : NSObject<NSCopying>

@property (nonatomic, weak) JUDComponent *target;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
@property (nonatomic, assign) double duration;
@property (nonatomic, assign) double delay;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@end

@implementation JUDAnimationInfo

- (id)copyWithZone:(NSZone *)zone
{
    JUDAnimationInfo *info = [[JUDAnimationInfo allocWithZone:zone] init];
    
    info.target = self.target;
    info.propertyName = self.propertyName;
    info.fromValue = self.fromValue;
    info.toValue = self.toValue;
    info.duration = self.duration;
    info.delay = self.delay;
    info.timingFunction = self.timingFunction;
    
    return info;
}

@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
// CAAnimationDelegate is not available before iOS 10 SDK
@interface JUDAnimationDelegate : NSObject 
#else
@interface JUDAnimationDelegate : NSObject <CAAnimationDelegate>
#endif

@property (nonatomic, copy) void (^finishBlock)(BOOL);
@property (nonatomic, strong) JUDAnimationInfo *animationInfo;

- (instancetype)initWithAnimationInfo:(JUDAnimationInfo *)info finishBlock:(void(^)(BOOL))finishBlock;

@end

@implementation JUDAnimationDelegate

- (instancetype)initWithAnimationInfo:(JUDAnimationInfo *)info finishBlock:(void (^)(BOOL))finishBlock
{
    if (self = [super init]) {
        _animationInfo = info;
        _finishBlock = finishBlock;
    }
    
    return self;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if ([_animationInfo.propertyName hasPrefix:@"transform"]) {
        JUDTransform *transform = _animationInfo.target->_transform;
        [transform applyTransformForView:_animationInfo.target.view];
    } else if ([_animationInfo.propertyName isEqualToString:@"backgroundColor"]) {
        _animationInfo.target.view.layer.backgroundColor = (__bridge CGColorRef _Nullable)(_animationInfo.toValue);
    } else if ([_animationInfo.propertyName isEqualToString:@"opacity"]) {
        _animationInfo.target.view.layer.opacity = [_animationInfo.toValue floatValue];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_finishBlock) {
        _finishBlock(flag);
    }
}

@end

@interface JUDAnimationModule ()

@end

@implementation JUDAnimationModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(transition:args:callback:))

- (void)transition:(NSString *)nodeRef args:(NSDictionary *)args callback:(JUDModuleCallback)callback
{
    JUDPerformBlockOnComponentThread(^{
        JUDComponent *targetComponent = [self.judInstance componentForRef:nodeRef];
        if (!targetComponent) {
            if (callback) {
                callback([NSString stringWithFormat:@"No component find for ref:%@", nodeRef]);
            }
            return;
        }
        
        JUDPerformBlockOnMainThread(^{
            [self animation:targetComponent args:args callback:callback];
        });
    });
}

- (NSArray<JUDAnimationInfo *> *)animationInfoArrayFromArgs:(NSDictionary *)args target:(JUDComponent *)target
{
    UIView *view = target.view;
    CALayer *layer = target.layer;
    NSMutableArray<JUDAnimationInfo *> *infos = [NSMutableArray new];

    double duration = [args[@"duration"] doubleValue] / 1000;
    double delay = [args[@"delay"] doubleValue] / 1000;
    CAMediaTimingFunction *timingFunction = [JUDConvert CAMediaTimingFunction:args[@"timingFunction"]];
    NSDictionary *styles = args[@"styles"];
    for (NSString *property in styles) {
        JUDAnimationInfo *info = [JUDAnimationInfo new];
        info.duration = duration;
        info.delay = delay;
        info.timingFunction = timingFunction;
        info.target = target;
        
        id value = styles[property];
        if ([property isEqualToString:@"transform"]) {
            NSString *transformOrigin = styles[@"transformOrigin"];
            JUDTransform *judTransform = [[JUDTransform alloc] initWithCSSValue:value origin:transformOrigin instance:self.judInstance];
            JUDTransform *oldTransform = target->_transform;
            if (judTransform.rotateAngle != oldTransform.rotateAngle) {
                JUDAnimationInfo *newInfo = [info copy];
                newInfo.propertyName = @"transform.rotation";
                /**
                 Rotate >= 180 degree not working on UIView block animation, have not found any more elegant solution than using CAAnimation
                 See http://stackoverflow.com/questions/9844925/uiview-infinite-360-degree-rotation-animation
                 **/
                newInfo.fromValue = @(oldTransform.rotateAngle);
                newInfo.toValue = [NSNumber numberWithDouble:judTransform.rotateAngle];
                [infos addObject:newInfo];
            }
            
            if (judTransform.scaleX != oldTransform.scaleX) {
                JUDAnimationInfo *newInfo = [info copy];
                newInfo.propertyName = @"transform.scale.x";
                newInfo.fromValue = @(oldTransform.scaleX);
                newInfo.toValue = @(judTransform.scaleX);
                [infos addObject:newInfo];
            }
            
            if (judTransform.scaleY != oldTransform.scaleY) {
                JUDAnimationInfo *newInfo = [info copy];
                newInfo.propertyName = @"transform.scale.y";
                newInfo.fromValue = @(oldTransform.scaleY);
                newInfo.toValue = @(judTransform.scaleX);
                [infos addObject:newInfo];
            }
            
            if ((judTransform.translateX && ![judTransform.translateX isEqualToLength:oldTransform.translateX]) || (!judTransform.translateX && oldTransform.translateX)) {
                JUDAnimationInfo *newInfo = [info copy];
                newInfo.propertyName = @"transform.translation.x";
                newInfo.fromValue = @([oldTransform.translateX valueForMaximumValue:view.bounds.size.width]);
                newInfo.toValue = @([judTransform.translateX valueForMaximumValue:view.bounds.size.width]);
                [infos addObject:newInfo];
            }
            
            if ((judTransform.translateY && ![judTransform.translateY isEqualToLength:oldTransform.translateY]) || (!judTransform.translateY && oldTransform.translateY)) {
                JUDAnimationInfo *newInfo = [info copy];
                newInfo.propertyName = @"transform.translation.y";
                newInfo.fromValue = @([oldTransform.translateY valueForMaximumValue:view.bounds.size.height]);
                newInfo.toValue = @([judTransform.translateY valueForMaximumValue:view.bounds.size.height]);
                [infos addObject:newInfo];
            }
            
            target->_transform = judTransform;
        } else if ([property isEqualToString:@"backgroundColor"]) {
            info.propertyName = @"backgroundColor";
            info.fromValue = (__bridge id)(layer.backgroundColor);
            info.toValue = (__bridge id)[JUDConvert CGColor:value];
            [infos addObject:info];
        } else if ([property isEqualToString:@"opacity"]) {
            info.propertyName = @"opacity";
            info.fromValue = @(layer.opacity);
            info.toValue = @([value floatValue]);
            [infos addObject:info];
        } else if ([property isEqualToString:@"width"]) {
            info.propertyName = @"bounds";
            info.fromValue = [NSValue valueWithCGRect:layer.bounds];
            CGRect newBounds = layer.bounds;
            newBounds.size = CGSizeMake([JUDConvert JUDPixelType:value scaleFactor:self.judInstance.pixelScaleFactor], newBounds.size.height);
            info.toValue = [NSValue valueWithCGRect:newBounds];
            [infos addObject:info];
        } else if ([property isEqualToString:@"height"]) {
            info.propertyName = @"bounds";
            info.fromValue = [NSValue valueWithCGRect:layer.bounds];
            CGRect newBounds = layer.bounds;
            newBounds.size = CGSizeMake(newBounds.size.width, [JUDConvert JUDPixelType:value scaleFactor:self.judInstance.pixelScaleFactor]);
            info.toValue = [NSValue valueWithCGRect:newBounds];
            [infos addObject:info];
        }
    }

    return infos;
}


- (void)animation:(JUDComponent *)targetComponent args:(NSDictionary *)args callback:(JUDModuleCallback)callback
{
    /**
       UIView-style animation functions support the standard timing functions,
       but they don’t allow you to specify your own cubic Bézier curve. 
       CATransaction can be used instead to force these animations to use the supplied CAMediaTimingFunction to pace animations.
     **/
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[JUDConvert CAMediaTimingFunction:args[@"timingFunction"]]];
    [CATransaction setCompletionBlock:^{
        if (callback) {
            callback(@"SUCCESS");
        }
    }];
    NSArray<JUDAnimationInfo *> *infos = [self animationInfoArrayFromArgs:args target:targetComponent];
    for (JUDAnimationInfo *info in infos) {
        [self _createCAAnimation:info];
    }

    [CATransaction commit];
}

- (void)_createCAAnimation:(JUDAnimationInfo *)info
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:info.propertyName];
    animation.fromValue = info.fromValue;
    animation.toValue = info.toValue;
    animation.duration = info.duration;
    animation.beginTime = CACurrentMediaTime() + info.delay;
    animation.timingFunction = info.timingFunction;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    JUDAnimationDelegate *delegate = [[JUDAnimationDelegate alloc] initWithAnimationInfo:info finishBlock:^(BOOL isFinish) {
        
    }];
    animation.delegate = delegate;
    
    CALayer *layer = info.target.layer;
    [layer addAnimation:animation forKey:info.propertyName];
}

@end
