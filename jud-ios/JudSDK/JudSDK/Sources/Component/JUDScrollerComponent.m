/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDScrollerComponent.h"
#import "JUDComponent_internal.h"
#import "JUDComponent.h"
#import "JUDDefine.h"
#import "JUDConvert.h"
#import "JUDSDKInstance.h"
#import "JUDUtility.h"
#import "JUDLoadingComponent.h"
#import "JUDRefreshComponent.h"

@interface JUDScrollToTarget : NSObject

@property (nonatomic, weak)   JUDComponent *target;
@property (nonatomic, assign) BOOL hasAppear;

@end

@implementation JUDScrollToTarget

@end


@interface JUDScrollerComponent()

@property (nonatomic, strong) NSMutableArray *  stickyArray;
@property (nonatomic, strong) NSMutableArray *  listenerArray;
@property (nonatomic, weak) JUDRefreshComponent *refreshComponent;
@property (nonatomic, weak) JUDLoadingComponent *loadingComponent;

@end

@implementation JUDScrollerComponent
{
    CGSize _contentSize;
    BOOL _listenLoadMore;
    BOOL _scrollEvent;
    CGFloat _loadMoreOffset;
    CGFloat _previousLoadMoreContentHeight;
    CGFloat _offsetAccuracy;
    CGPoint _lastContentOffset;
    CGPoint _lastScrollEventFiredOffset;
    BOOL _scrollable;

    // vertical & horizontal
    JUDScrollDirection _scrollDirection;
    // left & right & up & down
    NSString *_direction;
    BOOL _showScrollBar;

    css_node_t *_scrollerCSSNode;
}

JUD_EXPORT_METHOD(@selector(resetLoadmore))

- (void)resetLoadmore
{
    _previousLoadMoreContentHeight=0;
}

- (css_node_t *)scrollerCSSNode
{
    return _scrollerCSSNode;
}

- (void)_insertSubcomponent:(JUDComponent *)subcomponent atIndex:(NSInteger)index
{
    [super _insertSubcomponent:subcomponent atIndex:index];
    
    if ([subcomponent isKindOfClass:[JUDRefreshComponent class]]) {
        _refreshComponent = (JUDRefreshComponent*)subcomponent;
    }
    else if ([subcomponent isKindOfClass:[JUDLoadingComponent class]]) {
        _loadingComponent = (JUDLoadingComponent*)subcomponent;
    }
}

-(instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
        
        _stickyArray = [NSMutableArray array];
        _listenerArray = [NSMutableArray array];
        _scrollEvent = NO;
        _lastScrollEventFiredOffset = CGPointMake(0, 0);
        _scrollDirection = attributes[@"scrollDirection"] ? [JUDConvert JUDScrollDirection:attributes[@"scrollDirection"]] : JUDScrollDirectionVertical;
        _showScrollBar = attributes[@"showScrollbar"] ? [JUDConvert BOOL:attributes[@"showScrollbar"]] : YES;
        _loadMoreOffset = attributes[@"loadmoreoffset"] ? [JUDConvert JUDPixelType:attributes[@"loadmoreoffset"] scaleFactor:self.judInstance.pixelScaleFactor] : 0;
        _loadmoreretry = attributes[@"loadmoreretry"] ? [JUDConvert NSUInteger:attributes[@"loadmoreretry"]] : 0;
        _listenLoadMore = [events containsObject:@"loadmore"];
        _scrollable = attributes[@"scrollable"] ? [JUDConvert BOOL:attributes[@"scrollable"]] : YES;
        _offsetAccuracy = attributes[@"offsetAccuracy"] ? [JUDConvert JUDPixelType:attributes[@"offsetAccuracy"] scaleFactor:self.judInstance.pixelScaleFactor] : 0;
        _scrollerCSSNode = new_css_node();
        
        // let scroller fill the rest space if it is a child component and has no fixed height & width
        if (((_scrollDirection == JUDScrollDirectionVertical &&
            isUndefined(self.cssNode->style.dimensions[CSS_HEIGHT])) ||
            (_scrollDirection == JUDScrollDirectionHorizontal &&
              isUndefined(self.cssNode->style.dimensions[CSS_WIDTH]))) &&
             self.cssNode->style.flex <= 0.0) {
            self.cssNode->style.flex = 1.0;
        }
    }
    
    return self;
}

- (UIView *)loadView
{
    return [[UIScrollView alloc] init];
}

