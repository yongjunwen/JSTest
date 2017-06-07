/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

@class JUDComponent;
@protocol JUDScrollerProtocol <NSObject>

/**
 * @abstract add sticky component
 */
- (void)addStickyComponent:(JUDComponent *)sticky;

/**
 * @abstract remove sticky component
 */
- (void)removeStickyComponent:(JUDComponent *)sticky;

/**
 * @abstract adjust sticky components
 */
- (void)adjustSticky;

/**
 * @abstract add scroll listener
 */
- (void)addScrollToListener:(JUDComponent *)target;

/**
 * @abstract remove scroll listener
 */
- (void)removeScrollToListener:(JUDComponent *)target;

- (void)scrollToComponent:(JUDComponent *)component withOffset:(CGFloat)offset animated:(BOOL)animated;

- (BOOL)isNeedLoadMore;

- (void)loadMore;

- (CGPoint)contentOffset;

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

- (CGSize)contentSize;

- (void)setContentSize:(CGSize)size;

- (UIEdgeInsets)contentInset;

- (void)setContentInset:(UIEdgeInsets)contentInset;

- (void)resetLoadmore;

@end

