/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDModuleProtocol.h"

#define BIZTYPE             @"bizType"
#define PAGENAME            @"pageName"
#define JUDSDKVERSION        @"JUDSDKVersion"
#define JSLIBVERSION        @"JSLibVersion"
#define JUDREQUESTTYPE       @"requestType"
#define JUDCONNECTIONTYPE    @"connectionType"
#define JUDCUSTOMMONITORINFO @"customMonitorInfo"

#define SDKINITTIME         @"SDKInitTime"
#define SDKINITINVOKETIME   @"SDKInitInvokeTime"
#define JSLIBINITTIME       @"JSLibInitTime"
#define JSTEMPLATESIZE      @"JSTemplateSize"
#define NETWORKTIME         @"networkTime"
#define COMMUNICATETIME     @"communicateTime"
#define SCREENRENDERTIME    @"screenRenderTime"
#define TOTALTIME           @"totalTime"


@protocol JUDAppMonitorProtocol <JUDModuleProtocol>

- (void)commitAppMonitorArgs:(NSDictionary *)args;

- (void)commitAppMonitorAlarm:(NSString *)pageName monitorPoint:(NSString *)monitorPoint success:(BOOL)success errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg arg:(NSString *)arg;

@end
