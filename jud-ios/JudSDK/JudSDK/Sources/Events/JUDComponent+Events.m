/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent+Events.h"
#import "JUDComponent.h"
#import "JUDComponent_internal.h"
#import "JUDSDKInstance.h"
#import "JUDComponentManager.h"
#import "JUDAssert.h"
#import "JUDUtility.h"
#import "JUDSDKManager.h"
#import "JUDSDKInstance_private.h"
#import <objc/runtime.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "JUDComponent+PseudoClassManagement.h"

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@interface UITouch (JUDTouchGestureRecognizer)

@property (nonatomic, strong) NSNumber *jud_identifier;

@end

@implementation UITouch (JUDTouchGestureRecognizer)

- (NSNumber *)jud_identifier
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setJud_identifier:(NSNumber *)jud_identifier
{
    objc_setAssociatedObject(self, @selector(jud_identifier), jud_identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface UIGestureRecognizer (JUDGesture)

@property (nonatomic, strong) NSNumber *jud_identifier;

@end

@implementation UIGestureRecognizer (JUDGesture)

- (NSNumber *)jud_identifier
{
    NSNumber *identifier = objc_getAssociatedObject(self, _cmd);
    if (!identifier) {
        static NSUInteger _gestureIdentifier;
        identifier = @(_gestureIdentifier++);
        self.jud_identifier = identifier;
    }
    
    return identifier;
}

- (void)setJud_identifier:(NSNumber *)jud_identifier
{
    objc_setAssociatedObject(self, @selector(jud_identifier), jud_identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface JUDTouchGestureRecognizer : UIGestureRecognizer

@property (nonatomic, assign) BOOL listenTouchStart;
@property (nonatomic, assign) BOOL listenTouchMove;
@property (nonatomic, assign) BOOL listenTouchEnd;
@property (nonatomic, assign) BOOL listenTouchCancel;
@property (nonatomic, assign) BOOL listenPseudoTouch;

- (instancetype)initWithComponent:(JUDComponent *)component NS_DESIGNATED_INITIALIZER;

@end

@implementation JUDComponent (Events)

#pragma mark Public

- (void)fireEvent:(NSString *)eventName params:(NSDictionary *)params
{
    [self fireEvent:eventName params:params domChanges:nil];
}

- (void)fireEvent:(NSString *)eventName params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSTimeInterval timeSp = [[NSDate date] timeIntervalSince1970] * 1000;
    [dict setObject:@(timeSp) forKey:@"timestamp"];
    if (params) {
        [dict addEntriesFromDictionary:params];
    }
    
    [[JUDSDKManager bridgeMgr] fireEvent:self.judInstance.instanceId ref:self.ref type:eventName params:dict domChanges:domChanges];
}

- (void)addEvent:(NSString *)addEventName
{
    JUDAssertMainThread();
}

- (void)removeEvent:(NSString *)removeEventName
{
    JUDAssertMainThread();
}

#pragma mark Add & Remove Event


#define JUD_ADD_EVENT(eventName, addSelector) \
if ([addEventName isEqualToString:@#eventName]) {\
    [self addSelector];\
}

#define JUD_REMOVE_EVENT(eventName, removeSelector) \
if ([removeEventName isEqualToString:@#eventName]) {\
    [self removeSelector];\
}

- (void)_initEvents:(NSArray *)events
{
    for (NSString *addEventName in events) {
        [self _addEventOnMainThread:addEventName];
    }
}

- (void)_initPseudoEvents:(BOOL)isListenPseudoTouch
{
    if(isListenPseudoTouch) {
        self.touchGesture.listenPseudoTouch = YES;
    }
}

- (void)_addEventOnMainThread:(NSString *)addEventName
{
    JUD_ADD_EVENT(appear, addAppearEvent)
    JUD_ADD_EVENT(disappear, addDisappearEvent)
    
    JUD_ADD_EVENT(click, addClickEvent)
    JUD_ADD_EVENT(swipe, addSwipeEvent)
    JUD_ADD_EVENT(longpress, addLongPressEvent)
    
    JUD_ADD_EVENT(panstart, addPanStartEvent)
    JUD_ADD_EVENT(panmove, addPanMoveEvent)
    JUD_ADD_EVENT(panend, addPanEndEvent)
    
    JUD_ADD_EVENT(horizontalpan, addHorizontalPanEvent)
    JUD_ADD_EVENT(verticalpan, addVerticalPanEvent)
    
    JUD_ADD_EVENT(touchstart, addTouchStartEvent)
    JUD_ADD_EVENT(touchmove, addTouchMoveEvent)
    JUD_ADD_EVENT(touchend, addTouchEndEvent)
    JUD_ADD_EVENT(touchcancel, addTouchCancelEvent)
    
    [self addEvent:addEventName];
}

- (void)_removeEventOnMainThread:(NSString *)removeEventName
{
    JUD_REMOVE_EVENT(appear, removeAppearEvent)
    JUD_REMOVE_EVENT(disappear, removeDisappearEvent)
    
    JUD_REMOVE_EVENT(click, removeClickEvent)
    JUD_REMOVE_EVENT(swipe, removeSwipeEvent)
    JUD_REMOVE_EVENT(longpress, removeLongPressEvent)
    
    JUD_REMOVE_EVENT(panstart, removePanStartEvent)
    JUD_REMOVE_EVENT(panmove, removePanMoveEvent)
    JUD_REMOVE_EVENT(panend, removePanEndEvent)
    
    JUD_REMOVE_EVENT(horizontalpan, removeHorizontalPanEvent)
    JUD_REMOVE_EVENT(verticalpan, removeVerticalPanEvent)
    
    JUD_REMOVE_EVENT(touchstart, removeTouchStartEvent)
    JUD_REMOVE_EVENT(touchmove, removeTouchMoveEvent)
    JUD_REMOVE_EVENT(touchend, removeTouchEndEvent)
    JUD_REMOVE_EVENT(touchcancel, removeTouchCancelEvent)
    
    if(_isListenPseudoTouch) {
        self.touchGesture.listenPseudoTouch = NO;
    }

    [self removeEvent:removeEventName];
}

- (void)_removeAllEvents
{
    [self removeClickEvent];
    [self removeLongPressEvent];
    [self removePanStartEvent];
    [self removePanMoveEvent];
    [self removePanEndEvent];
    [self removeHorizontalPanEvent];
    [self removeVerticalPanEvent];
    
    [self removeTouchStartEvent];
    [self removeTouchMoveEvent];
    [self removeTouchEndEvent];
    [self removeTouchCancelEvent];
    [self removeSwipeEvent];
    [self removePseudoTouchEvent];

}

#pragma mark - Appear & Disappear

- (void)addAppearEvent
{
    _appearEvent = YES;
    [self.ancestorScroller addScrollToListener:self];
}

- (void)addDisappearEvent
{
    _disappearEvent = YES;
    [self.ancestorScroller addScrollToListener:self];
}

- (void)removeAppearEvent
{
    _appearEvent = NO;
    [self.ancestorScroller removeScrollToListener:self];
}

- (void)removeDisappearEvent
{
    _disappearEvent = NO;
    [self.ancestorScroller removeScrollToListener:self];
}

- (void)removePseudoTouchEvent
{
    _touchGesture.listenPseudoTouch = NO;
    [self checkRemoveTouchGesture];
}

#pragma mark - Click Event

- (void)addClickEvent
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        _tapGesture.delegate = self;
        [self.view addGestureRecognizer:_tapGesture];
    }
}

- (void)removeClickEvent
{
    if (_tapGesture) {
        _tapGesture.delegate = nil;
        _tapGesture = nil;
    }
}

- (void)onClick:(__unused UITapGestureRecognizer *)recognizer
{
    NSMutableDictionary *position = [[NSMutableDictionary alloc] initWithCapacity:4];
    CGFloat scaleFactor = self.judInstance.pixelScaleFactor;
    if (![self isViewLoaded]) {
        return;
    }
    if (!CGRectEqualToRect(self.view.frame, CGRectZero)) {
        CGRect frame = [self.view.superview convertRect:self.view.frame toView:self.view.window];
        position[@"x"] = @(frame.origin.x/scaleFactor);
        position[@"y"] = @(frame.origin.y/scaleFactor);
        position[@"width"] = @(frame.size.width/scaleFactor);
        position[@"height"] = @(frame.size.height/scaleFactor);
    }

    [self fireEvent:@"click" params:@{@"position":position}];
}

#pragma mark - Swipe event

- (void)addSwipeEvent
{
    if (_swipeGestures) {
        return;
    }
    
    _swipeGestures = [NSMutableArray arrayWithCapacity:4];
    
    // It's a little weird because the UISwipeGestureRecognizer.direction property is an options-style bit mask, but each recognizer can only handle one direction
    SEL selector = @selector(onSwipe:);
    UISwipeGestureRecognizer *upSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:selector];
    upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    upSwipeRecognizer.delegate = self;
    [_swipeGestures addObject:upSwipeRecognizer];
    [self.view addGestureRecognizer:upSwipeRecognizer];
    
    UISwipeGestureRecognizer *downSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:selector];
    downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    downSwipeRecognizer.delegate = self;
    [_swipeGestures addObject:downSwipeRecognizer];
    [self.view addGestureRecognizer:downSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:selector];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipeRecognizer.delegate = self;
    [_swipeGestures addObject:rightSwipeRecognizer];
    [self.view addGestureRecognizer:rightSwipeRecognizer];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:selector];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipeRecognizer.delegate = self;
    [_swipeGestures addObject:leftSwipeRecognizer];
    [self.view addGestureRecognizer:leftSwipeRecognizer];
}

