/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDScrollerProtocol.h"
#import "JUDComponent.h"

@interface JUDScrollerComponent : JUDComponent <JUDScrollerProtocol, UIScrollViewDelegate>

@property (nonatomic, copy) void (^onScroll)(UIScrollView *);

@property (nonatomic, assign) NSUInteger loadmoreretry;

@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, readonly, assign) css_node_t *scrollerCSSNode;

- (NSUInteger)childrenCountForScrollerLayout;

- (void)handleAppear;

@end

