/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    JUDResourceTypeMainBundle,
    JUDResourceTypeServiceBundle,
    JUDResourceTypeImage,
    JUDResourceTypeFont,
    JUDResourceTypeVideo,
    JUDResourceTypeLink,
    JUDResourceTypeOthers
} JUDResourceType;


@interface JUDResourceRequest : NSMutableURLRequest

@property (nonatomic, strong) id taskIdentifier;
@property (nonatomic, assign) JUDResourceType type;

@property (nonatomic, strong) NSString *referrer;
@property (nonatomic, strong) NSString *userAgent;

+ (instancetype)requestWithURL:(NSURL *)url
                  resourceType:(JUDResourceType)type
                      referrer:(NSString *)referrer
                   cachePolicy:(NSURLRequestCachePolicy)cachePolicy;

@end
