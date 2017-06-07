/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface JUDServiceFactory : NSObject

/**
 * @abstract Registers a service for a given name, js code and options
 *
 * @param name The service name to register
 *
 * @param options The service options to register
 *
 * @param code service js code to invoke
 *
 * @return script
 *
 */
+ (NSString *)registerServiceScript:(NSString *)name withRawScript:(NSString *)serviceScript withOptions:(NSDictionary *)options;


/**
 * @abstract Unregisters a service for a given name
 *
 * @param name The service name to register
 *
 * @return script
 *
 */
+ (NSString *)unregisterServiceScript:(NSString *)name;

@end
