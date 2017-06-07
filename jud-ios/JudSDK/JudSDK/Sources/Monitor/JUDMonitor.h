/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDDefine.h"
#import "JUDSDKError.h"

@class JUDSDKInstance;

typedef enum : NSUInteger {
    // global
    JUDPTInitalize = 0,
    JUDPTInitalizeSync,
    JUDPTFrameworkExecute,
    // instance
    JUDPTJSDownload,
    JUDPTJSCreateInstance,
    JUDPTFirstScreenRender,
    JUDPTAllRender,
    JUDPTBundleSize,
    JUDPTEnd
} JUDPerformanceTag;

typedef enum : NSUInteger {
    JUDMTJSFramework,
    JUDMTJSDownload,
    JUDMTJSBridge,
    JUDMTNativeRender,
    JUDMTJSService,
} JUDMonitorTag;


#define JUD_MONITOR_SUCCESS_ON_PAGE(tag, pageName) [JUDMonitor monitoringPointDidSuccess:tag onPage:pageName];
#define JUD_MONITOR_FAIL_ON_PAGE(tag, errorCode, errorMessage, pageName) \
NSError *error = [NSError errorWithDomain:JUD_ERROR_DOMAIN \
                                     code:errorCode \
                                 userInfo:@{NSLocalizedDescriptionKey:(errorMessage?:@"No message")}]; \
[JUDMonitor monitoringPoint:tag didFailWithError:error onPage:pageName];

#define JUD_MONITOR_SUCCESS(tag) JUD_MONITOR_SUCCESS_ON_PAGE(tag, nil)
#define JUD_MONITOR_FAIL(tag, errorCode, errorMessage) JUD_MONITOR_FAIL_ON_PAGE(tag, errorCode, errorMessage, nil)

#define JUD_MONITOR_PERF_START(tag) [JUDMonitor performancePoint:tag willStartWithInstance:nil];
#define JUD_MONITOR_PERF_END(tag) [JUDMonitor performancePoint:tag didEndWithInstance:nil];
#define JUD_MONITOR_INSTANCE_PERF_START(tag, instance) [JUDMonitor performancePoint:tag willStartWithInstance:instance];
#define JUD_MONITOR_INSTANCE_PERF_END(tag, instance) [JUDMonitor performancePoint:tag didEndWithInstance:instance];
#define JUD_MONITOR_PERF_SET(tag, value, instance) [JUDMonitor performancePoint:tag didSetValue:value withInstance:instance];
#define JUD_MONITOR_INSTANCE_PERF_IS_RECORDED(tag, instance) [JUDMonitor performancePoint:tag isRecordedWithInstance:instance]

@interface JUDMonitor : NSObject

+ (void)performancePoint:(JUDPerformanceTag)tag willStartWithInstance:(JUDSDKInstance *)instance;
+ (void)performancePoint:(JUDPerformanceTag)tag didEndWithInstance:(JUDSDKInstance *)instance;
+ (void)performancePoint:(JUDPerformanceTag)tag didSetValue:(double)value withInstance:(JUDSDKInstance *)instance;
+ (BOOL)performancePoint:(JUDPerformanceTag)tag isRecordedWithInstance:(JUDSDKInstance *)instance;

+ (void)monitoringPointDidSuccess:(JUDMonitorTag)tag onPage:(NSString *)pageName;
+ (void)monitoringPoint:(JUDMonitorTag)tag didFailWithError:(NSError *)error onPage:(NSString *)pageName;

@end
