/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBridgeMethod.h"

typedef enum : NSUInteger {
    JUDModuleMethodTypeSync,
    JUDModuleMethodTypeAsync,
} JUDModuleMethodType;

@interface JUDModuleMethod : JUDBridgeMethod

@property (nonatomic, assign) JUDModuleMethodType methodType;
@property (nonatomic, strong, readonly) NSString *moduleName;

- (instancetype)initWithModuleName:(NSString *)moduleName
                        methodName:(NSString *)methodName
                         arguments:(NSArray *)arguments
                          instance:(JUDSDKInstance *)instance;

- (NSInvocation *)invoke;

@end
