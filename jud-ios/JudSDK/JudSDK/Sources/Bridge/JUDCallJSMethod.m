/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDCallJSMethod.h"

@implementation JUDCallJSMethod
{
    NSString *_moduleName;
}

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(JUDSDKInstance *)instance
{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        _moduleName = moduleName;
    }
    
    return self;
}

- (NSDictionary *)callJSTask
{
    return @{@"module":_moduleName ?: @"",
             @"method":self.methodName ?: @"",
             @"args":self.arguments ?: @[]};
}

@end
