/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDMonitor.h"
#import "JUDSDKEngine.h"
#import "JUDSDKInstance.h"
#import "JUDAppMonitorProtocol.h"
#import "JUDHandlerFactory.h"
#import "JUDLog.h"
#import "JUDUtility.h"
#import "JUDComponentManager.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDAppConfiguration.h"

NSString *const kStartKey = @"start";
NSString *const kEndKey = @"end";

@implementation JUDMonitor

#pragma mark - Performance Monitor

static JUDThreadSafeMutableDictionary *globalPerformanceDict;

+ (void)performancePoint:(JUDPerformanceTag)tag willStartWithInstance:(JUDSDKInstance *)instance
{
    NSMutableDictionary *performanceDict = [self performanceDictForInstance:instance];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    dict[kStartKey] = @(CACurrentMediaTime() * 1000);
    performanceDict[@(tag)] = dict;
}

+ (void)performancePoint:(JUDPerformanceTag)tag didEndWithInstance:(JUDSDKInstance *)instance
{
    NSMutableDictionary *performanceDict = [self performanceDictForInstance:instance];
    NSMutableDictionary *dict = performanceDict[@(tag)];
    if (!dict) {
        JUDLogError(@"Performance point:%ld, in instance:%@, did not have a start", (unsigned long)tag, instance.instanceId);
        return;
    }
    
    if (dict[kEndKey]) {
        // not override.
        return;
    }
    
    dict[kEndKey] = @(CACurrentMediaTime() * 1000);
    
    if (tag == JUDPTAllRender) {
        [self performanceFinish:instance];
    }
}

+ (void)performancePoint:(JUDPerformanceTag)tag didSetValue:(double)value withInstance:(JUDSDKInstance *)instance
{
    NSMutableDictionary *performanceDict = [self performanceDictForInstance:instance];
    if (performanceDict[@(tag)]) {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    dict[kStartKey] = @(0);
    dict[kEndKey] = @(value);
    performanceDict[@(tag)] = dict;
}

+ (BOOL)performancePoint:(JUDPerformanceTag)tag isRecordedWithInstance:(JUDSDKInstance *)instance
{
    NSMutableDictionary *performanceDict = [self performanceDictForInstance:instance];
    if (!performanceDict) {
        return NO;
    }
    
    NSMutableDictionary *dict = performanceDict[@(tag)];
    return dict && dict[kStartKey] && dict[kEndKey];
}

+ (void)performanceFinish:(JUDSDKInstance *)instance
{
    NSMutableDictionary *commitDict = [NSMutableDictionary dictionaryWithCapacity:JUDPTEnd+4];
    
    commitDict[BIZTYPE] = instance.bizType ?: @"";
    commitDict[PAGENAME] = instance.pageName ?: @"";
    
    commitDict[JUDSDKVERSION] = JUD_SDK_VERSION;
    commitDict[JSLIBVERSION] = [JUDAppConfiguration JSFrameworkVersion];
    if (instance.userInfo[@"jud_bundlejs_connectionType"]) {
        commitDict[@"connectionType"] = instance.userInfo[@"jud_bundlejs_connectionType"];
    }
    if (instance.userInfo[@"jud_bundlejs_requestType"]) {
        commitDict[@"requestType"] = instance.userInfo[@"jud_bundlejs_requestType"];
    }
    if (instance.userInfo[JUDCUSTOMMONITORINFO]) {
        commitDict[JUDCUSTOMMONITORINFO] = instance.userInfo[JUDCUSTOMMONITORINFO];
    }
    JUDPerformBlockOnComponentThread(^{
        commitDict[@"componentCount"] = @([instance numberOfComponents]);
        JUDPerformBlockOnMainThread(^{
            [self commitPerformanceWithDict:commitDict instance:instance];
        });
    });
}

+ (void)commitPerformanceWithDict:(NSMutableDictionary *)commitDict instance:(JUDSDKInstance *)instance
{
    static NSDictionary *commitKeyDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // non-standard perf commit names, remove this hopefully.
        commitKeyDict = @{
                          @(JUDPTInitalize) : SDKINITTIME,
                          @(JUDPTInitalizeSync) : SDKINITINVOKETIME,
                          @(JUDPTFrameworkExecute) : JSLIBINITTIME,
                          @(JUDPTJSDownload) : NETWORKTIME,
                          @(JUDPTJSCreateInstance) : COMMUNICATETIME,
                          @(JUDPTFirstScreenRender) : SCREENRENDERTIME,
                          @(JUDPTAllRender) : TOTALTIME,
                          @(JUDPTBundleSize) : JSTEMPLATESIZE
                          };
    });
    
    for (int tag = 0; tag < JUDPTEnd; tag++) {
        NSMutableDictionary *performanceDict = tag <= JUDPTFrameworkExecute ? globalPerformanceDict : instance.performanceDict;
        NSMutableDictionary *keyDict = performanceDict[@(tag)];
        if (!keyDict || ![keyDict isKindOfClass:[NSMutableDictionary class]]) {
            continue;
        }
        
        NSNumber *start = keyDict[kStartKey];
        NSNumber *end = keyDict[kEndKey];
        
        if (!start || !end) {
            JUDLogWarning(@"Performance point:%d, in instance:%@, did not have a start or end", tag, instance);
            continue;
        }
        
        NSString *commitKey = commitKeyDict[@(tag)];
        commitDict[commitKey] = @([end integerValue] - [start integerValue]);
    }
    
    id<JUDAppMonitorProtocol> appMonitor = [JUDHandlerFactory handlerForProtocol:@protocol(JUDAppMonitorProtocol)];
    if (appMonitor && [appMonitor respondsToSelector:@selector(commitAppMonitorArgs:)]){
        [appMonitor commitAppMonitorArgs:commitDict];
    }
    
    [self printPerformance:commitDict];
}