- (void)viewDidLoad
{
    [self setContentSize:_contentSize];
    UIScrollView* scrollView = (UIScrollView *)self.view;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.exclusiveTouch = YES;
    scrollView.autoresizesSubviews = NO;
    scrollView.clipsToBounds = YES;
    scrollView.showsVerticalScrollIndicator = _showScrollBar;
    scrollView.showsHorizontalScrollIndicator = _showScrollBar;
    scrollView.scrollEnabled = _scrollable;
    
    if (self.ancestorScroller) {
        scrollView.scrollsToTop = NO;
    } else {
        scrollView.scrollsToTop = YES;
    }
}

- (void)layoutDidFinish
{
    if ([self isViewLoaded]) {
        [self setContentSize:_contentSize];
        [self adjustSticky];
        [self handleAppear];
    }
    
    [_loadingComponent resizeFrame];
}

- (void)viewWillUnload
{
    ((UIScrollView *)_view).delegate = nil;
}

- (void)dealloc
{
    [self.stickyArray removeAllObjects];
    [self.listenerArray removeAllObjects];
    
    free(_scrollerCSSNode);
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"showScrollbar"]) {
        _showScrollBar = [JUDConvert BOOL:attributes[@"showScrollbar"]];
        ((UIScrollView *)self.view).showsHorizontalScrollIndicator = _showScrollBar;
        ((UIScrollView *)self.view).showsVerticalScrollIndicator = _showScrollBar;
    }
    
    if (attributes[@"loadmoreoffset"]) {
        _loadMoreOffset = [JUDConvert JUDPixelType:attributes[@"loadmoreoffset"] scaleFactor:self.judInstance.pixelScaleFactor];
    }
    
    if (attributes[@"loadmoreretry"]) {
        NSUInteger loadmoreretry = [JUDConvert NSUInteger:attributes[@"loadmoreretry"]];
        if (loadmoreretry != _loadmoreretry) {
            _previousLoadMoreContentHeight = 0;
        }
        self.loadmoreretry = loadmoreretry;
    }
    if (attributes[@"scrollable"]) {
        _scrollable = attributes[@"scrollable"] ? [JUDConvert BOOL:attributes[@"scrollable"]] : YES;
        ((UIScrollView *)self.view).scrollEnabled = _scrollable;
    }
    if (attributes[@"offsetAccuracy"]) {
        _offsetAccuracy = [JUDConvert JUDPixelType:attributes[@"offsetAccuracy"] scaleFactor:self.judInstance.pixelScaleFactor];
    }
}

- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"loadmore"]) {
        _listenLoadMore = YES;
    }
    if ([eventName isEqualToString:@"scroll"]) {
        _scrollEvent = YES;
    }
}

- (void)removeEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"loadmore"]) {
        _listenLoadMore = NO;
    }
    if ([eventName isEqualToString:@"scroll"]) {
        _scrollEvent = NO;
    }
}

#pragma mark JUDScrollerProtocol

- (void)addStickyComponent:(JUDComponent *)sticky
{
    if(![self.stickyArray containsObject:sticky]) {
        [self.stickyArray addObject:sticky];
        [self adjustSticky];
    }
}

- (void)removeStickyComponent:(JUDComponent *)sticky
{
    if([self.stickyArray containsObject:sticky]) {
        [self.stickyArray removeObject:sticky];
        [self adjustSticky];
    }
}

