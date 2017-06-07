//
//  JUDMTADefaultImpl.m
//  Pods
//
//  Created by Leo on 2017/6/2.
//
//

#import "JUDMTADefaultImpl.h"

@implementation JUDMTADefaultImpl
- (void)pageName:(NSString*)pageName
          pageID:(NSString*)pageID
       pageParam:(NSString*)pageParam
         eventId:(NSString*)eventID
       eventName:(NSString*)eventName
      paramValue:(NSString*)paramValue
    nextPageName:(NSString*)nextPageName
{
    NSLog(@"pageName:%@\npageID:%@\npageParam:%@\neventId:%@\neventName:%@\nparamValue:%@\nnextPageName:%@\n",
          pageName, pageID, pageParam, eventID, eventName, paramValue, nextPageName);
}

- (void)pageName:(NSString*)pageName
          pageId:(NSString *)pageId
       pageParam:(NSDictionary*)pageParam
{
    NSLog(@"pageName:%@\npageID:%@\npageParam:%@\n",
          pageName, pageId, pageParam);
}

- (void)setPageLevel:(NSInteger)level
       pageClassName:(NSString *)name
         pageEventID:(NSString *)eventID
             otherID:(NSString *)otherID
           pageParam:(NSString *)param
          parameters:(NSDictionary *)parameters
{
    NSLog(@"level:%ld\nname:%@\neventID:%@\notherID:%@\nparam:%@\nparameters:%@\n",
          level, name, eventID, otherID, param, parameters);
}

@end
