/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <UIKit/UIKit.h>

/**
 * The JUDBaseViewController class provides the infrastructure for managing the jud view in your app. It is 
 * responsible for creating a jud instance or rendering the jud view, for observing the lifecycle of the
 * view such as "appear" or "disappear"、"foreground" or "background" etc. You can initialize this controller by
 * special bundle URL.
 */

@interface JUDBaseViewController : UIViewController <UIGestureRecognizerDelegate>

/**
 * @abstract initializes the viewcontroller with bundle url.
 *
 * @param sourceURL The url of bundle rendered to a jud view.
 *
 * @return a object the class of JUDBaseViewController.
 *
 */
- (instancetype)initWithSourceURL:(NSURL *)sourceURL;

/**
 * @abstract refreshes the jud view in controller.
 */
- (void)refreshJud;

@end
