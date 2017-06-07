/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDSliderComponent.h"
#import "JUDIndicatorComponent.h"
#import "JUDComponent_internal.h"
#import "NSTimer+Jud.h"
#import "JUDSDKManager.h"
#import "JUDUtility.h"

@class JUDSliderView;
@class JUDIndicatorView;

@protocol JUDSliderViewDelegate <UIScrollViewDelegate>

- (void)sliderView:(JUDSliderView *)sliderView sliderViewDidScroll:(UIScrollView *)scrollView;
- (void)sliderView:(JUDSliderView *)sliderView didScrollToItemAtIndex:(NSInteger)index;
- (void)sliderView:(JUDSliderView *)sliderView scrollViewDidStartScroll:(UIScrollView *)scrollView;
- (void)sliderView:(JUDSliderView *)sliderView scrollViewDidStopScroll:(UIScrollView *)scrollView;

@end

@interface JUDSliderView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) JUDIndicatorView *indicator;
@property (nonatomic, weak) id<JUDSliderViewDelegate> delegate;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isStartScroll;

- (UIScrollView *)scrollView;
- (void)insertItemView:(UIView *)view atIndex:(NSInteger)index;
- (void)removeItemView:(UIView *)view;
- (void)scroll2ItemView:(NSInteger)index animated:(BOOL)animated;
- (void)loadData;

@end

@implementation JUDSliderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *tempBackGround = [[UIView alloc] init];
        tempBackGround.backgroundColor = [UIColor clearColor];
        [self addSubview:tempBackGround];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        
        _itemViews = [NSMutableArray array];
        _currentIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    if (_scrollView) {
        _scrollView.delegate = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)setIndicator:(JUDIndicatorView *)indicator
{
    _indicator = indicator;
    [_indicator setPointCount:self.itemViews.count];
    [_indicator setCurrentPoint:_currentIndex];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex == currentIndex) return;
    
    _currentIndex = currentIndex;
    [self.indicator setCurrentPoint:_currentIndex];
    
    [self _configSubViews];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:didScrollToItemAtIndex:)]) {
        [self.delegate sliderView:self didScrollToItemAtIndex:_currentIndex];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.itemViews.count * self.frame.size.width, self.frame.size.height);
}

#pragma mark Public Methods

- (void)insertItemView:(UIView *)view atIndex:(NSInteger)index
{
    if (![self.itemViews containsObject:view]) {
        view.tag = self.itemViews.count;
        if (index < 0) {
            [self.itemViews addObject:view];
        } else {
            [self.itemViews insertObject:view atIndex:index];
        }
    }
    
    if (![self.scrollView.subviews containsObject:view]) {
        if (index < 0) {
            [self.scrollView addSubview:view];
        } else {
            [self.scrollView insertSubview:view atIndex:index];
        }
    }
    
    [self.indicator setPointCount:self.itemViews.count];
    [self setNeedsLayout];
}

- (void)removeItemView:(UIView *)view
{
    if ([self.itemViews containsObject:view]) {
        [self.itemViews removeObject:view];
    }
    
    if ([self.scrollView.subviews containsObject:view]) {
        [view removeFromSuperview];
    }
    
    [self.indicator setPointCount:self.itemViews.count];
    [self setNeedsLayout];
}

- (void)scroll2ItemView:(NSInteger)index animated:(BOOL)animated
{
    UIView *itemView = nil;
    for (itemView in self.itemViews) {
        if (itemView.tag == index) {
            break;
        }
    }
    
    if (itemView) {
        [self.scrollView setContentOffset:itemView.frame.origin animated:YES];
    }
}

- (void)loadData
{
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.itemViews.count * self.frame.size.width, self.frame.size.height);
    
    [self _configSubViews];
}

#pragma mark Private Methods

- (void)_configSubViews {
    [self _resortItemViews];
    [self _resetItemFrames];
    [self _scroll2Center];
    [self _resetItemCountLessThanOrEqualToTwo];
    [self setNeedsLayout];
}

- (void)_resortItemViews
{
    if (self.itemViews.count <= 2) return;
    
    NSInteger center = [self _centerItemIndex];
    NSInteger index = 0;
    
    if (self.currentIndex >= 0) {
        [self _validateCurrentIndex];
        if (self.currentIndex > center) {
            index = self.currentIndex - center;
        } else {
            index = self.currentIndex + self.itemViews.count - center;
        }
    }
    else {
        index = self.itemViews.count - center;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.itemViews sortUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        NSInteger tag1 = obj1.tag >= index ? obj1.tag - index : obj1.tag + weakSelf.itemViews.count - index;
        NSInteger tag2 = obj2.tag >= index ? obj2.tag - index : obj2.tag + weakSelf.itemViews.count - index;
        
        if (tag1 > tag2) {
            return 1;
        } else if (tag1 < tag2) {
            return -1;
        } else {
            return 0;
        }
    }];
}

