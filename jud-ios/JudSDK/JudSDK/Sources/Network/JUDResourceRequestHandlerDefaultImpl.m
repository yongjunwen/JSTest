/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */


#import "JUDResourceRequestHandlerDefaultImpl.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDAppConfiguration.h"

@interface JUDResourceRequestHandlerDefaultImpl () <NSURLSessionDataDelegate>

@end

@implementation JUDResourceRequestHandlerDefaultImpl
{
    NSURLSession *_session;
    JUDThreadSafeMutableDictionary<NSURLSessionDataTask *, id<JUDResourceRequestDelegate>> *_delegates;
}

#pragma mark - JUDResourceRequestHandler

- (void)sendRequest:(JUDResourceRequest *)request withDelegate:(id<JUDResourceRequestDelegate>)delegate
{
    if (!_session) {
        NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        if ([JUDAppConfiguration customizeProtocolClasses].count > 0) {
            NSArray *defaultProtocols = urlSessionConfig.protocolClasses;
            urlSessionConfig.protocolClasses = [[JUDAppConfiguration customizeProtocolClasses] arrayByAddingObjectsFromArray:defaultProtocols];
        }
        _session = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue mainQueue]];
        _delegates = [JUDThreadSafeMutableDictionary new];
    }
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    request.taskIdentifier = task;
    [_delegates setObject:delegate forKey:task];
    [task resume];
}

- (void)cancelRequest:(JUDResourceRequest *)request
{
    if ([request.taskIdentifier isKindOfClass:[NSURLSessionTask class]]) {
        NSURLSessionTask *task = (NSURLSessionTask *)request.taskIdentifier;
        [task cancel];
        [_delegates removeObjectForKey:task];
    }
}

#pragma mark - NSURLSessionTaskDelegate & NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    id<JUDResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(JUDResourceRequest *)task.originalRequest didSendData:bytesSent totalBytesToBeSent:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    id<JUDResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(JUDResourceRequest *)task.originalRequest didReceiveResponse:(JUDResourceResponse *)response];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)task didReceiveData:(NSData *)data
{
    id<JUDResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate request:(JUDResourceRequest *)task.originalRequest didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    id<JUDResourceRequestDelegate> delegate = [_delegates objectForKey:task];
    [delegate requestDidFinishLoading:(JUDResourceRequest *)task.originalRequest];
    [_delegates removeObjectForKey:task];
}


@end
