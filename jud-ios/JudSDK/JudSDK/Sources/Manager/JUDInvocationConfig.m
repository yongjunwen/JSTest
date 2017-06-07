/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDInvocationConfig.h"
#import "JUDLog.h"
#import "JUDSDKInstance.h"
#import "JUDSDKManager.h"
#import "JUDSDKInstance_private.h"
#import "JUDMonitor.h"
#import "JUDSDKError.h"
#import "JUDComponentFactory.h"
#import "JUDModuleFactory.h"
#import "JUDUtility.h"

#import <objc/runtime.h>

@interface JUDInvocationConfig()
@end

@implementation JUDInvocationConfig

+ (instancetype)sharedInstance
{
    static id _sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    
    if (self = [super init]) {
        _asyncMethods = [NSMutableDictionary new];
        _syncMethods = [NSMutableDictionary new];
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name class:(NSString *)clazz
{
    if (self = [self init]) {
        _name = name;
        _clazz = clazz;
    }
    return self;
}

- (void)registerMethods
{
    Class currentClass = NSClassFromString(_clazz);
    
    if (!currentClass) {
        JUDLogWarning(@"The module class [%@] doesn't exit！", _clazz);
        return;
    }
    
    while (currentClass != [NSObject class]) {
        unsigned int methodCount = 0;
        Method *methodList = class_copyMethodList(object_getClass(currentClass), &methodCount);
        for (unsigned int i = 0; i < methodCount; i++) {
            NSString *selStr = [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding];
            BOOL isSyncMethod = NO;
            if ([selStr hasPrefix:@"jud_export_method_sync_"]) {
                isSyncMethod = YES;
            } else if ([selStr hasPrefix:@"jud_export_method_"]) {
                isSyncMethod = NO;
            } else {
                continue;
            }
            
            NSString *name = nil, *method = nil;
            SEL selector = NSSelectorFromString(selStr);
            if ([currentClass respondsToSelector:selector]) {
                method = ((NSString* (*)(id, SEL))[currentClass methodForSelector:selector])(currentClass, selector);
            }
            
            if (method.length <= 0) {
                JUDLogWarning(@"The module class [%@] doesn't has any method！", _clazz);
                continue;
            }
            
            NSRange range = [method rangeOfString:@":"];
            if (range.location != NSNotFound) {
                name = [method substringToIndex:range.location];
            } else {
                name = method;
            }
            
            NSMutableDictionary *methods = isSyncMethod ? _syncMethods : _asyncMethods;
            [methods setObject:method forKey:name];
        }
        
        free(methodList);
        currentClass = class_getSuperclass(currentClass);
    }
    
}


@end
