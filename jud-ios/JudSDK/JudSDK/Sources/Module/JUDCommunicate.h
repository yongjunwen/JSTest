//
//  JUDCommunicate.h
//  Pods
//
//  Created by Leo on 2017/6/2.
//
//

#import <Foundation/Foundation.h>
#import "JUDModuleProtocol.h"

/**
 供客户端与js进行通信的模块
 */
@interface JUDCommunicate : NSObject

/**
 主动发送一个事件给js，前提是js注册了这个事件

 @param eventName 事件名
 @param info 传递的数据
 */
+ (void)send:(NSString *)eventName userInfo:(NSDictionary *)info;

/**
 用于监听js主动调用客户端的事件名
 */
@property (nonatomic, copy) NSString *eventName;

/**
 当js主动触发了事件则会进行响应
 */
@property (nonatomic, copy) void(^event)(NSDictionary *, JUDModuleCallback);

@end