- (void)_resetItemFrames
{
    CGFloat xOffset = 0; CGRect frame = CGRectZero;
    for(UIView *itemView in self.itemViews) {
        frame = itemView.frame;
        frame.origin.x = xOffset;
        frame.size.width = self.frame.size.width;
        itemView.frame = frame;
        xOffset += frame.size.width;
    }
}

- (NSInteger)_centerItemIndex
{
    if (self.itemViews.count > 2) {
        return self.itemViews.count % 2 ? self.itemViews.count / 2 : self.itemViews.count / 2 - 1;
    }
    return 0;
}

- (void)_scroll2Center
{
    if (self.itemViews.count > 2) {
        UIView *itemView = [self.itemViews objectAtIndex:[self _centerItemIndex]];
        [self.scrollView scrollRectToVisible:itemView.frame animated:NO];
    }
}

- (void)_resetItemCountLessThanOrEqualToTwo {
    if (self.itemViews.count > 0 && self.itemViews.count <= 2) {
        [self _validateCurrentIndex];
        for (UIView *itemView in self.itemViews) {
            if (itemView.tag == _currentIndex) {
                [self.scrollView scrollRectToVisible:itemView.frame animated:NO];
                break;
            }
        }
    }
}

- (BOOL)_validateCurrentIndex {
    if (_currentIndex > 0 && _currentIndex < self.itemViews.count) {
        return YES;
    }
    _currentIndex = 0;
    return NO;
}

- (BOOL)_isItemViewVisiable:(UIView *)itemView
{
    CGRect itemFrame = itemView.frame;
    
    CGFloat vx = self.scrollView.contentInset.left + self.scrollView.contentOffset.x;
    CGFloat vy = self.scrollView.contentInset.top + self.scrollView.contentOffset.y;
    CGFloat vw = self.scrollView.frame.size.width - self.scrollView.contentInset.left - self.scrollView.contentInset.right;
    CGFloat vh = self.scrollView.frame.size.height - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom;
    CGRect visiableRect = CGRectMake(vx - 2, vy, vw + 4, vh);
    
    CGRect intersection = CGRectIntersection(visiableRect, itemFrame);
    if (intersection.size.width > visiableRect.size.width - 10) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *itemView = nil;
    for (itemView in self.itemViews) {
        if ([self _isItemViewVisiable:itemView]) {
            break;
        }
    }
    if (itemView) {
        self.currentIndex = itemView.tag;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:sliderViewDidScroll:)]) {
        [self.delegate sliderView:self sliderViewDidScroll:self.scrollView];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:self.scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging: willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:self.scrollView willDecelerate:decelerate];
    }
}

// called when setContentOffset/scrollRectVisible:animated: finishes. called from the performselector in scrollViewDidScroll if not animating.
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sliderView:scrollViewDidStopScroll:)]) {
        [self.delegate sliderView:self scrollViewDidStopScroll:scrollView];
    }
}


@end

@interface JUDSliderComponent ()<JUDSliderViewDelegate>

@property (nonatomic, strong) JUDSliderView *sliderView;
@property (nonatomic, strong) NSTimer *autoTimer;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL  autoPlay;
@property (nonatomic, assign) NSUInteger interval;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat lastOffsetXRatio;
@property (nonatomic, assign) CGFloat offsetXAccuracy;
@property (nonatomic, assign) BOOL  sliderChangeEvent;
@property (nonatomic, assign) BOOL  sliderScrollEvent;
@property (nonatomic, assign) BOOL  sliderScrollStartEvent;
@property (nonatomic, assign) BOOL  sliderScrollStopEvent;
@property (nonatomic, assign) BOOL  sliderScrollCancelEvent;
@property (nonatomic, assign) BOOL  sliderStartEventFired;
@property (nonatomic, strong) NSMutableArray *childrenView;
@property (nonatomic, assign) BOOL scrollable;

@end

@implementation JUDSliderComponent

