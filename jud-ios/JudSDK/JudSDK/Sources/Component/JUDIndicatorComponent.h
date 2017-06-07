/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"

typedef enum
{
    JUDPointIndicatorAlignCenter,    // point indicator align center
    JUDPointIndicatorAlignLeft,      // point indicator align left
    JUDPointIndicatorAlignRight,     // point indicator align right
} JUDPointIndicatorAlignStyle;

@interface JUDIndicatorView : UIView

@property (nonatomic, assign)   NSInteger   pointCount;         // total count point of point indicator
@property (nonatomic, assign)   NSInteger   currentPoint;       // current light index of point at point indicator
@property (nonatomic, strong)   UIColor *pointColor;        // normal point color of point indicator
@property (nonatomic, strong)   UIColor *lightColor;        // highlight point color of point indicator
@property (nonatomic, assign)   JUDPointIndicatorAlignStyle  alignStyle;    //align style of point indicator
@property (nonatomic, assign)   CGFloat pointSize;          // point size of point indicator
@property (nonatomic, assign)   CGFloat pointSpace;         // point space of point indicator

@end


@interface JUDIndicatorComponent : JUDComponent

@end
