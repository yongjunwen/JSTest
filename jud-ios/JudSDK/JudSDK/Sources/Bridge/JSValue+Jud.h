/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <JavaScriptCore/JavaScriptCore.h>

@interface JSValue (Jud)

+ (JSValue *)jud_valueWithReturnValueFromInvocation:(NSInvocation *)invocation inContext:(JSContext *)context;

@end
