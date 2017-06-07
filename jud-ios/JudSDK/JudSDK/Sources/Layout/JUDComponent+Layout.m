/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent+Layout.h"
#import "JUDComponent_internal.h"
#import "JUDTransform.h"
#import "JUDAssert.h"
#import "JUDComponent_internal.h"
#import "JUDSDKInstance_private.h"

@implementation JUDComponent (Layout)

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#pragma mark Public

- (void)setNeedsLayout
{
    _isLayoutDirty = YES;
    JUDComponent *supercomponent = [self supercomponent];
    if(supercomponent){
        [supercomponent setNeedsLayout];
    }
}

- (BOOL)needsLayout
{
    return _isLayoutDirty;
}

- (CGSize (^)(CGSize))measureBlock
{
    return nil;
}

- (void)layoutDidFinish
{
    JUDAssertMainThread();
}

#pragma mark Private

- (void)_initCSSNodeWithStyles:(NSDictionary *)styles
{
    _cssNode = new_css_node();
    
    _cssNode->print = cssNodePrint;
    _cssNode->get_child = cssNodeGetChild;
    _cssNode->is_dirty = cssNodeIsDirty;
    if ([self measureBlock]) {
        _cssNode->measure = cssNodeMeasure;
    }
    _cssNode->context = (__bridge void *)self;
    
    [self _recomputeCSSNodeChildren];
    [self _fillCSSNode:styles];
    
    // To be in conformity with Android/Web, hopefully remove this in the future.
    if ([self.ref isEqualToString:JUD_SDK_ROOT_REF]) {
        if (isUndefined(_cssNode->style.dimensions[CSS_HEIGHT]) && self.judInstance.frame.size.height) {
            _cssNode->style.dimensions[CSS_HEIGHT] = self.judInstance.frame.size.height;
        }
        
        if (isUndefined(_cssNode->style.dimensions[CSS_WIDTH]) && self.judInstance.frame.size.width) {
            _cssNode->style.dimensions[CSS_WIDTH] = self.judInstance.frame.size.width;
        }
    }
}

- (void)_updateCSSNodeStyles:(NSDictionary *)styles
{
    [self _fillCSSNode:styles];
}

-(void)_resetCSSNodeStyles:(NSArray *)styles
{
    [self _resetCSSNode:styles];
}

- (void)_recomputeCSSNodeChildren
{
    _cssNode->children_count = (int)[self _childrenCountForLayout];
}

- (NSUInteger)_childrenCountForLayout
{
    NSArray *subcomponents = _subcomponents;
    NSUInteger count = subcomponents.count;
    for (JUDComponent *component in subcomponents) {
        if (!component->_isNeedJoinLayoutSystem) {
            count--;
        }
    }
    return (int)(count);
}

- (void)_frameDidCalculated:(BOOL)isChanged
{
    JUDAssertComponentThread();
    
    if ([self isViewLoaded] && isChanged && [self isViewFrameSyncWithCalculated]) {
        
        __weak typeof(self) weakSelf = self;
        [self.judInstance.componentManager _addUITask:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf->_transform && !CATransform3DEqualToTransform(strongSelf.layer.transform, CATransform3DIdentity)) {
                // From the UIView's frame documentation:
                // https://developer.apple.com/reference/uikit/uiview#//apple_ref/occ/instp/UIView/frame
                // Warning : If the transform property is not the identity transform, the value of this property is undefined and therefore should be ignored.
                // So layer's transform must be reset to CATransform3DIdentity before setFrame, otherwise frame will be incorrect
                strongSelf.layer.transform = CATransform3DIdentity;
            }
            
            strongSelf.view.frame = strongSelf.calculatedFrame;
            
            if (strongSelf->_transform) {
                [strongSelf->_transform applyTransformForView:strongSelf.view];
            }
            
            [strongSelf setNeedsDisplay];
        }];
    }
}

