/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent+ViewManagement.h"
#import "JUDComponent_internal.h"
#import "JUDComponent+GradientColor.h"
#import "JUDAssert.h"
#import "JUDView.h"
#import "JUDSDKInstance_private.h"
#import "JUDTransform.h"

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation JUDComponent (ViewManagement)

#pragma mark Public

- (UIView *)loadView
{
    return [[JUDView alloc] init];
}

- (BOOL)isViewLoaded
{
    return (_view != nil);
}

- (void)insertSubview:(JUDComponent *)subcomponent atIndex:(NSInteger)index
{
    JUDAssertMainThread();
    
    if (subcomponent->_positionType == JUDPositionTypeFixed) {
        [self.judInstance.rootView addSubview:subcomponent.view];
        return;
    }
    
    // use _lazyCreateView to forbid component like cell's view creating
    if(_lazyCreateView) {
        subcomponent->_lazyCreateView = YES;
    }
    
    if (!subcomponent->_lazyCreateView || (self->_lazyCreateView && [self isViewLoaded])) {
        [self.view insertSubview:subcomponent.view atIndex:index];
    }
}

- (void)willRemoveSubview:(JUDComponent *)component
{
    JUDAssertMainThread();
}

- (void)removeFromSuperview
{
    JUDAssertMainThread();
    
    if ([self isViewLoaded]) {
        [self.view removeFromSuperview];
    }
}

- (void)moveToSuperview:(JUDComponent *)newSupercomponent atIndex:(NSUInteger)index
{
    [self removeFromSuperview];
    [newSupercomponent insertSubview:self atIndex:index];
}

- (void)viewWillLoad
{
    JUDAssertMainThread();
}

- (void)viewDidLoad
{
    JUDAssertMainThread();
}

- (void)viewWillUnload
{
    JUDAssertMainThread();
}

- (void)viewDidUnload
{
    JUDAssertMainThread();
}

#pragma mark Private

- (void)_initViewPropertyWithStyles:(NSDictionary *)styles
{
    _backgroundColor = styles[@"backgroundColor"] ? [JUDConvert UIColor:styles[@"backgroundColor"]] : [UIColor clearColor];
    _backgroundImage = styles[@"backgroundImage"] ? [[JUDConvert NSString:styles[@"backgroundImage"]]stringByReplacingOccurrencesOfString:@" " withString:@""]: nil;
    _opacity = styles[@"opacity"] ? [JUDConvert CGFloat:styles[@"opacity"]] : 1.0;
    _clipToBounds = styles[@"overflow"] ? [JUDConvert JUDClipType:styles[@"overflow"]] : NO;
    _visibility = styles[@"visibility"] ? [JUDConvert JUDVisibility:styles[@"visibility"]] : JUDVisibilityShow;
    _positionType = styles[@"position"] ? [JUDConvert JUDPositionType:styles[@"position"]] : JUDPositionTypeRelative;
    _transform = styles[@"transform"] || styles[@"transformOrigin"] ?
    [[JUDTransform alloc] initWithCSSValue:[JUDConvert NSString:styles[@"transform"]] origin:styles[@"transformOrigin"] instance:self.judInstance] :
    [[JUDTransform alloc] initWithCSSValue:nil origin:nil instance:self.judInstance];
}

- (void)_updateViewStyles:(NSDictionary *)styles
{
    if (styles[@"backgroundColor"]) {
        _backgroundColor = [JUDConvert UIColor:styles[@"backgroundColor"]];
        _layer.backgroundColor = _backgroundColor.CGColor;
        [self setNeedsDisplay];
    }
    
    if (styles[@"backgroundImage"]) {
        _backgroundImage = styles[@"backgroundImage"] ? [[JUDConvert NSString:styles[@"backgroundImage"]]stringByReplacingOccurrencesOfString:@" " withString:@""]: nil;
        
        if (_backgroundImage) {
            [self setGradientLayer];
        }
    }
    
    if (styles[@"opacity"]) {
        _opacity = [JUDConvert CGFloat:styles[@"opacity"]];
        _layer.opacity = _opacity;
    }
    
    if (styles[@"overflow"]) {
        _clipToBounds = [JUDConvert JUDClipType:styles[@"overflow"]];
        _view.clipsToBounds = _clipToBounds;
    }
    
    if (styles[@"position"]) {
        JUDPositionType positionType = [JUDConvert JUDPositionType:styles[@"position"]];
        if (positionType == JUDPositionTypeSticky) {
            [self.ancestorScroller addStickyComponent:self];
        } else if (_positionType == JUDPositionTypeSticky) {
            [self.ancestorScroller removeStickyComponent:self];
        }
        
        if (positionType == JUDPositionTypeFixed) {
            [self.judInstance.componentManager addFixedComponent:self];
            _isNeedJoinLayoutSystem = NO;
            [self.supercomponent _recomputeCSSNodeChildren];
        } else if (_positionType == JUDPositionTypeFixed) {
            [self.judInstance.componentManager removeFixedComponent:self];
            _isNeedJoinLayoutSystem = YES;
            [self.supercomponent _recomputeCSSNodeChildren];
        }
        
        _positionType = positionType;
    }
    
    if (styles[@"visibility"]) {
        _visibility = [JUDConvert JUDVisibility:styles[@"visibility"]];
        if (_visibility == JUDVisibilityShow) {
            self.view.hidden = NO;
        }
        else {
            self.view.hidden = YES;
        }
    }
    
    if (styles[@"transformOrigin"] || styles[@"transform"]) {
        id transform = styles[@"transform"] ? : self.styles[@"transform"];
        id transformOrigin = styles[@"transformOrigin"] ? : self.styles[@"transformOrigin"];
        _transform = [[JUDTransform alloc] initWithCSSValue:[JUDConvert NSString:transform] origin:transformOrigin instance:self.judInstance];
        if (!CGRectEqualToRect(self.calculatedFrame, CGRectZero)) {
            [_transform applyTransformForView:_view];
            [_layer setNeedsDisplay];
        }
    }
}

-(void)_resetStyles:(NSArray *)styles
{
    if (styles && [styles containsObject:@"backgroundColor"]) {
        _backgroundColor = [UIColor clearColor];
        _layer.backgroundColor = _backgroundColor.CGColor;
        [self setNeedsDisplay];
    }
}

- (void)_unloadViewWithReusing:(BOOL)isReusing
{
    JUDAssertMainThread();
    
    if (isReusing && self->_positionType == JUDPositionTypeFixed) {
        return;
    }
    
    [self viewWillUnload];
    
    _view.gestureRecognizers = nil;
    
    [self _removeAllEvents];
    
    if(self.ancestorScroller){
        [self.ancestorScroller removeStickyComponent:self];
        [self.ancestorScroller removeScrollToListener:self];
    }
    
    for (JUDComponent *subcomponents in [self.subcomponents reverseObjectEnumerator]) {
        [subcomponents _unloadViewWithReusing:isReusing];
    }
    
    [_view removeFromSuperview];
    _view = nil;
    [_layer removeFromSuperlayer];
    _layer = nil;
    
    [self viewDidUnload];
}

@end
