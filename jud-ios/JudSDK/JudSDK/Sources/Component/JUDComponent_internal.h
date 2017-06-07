/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDScrollerProtocol.h"
#import "JUDComponent.h"
#import "JUDConvert.h"
#import "JUDTransform.h"
@class JUDTouchGestureRecognizer;
@class JUDThreadSafeCounter;

/**
 * The following variables and methods are used in Jud INTERNAL logic.
 * @warning These variables and methods must never be called or overridden.
 */
@interface JUDComponent ()
{
@package
    NSString *_type;
    NSMutableArray *_subcomponents;
    /**
     *  Layout
     */
    css_node_t *_cssNode;
    BOOL _isLayoutDirty;
    CGRect _calculatedFrame;
    CGPoint _absolutePosition;
    JUDPositionType _positionType;
    
    /**
     *  View
     */
    UIColor *_backgroundColor;
    NSString *_backgroundImage;
    JUDClipType _clipToBounds;
    UIView *_view;
    CGFloat _opacity;
    JUDVisibility  _visibility;
    
    /**
     *  PseudoClass
     */
    NSMutableDictionary *_pseudoClassStyles;
    NSMutableDictionary *_updatedPseudoClassStyles;
    BOOL _isListenPseudoTouch;
    
    /**
     *  Events
     */
    BOOL _appearEvent;
    BOOL _disappearEvent;
    UITapGestureRecognizer *_tapGesture;
    NSMutableArray *_swipeGestures;
    UILongPressGestureRecognizer *_longPressGesture;
    UIPanGestureRecognizer *_panGesture;
    
    BOOL _listenPanStart;
    BOOL _listenPanMove;
    BOOL _listenPanEnd;
    
    BOOL _listenHorizontalPan;
    BOOL _listenVerticalPan;
    
    JUDTouchGestureRecognizer* _touchGesture;
    
    /**
     *  Display
     */
    CALayer *_layer;
    BOOL _composite;
    BOOL _compositingChild;
    JUDThreadSafeCounter *_displayCounter;
    
    UIColor *_borderTopColor;
    UIColor *_borderRightColor;
    UIColor *_borderLeftColor;
    UIColor *_borderBottomColor;
    
    CGFloat _borderTopWidth;
    CGFloat _borderRightWidth;
    CGFloat _borderLeftWidth;
    CGFloat _borderBottomWidth;
    
    CGFloat _borderTopLeftRadius;
    CGFloat _borderTopRightRadius;
    CGFloat _borderBottomLeftRadius;
    CGFloat _borderBottomRightRadius;
    
    JUDBorderStyle _borderTopStyle;
    JUDBorderStyle _borderRightStyle;
    JUDBorderStyle _borderBottomStyle;
    JUDBorderStyle _borderLeftStyle;
    
    
    BOOL _isFixed;
    BOOL _async;
    BOOL _isNeedJoinLayoutSystem;
    BOOL _lazyCreateView;
    
    JUDTransform *_transform;
}

///--------------------------------------
/// @name Package Internal Methods
///--------------------------------------

- (void)_layoutDidFinish;
- (void)_calculateFrameWithSuperAbsolutePosition:(CGPoint)superAbsolutePosition
                           gatherDirtyComponents:(NSMutableSet<JUDComponent *> *)dirtyComponents;


- (void)_willDisplayLayer:(CALayer *)layer;

- (void)_unloadViewWithReusing:(BOOL)isReusing;

- (id<JUDScrollerProtocol>)ancestorScroller;

- (void)_insertSubcomponent:(JUDComponent *)subcomponent atIndex:(NSInteger)index;
- (void)_removeFromSupercomponent;
- (void)_moveToSupercomponent:(JUDComponent *)newSupercomponent atIndex:(NSUInteger)index;

- (void)_updateStylesOnComponentThread:(NSDictionary *)styles resetStyles:(NSMutableArray *)resetStyles isUpdateStyles:(BOOL)isUpdateStyles;
- (void)_updateAttributesOnComponentThread:(NSDictionary *)attributes;
- (void)_updateStylesOnMainThread:(NSDictionary *)styles resetStyles:(NSMutableArray *)resetStyles;
- (void)_updateAttributesOnMainThread:(NSDictionary *)attributes;

- (void)_addEventOnComponentThread:(NSString *)eventName;
- (void)_removeEventOnComponentThread:(NSString *)eventName;
- (void)_addEventOnMainThread:(NSString *)eventName;
- (void)_removeEventOnMainThread:(NSString *)eventName;

///--------------------------------------
/// @name Protected Methods
///--------------------------------------

- (BOOL)_needsDrawBorder;

- (void)_drawBorderWithContext:(CGContextRef)context size:(CGSize)size;

- (void)_frameDidCalculated:(BOOL)isChanged;

- (NSUInteger)_childrenCountForLayout;

- (void)_fillAbsolutePositions;

///--------------------------------------
/// @name Private Methods
///--------------------------------------

- (void)_initCSSNodeWithStyles:(NSDictionary *)styles;

- (void)_updateCSSNodeStyles:(NSDictionary *)styles;

- (void)_resetCSSNodeStyles:(NSArray *)styles;

- (void)_recomputeCSSNodeChildren;

- (void)_handleBorders:(NSDictionary *)styles isUpdating:(BOOL)updating;

- (void)_initViewPropertyWithStyles:(NSDictionary *)styles;

- (void)_updateViewStyles:(NSDictionary *)styles;

- (void)_resetStyles:(NSArray *)styles;

- (void)_initEvents:(NSArray *)events;

- (void)_initPseudoEvents:(BOOL)isListenPseudoTouch;

- (void)_removeAllEvents;

- (void)_setupNavBarWithStyles:(NSMutableDictionary *)styles attributes:(NSMutableDictionary *)attributes;

- (void)_updateNavBarAttributes:(NSDictionary *)attributes;

- (void)_handleFirstScreenTime;

- (void)_resetNativeBorderRadius;

- (void)_updatePseudoClassStyles:(NSString *)key;

- (void)_restoreViewStyles;
@end