- (void)_calculateFrameWithSuperAbsolutePosition:(CGPoint)superAbsolutePosition
                           gatherDirtyComponents:(NSMutableSet<JUDComponent *> *)dirtyComponents
{
    JUDAssertComponentThread();
    
    if (!_cssNode->layout.should_update) {
        return;
    }
    _cssNode->layout.should_update = false;
    _isLayoutDirty = NO;
    
    CGRect newFrame = CGRectMake(JUDRoundPixelValue(_cssNode->layout.position[CSS_LEFT]),
                                 JUDRoundPixelValue(_cssNode->layout.position[CSS_TOP]),
                                 JUDRoundPixelValue(_cssNode->layout.dimensions[CSS_WIDTH]),
                                 JUDRoundPixelValue(_cssNode->layout.dimensions[CSS_HEIGHT]));
    
    BOOL isFrameChanged = NO;
    if (!CGRectEqualToRect(newFrame, _calculatedFrame)) {
        isFrameChanged = YES;
        _calculatedFrame = newFrame;
        [dirtyComponents addObject:self];
    }
    
    CGPoint newAbsolutePosition = [self computeNewAbsolutePosition:superAbsolutePosition];
    
    _cssNode->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
    _cssNode->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
    _cssNode->layout.position[CSS_LEFT] = 0;
    _cssNode->layout.position[CSS_TOP] = 0;
    
    [self _frameDidCalculated:isFrameChanged];
    
    for (JUDComponent *subcomponent in _subcomponents) {
        [subcomponent _calculateFrameWithSuperAbsolutePosition:newAbsolutePosition gatherDirtyComponents:dirtyComponents];
    }
}

- (CGPoint)computeNewAbsolutePosition:(CGPoint)superAbsolutePosition
{
    // Not need absolutePosition any more
 //   [self _computeNewAbsolutePosition:superAbsolutePosition];
    return superAbsolutePosition;
}

- (CGPoint)_computeNewAbsolutePosition:(CGPoint)superAbsolutePosition
{
    CGPoint newAbsolutePosition = CGPointMake(JUDRoundPixelValue(superAbsolutePosition.x + _cssNode->layout.position[CSS_LEFT]),
                                              JUDRoundPixelValue(superAbsolutePosition.y + _cssNode->layout.position[CSS_TOP]));
    
    if(!CGPointEqualToPoint(_absolutePosition, newAbsolutePosition)){
        _absolutePosition = newAbsolutePosition;
    }
    
    return newAbsolutePosition;
}

- (void)_layoutDidFinish
{
    JUDAssertMainThread();
    
    if (_positionType == JUDPositionTypeSticky) {
        [self.ancestorScroller adjustSticky];
    }
    
    [self layoutDidFinish];
}

