/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent+Display.h"
#import "JUDComponent.h"
#import "JUDComponent_internal.h"
#import "JUDLayer.h"
#import "JUDAssert.h"
#import "JUDUtility.h"
#import "JUDDisplayQueue.h"
#import "JUDThreadSafeCounter.h"
#import "UIBezierPath+Jud.h"
#import "JUDRoundedRect.h"
#import "JUDSDKInstance.h"

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation JUDComponent (Display)

#pragma mark Public

- (void)setNeedsDisplay
{
    JUDAssertMainThread();
    
    if (_compositingChild) {
        JUDComponent *supercomponent = self.supercomponent;
        while (supercomponent) {
            if (supercomponent->_composite) {
                break;
            }
            supercomponent = supercomponent.supercomponent;
        }
        [supercomponent setNeedsDisplay];
    } else if (!_layer || _layer.frame.size.width ==0 || _layer.frame.size.height == 0) {
        return;
    } else {
        [_layer setNeedsDisplay];
    }
}

- (JUDDisplayBlock)displayBlock
{
    JUDDisplayBlock displayBlock = ^UIImage *(CGRect bounds, BOOL(^isCancelled)(void)) {
        if (isCancelled()) {
            return nil;
        }
        
        if (![self _needsDrawBorder]) {
            JUDLogDebug(@"No need to draw border for %@", self.ref);
            JUDPerformBlockOnMainThread(^{
                [self _resetNativeBorderRadius];
            });
            return nil;
        }
        
        return [self _borderImage];
    };
    
    return displayBlock;
}

- (JUDDisplayCompletionBlock)displayCompletionBlock
{
    return nil;
}

#pragma mark Private

- (void)_willDisplayLayer:(CALayer *)layer
{
    JUDAssertMainThread();
    
    if (_compositingChild) {
        // compsiting children need not draw layer
        return;
    }
    
    CGRect displayBounds = CGRectMake(0, 0, self.calculatedFrame.size.width, self.calculatedFrame.size.height);
    
    JUDDisplayBlock displayBlock;
    if (_composite) {
        displayBlock = [self _compositeDisplayBlock];
    } else {
        displayBlock = [self displayBlock];
    }
    JUDDisplayCompletionBlock completionBlock = [self displayCompletionBlock];
    
    if (!displayBlock) {
        if (completionBlock) {
            completionBlock(layer, NO);
        }
        return;
    }
    
    if (_async) {
        JUDThreadSafeCounter *displayCounter = _displayCounter;
        int32_t displayValue = [displayCounter increase];
        BOOL (^isCancelled)() = ^BOOL(){
            return displayValue != displayCounter.value;
        };
        
        [JUDDisplayQueue addBlock:^{
            if (isCancelled()) {
                if (completionBlock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionBlock(layer, NO);
                    });
                }
                return;
            }
            
            UIImage *image = displayBlock(displayBounds, isCancelled);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isCancelled()) {
                    if (completionBlock) {
                        completionBlock(layer, NO);
                    }
                    return;
                }
                
                layer.contents = (id)(image.CGImage);
                
                if (completionBlock) {
                    completionBlock(layer, YES);
                }
            });
            
        }];
    } else {
        UIImage *image = displayBlock(displayBounds, ^BOOL(){
            return NO;
        });
        
        _layer.contents = (id)image.CGImage;
        
        if (completionBlock) {
            completionBlock(layer, YES);
        }
    }
}

- (JUDDisplayBlock)_compositeDisplayBlock
{
    return ^UIImage* (CGRect bounds, BOOL(^isCancelled)(void)) {
        if (isCancelled()) {
            return nil;
        }
        NSMutableArray *displayBlocks = [NSMutableArray array];
        [self _collectDisplayBlocks:displayBlocks isCancelled:isCancelled];
        
        BOOL opaque = _layer.opaque && CGColorGetAlpha(_backgroundColor.CGColor) == 1.0f;
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0.0);
        
        for (dispatch_block_t block in displayBlocks) {
            if (isCancelled()) {
                UIGraphicsEndImageContext();
                return nil;
            }
            block();
        }
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    };
}