- (void)adjustSticky
{
    if (![self isViewLoaded]) {
        return;
    }
    CGFloat scrollOffsetY = ((UIScrollView *)self.view).contentOffset.y;
    for(JUDComponent *component in self.stickyArray) {
        if (isnan(component->_absolutePosition.x) && isnan(component->_absolutePosition.y)) {
            component->_absolutePosition = [component.supercomponent.view convertPoint:component.view.frame.origin toView:self.view];
        }
        CGPoint relativePosition = component->_absolutePosition;
        if (isnan(relativePosition.y)) {
            continue;
        }
        
        JUDComponent *supercomponent = component.supercomponent;
        if(supercomponent != self && component.view.superview != self.view) {
            [component.view removeFromSuperview];
            [self.view addSubview:component.view];
        } else {
            [self.view bringSubviewToFront:component.view];
        }
        
        CGFloat relativeY = relativePosition.y;
        BOOL needSticky = NO;
        
        if (scrollOffsetY >= relativeY) {
            needSticky = YES;
        } else {
            // important: reset views' frame
            component.view.frame = CGRectMake(relativePosition.x, relativePosition.y, component.calculatedFrame.size.width, component.calculatedFrame.size.height);
        }
        
        if (!needSticky) {
            continue;
        }
        
        // The minimum Y sticky view can reach is its original position
        CGFloat minY = relativeY;
        CGPoint superRelativePosition = supercomponent == self ? CGPointZero : [supercomponent.supercomponent.view convertPoint:supercomponent.view.frame.origin toView:self.view];
        CGFloat maxY = superRelativePosition.y + supercomponent.calculatedFrame.size.height - component.calculatedFrame.size.height;
        
        CGFloat stickyY = scrollOffsetY;
        if (stickyY < minY) {
            stickyY = minY;
        } else if (stickyY > maxY && ![supercomponent conformsToProtocol:@protocol(JUDScrollerProtocol)]) {
            // Sticky component can not go beyond its parent's bounds when its parent is not scroller;
            stickyY = maxY;
        }
        
        UIView *stickyView = component.view;
        CGPoint origin = stickyView.frame.origin;
        origin.y = stickyY;
        stickyView.frame = (CGRect){origin,stickyView.frame.size};
    }
}

- (void)addScrollToListener:(JUDComponent *)target
{
    BOOL has = NO;
    for (JUDScrollToTarget *targetData in self.listenerArray) {
        if (targetData.target == target) {
            has = YES;
            break;
        }
    }
    if (!has) {
        JUDScrollToTarget *scrollTarget = [[JUDScrollToTarget alloc] init];
        scrollTarget.target = target;
        scrollTarget.hasAppear = NO;
        [self.listenerArray addObject:scrollTarget];
    }
}

- (void)removeScrollToListener:(JUDComponent *)target
{
    JUDScrollToTarget *targetData = nil;
    for (JUDScrollToTarget *targetData in self.listenerArray) {
        if (targetData.target == target) {
            break;
        }
    }
    if(targetData) {
        [self.listenerArray removeObject:targetData];
    }
}

- (void)scrollToComponent:(JUDComponent *)component withOffset:(CGFloat)offset animated:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGPoint contentOffset = scrollView.contentOffset;
    CGFloat scaleFactor = self.judInstance.pixelScaleFactor;
    
    if (_scrollDirection == JUDScrollDirectionHorizontal) {
        CGFloat contentOffetX = [component.supercomponent.view convertPoint:component.view.frame.origin toView:self.view].x;
        contentOffetX += offset * scaleFactor;
        
        if (contentOffetX > scrollView.contentSize.width - scrollView.frame.size.width) {
            contentOffset.x = scrollView.contentSize.width - scrollView.frame.size.width;
        } else {
            contentOffset.x = contentOffetX;
        }
    } else {
        CGFloat contentOffetY = [component.supercomponent.view convertPoint:component.view.frame.origin toView:self.view].y;
        contentOffetY += offset * scaleFactor;
        
        if (contentOffetY > scrollView.contentSize.height - scrollView.frame.size.height) {
            contentOffset.y = scrollView.contentSize.height - scrollView.frame.size.height;
        } else {
            contentOffset.y = contentOffetY;
        }
    }
    
    [scrollView setContentOffset:contentOffset animated:animated];
}

- (BOOL)isNeedLoadMore
{
    if (_loadMoreOffset >= 0.0 && ((UIScrollView *)self.view).contentOffset.y >= 0) {
        return _previousLoadMoreContentHeight != ((UIScrollView *)self.view).contentSize.height && ((UIScrollView *)self.view).contentSize.height - ((UIScrollView *)self.view).contentOffset.y -  self.view.frame.size.height <= _loadMoreOffset;
    }
    
    return NO;
}

- (void)loadMore
{
    [self fireEvent:@"loadmore" params:nil];
    _previousLoadMoreContentHeight = ((UIScrollView *)self.view).contentSize.height;
}

- (CGPoint)contentOffset
{
    CGPoint rtv = CGPointZero;
    UIScrollView *scrollView = (UIScrollView *)self.view;
    if (scrollView) {
        rtv = scrollView.contentOffset;
    }
    return rtv;
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentOffset:contentOffset animated:animated];
}

- (CGSize)contentSize
{
    return ((UIScrollView *)self.view).contentSize;
}

- (void)setContentSize:(CGSize)size
{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = size;
}

