/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDRefreshComponent.h"
#import "JUDScrollerComponent.h"
#import "JUDLoadingIndicator.h"
#import "JUDComponent_internal.h"
#import "JUDLog.h"

@interface JUDRefreshComponent()

@property (nonatomic) BOOL displayState;
@property (nonatomic) BOOL initFinished;
@property (nonatomic) BOOL refreshEvent;
@property (nonatomic) BOOL pullingdownEvent;

@property (nonatomic, weak) JUDLoadingIndicator *indicator;

@end

@implementation JUDRefreshComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
        _refreshEvent = NO;
        _pullingdownEvent = NO;
        if (attributes[@"display"]) {
            if ([attributes[@"display"] isEqualToString:@"show"]) {
                _displayState = YES;
            } else if ([attributes[@"display"] isEqualToString:@"hide"]) {
                _displayState = NO;
            } else {
                JUDLogError(@"");
            }
        }
        self.cssNode->style.position_type = CSS_POSITION_ABSOLUTE;
    }
    return self;
}

- (void)viewDidLoad
{
     _initFinished = YES;
    [self.view setFrame: (CGRect) {
        .size = self.calculatedFrame.size,
        .origin.x = self.calculatedFrame.origin.x,
        .origin.y = self.view.frame.origin.y - CGRectGetHeight(self.calculatedFrame)
    }];
    if (!_displayState) {
        [_indicator.view setHidden:YES];
    }
}

- (void)viewWillUnload
{
    _displayState = NO;
    _refreshEvent = NO;
    _initFinished = NO;
}

- (void)refresh
{
    if (!_refreshEvent || _displayState) {
        return;
    }
    [self fireEvent:@"refresh" params:nil];
}

- (void)pullingdown:(NSDictionary*)param
{
    if (!_pullingdownEvent) {
        return ;
    }
    
    [self fireEvent:@"pullingdown" params:param];
}

- (void)_insertSubcomponent:(JUDComponent *)subcomponent atIndex:(NSInteger)index
{
    if (subcomponent) {
        [super _insertSubcomponent:subcomponent atIndex:index];
        if ([subcomponent isKindOfClass:[JUDLoadingIndicator class]]) {
            _indicator = (JUDLoadingIndicator*)subcomponent;
        }
    }
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"display"]) {
        if ([attributes[@"display"] isEqualToString:@"show"]) {
            _displayState = YES;
        } else if ([attributes[@"display"] isEqualToString:@"hide"]) {
            _displayState = NO;
        } else {
            JUDLogError(@"");
        }
        [self setDisplay];
    }
}

- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"refresh"]) {
        _refreshEvent = YES;
    }
    if ([eventName isEqualToString:@"pullingdown"]) {
        _pullingdownEvent = YES;
    }
}

- (void)removeEvent:(NSString *)evetName
{
    if ([evetName isEqualToString:@"refresh"]) {
        _refreshEvent = NO;
    }
    if ([evetName isEqualToString:@"pullingdown"]) {
        _pullingdownEvent = NO;
    }
}

- (void)setDisplay
{
    id<JUDScrollerProtocol> scrollerProtocol = self.ancestorScroller;
    if (scrollerProtocol == nil || !_initFinished)
        return;
    
    CGPoint offset = [scrollerProtocol contentOffset];
    if (_displayState) {
        offset.y = -self.calculatedFrame.size.height;
        [_indicator start];
    } else {
        offset.y = 0;
        [_indicator stop];
    }
    [scrollerProtocol setContentOffset:offset animated:YES];
}

- (BOOL)displayState
{
    return _displayState;
}

- (void)setFrame:(CGRect)frame
{
    CGRect rect = frame;
    rect.origin.y = 0 - frame.size.height;
}

@end
