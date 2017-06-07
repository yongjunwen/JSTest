/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

@interface JUDComponentFactory : NSObject

/**
 * @abstract Register a component for a given name
 *
 * @param name The component name to register;
 * @param clazz The JUDComponent subclass to register
 * @param pros The component properties to register
 */
+ (void)registerComponent:(NSString *)name withClass:(Class)clazz withPros:(NSDictionary *)pros;

/**
 * @abstract Register a list of components
 * @param components The components array to register, every element in array should be a dictionary,  in the form of @{@"name": @"xxx", @"class":@"yyy"}, which specifies the name and class of the component
 */
+ (void)registerComponents:(NSArray *)components;

+ (NSMutableDictionary *)componentMethodMapsWithName:(NSString *)name;

+ (SEL)methodWithComponentName:(NSString *)name withMethod:(NSString *)method;

/**
 * @abstract Unregister all the components
 */
+ (void)unregisterAllComponents;

/**
 * @abstract Returns the class with a given component name.
 * @param name The component's name
 * @return The component's class
 */
+ (Class)classWithComponentName:(NSString *)name;

/**
 * @abstract Returns the registered components.
 */
+ (NSDictionary *)componentConfigs;


@end
