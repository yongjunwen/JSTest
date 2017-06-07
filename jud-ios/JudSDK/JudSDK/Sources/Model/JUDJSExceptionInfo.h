/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface JUDJSExceptionInfo : NSObject
/**
 * instance id
 */
@property(nonatomic,strong) NSString * instanceId;
/**
 * the URL where the exception occurred
 */
@property(nonatomic,strong) NSString * bundleUrl;
/**
 * error code
 */
@property(nonatomic,strong) NSString * errorCode;
/**
 * the function name of exception
 */
@property(nonatomic,strong) NSString * functionName;
/**
 * exception detail;
 */
@property(nonatomic,strong) NSString * exception;
/**
 * extend filed
 */
@property(nonatomic,strong) NSMutableDictionary * userInfo;
/**
 * jud sdk version
 */
@property(nonatomic,strong, readonly) NSString * sdkVersion;
/**
 * js framework verison
 */
@property(nonatomic,strong, readonly) NSString * jsfmVersion;

/**
 * @abstract Initializes a JUDJSException instance
 * @param instanceId the id of instance
 * @param bundleUrl the page URL where the exception occurred
 * @param errorCode error Code
 * @param exception exception detail
 * @param userInfo  extend field
 */
- (instancetype)initWithInstanceId:(NSString *)instanceId
                         bundleUrl:(NSString *)bundleUrl
                         errorCode:(NSString *)errorCode
                      functionName:(NSString *)functionName
                         exception:(NSString *)exception
                          userInfo:(NSMutableDictionary *)userInfo;

@end