- (void) dealloc
{
    [self _stopAutoPlayTimer];
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance]) {
        _sliderChangeEvent = NO;
        _sliderScrollEvent = NO;
        _interval = 3000;
        _childrenView = [NSMutableArray new];
        _lastOffsetXRatio = 0;
        
        if (attributes[@"autoPlay"]) {
            _autoPlay = [attributes[@"autoPlay"] boolValue];
        }
        
        if (attributes[@"interval"]) {
            _interval = [attributes[@"interval"] integerValue];
        }
        
        if (attributes[@"index"]) {
            _index = [attributes[@"index"] integerValue];
        }
        
        _scrollable = attributes[@"scrollable"] ? [JUDConvert BOOL:attributes[@"scrollable"]] : YES;

        if (attributes[@"offsetXAccuracy"]) {
            _offsetXAccuracy = [JUDConvert CGFloat:attributes[@"offsetXAccuracy"]];
        }
        
        self.cssNode->style.flex_direction = CSS_FLEX_DIRECTION_ROW;
    }
    return self;
}

- (UIView *)loadView
{
    return [[JUDSliderView alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sliderView = (JUDSliderView *)self.view;
    _sliderView.delegate = self;
    _sliderView.scrollView.pagingEnabled = YES;
    _sliderView.exclusiveTouch = YES;
    _sliderView.scrollView.scrollEnabled = _scrollable;
    
    if (_autoPlay) {
        [self _startAutoPlayTimer];
    } else {
        [self _stopAutoPlayTimer];
    }
}

- (void)layoutDidFinish
{
    _sliderView.currentIndex = _index;
}

- (void)viewDidUnload
{
    [_childrenView removeAllObjects];
}

- (void)insertSubview:(JUDComponent *)subcomponent atIndex:(NSInteger)index
{
    if (subcomponent->_positionType == JUDPositionTypeFixed) {
        [self.judInstance.rootView addSubview:subcomponent.view];
        return;
    }
    
    // use _lazyCreateView to forbid component like cell's view creating
    if(_lazyCreateView) {
        subcomponent->_lazyCreateView = YES;
    }
    
    if (!subcomponent->_lazyCreateView || (self->_lazyCreateView && [self isViewLoaded])) {
        UIView *view = subcomponent.view;
        
        if(index < 0) {
            [self.childrenView addObject:view];
        }
        else {
            [self.childrenView insertObject:view atIndex:index];
        }
        
        JUDSliderView *sliderView = (JUDSliderView *)self.view;
        if ([view isKindOfClass:[JUDIndicatorView class]]) {
            [sliderView addSubview:view];
            return;
        }
        
        subcomponent.isViewFrameSyncWithCalculated = NO;
        
        if (index == -1) {
            [sliderView insertItemView:view atIndex:index];
        } else {
            NSInteger offset = 0;
            for (int i = 0; i < [self.childrenView count]; ++i) {
                if (index == i) break;
                
                if ([self.childrenView[i] isKindOfClass:[JUDIndicatorView class]]) {
                    offset++;
                }
            }
            [sliderView insertItemView:view atIndex:index - offset];
        }
        
        [sliderView loadData];
    }
}

- (void)willRemoveSubview:(JUDComponent *)component
{
    UIView *view = component.view;
    
    if(self.childrenView && [self.childrenView containsObject:view]) {
        [self.childrenView removeObject:view];
    }
    
    JUDSliderView *sliderView = (JUDSliderView *)_view;
    [sliderView removeItemView:view];
    [sliderView setCurrentIndex:0];
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"autoPlay"]) {
        _autoPlay = [attributes[@"autoPlay"] boolValue];
        if (_autoPlay) {
            [self _startAutoPlayTimer];
        } else {
            [self _stopAutoPlayTimer];
        }
    }
    
    if (attributes[@"interval"]) {
        _interval = [attributes[@"interval"] integerValue];
        
        [self _stopAutoPlayTimer];
        
        if (_autoPlay) {
            [self _startAutoPlayTimer];
        } 
    }
    
    if (attributes[@"index"]) {
        _index = [attributes[@"index"] integerValue];
        
        self.currentIndex = _index;
        [_sliderView scroll2ItemView:self.currentIndex animated:YES];
    }
    
    if (attributes[@"scrollable"]) {
        _scrollable = attributes[@"scrollable"] ? [JUDConvert BOOL:attributes[@"scrollable"]] : YES;
        ((JUDSliderView *)self.view).scrollView.scrollEnabled = _scrollable;
    }
    
    if (attributes[@"offsetXAccuracy"]) {
        _offsetXAccuracy = [JUDConvert CGFloat:attributes[@"offsetXAccuracy"]];
    }
}

- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"change"]) {
        _sliderChangeEvent = YES;
    }
    if ([eventName isEqualToString:@"scroll"]) {
        _sliderScrollEvent = YES;
    }
    if ([eventName isEqualToString:@"scrollstart"]) {
        _sliderScrollStartEvent = YES;
    }
    if ([eventName isEqualToString:@"scrollstop"]) {
        _sliderScrollStopEvent = YES;
    }
    if ([eventName isEqualToString:@"dragcancel"]) {
        _sliderScrollCancelEvent = YES;
    }
}

