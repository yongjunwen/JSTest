/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponentMethod.h"
#import "JUDComponentFactory.h"
#import "JUDComponentManager.h"
#import "JUDSDKInstance.h"
#import "JUDLog.h"
#import "JUDUtility.h"

@implementation JUDComponentMethod
{
    NSString *_componentName;
    NSString *_componentRef;
}

- (instancetype)initWithComponentRef:(NSString *)ref
                          methodName:(NSString *)methodName
                           arguments:(NSArray *)arguments
                            instance:(JUDSDKInstance *)instance
{
    if (self = [super initWithMethodName:methodName arguments:arguments instance:instance]) {
        _componentRef = ref;
    }
    
    return self;
}

- (void)invoke
{
    JUDPerformBlockOnComponentThread(^{
        JUDComponent *component = [self.instance componentForRef:_componentRef];
        if (!component) {
            JUDLogError(@"component not found for ref:%@, type:%@", _componentRef, _componentName);
        }
        SEL selector = [JUDComponentFactory methodWithComponentName:component.type withMethod:self.methodName];
        NSInvocation * invocation = [self invocationWithTarget:component selector:selector];
        JUDPerformBlockOnMainThread(^{
            [invocation invoke];
        });
    });
    
    
}

@end
