/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDModuleProtocol.h"

/**
 * This enum is used to define the position of navbar item.
 */
typedef NS_ENUM(NSInteger, JUDNavigationItemPosition) {
    JUDNavigationItemPositionCenter = 0x00,
    JUDNavigationItemPositionRight,
    JUDNavigationItemPositionLeft,
    JUDNavigationItemPositionMore
};

/**
 * @abstract The callback after executing navigator operations. The code has some status such as 'JUD_SUCCESS'、'JUD_FAILED' etc. The responseData
 * contains some useful info you can handle.
 */
typedef void (^JUDNavigationResultBlock)(NSString *code, NSDictionary * responseData);

@protocol JUDNavigationProtocol <JUDModuleProtocol>

/**
 * @abstract Returns the navigation controller.
 *
 * @param container The target controller.
 */
- (id)navigationControllerOfContainer:(UIViewController *)container;

/**
 * @abstract Sets the navigation bar hidden.
 *
 * @param hidden If YES, the navigation bar is hidden.
 *
 * @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated.
 *
 * @param container The navigation controller.
 *
 */
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
                 withContainer:(UIViewController *)container;

/**
 * @abstract Sets the background color of navigation bar.
 *
 * @param backgroundColor The background color of navigation bar.
 *
 * @param container The target controller.
 *
 */
- (void)setNavigationBackgroundColor:(UIColor *)backgroundColor
                       withContainer:(UIViewController *)container;

/**
 * @abstract Sets the item in navigation bar.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param position The value indicates the position of item.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)setNavigationItemWithParam:(NSDictionary *)param
                          position:(JUDNavigationItemPosition)position
                        completion:(JUDNavigationResultBlock)block
                     withContainer:(UIViewController *)container;

/**
 * @abstract Clears the item in navigation bar.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param position The value indicates the position of item.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)clearNavigationItemWithParam:(NSDictionary *)param
                            position:(JUDNavigationItemPosition)position
                          completion:(JUDNavigationResultBlock)block
                       withContainer:(UIViewController *)container;

/**
 * @abstract Pushes a view controller onto the receiver’s stack.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)pushViewControllerWithParam:(NSDictionary *)param
                         completion:(JUDNavigationResultBlock)block
                      withContainer:(UIViewController *)container;

/**
 * @abstract Pops the top view controller from the navigation stack.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param block A block called once the action is completed.
 *
 * @param container The target controller.
 *
 */
- (void)popViewControllerWithParam:(NSDictionary *)param
                        completion:(JUDNavigationResultBlock)block
                     withContainer:(UIViewController *)container;

    
@optional
    
/**
 * @abstract open the resource at the specified URL which supports many common schemes, including the http, https, tel and mailto schemes.
 *
 * @param param The data which is passed to the implementation of the protocol.
 *
 * @param success A block called once the action is completed successfully.
 *
 * @param failure A block called once the action failed to be completed.
 *
 * @param container The target controller.
 *
 */
- (void)open:(NSDictionary *)param success:(JUDModuleCallback)success
                                   failure:(JUDModuleCallback)failure
                             withContainer:(UIViewController *)container;


/**
  * @abstract close the current jud page
  *
  * @param param The data which is passed to the implementation of the protocol.
  *
  * @param success A block called once the action is completed successfully.
  *
  * @param failure A block called once the action failed to be completed.
  *
  * @param container The target controller.
  *
  */
- (void)close:(NSDictionary *)param success:(JUDModuleCallback)success
                                   failure:(JUDModuleCallback)failure
                             withContainer:(UIViewController *)container;
@end
