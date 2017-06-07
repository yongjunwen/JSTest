/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */


#import <Foundation/Foundation.h>
#import "JUDResourceRequest.h"
#import "JUDResourceResponse.h"

@protocol JUDResourceRequestDelegate <NSObject>

// Periodically informs the delegate of the progress of sending content to the server.
- (void)request:(JUDResourceRequest *)request didSendData:(unsigned long long)bytesSent totalBytesToBeSent:(unsigned long long)totalBytesToBeSent;

// Tells the delegate that the request received the initial reply (headers) from the server.
- (void)request:(JUDResourceRequest *)request didReceiveResponse:(JUDResourceResponse *)response;

// Tells the delegate that the request has received some of the expected data.
- (void)request:(JUDResourceRequest *)request didReceiveData:(NSData *)data;

// Tells the delegate that the request finished transferring data.
- (void)requestDidFinishLoading:(JUDResourceRequest *)request;

// Tells the delegate that the request failed to load successfully.
- (void)request:(JUDResourceRequest *)request didFailWithError:(NSError *)error;

@end

@protocol JUDResourceRequestHandler <NSObject>

// Send a resource request with a delegate
- (void)sendRequest:(JUDResourceRequest *)request withDelegate:(id<JUDResourceRequestDelegate>)delegate;

@optional

// Cancel the ongoing request
- (void)cancelRequest:(JUDResourceRequest *)request;

@end


