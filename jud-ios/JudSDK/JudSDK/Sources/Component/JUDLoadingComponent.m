 /**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDLoadingComponent.h"
#import "JUDScrollerComponent.h"
#import "JUDLoadingIndicator.h"
#import "JUDComponent_internal.h"
#import "JUDLog.h"

@interface JUDLoadingComponent()

@property (nonatomic) BOOL initFinished;
@property (nonatomic) BOOL loadingEvent;
@property (nonatomic) BOOL displayState;

@property (nonatomic, weak) JUDLoadingIndicator *indicator;

@end

@implementation JUDLoadingComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
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

- (void)viewWillUnload
{
    _displayState = NO;
    _loadingEvent = NO;
    _initFinished = NO;
}

-(void)updateAttributes:(NSDictionary *)attributes
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

- (void)viewDidLoad
{
    _initFinished = YES;
    
    if (!_displayState) {
        [_indicator.view setHidden:YES];
    }
    [self.view setFrame: (CGRect){
        .size = self.calculatedFrame.size,
        .origin.x = self.calculatedFrame.origin.x,
        .origin.y = self.view.frame.origin.y + CGRectGetHeight(self.calculatedFrame)
    }];
}

- (void)layoutDidFinish {
    [self.view setFrame: (CGRect){
        .size = self.calculatedFrame.size,
        .origin.x = self.calculatedFrame.origin.x,
        .origin.y = self.view.frame.origin.y + CGRectGetHeight(self.calculatedFrame)
    }];
}

- (void)addEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"loading"]) {
        _loadingEvent = YES;
    }
}

- (void)removeEvent:(NSString *)eventName
{
    if ([eventName isEqualToString:@"loading"]) {
        _loadingEvent = NO;
    }
}

- (void)loading
{
    if (!_loadingEvent || _displayState)
        return;
    
    [self fireEvent:@"loading" params:nil];
}

- (void)setDisplay
{
    id<JUDScrollerProtocol> scrollerProtocol = [self ancestorScroller];
    if (scrollerProtocol == nil || !_initFinished)
        return;
    JUDComponent *scroller = (JUDComponent*)scrollerProtocol;
    CGPoint contentOffset = [scrollerProtocol contentOffset];
    if (_displayState) {
        contentOffset.y = [scrollerProtocol contentSize].height - scroller.calculatedFrame.size.height + self.calculatedFrame.size.height;
        [_indicator start];
    } else {
        contentOffset.y = contentOffset.y - self.calculatedFrame.size.height;
        [_indicator stop];
    }
    [scrollerProtocol setContentOffset:contentOffset animated:YES];
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

- (BOOL)displayState
{
    return _displayState;
}

- (void)resizeFrame
{
    CGRect rect = self.calculatedFrame;
    
    id<JUDScrollerProtocol> scrollerProtocol = self.ancestorScroller;
    if (scrollerProtocol) {
        rect.origin.y = [scrollerProtocol contentSize].height;
    }
    
    [self.view setFrame:rect];
}

@end
