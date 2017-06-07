/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "JUDDefine.h"
#import "JUDSDKInstance.h"

#define MSG_SUCCESS     @"JUD_SUCCESS"
#define MSG_NO_HANDLER  @"JUD_NO_HANDLER"
#define MSG_NO_PERMIT   @"JUD_NO_PERMISSION"
#define MSG_FAILED      @"JUD_FAILED"
#define MSG_PARAM_ERR   @"JUD_PARAM_ERR"
#define MSG_EXP         @"JUD_EXCEPTION"

@protocol JUDModuleProtocol <NSObject>

/**
 * @abstract the module callback , result can be string or dictionary.
 * @discussion callback data to js, the id of callback function will be removed to save memory.
 */
typedef void (^JUDModuleCallback)(id result);

/**
 * @abstract the module callback , result can be string or dictionary.
 * @discussion callback data to js, you can specify the keepAlive parameter to keep callback function id keepalive or not. If the keepAlive is true, it won't be removed until instance destroyed, so you can call it repetitious.
 */
typedef void (^JUDModuleKeepAliveCallback)(id result, BOOL keepAlive);

#define JUD_EXPORT_MODULE(module) 

@optional

/**
 *  @abstract returns the execute queue for the module
 *
 *  @return dispatch queue that module's methods will be invoked on
 *
 *  @discussion the implementation is optional. Implement it if you want to execute module actions in the special queue.
 *  Default dispatch queue will be the main queue.
 *
 */
- (dispatch_queue_t)targetExecuteQueue;

/**
 *  @abstract returns the execute thread for the module
 *
 *  @return  thread that module's methods will be invoked on
 *
 *  @discussion the implementation is optional. If you want to execute module actions in the special thread, you can create a new one. 
 *  If `targetExecuteQueue` is implemented,  the queue returned will be respected first.
 *  Default is the main thread.
 *
 */
- (NSThread *)targetExecuteThread;

/**
 *  @abstract the instance bind to this module. It helps you to get many useful properties related to the instance.
 */
@property (nonatomic, weak) JUDSDKInstance *judInstance;

@end
