/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDResourceRequest.h"

@class JUDSDKInstance;

#define JUD_REWRITE_URL(url, resourceType, instance, newUrl)\
do {\
    (*newUrl) = nil;\
    id<JUDURLRewriteProtocol> rewriteHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDURLRewriteProtocol)];\
    if ([rewriteHandler respondsToSelector:@selector(rewriteURL:withResourceType:withInstance:)]) {\
        (*newUrl) = [[rewriteHandler rewriteURL:url withResourceType:JUDResourceTypeLink withInstance:instance].absoluteString mutableCopy];\
    }\
} while(0);


@protocol JUDURLRewriteProtocol <NSObject>

/**
 * @abstract rewrite and complete URL
 *
 * @param url The original URL to be rewritten
 *
 * @param resourceType resource type which the url is sent for
 *
 * @param instance related instance
 *
 * @return a new url
 */
- (NSURL *)rewriteURL:(NSString *)url withResourceType:(JUDResourceType)resourceType withInstance:(JUDSDKInstance *)instance;

@end
