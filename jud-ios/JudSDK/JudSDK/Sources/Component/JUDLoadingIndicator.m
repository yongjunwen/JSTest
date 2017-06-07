/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDLoadingIndicator.h"
#import "JUDConvert.h"

@implementation JUDLoadingIndicator {
    UIActivityIndicatorView *_indicator;
    UIColor *_indicatorColor;
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
        if (styles[@"color"]) {
            _indicatorColor = [JUDConvert UIColor:styles[@"color"]];
        }
    }
    return self;
}

- (UIView *)loadView {
    return [[UIActivityIndicatorView alloc] init];
}

- (void)viewDidLoad {
    _indicator = (UIActivityIndicatorView *)self.view;
    
    if (_indicatorColor) {
        _indicator.color = _indicatorColor;
    }
}

- (void)updateStyles:(NSDictionary *)styles {
    if (styles[@"color"]) {
        _indicatorColor = [JUDConvert UIColor:styles[@"color"]];
        _indicator.color = _indicatorColor;
    }
}

#pragma mark - lifeCircle

- (void)viewWillUnload {
    if (_indicator) {
        [_indicator stopAnimating];
        _indicator = nil;
    }
}

- (void)start {
    if (_indicator) {
        [_indicator startAnimating];
    }
}

- (void)stop {
    if (_indicator) {
        [_indicator stopAnimating];
    }
}

#pragma mark -reset color

- (void)resetStyles:(NSArray *)styles {
    if ([styles containsObject:@"color"]) {
        _indicatorColor = [UIColor blackColor];
        _indicator.color = _indicatorColor;
    }
}

@end
