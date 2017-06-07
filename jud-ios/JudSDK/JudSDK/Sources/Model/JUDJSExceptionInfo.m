//
//  JUDJSException.m
/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDJSExceptionInfo.h"
#import "JUDAppConfiguration.h"

@implementation JUDJSExceptionInfo

- (instancetype)initWithInstanceId:(NSString *)instanceId
                         bundleUrl:(NSString *)bundleUrl
                         errorCode:(NSString *)errorCode
                      functionName:(NSString *)functionName
                         exception:(NSString *)exception
                          userInfo:(NSMutableDictionary *)userInfo
{
    if (self = [super init]) {
        self.instanceId = instanceId;
        self.bundleUrl = bundleUrl;
        self.errorCode = errorCode;
        self.exception = exception;
        self.userInfo = userInfo;
        self.functionName = functionName;
        _jsfmVersion = [JUDAppConfiguration JSFrameworkVersion];
        _sdkVersion = JUD_SDK_VERSION;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"instanceId:%@ bundleUrl:%@ errorCode:%@ functionName:%@ exception:%@ userInfo:%@ jsfmVersion:%@ sdkVersion:%@", _instanceId?:@"", _bundleUrl?:@"", _errorCode?:@"", _functionName?:@"", _exception?:@"", _userInfo?:@"", _jsfmVersion, _sdkVersion];
}
@end