- (void)removeSwipeEvent
{
    if (_swipeGestures == nil) {
        return;
    }
  
    for (UISwipeGestureRecognizer *recognizer in _swipeGestures) {
        recognizer.delegate = nil;
    }
    
    _swipeGestures = nil;
}

- (void)onSwipe:(UISwipeGestureRecognizer *)gesture
{
    UISwipeGestureRecognizerDirection direction = gesture.direction;
    
    NSString *directionString;
    switch(direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            directionString = @"left";
            break;
        case UISwipeGestureRecognizerDirectionRight:
            directionString = @"right";
            break;
        case UISwipeGestureRecognizerDirectionUp:
            directionString = @"up";
            break;
        case UISwipeGestureRecognizerDirectionDown:
            directionString = @"down";
            break;
        default:
            directionString = @"unknown";
    }
    
    CGPoint screenLocation = [gesture locationInView:self.view.window];
    CGPoint pageLoacation = [gesture locationInView:self.judInstance.rootView];
    NSDictionary *resultTouch = [self touchResultWithScreenLocation:screenLocation pageLocation:pageLoacation identifier:gesture.jud_identifier];
    [self fireEvent:@"swipe" params:@{@"direction":directionString, @"changedTouches":resultTouch ? @[resultTouch] : @[]}];
}