- (UIEdgeInsets)contentInset
{
    UIEdgeInsets rtv = UIEdgeInsetsZero;
    UIScrollView *scrollView = (UIScrollView *)self.view;
    if (scrollView) {
        rtv = scrollView.contentInset;
    }
    return rtv;
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView setContentInset:contentInset];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //apply block which are registered
    JUDSDKInstance *instance = self.judInstance;
    if ([self.ref isEqualToString:JUD_SDK_ROOT_REF] &&
        [self isKindOfClass:[JUDScrollerComponent class]]) {
        if (instance.onScroll) {
            instance.onScroll(scrollView.contentOffset);
        }
    }
    
    if (_lastContentOffset.x > scrollView.contentOffset.x) {
        _direction = @"right";
    } else if (_lastContentOffset.x < scrollView.contentOffset.x) {
        _direction = @"left";
    } else if(_lastContentOffset.y > scrollView.contentOffset.y) {
        _direction = @"down";
    } else if(_lastContentOffset.y < scrollView.contentOffset.y) {
        _direction = @"up";
    }
    if (scrollView.dragging) {
        [_refreshComponent pullingdown:@{
            DISTANCE_Y: @(fabs(scrollView.contentOffset.y - _lastContentOffset.y)),
            PULLING_DISTANCE: @(scrollView.contentOffset.y),
            @"type":@"pullingdown"
            }];
    }
    _lastContentOffset = scrollView.contentOffset;

    // check sticky
    [self adjustSticky];
    [self handleLoadMore];
    [self handleAppear];
    
    if (self.onScroll) {
        self.onScroll(scrollView);
    }
    if (_scrollEvent) {
        CGFloat scaleFactor = self.judInstance.pixelScaleFactor;
        NSDictionary *contentSizeData = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:scrollView.contentSize.width / scaleFactor],@"width",[NSNumber numberWithFloat:scrollView.contentSize.height / scaleFactor],@"height", nil];
        //contentOffset values are replaced by (-contentOffset.x,-contentOffset.y) ,in order to be consistent with Android client.
        NSDictionary *contentOffsetData = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:-scrollView.contentOffset.x / scaleFactor],@"x",[NSNumber numberWithFloat:-scrollView.contentOffset.y / scaleFactor],@"y", nil];
        CGFloat distance = 0;
        if (_scrollDirection == JUDScrollDirectionHorizontal) {
            distance = scrollView.contentOffset.x - _lastScrollEventFiredOffset.x;
        } else {
            distance = scrollView.contentOffset.y - _lastScrollEventFiredOffset.y;
        }
        if (fabs(distance) >= _offsetAccuracy) {
            [self fireEvent:@"scroll" params:@{@"contentSize":contentSizeData,@"contentOffset":contentOffsetData} domChanges:nil];
            _lastScrollEventFiredOffset = scrollView.contentOffset;
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    UIEdgeInsets inset = [scrollView contentInset];
    if ([_refreshComponent displayState]) {
        inset.top = _refreshComponent.view.frame.size.height;
    }
    else {
        inset.top = 0;
    }
    if ([_loadingComponent displayState]) {
        inset.bottom = _loadingComponent.view.frame.size.height;
    } else {
        inset.bottom = 0;
    }
    
    [scrollView setContentInset:inset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_loadingComponent.view setHidden:NO];
    [_refreshComponent.view setHidden:NO];
    
    //refresh
    if (_refreshComponent && scrollView.contentOffset.y < 0 && scrollView.contentOffset.y + _refreshComponent.calculatedFrame.size.height < _refreshComponent.calculatedFrame.origin.y) {
        [_refreshComponent refresh];
    }
    
    //loading
    if (_loadingComponent && scrollView.contentOffset.y > 0 &&
        scrollView.contentOffset.y + scrollView.frame.size.height > _loadingComponent.view.frame.origin.y + _loadingComponent.calculatedFrame.size.height) {
        [_loadingComponent loading];
    }
}

- (void)handleAppear
{
    if (![self isViewLoaded]) {
        return;
    }
    UIScrollView *scrollView = (UIScrollView *)self.view;
    CGFloat vx = scrollView.contentInset.left + scrollView.contentOffset.x;
    CGFloat vy = scrollView.contentInset.top + scrollView.contentOffset.y;
    CGFloat vw = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right;
    CGFloat vh = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom;
    CGRect scrollRect = CGRectMake(vx, vy, vw, vh);;
    
    // notify action for appear
    for(JUDScrollToTarget *target in self.listenerArray){
        [self scrollToTarget:target scrollRect:scrollRect];
    }
}

#pragma mark  Private Methods

