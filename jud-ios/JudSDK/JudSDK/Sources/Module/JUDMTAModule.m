//
//  JUDMTAModule.m
//  Pods
//
//  Created by Leo on 2017/6/2.
//
//

#import "JUDMTAModule.h"
#import "JUDMTAProtocol.h"
#import "JUDHandlerFactory.h"

@implementation JUDMTAModule

JUD_EXPORT_METHOD(@selector(page_id_param_event_id_param_next:pageID:pageParam:eventName:eventId:paramValue:nextPageName:))
JUD_EXPORT_METHOD(@selector(name_id_param:pageId:pageParam:))
JUD_EXPORT_METHOD(@selector(level_name_event_other_param_params:pageClassName:pageEventID:otherID:pageParam:parameters:))
JUD_EXPORT_METHOD(@selector(click:pageID:pageParam:eventName:eventId:paramValue:nextPageName:))
JUD_EXPORT_METHOD(@selector(pv:pageId:pageParam:))
JUD_EXPORT_METHOD(@selector(level:pageClassName:pageEventID:otherID:pageParam:parameters:))

#pragma mark -全拼
/// 点击埋点
- (void)page_id_param_event_id_param_next:(NSString*)pageName
                                   pageID:(NSString*)pageID
                                pageParam:(NSString*)pageParam
                                eventName:(NSString*)eventName
                                  eventId:(NSString*)eventID
                               paramValue:(NSString*)paramValue
                             nextPageName:(NSString*)nextPageName
{
    id<JUDMTAProtocol> mta = [JUDHandlerFactory handlerForProtocol:@protocol(JUDMTAProtocol)];
    if(mta)
    {
        [mta pageName:pageName
               pageID:pageID
            pageParam:pageParam
              eventId:eventID
            eventName:eventName
           paramValue:paramValue
         nextPageName:nextPageName];
    }
}

/// pv埋点
- (void)name_id_param:(NSString*)pageName
               pageId:(NSString *)pageId
            pageParam:(NSDictionary*)pageParam
{
    id<JUDMTAProtocol> mta = [JUDHandlerFactory handlerForProtocol:@protocol(JUDMTAProtocol)];
    if(mta)
    {
        [mta pageName:pageName
               pageId:pageId
            pageParam:pageParam];
    }
}

/// 订单等级埋点
- (void)level_name_event_other_param_params:(NSInteger)level
                              pageClassName:(NSString *)name
                                pageEventID:(NSString *)eventID
                                    otherID:(NSString *)otherID
                                  pageParam:(NSString *)param
                                 parameters:(NSDictionary *)parameters
{
    id<JUDMTAProtocol> mta = [JUDHandlerFactory handlerForProtocol:@protocol(JUDMTAProtocol)];
    if(mta)
    {
        [mta setPageLevel:level
            pageClassName:name
              pageEventID:eventID
                  otherID:otherID
                pageParam:param
               parameters:parameters];
    }
}

#pragma mark -简写
/// 点击埋点
- (void)click:(NSString*)pageName
       pageID:(NSString*)pageID
    pageParam:(NSString*)pageParam
    eventName:(NSString*)eventName
      eventId:(NSString*)eventID
   paramValue:(NSString*)paramValue
 nextPageName:(NSString*)nextPageName
{
    id<JUDMTAProtocol> mta = [JUDHandlerFactory handlerForProtocol:@protocol(JUDMTAProtocol)];
    if(mta)
    {
        [mta pageName:pageName
               pageID:pageID
            pageParam:pageParam
              eventId:eventID
            eventName:eventName
           paramValue:paramValue
         nextPageName:nextPageName];
    }
}

/// pv埋点
- (void)pv:(NSString*)pageName
    pageId:(NSString *)pageId
 pageParam:(NSDictionary*)pageParam
{
    id<JUDMTAProtocol> mta = [JUDHandlerFactory handlerForProtocol:@protocol(JUDMTAProtocol)];
    if(mta)
    {
        [mta pageName:pageName
               pageId:pageId
            pageParam:pageParam];
    }
}

/// 订单等级埋点
- (void)level:(NSInteger)level
pageClassName:(NSString *)name
  pageEventID:(NSString *)eventID
      otherID:(NSString *)otherID
    pageParam:(NSString *)param
   parameters:(NSDictionary *)parameters
{
    id<JUDMTAProtocol> mta = [JUDHandlerFactory handlerForProtocol:@protocol(JUDMTAProtocol)];
    if(mta)
    {
        [mta setPageLevel:level
            pageClassName:name
              pageEventID:eventID
                  otherID:otherID
                pageParam:param
               parameters:parameters];
    }
}

@end
