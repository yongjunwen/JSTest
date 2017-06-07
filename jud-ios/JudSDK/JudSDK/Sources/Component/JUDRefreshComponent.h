/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"

#define  DISTANCE_Y             @"dy"
#define  PULLING_DISTANCE       @"pullingDistance"
#define  VIEW_HEIGHT            @"viewHeight"

@interface JUDRefreshComponent : JUDComponent

- (void)refresh;

- (BOOL)displayState;

- (void)pullingdown:(NSDictionary*)param;

@end
