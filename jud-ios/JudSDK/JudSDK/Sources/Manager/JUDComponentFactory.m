/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponentFactory.h"
#import "JUDAssert.h"
#import "JUDLog.h"
#import "JUDInvocationConfig.h"

#import <objc/runtime.h>

@interface JUDComponentConfig : JUDInvocationConfig
@property (nonatomic, strong) NSDictionary *properties;

- (instancetype)initWithName:(NSString *)name class:(NSString *)clazz pros:(NSDictionary *)pros;

@end

@implementation JUDComponentConfig

- (instancetype)initWithName:(NSString *)name class:(NSString *)clazz pros:(NSDictionary *)pros
{
    if (self = [super initWithName:name class:clazz]) {
        _properties = pros;
    }
    
    return self;
}

- (BOOL)isValid
{
    if (self.name == nil || self.clazz == nil) {
        return NO;
    }
    return YES;
}

@end

@implementation JUDComponentFactory
{
    NSMutableDictionary *_componentConfigs;
    NSLock *_configLock;
}

#pragma mark Life Cycle

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if(self = [super init]){
        _componentConfigs = [NSMutableDictionary dictionary];
        _configLock = [[NSLock alloc] init];
    }
    return self;
}

#pragma mark Public

+ (Class)classWithComponentName:(NSString *)name
{
    return [[self sharedInstance] classWithComponentName:name];
}

+ (void)registerComponent:(NSString *)name withClass:(Class)clazz withPros:(NSDictionary *)pros
{
    [[self sharedInstance] registerComponent:name withClass:clazz withPros:pros];
}

+ (void)registerComponents:(NSArray *)components
{
    [[self sharedInstance] registerComponents:components];
}

+ (void)unregisterAllComponents
{
    [[self sharedInstance] unregisterAllComponents];
}

+ (NSDictionary *)componentConfigs {
    return [[self sharedInstance] getComponentConfigs];
}

+ (SEL)methodWithComponentName:(NSString *)name withMethod:(NSString *)method
{
    return [[self sharedInstance] _methodWithComponetName:name withMethod:method];
}

+ (NSMutableDictionary *)componentMethodMapsWithName:(NSString *)name
{
    return [[self sharedInstance] _componentMethodMapsWithName:name];
}

#pragma mark Private

- (NSMutableDictionary *)_componentMethodMapsWithName:(NSString *)name
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *methods = [NSMutableArray array];
    
    [_configLock lock];
    [dict setValue:methods forKey:@"methods"];
    
    JUDComponentConfig *config = _componentConfigs[name];
    void (^mBlock)(id, id, BOOL *) = ^(id mKey, id mObj, BOOL * mStop) {
        [methods addObject:mKey];
    };
    [config.asyncMethods enumerateKeysAndObjectsUsingBlock:mBlock];
    [_configLock unlock];
    
    return dict;
}

- (SEL)_methodWithComponetName:(NSString *)name withMethod:(NSString *)method
{
    JUDAssert(name && method, @"Fail to find selector with module name and method, please check if the parameters are correct ！");
    
    NSString *selStr = nil; SEL selector = nil;
    JUDComponentConfig *config = nil;
    
    [_configLock lock];
    config = [_componentConfigs objectForKey:name];
    if (config.asyncMethods) {
        selStr = [config.asyncMethods objectForKey:method];
    }
    if (selStr) {
        selector = NSSelectorFromString(selStr);
    }
    [_configLock unlock];
    
    return selector;
}

- (NSDictionary *)getComponentConfigs {
    NSMutableDictionary *componentDic = [[NSMutableDictionary alloc] init];
    void (^componentBlock)(id, id, BOOL *) = ^(id mKey, id mObj, BOOL * mStop) {
        JUDComponentConfig *componentConfig = (JUDComponentConfig *)mObj;
        if ([componentConfig isValid]) {
            NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
            [configDic setObject:componentConfig.name forKey:@"name"];
            [configDic setObject:componentConfig.clazz forKey:@"clazz"];
            if (componentConfig.properties) {
                [configDic setObject:componentConfig.properties forKey:@"pros"];
            }
            [componentDic setObject:configDic forKey:componentConfig.name];
        }
    };
    [_componentConfigs enumerateKeysAndObjectsUsingBlock:componentBlock];
    return componentDic;
}

- (Class)classWithComponentName:(NSString *)name
{
    JUDAssert(name, @"Can not find class for a nil component name");
    
    JUDComponentConfig *config = nil;
    
    [_configLock lock];
    config = [_componentConfigs objectForKey:name];
    if (!config) {
        JUDLogWarning(@"No component config for name:%@, use default config", name);
        config = [_componentConfigs objectForKey:@"div"];
    }
    [_configLock unlock];
    
    if(!config || !config.clazz) {
        return nil;
    }
    
    return NSClassFromString(config.clazz);
}

- (void)registerComponent:(NSString *)name withClass:(Class)clazz withPros:(NSDictionary *)pros
{
    JUDAssert(name && clazz, @"name or clazz must not be nil for registering component.");
    
    JUDComponentConfig *config = nil;
    [_configLock lock];
    config = [_componentConfigs objectForKey:name];
    
    if(config){
        JUDLogInfo(@"Overrider component name:%@ class:%@, to name:%@ class:%@",
                  config.name, config.class, name, clazz);
    }
    
    config = [[JUDComponentConfig alloc] initWithName:name class:NSStringFromClass(clazz) pros:pros];
    [_componentConfigs setValue:config forKey:name];
    [config registerMethods];
    
    [_configLock unlock];
}

- (void)registerComponents:(NSArray *)components
{
    JUDAssert(components, @"components array must not be nil for registering component.");
    
    [_configLock lock];
    for(NSDictionary *dict in components){
        NSString *name = dict[@"name"];
        NSString *clazz = dict[@"class"];
        JUDAssert(name && clazz, @"name or clazz must not be nil for registering components.");
        
        JUDComponentConfig *config = [[JUDComponentConfig alloc] initWithName:name class:clazz pros:nil];
        if(config){
            [_componentConfigs setValue:config forKey:name];
            [config registerMethods];
        }
    }
    [_configLock unlock];
}

- (void)unregisterAllComponents
{
    [_configLock lock];
    [_componentConfigs removeAllObjects];
    [_configLock unlock];
}

@end