+ (NSMutableDictionary *)performanceDictForInstance:(JUDSDKInstance *)instance
{
    NSMutableDictionary *performanceDict;
    if (!instance) {
        if (!globalPerformanceDict) {
            globalPerformanceDict = [JUDThreadSafeMutableDictionary dictionary];
        }
        performanceDict = globalPerformanceDict;
    } else {
        performanceDict = instance.performanceDict;
    }
    
    return performanceDict;
}

+ (void)printPerformance:(NSDictionary *)commitDict
{
    if ([JUDLog logLevel] < JUDLogLevelLog) {
        return;
    }
    
    NSMutableString *performanceString = [NSMutableString stringWithString:@"Performance:"];
    for (NSString *commitKey in commitDict) {
        [performanceString appendFormat:@"\n    %@: %@,", commitKey, commitDict[commitKey]];
    }
    
    JUDLog(@"%@", performanceString);
}

#pragma mark - Error Monitor

+ (void)monitoringPointDidSuccess:(JUDMonitorTag)tag onPage:(NSString *)pageName
{
    [self monitoringPoint:tag isSuccss:YES error:nil onPage:pageName];
}

+ (void)monitoringPoint:(JUDMonitorTag)tag didFailWithError:(NSError *)error onPage:(NSString *)pageName
{
    [self monitoringPoint:tag isSuccss:NO error:error onPage:pageName];
}

+ (void)monitoringPoint:(JUDMonitorTag)tag isSuccss:(BOOL)success error:(NSError *)error onPage:(NSString *)pageName
{
    if (!success) {
        JUDLogError(@"%@", error.localizedDescription);
    }
    
    id<JUDAppMonitorProtocol> appMonitorHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDAppMonitorProtocol)];
    if ([appMonitorHandler respondsToSelector:@selector(commitAppMonitorAlarm:monitorPoint:success:errorCode:errorMsg:arg:)]) {
        NSString *errorCodeStr = [NSString stringWithFormat:@"%ld", (long)error.code];
        
        static NSDictionary *monitorNameDict;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            monitorNameDict = @{
                                @(JUDMTJSFramework) : @"jsFramework",
                                @(JUDMTJSDownload) : @"jsDownload",
                                @(JUDMTJSBridge) : @"jsBridge",
                                @(JUDMTNativeRender) : @"domModule"
                                };
        });
        
        pageName = pageName ? : [JUDSDKEngine topInstance].pageName;
        [appMonitorHandler commitAppMonitorAlarm:@"jud" monitorPoint:monitorNameDict[@(tag)] success:success errorCode:errorCodeStr errorMsg:error.localizedDescription arg:pageName];
    }
}

@end
