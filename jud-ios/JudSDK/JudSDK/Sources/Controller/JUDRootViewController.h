/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <UIKit/UIKit.h>

/**
 * The JUDRootViewController class inherited from UINavigationController class which implements a specialized
 * view controller that manages the navigation of hierarchical content. Developing an iOS application, you
 * need a series of customer pages which will be render by jud bundle. Sometimes, these pages are embedded in
 * viewcontroller. This navigation controller makes it possible to present your page efficiently and makes it
 * easier for the user to navigate that content.
 */

@interface JUDRootViewController : UINavigationController

/**
 * @abstract initialize the RootViewController with bundle url.
 *
 * @param sourceURL The bundle url which can be render to a jud view.
 *
 * @return a object the class of JUDRootViewController.
 *
 * @discussion initialize this controller in function 'application:didFinishLaunchingWithOptions', and make it as rootViewController of window. In the
 * jud application, all page content can be managed by the navigation, such as push or pop.
 */
- (id)initWithSourceURL:(NSURL *)sourceURL;

@end