- (void)_collectDisplayBlocks:(NSMutableArray *)displayBlocks isCancelled:(BOOL(^)(void))isCancelled
{
    // compositingChild has no chance to applyPropertiesToView, so force updateNode
    //    if (_compositingChild) {
    //        if (_data) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [self updateNode:_data];
    //            });
    //        }
    //    }
    
    UIColor *backgroundColor = _backgroundColor;
    BOOL clipsToBounds = _clipToBounds;
    CGRect frame = self.calculatedFrame;
    CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    if (_composite) {
        frame.origin = CGPointMake(0, 0);
    }
    
    JUDDisplayBlock displayBlock = [self displayBlock];
    
    BOOL shouldDisplay = displayBlock || backgroundColor || CGPointEqualToPoint(CGPointZero, frame.origin) == NO || clipsToBounds;
    
    if (shouldDisplay) {
        dispatch_block_t displayBlockToPush = ^{
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, frame.origin.x, frame.origin.y);
            
            if (_compositingChild && clipsToBounds) {
                [[UIBezierPath bezierPathWithRect:bounds] addClip];
            }
            
            CGColorRef backgroundCGColor = backgroundColor.CGColor;
            if (backgroundColor && CGColorGetAlpha(backgroundCGColor) > 0.0) {
                CGContextSetFillColorWithColor(context, backgroundCGColor);
                CGContextFillRect(context, bounds);
            }
            
            if (displayBlock) {
                UIImage *image = displayBlock(bounds, isCancelled);
                if (image) {
                    [image drawInRect:bounds];
                }
            }
        };
        [displayBlocks addObject:[displayBlockToPush copy]];
    }
    
    for (JUDComponent *component in self.subcomponents) {
        if (!isCancelled()) {
            [component _collectDisplayBlocks:displayBlocks isCancelled:isCancelled];
        }
    }
    
    if (shouldDisplay) {
        dispatch_block_t blockToPop = ^{
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextRestoreGState(context);
        };
        [displayBlocks addObject:[blockToPop copy]];
    }
}

#pragma mark Border Drawing

