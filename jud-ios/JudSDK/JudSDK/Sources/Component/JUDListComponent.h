/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDScrollerComponent.h"

@class JUDCellComponent;
@class JUDHeaderComponent;
@interface JUDListComponent : JUDScrollerComponent

- (void)cellDidRemove:(JUDCellComponent *)cell;

- (void)cellDidLayout:(JUDCellComponent *)cell;

- (void)headerDidLayout:(JUDHeaderComponent *)header;

- (void)cellDidRendered:(JUDCellComponent *)cell;

- (void)cell:(JUDCellComponent *)cell didMoveToIndex:(NSUInteger)index;

@end
