/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <JavaScriptCore/JavaScriptCore.h>

typedef NSInteger(^JUDJSCallNative)(NSString *instance, NSArray *tasks, NSString *callback);
typedef NSInteger(^JUDJSCallAddElement)(NSString *instanceId,  NSString *parentRef, NSDictionary *elementData, NSInteger index);
typedef NSInvocation *(^JUDJSCallNativeModule)(NSString *instanceId, NSString *moduleName, NSString *methodName, NSArray *args, NSDictionary *options);
typedef void (^JUDJSCallNativeComponent)(NSString *instanceId, NSString *componentRef, NSString *methodName, NSArray *args, NSDictionary *options);

@protocol JUDBridgeProtocol <NSObject>

@property (nonatomic, readonly) JSValue* exception;

/**
 * Executes the js framework code in javascript engine
 * You can do some setup in this method
 */
- (void)executeJSFramework:(NSString *)frameworkScript;

/**
 * Executes the js code in javascript engine
 * You can do some setup in this method
 */
- (void)executeJavascript:(NSString *)script;

/**
 * Executes global js method with specific arguments
 */
- (JSValue *)callJSMethod:(NSString *)method args:(NSArray*)args;

/**
 * Register callback when call native tasks occur
 */
- (void)registerCallNative:(JUDJSCallNative)callNative;

/**
 * Reset js engine environment, called when any environment variable is changed.
 */
- (void)resetEnvironment;

@optional

/**
 * Called when garbage collection is wanted by sdk.
 */
- (void)garbageCollect;

/**
 * Register callback when addElement tasks occur
 */
- (void)registerCallAddElement:(JUDJSCallAddElement)callAddElement;

/**
 * Register callback for global js function `callNativeModule`
 */
- (void)registerCallNativeModule:(JUDJSCallNativeModule)callNativeModuleBlock;

/**
 * Register callback for global js function `callNativeComponent`
 */
- (void)registerCallNativeComponent:(JUDJSCallNativeComponent)callNativeComponentBlock;


@end
