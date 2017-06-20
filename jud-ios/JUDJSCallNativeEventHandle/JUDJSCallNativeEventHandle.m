//
//  JUDJSCallNativeEventHandle.m
//  Jdipad
//
//  Created by Leo on 2017/5/24.
//  Copyright © 2017年 steven sun. All rights reserved.
//

#import "JUDJSCallNativeEventHandle.h"
#import <JUDSDK/JUDEventModuleProtocol.h>
#import <JUDSDK/JUDResourceRequestHandler.h>
#import <JUDSDK/JUDUtility.h>
#import "JUDCallNative.h"

@implementation JUDJSCallNativeEventHandle

JUD_EXPORT_METHOD(@selector(handleEvent:userInfo:callJSBack:))

- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)info callJSBack:(JUDModuleCallback)callBack
{
    [JUDCallNative handleEvent:eventName userInfo:info callJSBack:callBack];
}

@end