- (UIImage *)_borderImage
{
    CGSize size = self.calculatedFrame.size;
    if (size.width <= 0 || size.height <= 0) {
        JUDLogDebug(@"No need to draw border for %@, because width or height is zero", self.ref);
        return nil;
    }
    
    JUDLogDebug(@"Begin to draw border for %@", self.ref);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self _drawBorderWithContext:context size:size];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)_drawBorderWithContext:(CGContextRef)context size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    JUDRoundedRect *borderRect = [[JUDRoundedRect alloc] initWithRect:rect topLeft:_borderTopLeftRadius topRight:_borderTopRightRadius bottomLeft:_borderBottomLeftRadius bottomRight:_borderBottomRightRadius];
    // here is computed radii, do not use original style
    JUDRadii *radii = borderRect.radii;
    CGFloat topLeft = radii.topLeft, topRight = radii.topRight, bottomLeft = radii.bottomLeft, bottomRight = radii.bottomRight;
    
    // fill background color
    if (_backgroundColor && CGColorGetAlpha(_backgroundColor.CGColor) > 0) {
        CGContextSetFillColorWithColor(context, _backgroundColor.CGColor);
        UIBezierPath *bezierPath = [UIBezierPath jud_bezierPathWithRoundedRect:rect topLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight];
        [bezierPath fill];
    }
    
    // Top
    if (_borderTopWidth > 0) {
        if(_borderTopStyle == JUDBorderStyleDashed || _borderTopStyle == JUDBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (_borderTopStyle == JUDBorderStyleDashed ? 3 : 1) * _borderTopWidth;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, _borderTopWidth);
        CGContextSetStrokeColorWithColor(context, _borderTopColor.CGColor);
        CGContextAddArc(context, size.width-topRight, topRight, topRight-_borderTopWidth/2, -M_PI_4+(_borderRightWidth>0?0:M_PI_4), -M_PI_2, 1);
        CGContextMoveToPoint(context, size.width-topRight, _borderTopWidth/2);
        CGContextAddLineToPoint(context, topLeft, _borderTopWidth/2);
        CGContextAddArc(context, topLeft, topLeft, topLeft-_borderTopWidth/2, -M_PI_2, -M_PI_2-M_PI_4-(_borderLeftWidth>0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    // Left
    if (_borderLeftWidth > 0) {
        if(_borderLeftStyle == JUDBorderStyleDashed || _borderLeftStyle == JUDBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (_borderLeftStyle == JUDBorderStyleDashed ? 3 : 1) * _borderLeftWidth;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, _borderLeftWidth);
        CGContextSetStrokeColorWithColor(context, _borderLeftColor.CGColor);
        CGContextAddArc(context, topLeft, topLeft, topLeft-_borderLeftWidth/2, -M_PI, -M_PI_2-M_PI_4+(_borderTopWidth > 0?0:M_PI_4), 0);
        CGContextMoveToPoint(context, _borderLeftWidth/2, topLeft);
        CGContextAddLineToPoint(context, _borderLeftWidth/2, size.height-bottomLeft);
        CGContextAddArc(context, bottomLeft, size.height-bottomLeft, bottomLeft-_borderLeftWidth/2, M_PI, M_PI-M_PI_4-(_borderBottomWidth>0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    // Bottom
    if (_borderBottomWidth > 0) {
        if(_borderBottomStyle == JUDBorderStyleDashed || _borderBottomStyle == JUDBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (_borderBottomStyle == JUDBorderStyleDashed ? 3 : 1) * _borderBottomWidth;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, _borderBottomWidth);
        CGContextSetStrokeColorWithColor(context, _borderBottomColor.CGColor);
        CGContextAddArc(context, bottomLeft, size.height-bottomLeft, bottomLeft-_borderBottomWidth/2, M_PI-M_PI_4+(_borderLeftWidth>0?0:M_PI_4), M_PI_2, 1);
        CGContextMoveToPoint(context, bottomLeft, size.height-_borderBottomWidth/2);
        CGContextAddLineToPoint(context, size.width-bottomRight, size.height-_borderBottomWidth/2);
        CGContextAddArc(context, size.width-bottomRight, size.height-bottomRight, bottomRight-_borderBottomWidth/2, M_PI_2, M_PI_4-(_borderRightWidth > 0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    // Right
    if (_borderRightWidth > 0) {
        if(_borderRightStyle == JUDBorderStyleDashed || _borderRightStyle == JUDBorderStyleDotted){
            CGFloat lengths[2];
            lengths[0] = lengths[1] = (_borderRightStyle == JUDBorderStyleDashed ? 3 : 1) * _borderRightWidth;
            CGContextSetLineDash(context, 0, lengths, sizeof(lengths) / sizeof(*lengths));
        } else{
            CGContextSetLineDash(context, 0, 0, 0);
        }
        CGContextSetLineWidth(context, _borderRightWidth);
        CGContextSetStrokeColorWithColor(context, _borderRightColor.CGColor);
        CGContextAddArc(context, size.width-bottomRight, size.height-bottomRight, bottomRight-_borderRightWidth/2, M_PI_4+(_borderBottomWidth>0?0:M_PI_4), 0, 1);
        CGContextMoveToPoint(context, size.width-_borderRightWidth/2, size.height-bottomRight);
        CGContextAddLineToPoint(context, size.width-_borderRightWidth/2, topRight);
        CGContextAddArc(context, size.width-topRight, topRight, topRight-_borderRightWidth/2, 0, -M_PI_4-(_borderTopWidth > 0?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    
    CGContextStrokePath(context);
}

- (BOOL)_needsDrawBorder
{
    if (![_layer isKindOfClass:[JUDLayer class]]) {
        // Only support JUDLayer
        return NO;
    }
    // Set border property for most of components because border drawing consumes a lot of memory (v0.6.0)
//    if (_async) {
//        // Async layer always draw border
//        return YES;
//    }
    if (!(_borderLeftStyle == _borderTopStyle &&
          _borderTopStyle == _borderRightStyle &&
          _borderRightStyle == _borderBottomStyle &&
          _borderBottomStyle == JUDBorderStyleSolid)
        ) {
        // Native border property doesn't support dashed or dotted border
        return YES;
    }
    
    // user native border property only when border width & color & radius are equal;
    BOOL widthEqual = _borderTopWidth == _borderRightWidth && _borderRightWidth == _borderBottomWidth && _borderBottomWidth == _borderLeftWidth;
    if (!widthEqual) {
        return YES;
    }
    BOOL radiusEqual = _borderTopLeftRadius == _borderTopRightRadius && _borderTopRightRadius == _borderBottomRightRadius && _borderBottomRightRadius == _borderBottomLeftRadius;
    if (!radiusEqual) {
        return YES;
    }
    BOOL colorEqual = [_borderTopColor isEqual:_borderRightColor] && [_borderRightColor isEqual:_borderBottomColor] && [_borderBottomColor isEqual:_borderLeftColor];
    if (!colorEqual) {
        return YES;
    }
    
    return NO;
}

- (void)_handleBorders:(NSDictionary *)styles isUpdating:(BOOL)updating
{
    if (!updating) {
        // init with default value
        _borderTopStyle = _borderRightStyle = _borderBottomStyle = _borderLeftStyle = JUDBorderStyleSolid;
        _borderTopColor = _borderLeftColor = _borderRightColor = _borderBottomColor = [UIColor blackColor];
        _borderTopWidth = _borderLeftWidth = _borderRightWidth = _borderBottomWidth = 0;
        _borderTopLeftRadius = _borderTopRightRadius = _borderBottomLeftRadius = _borderBottomRightRadius = 0;
    }
    
    BOOL previousNeedsDrawBorder = YES;
    if (updating) {
        previousNeedsDrawBorder = [self _needsDrawBorder];
    }
    
#define JUD_CHECK_BORDER_PROP(prop, direction1, direction2, direction3, direction4, type)\
do {\
    BOOL needsDisplay = NO; \
    NSString *styleProp= JUD_NSSTRING(JUD_CONCAT(border, prop));\
    if (styles[styleProp]) {\
        _border##direction1##prop = _border##direction2##prop = _border##direction3##prop = _border##direction4##prop = [JUDConvert type:styles[styleProp]];\
        needsDisplay = YES;\
    }\
    NSString *styleDirection1Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction1, prop));\
    if (styles[styleDirection1Prop]) {\
        _border##direction1##prop = [JUDConvert type:styles[styleDirection1Prop]];\
        needsDisplay = YES;\
    }\
    NSString *styleDirection2Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction2, prop));\
    if (styles[styleDirection2Prop]) {\
        _border##direction2##prop = [JUDConvert type:styles[styleDirection2Prop]];\
        needsDisplay = YES;\
    }\
    NSString *styleDirection3Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction3, prop));\
    if (styles[styleDirection3Prop]) {\
        _border##direction3##prop = [JUDConvert type:styles[styleDirection3Prop]];\
        needsDisplay = YES;\
    }\
    NSString *styleDirection4Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction4, prop));\
    if (styles[styleDirection4Prop]) {\
        _border##direction4##prop = [JUDConvert type:styles[styleDirection4Prop]];\
        needsDisplay = YES;\
    }\
    if (needsDisplay && updating) {\
        [self setNeedsDisplay];\
    }\
} while (0);
    
// TODO: refactor this hopefully
#define JUD_CHECK_BORDER_PROP_PIXEL(prop, direction1, direction2, direction3, direction4)\
do {\
    BOOL needsDisplay = NO; \
    NSString *styleProp= JUD_NSSTRING(JUD_CONCAT(border, prop));\
    if (styles[styleProp]) {\
        _border##direction1##prop = _border##direction2##prop = _border##direction3##prop = _border##direction4##prop = [JUDConvert JUDPixelType:styles[styleProp] scaleFactor:self.judInstance.pixelScaleFactor];\
    needsDisplay = YES;\
    }\
    NSString *styleDirection1Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction1, prop));\
    if (styles[styleDirection1Prop]) {\
        _border##direction1##prop = [JUDConvert JUDPixelType:styles[styleDirection1Prop] scaleFactor:self.judInstance.pixelScaleFactor];\
        needsDisplay = YES;\
    }\
    NSString *styleDirection2Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction2, prop));\
    if (styles[styleDirection2Prop]) {\
        _border##direction2##prop = [JUDConvert JUDPixelType:styles[styleDirection2Prop] scaleFactor:self.judInstance.pixelScaleFactor];\
        needsDisplay = YES;\
    }\
    NSString *styleDirection3Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction3, prop));\
    if (styles[styleDirection3Prop]) {\
        _border##direction3##prop = [JUDConvert JUDPixelType:styles[styleDirection3Prop] scaleFactor:self.judInstance.pixelScaleFactor];\
        needsDisplay = YES;\
    }\
    NSString *styleDirection4Prop = JUD_NSSTRING(JUD_CONCAT_TRIPLE(border, direction4, prop));\
    if (styles[styleDirection4Prop]) {\
        _border##direction4##prop = [JUDConvert JUDPixelType:styles[styleDirection4Prop] scaleFactor:self.judInstance.pixelScaleFactor];\
        needsDisplay = YES;\
    }\
    if (needsDisplay && updating) {\
        [self setNeedsDisplay];\
    }\
} while (0);
    
    
    JUD_CHECK_BORDER_PROP(Style, Top, Left, Bottom, Right, JUDBorderStyle)
    JUD_CHECK_BORDER_PROP(Color, Top, Left, Bottom, Right, UIColor)
    JUD_CHECK_BORDER_PROP_PIXEL(Width, Top, Left, Bottom, Right)
    JUD_CHECK_BORDER_PROP_PIXEL(Radius, TopLeft, TopRight, BottomLeft, BottomRight)

    if (updating) {
        BOOL nowNeedsDrawBorder = [self _needsDrawBorder];
        if (nowNeedsDrawBorder && !previousNeedsDrawBorder) {
            _layer.cornerRadius = 0;
            _layer.borderWidth = 0;
            _layer.backgroundColor = NULL;
        } else if (!nowNeedsDrawBorder) {
            [self _resetNativeBorderRadius];
            _layer.borderWidth = _borderTopWidth;
            _layer.borderColor = _borderTopColor.CGColor;
            _layer.backgroundColor = _backgroundColor.CGColor;
        }
    }
}

@end