- (void)removeEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"change"]) {
        _sliderChangeEvent = NO;
    }
    if ([eventName isEqualToString:@"scroll"]) {
        _sliderScrollEvent = NO;
    }
    if ([eventName isEqualToString:@"scrollstart"]) {
        _sliderScrollStartEvent = NO;
    }
    if ([eventName isEqualToString:@"scrollstop"]) {
        _sliderScrollStopEvent = NO;
    }
    if ([eventName isEqualToString:@"dragcancel"]) {
        _sliderScrollCancelEvent = NO;
    }
}

#pragma mark Public Methods

-(void)setIndicatorView:(JUDIndicatorView *)indicatorView
{
    NSAssert(_sliderView, @"");
    [_sliderView setIndicator:indicatorView];
}

#pragma mark Private Methods

- (void)_startAutoPlayTimer
{
    if (!self.autoTimer || ![self.autoTimer isValid]) {
        __weak __typeof__(self) weakSelf = self;
        self.autoTimer = [NSTimer jud_scheduledTimerWithTimeInterval:_interval/1000.0f block:^() {
            [weakSelf _autoPlayOnTimer];
        } repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.autoTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)_stopAutoPlayTimer
{
    if (self.autoTimer && [self.autoTimer isValid]) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
    }
}

- (void)_autoPlayOnTimer
{
    JUDSliderView *sliderView = (JUDSliderView *)self.view;

    int indicatorCnt = 0;
    for (int i = 0; i < [self.childrenView count]; ++i) {
        if ([self.childrenView[i] isKindOfClass:[JUDIndicatorView class]]) {
            indicatorCnt++;
        }
    }
    
    self.currentIndex ++;
    if (self.currentIndex < self.childrenView.count - indicatorCnt) {
        [sliderView scroll2ItemView:self.currentIndex animated:YES];
    } else {
        self.currentIndex = 0;
        [sliderView scroll2ItemView:self.currentIndex animated:YES];
    }
}

#pragma mark ScrollView Delegate

- (void)sliderView:(JUDSliderView *)sliderView sliderViewDidScroll:(UIScrollView *)scrollView
{
    if (_sliderScrollEvent) {
        CGFloat width = scrollView.frame.size.width;
        CGFloat XDeviation = scrollView.frame.origin.x - (scrollView.contentOffset.x - width);
        CGFloat offsetXRatio = (XDeviation / width);
        if (fabs(offsetXRatio - _lastOffsetXRatio) >= _offsetXAccuracy) {
            _lastOffsetXRatio = offsetXRatio;
            [self fireEvent:@"scroll" params:@{@"offsetXRatio":[NSNumber numberWithFloat:offsetXRatio]} domChanges:nil];
        }
    }
    if (!_sliderStartEventFired) {
        [self sliderView:sliderView scrollViewDidStartScroll:scrollView];
    }
}

- (void)sliderView:(JUDSliderView *)sliderView didScrollToItemAtIndex:(NSInteger)index
{
    self.currentIndex = index;
    if (_sliderChangeEvent) {
        [self fireEvent:@"change" params:@{@"index":@(index)} domChanges:@{@"attrs": @{@"index": @(index)}}];
    }
}

- (void)sliderView:(JUDSliderView *)sliderView scrollViewDidStartScroll:(UIScrollView *)scrollView
{
    if (_sliderScrollStartEvent) {
        [self fireEvent:@"scrollstart" params:nil domChanges:nil];
    }
    _sliderStartEventFired = YES;
}

- (void)sliderView:(JUDSliderView *)sliderView scrollViewDidStopScroll:(UIScrollView *)scrollView
{
    if (_sliderScrollStopEvent) {
        [self fireEvent:@"scrollstop" params:nil domChanges:nil];
    }
    _sliderStartEventFired = NO;
}

- (void)sliderView:(JUDSliderView *)sliderView scrollViewDidCancelDraging:(UIScrollView *)scrollView
{
    if (_sliderScrollCancelEvent) {
        [self fireEvent:@"dragcancel" params:nil domChanges:nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self _stopAutoPlayTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_autoPlay) {
        [self _startAutoPlayTimer];
    }
    //DidEndDragging and index is not changed mean that cancel dragging
    CGFloat width = scrollView.frame.size.width;
    CGFloat XDeviation = scrollView.frame.origin.x - (scrollView.contentOffset.x - width);
    CGFloat offsetXRatio = (XDeviation / width);
    if (fabs(offsetXRatio) < 0.5) {
        [self sliderView:self.sliderView scrollViewDidCancelDraging:self.sliderView.scrollView];
    }
}

@end
