/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"
#import "JUDComponent_internal.h"
#import "JUDComponent+GradientColor.h"
#import "JUDComponentManager.h"
#import "JUDSDKManager.h"
#import "JUDSDKInstance.h"
#import "JUDSDKInstance_private.h"
#import "JUDDefine.h"
#import "JUDLog.h"
#import "JUDWeakObjectWrapper.h"
#import "JUDUtility.h"
#import "JUDConvert.h"
#import "JUDMonitor.h"
#import "JUDAssert.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDThreadSafeMutableArray.h"
#import "JUDTransform.h"
#import "JUDRoundedRect.h"
#import <pthread/pthread.h>
#import "JUDComponent+PseudoClassManagement.h"

#pragma clang diagnostic ignored "-Wincomplete-implementation"
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface JUDComponent () <UIGestureRecognizerDelegate>

@end

@implementation JUDComponent
{
@private
    NSString *_ref;
    NSMutableDictionary *_styles;
    NSMutableDictionary *_attributes;
    NSMutableArray *_events;
    
    // Protects properties styles/attributes/events/subcomponents which will be accessed from multiple threads.
    pthread_mutex_t _propertyMutex;
    pthread_mutexattr_t _propertMutexAttr;
    
    __weak JUDComponent *_supercomponent;
    __weak id<JUDScrollerProtocol> _ancestorScroller;
    __weak JUDSDKInstance *_judInstance;
}

#pragma mark Life Cycle

- (instancetype)initWithRef:(NSString *)ref
                       type:(NSString *)type
                     styles:(NSDictionary *)styles
                 attributes:(NSDictionary *)attributes
                     events:(NSArray *)events
               judInstance:(JUDSDKInstance *)judInstance
{
    if (self = [super init]) {
        pthread_mutexattr_init(&_propertMutexAttr);
        pthread_mutexattr_settype(&_propertMutexAttr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&_propertyMutex, &_propertMutexAttr);
        
        _ref = ref;
        _type = type;
        _judInstance = judInstance;
        _styles = [self parseStyles:styles];
        _attributes = attributes ? [NSMutableDictionary dictionaryWithDictionary:attributes] : [NSMutableDictionary dictionary];
        _events = events ? [NSMutableArray arrayWithArray:events] : [NSMutableArray array];
        _subcomponents = [NSMutableArray array];
        
        _absolutePosition = CGPointMake(NAN, NAN);
        
        _isNeedJoinLayoutSystem = YES;
        _isLayoutDirty = YES;
        _isViewFrameSyncWithCalculated = YES;
        
        _async = NO;
        
        //TODO set indicator style 
        if ([type isEqualToString:@"indicator"]) {
            _styles[@"position"] = @"absolute";
            if (!_styles[@"left"] && !_styles[@"right"]) {
                _styles[@"left"] = @0.0f;
            }
            if (!_styles[@"top"] && !_styles[@"bottom"]) {
                _styles[@"top"] = @0.0f;
            }
        }
        
        [self _setupNavBarWithStyles:_styles attributes:_attributes];
        [self _initCSSNodeWithStyles:_styles];
        [self _initViewPropertyWithStyles:_styles];
        [self _handleBorders:styles isUpdating:NO];
    }
    
    return self;
}

- (void)dealloc
{
    free_css_node(_cssNode);

    [self _removeAllEvents];
    if (_positionType == JUDPositionTypeFixed) {
        [self.judInstance.componentManager removeFixedComponent:self];
    }

    pthread_mutex_destroy(&_propertyMutex);
    pthread_mutexattr_destroy(&_propertMutexAttr);

}

- (NSDictionary *)styles
{
    NSDictionary *styles;
    pthread_mutex_lock(&_propertyMutex);
    styles = _styles;
    pthread_mutex_unlock(&_propertyMutex);
    
    return styles;
}

- (NSDictionary *)pseudoClassStyles
{
    NSDictionary *pseudoClassStyles;
    pthread_mutex_lock(&_propertyMutex);
    pseudoClassStyles = _pseudoClassStyles;
    pthread_mutex_unlock(&_propertyMutex);
    
    return pseudoClassStyles;
}

- (NSString *)type
{
    return _type;
}

- (NSDictionary *)attributes
{
    NSDictionary *attributes;
    pthread_mutex_lock(&_propertyMutex);
    attributes = _attributes;
    pthread_mutex_unlock(&_propertyMutex);
    
    return attributes;
}

- (NSArray *)events
{
    NSArray *events;
    pthread_mutex_lock(&_propertyMutex);
    events = [_events copy];
    pthread_mutex_unlock(&_propertyMutex);
    
    return events;
}

- (JUDSDKInstance *)judInstance
{
    return _judInstance;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ ref=%@> %@", _type, _ref, _view];
}

#pragma mark Property

