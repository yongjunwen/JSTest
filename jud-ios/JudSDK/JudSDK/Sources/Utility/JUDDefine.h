/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#ifndef __JUD_DEFINE_H__
#define __JUD_DEFINE_H__

#define JUD_SDK_VERSION @"0.10.2"

#if defined(__cplusplus)
#define JUD_EXTERN extern "C" __attribute__((visibility("default")))
#else
#define JUD_EXTERN extern __attribute__((visibility("default")))
#endif

/*
 * Concatenate preprocessor tokens a and b without expanding macro definitions
 * (however, if invoked from a macro, macro arguments are expanded).
 */
#define JUD_CONCAT(a, b)   a ## b
/*
 * Concatenate preprocessor tokens a and b after macro-expanding them.
 */
#define JUD_CONCAT_WRAPPER(a, b)    JUD_CONCAT(a, b)

#define JUD_CONCAT_TRIPLE(a, b, c) a ## b ## c

#define JUD_NSSTRING_HELPER(x) #x
#define JUD_NSSTRING(x) @JUD_NSSTRING_HELPER(x)

#define JUD_SDK_ROOT_REF     @"_root"

#define JUD_TEXT_FONT_SIZE   (32.0 * self.judInstance.pixelScaleFactor)

#define JUD_UPDATE_CONFIG(prefix, name, configs) \
NSString *selStr = [NSString stringWithFormat:@"%@_%@", prefix, name];\
SEL selector = NSSelectorFromString(selStr);\
Class clazz = JUD_COMPONENT_CLASS(_properties[@"type"]);\
if ([clazz respondsToSelector:selector]) {\
    configs = ((NSArray *(*)(id, SEL))objc_msgSend)(clazz, selector);\
}\

#define JUD_TYPE_KEYPATH(config, name, type, parts, vKey) \
type = [config[0] stringByAppendingString:@":"];\
NSString *keyPath = config.count > 1 ? config[1] : nil;\
if(keyPath){\
    parts = [keyPath componentsSeparatedByString:@"."];\
    vKey = parts.lastObject;\
parts = [parts subarrayWithRange:(NSRange){0, parts.count - 1}];\
} else {\
    vKey = name;\
}

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGB_A(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)

#define JUD_ERROR_DOMAIN @"JUDErrorDomain"

#define JUD_APPLICATION_WILL_RESIGN_ACTIVE @"JUDApplicationWillResignActiveEvent"

#define JUD_APPLICATION_DID_BECOME_ACTIVE @"JUDApplicationDidBecomeActiveEvent"

#define JUD_INSTANCE_NOTIFICATION_UPDATE_STATE @"JUDInstUpdateState"

#define JUD_COMPONENT_THREAD_NAME @"com.jingdong.jud.component"

#define JUD_BRIDGE_THREAD_NAME @"com.jingdong.jud.bridge"

#define JUD_FONT_DOWNLOAD_DIR [[JUDUtility cacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"juddownload"]]

#define JUD_EXPORT_METHOD_INTERNAL(method, token) \
+ (NSString *)JUD_CONCAT_WRAPPER(token, __LINE__) { \
    return NSStringFromSelector(method); \
}

#define JUD_MODULE_EVENT_FIRE_NOTIFICATION  @"JUD_MODULE_EVENT_FIRE_NOTIFICATION"
#define JUD_ICONFONT_DOWNLOAD_NOTIFICATION  @"JUD_ICONFONT_DOWNLOAD_FINISH_NOTIFICATION"

/**
 *  @abstract export public method
 */
#define JUD_EXPORT_METHOD(method) JUD_EXPORT_METHOD_INTERNAL(method,jud_export_method_)

/**
 *  @abstract export public method, support sync return value
 *  @warning the method can only be called on js thread
 */
#define JUD_EXPORT_METHOD_SYNC(method) JUD_EXPORT_METHOD_INTERNAL(method,jud_export_method_sync_)

/** extern "C" makes a function-name in C++ have 'C' linkage (compiler does not mangle the name)
 * so that client C code can link to (i.e use) your function using a 'C' compatible header file that contains just the declaration of your function.
 *  http://stackoverflow.com/questions/1041866/in-c-source-what-is-the-effect-of-extern-c
 */
#ifdef __cplusplus
# define JUD_EXTERN_C_BEGIN extern "C" {
# define JUD_EXTERN_C_END   }
#else
# define JUD_EXTERN_C_BEGIN
# define JUD_EXTERN_C_END
#endif

/**
 *  @abstract Compared with system version of current device 
 *  
 *  @return YES if greater than or equal to the system verison, otherwise, NO.
 *
 */
#define JUD_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/**
 *  @abstract Compared with system version of current device
 *
 *  @return YES if greater than the system verison, otherwise, NO.
 *
 */
#define JUD_SYS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

/**
 *  @abstract Compared with system version of current device
 *
 *  @return YES if equal to the system verison, otherwise, NO.
 *
 */
#define JUD_SYS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

/**
 *  @abstract Compared with system version of current device
 *
 *  @return YES if less than the system verison, otherwise, NO.
 *
 */
#define JUD_SYS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/**
 *  @abstract Compared with system version of current device
 *
 *  @return YES if less than or equal to the system verison, otherwise, NO.
 *
 */
#define JUD_SYS_LESS_THAN_OR_EQUAL_TO(v)             ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#if __has_attribute(objc_requires_super)
    #define JUD_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
    #define JUD_REQUIRES_SUPER
#endif

#endif
