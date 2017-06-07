/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDComponent.h"

typedef NS_ENUM(NSInteger, JUDSliderNeighborOption)
{
    JUDSliderNeighborOptionWrap = 0,
    JUDSliderNeighborOptionShowBackfaces,
    JUDSliderNeighborOptionOffsetMultiplier,
    JUDSliderNeighborOptionVisibleItems,
    JUDSliderNeighborOptionCount,
    JUDSliderNeighborOptionArc,
    JUDSliderNeighborOptionAngle,
    JUDSliderNeighborOptionRadius,
    JUDSliderNeighborOptionTilt,
    JUDSliderNeighborOptionSpacing,
    JUDSliderNeighborOptionFadeMin,
    JUDSliderNeighborOptionFadeMax,
    JUDSliderNeighborOptionFadeRange,
    JUDSliderNeighborOptionFadeMinAlpha
};

@class JUDSliderNeighborView;

@protocol JUDSliderNeighborDelegate <NSObject>
@optional

- (void)sliderNeighborWillBeginScrollingAnimation:(JUDSliderNeighborView * _Nonnull )sliderNeighbor;
- (void)sliderNeighborDidEndScrollingAnimation:(JUDSliderNeighborView *_Nonnull)sliderNeighbor;
- (void)sliderNeighborDidScroll:(JUDSliderNeighborView * _Nonnull)sliderNeighbor;
- (void)sliderNeighborCurrentItemIndexDidChange:(JUDSliderNeighborView * _Nonnull)sliderNeighbor from:(NSInteger) from to:(NSInteger)to;
- (void)sliderNeighborWillBeginDragging:(JUDSliderNeighborView * _Nonnull)sliderNeighbor;
- (void)sliderNeighborDidEndDragging:(JUDSliderNeighborView * _Nonnull)sliderNeighbor willDecelerate:(BOOL)decelerate;
- (void)sliderNeighborWillBeginDecelerating:(JUDSliderNeighborView * _Nonnull)sliderNeighbor;
- (void)sliderNeighborDidEndDecelerating:(JUDSliderNeighborView * _Nonnull)sliderNeighbor;

- (BOOL)sliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor shouldSelectItemAtIndex:(NSInteger)index;
- (void)sliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor didSelectItemAtIndex:(NSInteger)index;
- (void)sliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor didScrollToItemAtIndex:(NSInteger)index;

- (CGFloat)sliderNeighborItemWidth:(JUDSliderNeighborView * _Nonnull)sliderNeighbor;
- (CGFloat)sliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor valueForOption:(JUDSliderNeighborOption)option withDefault:(CGFloat)value;

@end

@protocol JUDSliderNeighborDataSource <NSObject>

- (NSInteger)numberOfItemsInSliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor;
- (UIView * _Nonnull)sliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor viewForItemAtIndex:(NSInteger)index reusingView:( UIView * _Nonnull)view;

@optional

- (NSInteger)numberOfPlaceholdersInsliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor;
- (UIView * _Nonnull)sliderNeighbor:(JUDSliderNeighborView * _Nonnull)sliderNeighbor placeholderViewAtIndex:(NSInteger)index reusingView:( UIView * _Nonnull)view;

@end

@interface JUDSliderNeighborComponent : JUDComponent<JUDSliderNeighborDelegate, JUDSliderNeighborDataSource>

@end

