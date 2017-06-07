/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"
#import "JUDErrorView.h"

@interface JUDEmbedComponent : JUDComponent <JUDErrorViewDelegate>

- (void)refreshJud;

@end
