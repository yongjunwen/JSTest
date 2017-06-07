/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "JUDResourceRequest.h"
#import "JUDResourceResponse.h"


@interface JUDResourceLoader : NSObject

@property (nonatomic, strong) JUDResourceRequest *request;

@property (nonatomic, copy) void (^onDataSent)(unsigned long long /* bytesSent */, unsigned long long /* totalBytesToBeSent */);
@property (nonatomic, copy) void (^onResponseReceived)(const JUDResourceResponse *);
@property (nonatomic, copy) void (^onDataReceived)(NSData *);
@property (nonatomic, copy) void (^onFinished)(const JUDResourceResponse *, NSData *);
@property (nonatomic, copy) void (^onFailed)(NSError *);

- (instancetype)initWithRequest:(JUDResourceRequest *)request;

- (void)start;

- (void)cancel:(NSError **)error;

@end