#pragma mark - Long Press

- (void)addLongPressEvent
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        _longPressGesture.delegate = self;
        [self.view addGestureRecognizer:_longPressGesture];
    }
}

- (void)removeLongPressEvent
{
    if (_longPressGesture) {
        _longPressGesture.delegate = nil;
        _longPressGesture = nil;
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint screenLocation = [gesture locationInView:self.view.window];
        CGPoint pageLoacation = [gesture locationInView:self.judInstance.rootView];
        NSDictionary *resultTouch = [self touchResultWithScreenLocation:screenLocation pageLocation:pageLoacation identifier:gesture.jud_identifier];
        [self fireEvent:@"longpress" params:@{@"changedTouches":resultTouch ? @[resultTouch] : @[]}];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        gesture.jud_identifier = nil;
    }
}

#pragma mark - Pan

- (void)addPanGesture
{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        _panGesture.delegate = self;
        [self.view addGestureRecognizer:_panGesture];
    }
}

- (void)addPanStartEvent
{
    _listenPanStart = YES;
    [self addPanGesture];
}

- (void)addPanMoveEvent
{
    _listenPanMove = YES;
    [self addPanGesture];
}

- (void)addPanEndEvent
{
    _listenPanEnd = YES;
    [self addPanGesture];
}

- (void)addHorizontalPanEvent
{
    _listenHorizontalPan = YES;
    [self addPanGesture];
}

