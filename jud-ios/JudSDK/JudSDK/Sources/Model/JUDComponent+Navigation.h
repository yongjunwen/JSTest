/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"
#import "JUDNavigationProtocol.h"

@interface JUDComponent (Navigation)

- (void)setNavigationBarHidden:(BOOL)hidden;

- (void)setNavigationBackgroundColor:(UIColor *)backgroundColor;

- (void)setNavigationItemWithParam:(NSDictionary *)param position:(JUDNavigationItemPosition)position;

- (void)setNavigationWithStyles:(NSDictionary *)styles;
    
@end
