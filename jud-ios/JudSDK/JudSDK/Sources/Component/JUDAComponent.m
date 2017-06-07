/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDAComponent.h"
#import "JUDNavigationProtocol.h"
#import "JUDHandlerFactory.h"
#import "JUDLog.h"
#import "JUDComponent+Events.h"
#import "JUDURLRewriteProtocol.h"

@interface JUDAComponent()

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) NSString *href;

@end

@implementation JUDAComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL)];
        _tap.delegate = self;
        if (attributes[@"href"]) {
            _href = attributes[@"href"];
        }
    }
    return self;
}

- (void)dealloc
{
    if (_tap.delegate) {
        _tap.delegate = nil;
    }
}

- (void)viewDidLoad
{
    [self.view addGestureRecognizer:_tap];
}

- (void)openURL
{
    if (_href && [_href length] > 0) {
        NSMutableString *newHref = [_href mutableCopy];
        JUD_REWRITE_URL(_href, JUDResourceTypeLink, self.judInstance, &newHref)
        if (!newHref) {
            return;
        }
        id<JUDNavigationProtocol> navigationHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDNavigationProtocol)];
        if ([navigationHandler respondsToSelector:@selector(pushViewControllerWithParam:
                                                            completion:
                                                            withContainer:)]) {
            __weak typeof(self) judSelf = self;
            [navigationHandler pushViewControllerWithParam:@{@"url":newHref} completion:^(NSString *code, NSDictionary *responseData) {
                JUDLogDebug(@"Push success -> %@", judSelf.href);
            } withContainer:self.judInstance.viewController];
        } else {
            JUDLogError(@"Event handler of class %@ does not respond to pushViewControllerWithParam", NSStringFromClass([navigationHandler class]));
        }
    }
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"href"]) {
        _href = attributes[@"href"];
    }
}

#pragma mark
#pragma gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    
    return NO;
}

@end