- (void)addVerticalPanEvent
{
    _listenVerticalPan = YES;
    [self addPanGesture];
}


- (void)onPan:(UIPanGestureRecognizer *)gesture
{
    CGPoint screenLocation = [gesture locationInView:self.view.window];
    CGPoint pageLoacation = [gesture locationInView:self.judInstance.rootView];
    NSString *eventName;
    NSString *state = @"";
    NSDictionary *resultTouch = [self touchResultWithScreenLocation:screenLocation pageLocation:pageLoacation identifier:gesture.jud_identifier];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_listenPanStart) {
            eventName = @"panstart";
        }
        state = @"start";
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (_listenPanEnd) {
            eventName = @"panend";
        }
        state = @"end";
        gesture.jud_identifier = nil;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (_listenPanMove) {
             eventName = @"panmove";
        }
        state = @"move";
    }
    
    
    CGPoint translation = [_panGesture translationInView:self.view];
    
    if (_listenHorizontalPan && fabs(translation.y) <= fabs(translation.x)) {
        [self fireEvent:@"horizontalpan" params:@{@"state":state, @"changedTouches":resultTouch ? @[resultTouch] : @[]}];
    }
        
    if (_listenVerticalPan && fabs(translation.y) > fabs(translation.x)) {
        [self fireEvent:@"verticalpan" params:@{@"state":state, @"changedTouches":resultTouch ? @[resultTouch] : @[]}];
    }
        
    if (eventName) {
        [self fireEvent:eventName params:@{@"changedTouches":resultTouch ? @[resultTouch] : @[]}];
    }
}

- (void)removePanStartEvent
{
    _listenPanStart = NO;
    [self checkRemovePanGesture];
}

- (void)removePanMoveEvent
{
    _listenPanMove = NO;
    [self checkRemovePanGesture];
}

- (void)removePanEndEvent
{
    _listenPanEnd = NO;
    [self checkRemovePanGesture];
}

- (void)removeHorizontalPanEvent
{
    _listenHorizontalPan = NO;
    [self checkRemovePanGesture];
}

- (void)removeVerticalPanEvent
{
    _listenVerticalPan = NO;
    [self checkRemovePanGesture];
}

- (void)checkRemovePanGesture
{
    if (_panGesture
        && !_listenPanStart && !_listenPanMove && !_listenPanEnd
        && !_listenHorizontalPan && !_listenVerticalPan
        ) {
        _panGesture.delegate = nil;
        _panGesture = nil;
    }
}

#pragma mark - Touch Event

- (JUDTouchGestureRecognizer *)touchGesture
{
    if (!_touchGesture) {
        _touchGesture = [[JUDTouchGestureRecognizer alloc] initWithComponent:self];
        _touchGesture.delegate = self;
        [self.view addGestureRecognizer:_touchGesture];
    }
    
    return _touchGesture;
}

- (void)addTouchStartEvent
{
    self.touchGesture.listenTouchStart = YES;
}

- (void)addTouchMoveEvent
{
    self.touchGesture.listenTouchMove = YES;
}

- (void)addTouchEndEvent
{
    self.touchGesture.listenTouchEnd = YES;
}

- (void)addTouchCancelEvent
{
    self.touchGesture.listenTouchCancel = YES;
}

- (void)removeTouchStartEvent
{
    _touchGesture.listenTouchStart = NO;
    [self checkRemoveTouchGesture];
}

- (void)removeTouchMoveEvent
{
    _touchGesture.listenTouchMove = NO;
    [self checkRemoveTouchGesture];
}

- (void)removeTouchEndEvent
{
    _touchGesture.listenTouchEnd = NO;
    [self checkRemoveTouchGesture];
}

- (void)removeTouchCancelEvent
{
    _touchGesture.listenTouchCancel = NO;
    [self checkRemoveTouchGesture];
}

