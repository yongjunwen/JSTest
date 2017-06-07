/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDDefine.h"

JUD_EXTERN_C_BEGIN

void JUDAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...);

#if DEBUG
#define JUDAssert(condition, ...) \
do{\
    if(!(condition)){\
        JUDAssertInternal(@(__func__), @(__FILE__), __LINE__, __VA_ARGS__);\
    }\
}while(0)
#else
#define JUDAssert(condition, ...)
#endif

/**
 *  @abstract macro for asserting that a parameter is required.
 */
#define JUDAssertParam(name) JUDAssert(name, \
@"the parameter '%s' is required", #name)

/**
 *  @abstract macro for asserting if the handler conforms to the protocol
 */
#define JUDAssertProtocol(handler, protocol) JUDAssert([handler conformsToProtocol:protocol], \
@"handler:%@ does not conform to protocol:%@", handler, protocol)

/**
 *  @abstract macro for asserting that the object is kind of special class.
 */
#define JUDAssertClass(name,className) JUDAssert([name isKindOfClass:[className class]], \
@"the variable '%s' is not a kind of '%s' class", #name,#className)

/**
 *  @abstract macro for asserting that we are running on the main thread.
 */
#define JUDAssertMainThread() JUDAssert([NSThread isMainThread], \
@"must be called on the main thread")

/**
 *  @abstract macro for asserting that we are running on the component thread.
 */
#define JUDAssertComponentThread() \
JUDAssert([[NSThread currentThread].name isEqualToString:JUD_COMPONENT_THREAD_NAME], \
@"must be called on the component thread")

/**
 *  @abstract macro for asserting that we are running on the bridge thread.
 */
#define JUDAssertBridgeThread() \
JUDAssert([[NSThread currentThread].name isEqualToString:JUD_BRIDGE_THREAD_NAME], \
@"must be called on the bridge thread")


#define JUDAssertNotReached() \
JUDAssert(NO, @"should never be reached")

JUD_EXTERN_C_END