#define JUD_STYLE_FILL_CSS_NODE(key, cssProp, type)\
do {\
    id value = styles[@#key];\
    if (value) {\
        typeof(_cssNode->style.cssProp) convertedValue = (typeof(_cssNode->style.cssProp))[JUDConvert type:value];\
        _cssNode->style.cssProp = convertedValue;\
        [self setNeedsLayout];\
    }\
} while(0);

#define JUD_STYLE_FILL_CSS_NODE_PIXEL(key, cssProp)\
do {\
    id value = styles[@#key];\
    if (value) {\
        CGFloat pixel = [self JUDPixelType:value];\
        if (isnan(pixel)) {\
            JUDLogError(@"Invalid NaN value for style:%@, ref:%@", @#key, self.ref);\
        } else {\
            _cssNode->style.cssProp = pixel;\
            [self setNeedsLayout];\
        }\
    }\
} while(0);

#define JUD_STYLE_FILL_CSS_NODE_ALL_DIRECTION(key, cssProp)\
do {\
    JUD_STYLE_FILL_CSS_NODE_PIXEL(key, cssProp[CSS_TOP])\
    JUD_STYLE_FILL_CSS_NODE_PIXEL(key, cssProp[CSS_LEFT])\
    JUD_STYLE_FILL_CSS_NODE_PIXEL(key, cssProp[CSS_RIGHT])\
    JUD_STYLE_FILL_CSS_NODE_PIXEL(key, cssProp[CSS_BOTTOM])\
} while(0);


- (CGFloat)JUDPixelType:(id)value
{
    return [JUDConvert JUDPixelType:value scaleFactor:self.judInstance.pixelScaleFactor];
}

- (void)_fillCSSNode:(NSDictionary *)styles;
{
    // flex
    JUD_STYLE_FILL_CSS_NODE(flex, flex, CGFloat)
    JUD_STYLE_FILL_CSS_NODE(flexDirection, flex_direction, css_flex_direction_t)
    JUD_STYLE_FILL_CSS_NODE(alignItems, align_items, css_align_t)
    JUD_STYLE_FILL_CSS_NODE(alignSelf, align_self, css_align_t)
    JUD_STYLE_FILL_CSS_NODE(flexWrap, flex_wrap, css_wrap_type_t)
    JUD_STYLE_FILL_CSS_NODE(justifyContent, justify_content, css_justify_t)
    
    // position
    JUD_STYLE_FILL_CSS_NODE(position, position_type, css_position_type_t)
    JUD_STYLE_FILL_CSS_NODE_PIXEL(top, position[CSS_TOP])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(left, position[CSS_LEFT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(right, position[CSS_RIGHT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(bottom, position[CSS_BOTTOM])
    
    // dimension
    JUD_STYLE_FILL_CSS_NODE_PIXEL(width, dimensions[CSS_WIDTH])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(height, dimensions[CSS_HEIGHT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(minWidth, minDimensions[CSS_WIDTH])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(minHeight, minDimensions[CSS_HEIGHT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(maxWidth, maxDimensions[CSS_WIDTH])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(maxHeight, maxDimensions[CSS_HEIGHT])
    
    // margin
    JUD_STYLE_FILL_CSS_NODE_ALL_DIRECTION(margin, margin)
    JUD_STYLE_FILL_CSS_NODE_PIXEL(marginTop, margin[CSS_TOP])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(marginLeft, margin[CSS_LEFT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(marginRight, margin[CSS_RIGHT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(marginBottom, margin[CSS_BOTTOM])
    
    // border
    JUD_STYLE_FILL_CSS_NODE_ALL_DIRECTION(borderWidth, border)
    JUD_STYLE_FILL_CSS_NODE_PIXEL(borderTopWidth, border[CSS_TOP])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(borderLeftWidth, border[CSS_LEFT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(borderRightWidth, border[CSS_RIGHT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(borderBottomWidth, border[CSS_BOTTOM])
    
    // padding
    JUD_STYLE_FILL_CSS_NODE_ALL_DIRECTION(padding, padding)
    JUD_STYLE_FILL_CSS_NODE_PIXEL(paddingTop, padding[CSS_TOP])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(paddingLeft, padding[CSS_LEFT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(paddingRight, padding[CSS_RIGHT])
    JUD_STYLE_FILL_CSS_NODE_PIXEL(paddingBottom, padding[CSS_BOTTOM])
}

#define JUD_STYLE_RESET_CSS_NODE(key, cssProp, defaultValue)\
do {\
    if (styles && [styles containsObject:@#key]) {\
        _cssNode->style.cssProp = defaultValue;\
        [self setNeedsLayout];\
    }\
} while(0);

#define JUD_STYLE_RESET_CSS_NODE_ALL_DIRECTION(key, cssProp, defaultValue)\
do {\
    JUD_STYLE_RESET_CSS_NODE(key, cssProp[CSS_TOP], defaultValue)\
    JUD_STYLE_RESET_CSS_NODE(key, cssProp[CSS_LEFT], defaultValue)\
    JUD_STYLE_RESET_CSS_NODE(key, cssProp[CSS_RIGHT], defaultValue)\
    JUD_STYLE_RESET_CSS_NODE(key, cssProp[CSS_BOTTOM], defaultValue)\
} while(0);

- (void)_resetCSSNode:(NSArray *)styles;
{
    // flex
    JUD_STYLE_RESET_CSS_NODE(flex, flex, 0.0)
    JUD_STYLE_RESET_CSS_NODE(flexDirection, flex_direction, CSS_FLEX_DIRECTION_COLUMN)
    JUD_STYLE_RESET_CSS_NODE(alignItems, align_items, CSS_ALIGN_STRETCH)
    JUD_STYLE_RESET_CSS_NODE(alignSelf, align_self, CSS_ALIGN_AUTO)
    JUD_STYLE_RESET_CSS_NODE(flexWrap, flex_wrap, CSS_NOWRAP)
    JUD_STYLE_RESET_CSS_NODE(justifyContent, justify_content, CSS_JUSTIFY_FLEX_START)

    // position
    JUD_STYLE_RESET_CSS_NODE(position, position_type, CSS_POSITION_RELATIVE)
    JUD_STYLE_RESET_CSS_NODE(top, position[CSS_TOP], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(left, position[CSS_LEFT], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(right, position[CSS_RIGHT], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(bottom, position[CSS_BOTTOM], CSS_UNDEFINED)
    
    // dimension
    JUD_STYLE_RESET_CSS_NODE(width, dimensions[CSS_WIDTH], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(height, dimensions[CSS_HEIGHT], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(minWidth, minDimensions[CSS_WIDTH], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(minHeight, minDimensions[CSS_HEIGHT], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(maxWidth, maxDimensions[CSS_WIDTH], CSS_UNDEFINED)
    JUD_STYLE_RESET_CSS_NODE(maxHeight, maxDimensions[CSS_HEIGHT], CSS_UNDEFINED)
    
    // margin
    JUD_STYLE_RESET_CSS_NODE_ALL_DIRECTION(margin, margin, 0.0)
    JUD_STYLE_RESET_CSS_NODE(marginTop, margin[CSS_TOP], 0.0)
    JUD_STYLE_RESET_CSS_NODE(marginLeft, margin[CSS_LEFT], 0.0)
    JUD_STYLE_RESET_CSS_NODE(marginRight, margin[CSS_RIGHT], 0.0)
    JUD_STYLE_RESET_CSS_NODE(marginBottom, margin[CSS_BOTTOM], 0.0)
    
    // border
    JUD_STYLE_RESET_CSS_NODE_ALL_DIRECTION(borderWidth, border, 0.0)
    JUD_STYLE_RESET_CSS_NODE(borderTopWidth, border[CSS_TOP], 0.0)
    JUD_STYLE_RESET_CSS_NODE(borderLeftWidth, border[CSS_LEFT], 0.0)
    JUD_STYLE_RESET_CSS_NODE(borderRightWidth, border[CSS_RIGHT], 0.0)
    JUD_STYLE_RESET_CSS_NODE(borderBottomWidth, border[CSS_BOTTOM], 0.0)
    
    // padding
    JUD_STYLE_RESET_CSS_NODE_ALL_DIRECTION(padding, padding, 0.0)
    JUD_STYLE_RESET_CSS_NODE(paddingTop, padding[CSS_TOP], 0.0)
    JUD_STYLE_RESET_CSS_NODE(paddingLeft, padding[CSS_LEFT], 0.0)
    JUD_STYLE_RESET_CSS_NODE(paddingRight, padding[CSS_RIGHT], 0.0)
    JUD_STYLE_RESET_CSS_NODE(paddingBottom, padding[CSS_BOTTOM], 0.0)
}

- (void)_fillAbsolutePositions
{
    CGPoint absolutePosition = _absolutePosition;
    NSArray *subcomponents = self.subcomponents;
    for (JUDComponent *subcomponent in subcomponents) {
        subcomponent->_absolutePosition = CGPointMake(absolutePosition.x + subcomponent.calculatedFrame.origin.x, absolutePosition.y + subcomponent.calculatedFrame.origin.y);
        [subcomponent _fillAbsolutePositions];
    }
}

#pragma mark CSS Node Override

static void cssNodePrint(void *context)
{
    JUDComponent *component = (__bridge JUDComponent *)context;
    // TODO:
    printf("%s:%s ", component.ref.UTF8String, component->_type.UTF8String);
}

static css_node_t * cssNodeGetChild(void *context, int i)
{
    JUDComponent *component = (__bridge JUDComponent *)context;
    NSArray *subcomponents = component->_subcomponents;
    for (int j = 0; j <= i && j < subcomponents.count; j++) {
        JUDComponent *child = subcomponents[j];
        if (!child->_isNeedJoinLayoutSystem) {
            i++;
        }
    }
    
    if(i >= 0 && i < subcomponents.count){
        JUDComponent *child = subcomponents[i];
        return child->_cssNode;
    }
    
    
    JUDAssert(NO, @"Can not find component:%@'s css node child at index: %ld, totalCount:%ld", component, i, subcomponents.count);
    return NULL;
}

static bool cssNodeIsDirty(void *context)
{
    JUDAssertComponentThread();
    
    JUDComponent *component = (__bridge JUDComponent *)context;
    BOOL needsLayout = [component needsLayout];
    
    return needsLayout;
}

static css_dim_t cssNodeMeasure(void *context, float width, css_measure_mode_t widthMode, float height, css_measure_mode_t heightMode)
{
    JUDComponent *component = (__bridge JUDComponent *)context;
    CGSize (^measureBlock)(CGSize) = [component measureBlock];
    
    if (!measureBlock) {
        return (css_dim_t){NAN, NAN};
    }
    
    CGSize constrainedSize = CGSizeMake(width, height);
    CGSize resultSize = measureBlock(constrainedSize);
    
    return (css_dim_t){resultSize.width, resultSize.height};
}

@end