- (void)checkRemoveTouchGesture
{
    if (_touchGesture && !_touchGesture.listenTouchStart && !_touchGesture.listenTouchMove && !_touchGesture.listenTouchEnd && !_touchGesture.listenTouchCancel && !_touchGesture.listenPseudoTouch) {
        _touchGesture.delegate = nil;
        _touchGesture = nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _panGesture) {
        CGPoint translation = [_panGesture translationInView:self.view];
        if (_listenHorizontalPan && !_listenVerticalPan && fabs(translation.y) > fabs(translation.x)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // trigger touches
    if ([gestureRecognizer isKindOfClass:[JUDTouchGestureRecognizer class]]) {
        return YES;
    }
    // swipe and scroll
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
        return YES;
    }
    // onclick and textviewInput
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass: NSClassFromString(@"UITextTapRecognizer")]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Utils

- (NSDictionary *)touchResultWithScreenLocation:(CGPoint)screenLocation pageLocation:(CGPoint)pageLocation identifier:(NSNumber *)identifier
{
    NSMutableDictionary *resultTouch = [[NSMutableDictionary alloc] initWithCapacity:5];
    CGFloat scaleFactor = self.judInstance.pixelScaleFactor;
    resultTouch[@"screenX"] = @(screenLocation.x/scaleFactor);
    resultTouch[@"screenY"] = @(screenLocation.y/scaleFactor);
    resultTouch[@"pageX"] = @(pageLocation.x/scaleFactor);
    resultTouch[@"pageY"] = @(pageLocation.y/scaleFactor);
    resultTouch[@"identifier"] = identifier;
    
    return resultTouch;
}

@end

@implementation JUDTouchGestureRecognizer
{
    __weak JUDComponent *_component;
    NSUInteger _touchIdentifier;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    return [self initWithComponent:nil];;
}

- (instancetype)initWithComponent:(JUDComponent *)component
{
    if (self = [super initWithTarget:self action:@selector(touchResponse:)]) {
        _component = component;
        
        _listenTouchStart = NO;
        _listenTouchEnd = NO;
        _listenTouchMove = NO;
        _listenTouchCancel = NO;
        
        self.cancelsTouchesInView = NO;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (_listenTouchStart) {
        [self fireTouchEvent:@"touchstart" withTouches:touches];
    }
    if(_listenPseudoTouch) {
        NSMutableDictionary *styles = [_component getPseudoClassStyles:@"active"];
        [_component updatePseudoClassStyles:styles];
    }

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (_listenTouchMove) {
        [self fireTouchEvent:@"touchmove" withTouches:touches];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    
    if (_listenTouchEnd) {
        [self fireTouchEvent:@"touchend" withTouches:touches];
    }
    if(_listenPseudoTouch) {
        [self recoveryPseudoStyles:_component.styles];
    }

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (_listenTouchCancel) {
        [self fireTouchEvent:@"touchcancel" withTouches:touches];
    }
    if(_listenPseudoTouch) {
        [self recoveryPseudoStyles:_component.styles];
    }
}

- (void)fireTouchEvent:(NSString *)eventName withTouches:(NSSet<UITouch *> *)touches
{
    NSMutableArray *resultTouches = [NSMutableArray new];
    
    for (UITouch *touch in touches) {
        CGPoint screenLocation = [touch locationInView:touch.window];
        CGPoint pageLocation = [touch locationInView:_component.judInstance.rootView];
        if (!touch.jud_identifier) {
            touch.jud_identifier = @(_touchIdentifier++);
        }
        NSDictionary *resultTouch = [_component touchResultWithScreenLocation:screenLocation pageLocation:pageLocation identifier:touch.jud_identifier];
        [resultTouches addObject:resultTouch];
    }
    
    [_component fireEvent:eventName params:@{@"changedTouches":resultTouches ?: @[]}];
}

- (void)recoveryPseudoStyles:(NSDictionary *)styles
{
    [_component recoveryPseudoStyles:styles];
}

- (void)touchResponse:(UIGestureRecognizer *)gesture
{
    
}

@end
