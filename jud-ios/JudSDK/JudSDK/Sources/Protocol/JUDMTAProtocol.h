//
//  JUDMTAProtocol.h
//  Pods
//
//  Created by Leo on 2017/6/2.
//
//

#import <Foundation/Foundation.h>

/// 埋点模块协议
@protocol JUDMTAProtocol <NSObject>

/**
 *  点击/露出上报埋点
 *
 *  @param pageName     当前页面类名        //(点击)必要     //(露出)必要
 *  @param pageID       当前页面ID         //(点击)必要     //(露出)必要
 *  @param pageParam    当前页面参数       //(点击)必要
 *  @param eventID      事件ID            //(点击)必要     //(露出)必要
 *  @param eventName    事件名称
 *  @param paramValue   事件参数           //(点击)必要
 *  @param nextPageName 下个页面类名
 */
- (void)pageName:(NSString*)pageName
          pageID:(NSString*)pageID
       pageParam:(NSString*)pageParam
         eventId:(NSString*)eventID
       eventName:(NSString*)eventName
      paramValue:(NSString*)paramValue
    nextPageName:(NSString*)nextPageName;

/**
 *  PV 上报
 *
 *  @param pageName  页面类名
 *  @param pageId    页面 Id
 *  @param pageParam 页面参数（商品ID、活动ID、店铺ID）
 */
- (void)pageName:(NSString*)pageName
          pageId:(NSString *)pageId
       pageParam:(NSDictionary*)pageParam;


/**
 *  订单跟踪追加pageID
 *
 *  @param level   页面级别(1 - 5)
 *  @param name    页面类别
 *  @param eventID 页面事件ID
 *  @param otherID  其他ID(event_param)
 *  @param pageParam   页面参数(page_param)
 *  @param parameters  扩展字段
 */
- (void)setPageLevel:(NSInteger)level
       pageClassName:(NSString *)name
         pageEventID:(NSString *)eventID
             otherID:(NSString *)otherID
           pageParam:(NSString *)param
          parameters:(NSDictionary *)parameters;

@end
