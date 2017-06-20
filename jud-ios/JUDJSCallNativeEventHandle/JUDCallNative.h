//
//  JUDCallNative.h
//  Jdipad
//
//  Created by Leo on 2017/5/24.
//  Copyright © 2017年 steven sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JUDSDK/JUDModuleProtocol.h>

/// js调用原生接口
/**
 ios:
 [JUDCallNative registEvent:@"JDProductIntroduceSegmentViewController"
                   callBack:^(NSDictionary *info, JUDModuleCallback callJS) {
    if(wSelf.selectCall)
    {
        NSInteger index = [info[@"index"] integerValue];
        if(callJS)
        {
            callJS(@"Hello": @"World")
        }
    }
 }];
 
 js端:
 var nativeEventHandle = require('@jud-module/nativeEventHandle');
 
 var self = this;
 nativeEventHandle.handleEvent(
    "JDProductIntroduceSegmentViewController",
    {"index": index},
    function(ret) {
        // ret就是我们传入的{"Hello": "World"}
    });
**/
@interface JUDCallNative : NSObject

/**
 注册一个事件

 @param name 事件名
 @param callBack 事件的回调，当js主动调用时将会进行回调，info是js返回的数据，callJS则是回调回js端
 */
+ (void)registEvent:(NSString *)name callBack:(void(^)(NSDictionary *info, JUDModuleCallback callJS))callBack;

/**
 取消注册，请在不需要时取消，比如dealloc

 @param name 事件名
 */
+ (void)resignEvent:(NSString *)name;

/**
 请不要主动调用

 @param name 事件名
 @param info 信息
 @param callJS 调用js
 */
+ (void)handleEvent:(NSString *)name userInfo:(NSDictionary *)info callJSBack:(JUDModuleCallback)callJS;
@end
