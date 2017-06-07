/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"

@interface JUDWebComponent : JUDComponent<UIWebViewDelegate>

- (void)notifyWebview:(NSDictionary *) data;

- (void)reload;

- (void)goBack;

- (void)goForward;

@end
