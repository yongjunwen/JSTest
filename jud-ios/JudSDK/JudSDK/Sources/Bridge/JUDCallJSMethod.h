/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBridgeMethod.h"

@interface JUDCallJSMethod : JUDBridgeMethod

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(JUDSDKInstance *)instance;

- (NSDictionary *)callJSTask;

@end
