/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface JUDHandlerFactory : NSObject

/**
 * @abstract Register a handler for a given handler instance and specific protocol
 *
 * @param handler The handler instance to register
 *
 * @param protocol The protocol to confirm
 *
 */
+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol;

/**
 * @abstract Returns the handler for a given protocol
 *
 **/
+ (id)handlerForProtocol:(Protocol *)protocol;

/**
 * @abstract Returns the registered handlers.
 */
+ (NSDictionary *)handlerConfigs;

@end
