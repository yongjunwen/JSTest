/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */
#import "JUDResourceLoader.h"
#import "JUDResourceRequestHandler.h"
#import "JUDSDKInstance.h"
#import "JUDLog.h"
#import "JUDHandlerFactory.h"
#import "JUDSDKError.h"

//deprecated
#import "JUDNetworkProtocol.h"

@interface JUDResourceLoader () <JUDResourceRequestDelegate>

@end

@implementation JUDResourceLoader
{
    NSMutableData *_data;
    JUDResourceResponse *_response;
}

- (instancetype)initWithRequest:(JUDResourceRequest *)request
{
    if (self = [super init]) {
        self.request = request;
    }
    
    return self;
}

- (void)setRequest:(JUDResourceRequest *)request
{
    if (_request) {
        [self cancel:nil];
    }
    
    _request = request;
}

- (void)start
{
    if ([_request.URL isFileURL]) {
        [self _handleFileURL:_request.URL];
        return;
    }
    
    id<JUDResourceRequestHandler> requestHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDResourceRequestHandler)];
    if (requestHandler) {
        [requestHandler sendRequest:_request withDelegate:self];
    } else if ([JUDHandlerFactory handlerForProtocol:NSProtocolFromString(@"JUDNetworkProtocol")]){
        // deprecated logic
        [self _handleDEPRECATEDNetworkHandler];
    } else {
        JUDLogError(@"No resource request handler found!");
    }
}

- (void)cancel:(NSError *__autoreleasing *)error
{
    id<JUDResourceRequestHandler> requestHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDResourceRequestHandler)];
    if ([requestHandler respondsToSelector:@selector(cancelRequest:)]) {
        [requestHandler cancelRequest:_request];
    } else if (error) {
        *error = [NSError errorWithDomain:JUD_ERROR_DOMAIN code:JUD_ERR_CANCEL userInfo:@{NSLocalizedDescriptionKey: @"handle:%@ not respond to cancelRequest"}];
    }
}

- (void)_handleFileURL:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[url path]];
        if (self.onFinished) {
            self.onFinished([JUDResourceResponse new], fileData);
        }
    });
}

- (void)_handleDEPRECATEDNetworkHandler
{
    JUDLogWarning(@"JUDNetworkProtocol is deprecated, use JUDResourceRequestHandler instead!");
    id networkHandler = [JUDHandlerFactory handlerForProtocol:NSProtocolFromString(@"JUDNetworkProtocol")];
    __weak typeof(self) weakSelf = self;
    [networkHandler sendRequest:_request withSendingData:^(int64_t bytesSent, int64_t totalBytes) {
        if (weakSelf.onDataSent) {
            weakSelf.onDataSent(bytesSent, totalBytes);
        }
    } withResponse:^(NSURLResponse *response) {
        _response = (JUDResourceResponse *)response;
        if (weakSelf.onResponseReceived) {
            weakSelf.onResponseReceived((JUDResourceResponse *)response);
        }
    } withReceiveData:^(NSData *data) {
        if (weakSelf.onDataReceived) {
            weakSelf.onDataReceived(data);
        }
    } withCompeletion:^(NSData *totalData, NSError *error) {
        if (error) {
            if (weakSelf.onFailed) {
                weakSelf.onFailed(error);
            }
        } else {
            weakSelf.onFinished(_response, totalData);
            _response = nil;
        }
    }];
}

#pragma mark - JUDResourceRequestDelegate

- (void)request:(JUDResourceRequest *)request didSendData:(unsigned long long)bytesSent totalBytesToBeSent:(unsigned long long)totalBytesToBeSent
{
    JUDLogDebug(@"request:%@ didSendData:%llu totalBytesToBeSent:%llu", request, bytesSent, totalBytesToBeSent);
    
    if (self.onDataSent) {
        self.onDataSent(bytesSent, totalBytesToBeSent);
    }
}

- (void)request:(JUDResourceRequest *)request didReceiveResponse:(JUDResourceResponse *)response
{
    JUDLogDebug(@"request:%@ didReceiveResponse:%@ ", request, response);
    
    _response = response;
    
    if (self.onResponseReceived) {
        self.onResponseReceived(response);
    }
}

- (void)request:(JUDResourceRequest *)request didReceiveData:(NSData *)data
{
    JUDLogDebug(@"request:%@ didReceiveDataLength:%ld", request, (unsigned long)data.length);
    
    if (!_data) {
        _data = [NSMutableData new];
    }
    [_data appendData:data];
    
    if (self.onDataReceived) {
        self.onDataReceived(data);
    }
}

- (void)requestDidFinishLoading:(JUDResourceRequest *)request
{
    JUDLogDebug(@"request:%@ requestDidFinishLoading", request);
    
    if (self.onFinished) {
        self.onFinished(_response, _data);
    }
    
    _data = nil;
    _response = nil;
}

- (void)request:(JUDResourceRequest *)request didFailWithError:(NSError *)error
{
    JUDLogDebug(@"request:%@ didFailWithError:%@", request, error.localizedDescription);
    
    if (self.onFailed) {
        self.onFailed(error);
    }
    
    _data = nil;
    _response = nil;
}

@end