- (UIView *)view
{
    if ([self isViewLoaded]) {
        return _view;
    } else {
        JUDAssertMainThread();
        
        // compositing child will be drew by its composited ancestor
        if (_compositingChild) {
            return nil;
        }
        
        [self viewWillLoad];
        
        _view = [self loadView];
        
        _layer = _view.layer;
        _view.frame = _calculatedFrame;
        
        _view.hidden = _visibility == JUDVisibilityShow ? NO : YES;
        _view.clipsToBounds = _clipToBounds;
        
        if (![self _needsDrawBorder]) {
            _layer.borderColor = _borderTopColor.CGColor;
            _layer.borderWidth = _borderTopWidth;
            [self _resetNativeBorderRadius];
            _layer.opacity = _opacity;
            _view.backgroundColor = _backgroundColor;
        }
        
        if (_backgroundImage) {
            [self setGradientLayer];
        }
        
        if (_transform) {
            [_transform applyTransformForView:_view];
        }
        
        _view.jud_component = self;
        _view.jud_ref = self.ref;
        _layer.jud_component = self;
        
        [self _initEvents:self.events];
        [self _initPseudoEvents:_isListenPseudoTouch];
        
        if (_positionType == JUDPositionTypeSticky) {
            [self.ancestorScroller addStickyComponent:self];
        }
        
        if (self.supercomponent && self.supercomponent->_async) {
            self->_async = YES;
        }
        
        [self setNeedsDisplay];
        [self viewDidLoad];
        
        if (_lazyCreateView) {
            [self _buildViewHierarchyLazily];
        }
        
        [self _handleFirstScreenTime];
        
        return _view;
    }
}

- (void)_buildViewHierarchyLazily
{
    if (self.supercomponent && !((JUDComponent *)self.supercomponent)->_lazyCreateView) {
        NSArray *subcomponents = ((JUDComponent *)self.supercomponent).subcomponents;
        
        NSInteger index = [subcomponents indexOfObject:self];
        if (index != NSNotFound) {
            [(JUDComponent *)self.supercomponent insertSubview:self atIndex:index];
        }
    }
    
    NSArray *subcomponents = self.subcomponents;
    for (int i = 0; i < subcomponents.count; i++) {
        JUDComponent *subcomponent = subcomponents[i];
        [self insertSubview:subcomponent atIndex:i];
    }
}

- (void)_resetNativeBorderRadius
{
    JUDRoundedRect *borderRect = [[JUDRoundedRect alloc] initWithRect:_calculatedFrame topLeft:_borderTopRightRadius topRight:_borderTopRightRadius bottomLeft:_borderBottomLeftRadius bottomRight:_borderBottomRightRadius];
    _layer.cornerRadius = borderRect.radii.topLeft;
}

- (void)_handleFirstScreenTime
{
    if (JUD_MONITOR_INSTANCE_PERF_IS_RECORDED(JUDPTFirstScreenRender, self.judInstance)) {
        return;
    }
    
    CGPoint absolutePosition = [self.supercomponent.view convertPoint:_view.frame.origin toView:_judInstance.rootView];
    if (absolutePosition.y + _view.frame.size.height > self.judInstance.rootView.frame.size.height + 1) {
        JUD_MONITOR_INSTANCE_PERF_END(JUDPTFirstScreenRender, self.judInstance);
    }
}

- (CALayer *)layer
{
    return _layer;
}

- (CGRect)calculatedFrame
{
    return _calculatedFrame;
}

- (CGPoint)absolutePosition
{
    return _absolutePosition;
}

- (css_node_t *)cssNode
{
    return _cssNode;
}

#pragma mark Component Hierarchy 

- (NSArray<JUDComponent *> *)subcomponents
{
    NSArray<JUDComponent *> *subcomponents;
    pthread_mutex_lock(&_propertyMutex);
    subcomponents = [_subcomponents copy];
    pthread_mutex_unlock(&_propertyMutex);
    
    return subcomponents;
}

- (JUDComponent *)supercomponent
{
    return _supercomponent;
}

- (void)_insertSubcomponent:(JUDComponent *)subcomponent atIndex:(NSInteger)index
{
    JUDAssert(subcomponent, @"The subcomponent to insert to %@ at index %d must not be nil", self, index);
    
    subcomponent->_supercomponent = self;
    
    pthread_mutex_lock(&_propertyMutex);
    [_subcomponents insertObject:subcomponent atIndex:index];
    pthread_mutex_unlock(&_propertyMutex);
    
    if (subcomponent->_positionType == JUDPositionTypeFixed) {
        [self.judInstance.componentManager addFixedComponent:subcomponent];
        subcomponent->_isNeedJoinLayoutSystem = NO;
    }
    
    [self _recomputeCSSNodeChildren];
    [self setNeedsLayout];
}

- (void)_removeSubcomponent:(JUDComponent *)subcomponent
{
    pthread_mutex_lock(&_propertyMutex);
    [_subcomponents removeObject:subcomponent];
    pthread_mutex_unlock(&_propertyMutex);
}

