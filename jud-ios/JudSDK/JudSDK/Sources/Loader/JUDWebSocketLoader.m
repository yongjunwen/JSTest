/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDWebSocketLoader.h"
#import "JUDWebSocketHandler.h"
#import "JUDHandlerFactory.h"
#import "JUDLog.h"

@interface JUDWebSocketLoader () <JUDWebSocketDelegate>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *protocol;
@end

@implementation JUDWebSocketLoader

- (instancetype)initWithUrl:(NSString *)url protocol:(NSString *)protocol
{
    if (self = [super init]) {
        self.url = url;
        self.protocol = protocol;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    
    JUDWebSocketLoader *newClass = [[JUDWebSocketLoader alloc]init];
    newClass.onOpen = self.onOpen;
    newClass.onReceiveMessage = self.onReceiveMessage;
    newClass.onFail = self.onFail;
    newClass.onClose = self.onClose;
    newClass.protocol = self.protocol;
    newClass.url = self.url;
    newClass.identifier = self.identifier;
    return newClass;
}

-(NSString *)identifier
{
    if(!_identifier)
    {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        _identifier = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        assert(_identifier);
        CFRelease(uuid);
    }
    return _identifier;
}

- (void)open
{
    id<JUDWebSocketHandler> requestHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDWebSocketHandler)];
    if (requestHandler) {
        [requestHandler open:self.url protocol:self.protocol identifier:self.identifier withDelegate:self];
    } else {
        JUDLogError(@"No resource request handler found!");
    }
}

- (void)send:(NSString *)data
{
    id<JUDWebSocketHandler> requestHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDWebSocketHandler)];
    if (requestHandler) {
        [requestHandler send:self.identifier data:data];
    } else {
        JUDLogError(@"No resource request handler found!");
    }
}

- (void)close
{
    id<JUDWebSocketHandler> requestHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDWebSocketHandler)];
    if (requestHandler) {
        [requestHandler close:self.identifier];
    } else {
        JUDLogError(@"No resource request handler found!");
    }
}

- (void)clear
{
    id<JUDWebSocketHandler> requestHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDWebSocketHandler)];
    if (requestHandler) {
        [requestHandler clear:self.identifier];
    } else {
        JUDLogError(@"No resource request handler found!");
    }
}

- (void)close:(NSInteger)code reason:(NSString *)reason
{
    id<JUDWebSocketHandler> requestHandler = [JUDHandlerFactory handlerForProtocol:@protocol(JUDWebSocketHandler)];
    if (requestHandler) {
        [requestHandler close:self.identifier code:code reason:reason];
    } else {
        JUDLogError(@"No resource request handler found!");
    }
}

#pragma mark - JUDWebSocketDelegate
- (void)didOpen
{
    if (self.onOpen) {
        self.onOpen();
    }
}
- (void)didFailWithError:(NSError *)error
{
    if(self.onFail) {
        self.onFail(error);
    }
}
- (void)didReceiveMessage:(id)message
{
    if (self.onReceiveMessage) {
        self.onReceiveMessage(message);
    }
}
- (void)didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    if (self.onClose) {
        self.onClose(code,reason,wasClean);
    }
}
@end