- (void)scrollToTarget:(JUDScrollToTarget *)target scrollRect:(CGRect)rect
{
    JUDComponent *component = target.target;
    if (![component isViewLoaded]) {
        return;
    }
    
    CGFloat ctop;
    if (component && component->_view && component->_view.superview) {
        ctop = [component->_view.superview convertPoint:component->_view.frame.origin toView:_view].y;
    } else {
        ctop = 0.0;
    }
    CGFloat cbottom = ctop + CGRectGetHeight(component.calculatedFrame);
    CGFloat cleft;
    if (component && component->_view && component->_view.superview) {
        cleft = [component->_view.superview convertPoint:component->_view.frame.origin toView:_view].x;
    } else {
        cleft = 0.0;
    }
    CGFloat cright = cleft + CGRectGetWidth(component.calculatedFrame);
    
    CGFloat vtop = CGRectGetMinY(rect), vbottom = CGRectGetMaxY(rect), vleft = CGRectGetMinX(rect), vright = CGRectGetMaxX(rect);
    if(cbottom > vtop && ctop <= vbottom && cleft <= vright && cright > vleft){
        if(!target.hasAppear && component){
            target.hasAppear = YES;
            if (component->_appearEvent) {
                [component fireEvent:@"appear" params:_direction ? @{@"direction":_direction} : nil];
            }
        }
    } else {
        if(target.hasAppear && component){
            target.hasAppear = NO;
            if(component->_disappearEvent){
                [component fireEvent:@"disappear" params:_direction ? @{@"direction":_direction} : nil];
            }
        }
    }
}

- (void)handleLoadMore
{
    if (_listenLoadMore && [self isNeedLoadMore]) {
        [self loadMore];
    }
}

#pragma mark Layout

- (NSUInteger)_childrenCountForLayout;
{
    return 0;
}

- (NSUInteger)childrenCountForScrollerLayout
{
    return [super _childrenCountForLayout];
}

- (void)_calculateFrameWithSuperAbsolutePosition:(CGPoint)superAbsolutePosition
                          gatherDirtyComponents:(NSMutableSet<JUDComponent *> *)dirtyComponents
{
    /**
     *  Pretty hacky way
     *  layout from root to scroller to get scroller's frame,
     *  layout from children to scroller to get scroller's contentSize
     */
    if ([self needsLayout]) {
        memcpy(_scrollerCSSNode, self.cssNode, sizeof(css_node_t));
        _scrollerCSSNode->children_count = (int)[self childrenCountForScrollerLayout];
        
        _scrollerCSSNode->style.position[CSS_LEFT] = 0;
        _scrollerCSSNode->style.position[CSS_TOP] = 0;
        
        if (_scrollDirection == JUDScrollDirectionVertical) {
            _scrollerCSSNode->style.flex_direction = CSS_FLEX_DIRECTION_COLUMN;
            _scrollerCSSNode->style.dimensions[CSS_WIDTH] = _cssNode->layout.dimensions[CSS_WIDTH];
            _scrollerCSSNode->style.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
        } else {
            _scrollerCSSNode->style.flex_direction = CSS_FLEX_DIRECTION_ROW;
            _scrollerCSSNode->style.dimensions[CSS_HEIGHT] = _cssNode->layout.dimensions[CSS_HEIGHT];
            _scrollerCSSNode->style.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        }
        
        _scrollerCSSNode->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        _scrollerCSSNode->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
        
        layoutNode(_scrollerCSSNode, CSS_UNDEFINED, CSS_UNDEFINED, CSS_DIRECTION_INHERIT);
        if ([JUDLog logLevel] >= JUDLogLevelDebug) {
            print_css_node(_scrollerCSSNode, CSS_PRINT_LAYOUT | CSS_PRINT_STYLE | CSS_PRINT_CHILDREN);
        }
        CGSize size = {
            JUDRoundPixelValue(_scrollerCSSNode->layout.dimensions[CSS_WIDTH]),
            JUDRoundPixelValue(_scrollerCSSNode->layout.dimensions[CSS_HEIGHT])
        };

        if (!CGSizeEqualToSize(size, _contentSize)) {
            // content size
            _contentSize = size;
            [dirtyComponents addObject:self];
        }
        
        _scrollerCSSNode->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        _scrollerCSSNode->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
    }
    
    [super _calculateFrameWithSuperAbsolutePosition:superAbsolutePosition gatherDirtyComponents:dirtyComponents];
}

@end