- (void)_removeFromSupercomponent
{
    [self.supercomponent _removeSubcomponent:self];
    [self.supercomponent _recomputeCSSNodeChildren];
    [self.supercomponent setNeedsLayout];
    
    if (_positionType == JUDPositionTypeFixed) {
        [self.judInstance.componentManager removeFixedComponent:self];
        self->_isNeedJoinLayoutSystem = YES;
    }
}

- (void)_moveToSupercomponent:(JUDComponent *)newSupercomponent atIndex:(NSUInteger)index
{
    [self _removeFromSupercomponent];
    [newSupercomponent _insertSubcomponent:self atIndex:index];
}

- (id<JUDScrollerProtocol>)ancestorScroller
{
    if(!_ancestorScroller) {
        JUDComponent *supercomponent = self.supercomponent;
        while (supercomponent) {
            if([supercomponent conformsToProtocol:@protocol(JUDScrollerProtocol)]) {
                _ancestorScroller = (id<JUDScrollerProtocol>)supercomponent;
                break;
            }
            supercomponent = supercomponent.supercomponent;
        }
    }
    
    return _ancestorScroller;
}

#pragma mark Updating

- (void)_updateStylesOnComponentThread:(NSDictionary *)styles resetStyles:(NSMutableArray *)resetStyles isUpdateStyles:(BOOL)isUpdateStyles
{
    if (isUpdateStyles) {
        pthread_mutex_lock(&_propertyMutex);
        [_styles addEntriesFromDictionary:styles];
        pthread_mutex_unlock(&_propertyMutex);
    }
    [self _updateCSSNodeStyles:styles];
    [self _resetCSSNodeStyles:resetStyles];
}

- (void)_updateAttributesOnComponentThread:(NSDictionary *)attributes
{
    pthread_mutex_lock(&_propertyMutex);
    [_attributes addEntriesFromDictionary:attributes];
    pthread_mutex_unlock(&_propertyMutex);
}

- (void)_addEventOnComponentThread:(NSString *)eventName
{
    pthread_mutex_lock(&_propertyMutex);
    [_events addObject:eventName];
    pthread_mutex_unlock(&_propertyMutex);
}

- (void)_removeEventOnComponentThread:(NSString *)eventName
{
    pthread_mutex_lock(&_propertyMutex);
    [_events removeObject:eventName];
    pthread_mutex_unlock(&_propertyMutex);
}

- (void)_updateStylesOnMainThread:(NSDictionary *)styles resetStyles:(NSMutableArray *)resetStyles
{
    JUDAssertMainThread();
    [self _updateViewStyles:styles];
    [self _resetStyles:resetStyles];
    [self _handleBorders:styles isUpdating:YES];
    
    [self updateStyles:styles];
    [self resetStyles:resetStyles];
}

- (void)_updateAttributesOnMainThread:(NSDictionary *)attributes
{
    JUDAssertMainThread();
    
    [self _updateNavBarAttributes:attributes];
    
    [self updateAttributes:attributes];
}

- (void)updateStyles:(NSDictionary *)styles
{
    JUDAssertMainThread();
}

- (void)readyToRender
{
    if (self.judInstance.trackComponent) {
        [self.supercomponent readyToRender];
    }
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    JUDAssertMainThread();
}

#pragma mark Reset
- (void)resetStyles:(NSArray *)styles
{
    JUDAssertMainThread();
}

#pragma mark Layout

/**
 *  @see JUDComponent+Layout.m
 */

#pragma mark View Management

/**
 *  @see JUDComponent+ViewManagement.m
 */

#pragma mark Events

/**
 *  @see JUDComponent+Events.m
 */

#pragma mark Display

/**
 *  @see JUDComponent+Display.m
 */

@end


@implementation UIView (JUDComponent)

- (JUDComponent *)jud_component
{
    JUDWeakObjectWrapper *weakWrapper = objc_getAssociatedObject(self, @selector(jud_component));
    return [weakWrapper weakObject];
}

- (void)setJud_component:(JUDComponent *)jud_component
{
    id weakWrapper = [[JUDWeakObjectWrapper alloc] initWithWeakObject:jud_component];
    objc_setAssociatedObject(self, @selector(jud_component), weakWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)jud_ref
{
    JUDWeakObjectWrapper *weakWrapper = objc_getAssociatedObject(self, @selector(jud_ref));
    return [weakWrapper weakObject];
}

- (void)setJud_ref:(NSString *)jud_ref
{
    id weakWrapper = [[JUDWeakObjectWrapper alloc] initWithWeakObject:jud_ref];
    objc_setAssociatedObject(self, @selector(jud_ref), weakWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation CALayer (JUDComponents_new)

- (JUDComponent *)jud_component
{
    JUDWeakObjectWrapper *weakWrapper = objc_getAssociatedObject(self, @selector(jud_component));
    return [weakWrapper weakObject];
}

- (void)setJud_component:(JUDComponent *)jud_component
{
    id weakWrapper = [[JUDWeakObjectWrapper alloc] initWithWeakObject:jud_component];
    objc_setAssociatedObject(self, @selector(jud_component), weakWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

