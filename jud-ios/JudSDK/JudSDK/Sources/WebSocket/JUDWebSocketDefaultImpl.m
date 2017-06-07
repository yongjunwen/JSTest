/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDWebSocketDefaultImpl.h"
#import "SRWebSocket.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "SRWebSocket+Jud.h"

@interface JUDWebSocketDefaultImpl()<SRWebSocketDelegate>

@end

@implementation JUDWebSocketDefaultImpl
{
    JUDThreadSafeMutableDictionary<NSString *, SRWebSocket *> *_webSockets;
}

#pragma mark - JUDWebSocketHandler
- (void)open:(NSString *)url protocol:(NSString *)protocol identifier:(NSString *)identifier withDelegate:(id<JUDWebSocketDelegate>)delegate
{
    if(!_webSockets)
    {
        _webSockets = [JUDThreadSafeMutableDictionary new];
    }
    if([_webSockets objectForKey:identifier]){
        SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
        webSocket.delegate = nil;
        [webSocket close];
        
    }
    NSArray *protols;
    if([protocol length]>0){
       protols = [NSArray arrayWithObject:protocol];
    }
    SRWebSocket *webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url] protocols:protols];
    webSocket.delegate = self;
    [webSocket open];
    webSocket.jud_Identifier = identifier;
    webSocket.jud_WebSocketDelegate = delegate;
    [_webSockets setObject:webSocket forKey:identifier];
}

- (void)send:(NSString *)identifier data:(NSString *)data
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        [webSocket send:data];
    }
}

- (void)close:(NSString *)identifier
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        [webSocket close];
    }
}

- (void)close:(NSString *)identifier code:(NSInteger)code reason:(NSString *)reason
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        [webSocket closeWithCode:code reason:reason];
    }
}

- (void)clear:(NSString *)identifier
{
    SRWebSocket *webSocket = [_webSockets objectForKey:identifier];
    if(webSocket) {
        webSocket.delegate = nil;
        [webSocket close];
        [_webSockets removeObjectForKey:identifier];
    }
}

#pragma mark -SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    if (webSocket.jud_WebSocketDelegate && [webSocket.jud_WebSocketDelegate respondsToSelector:@selector(didOpen)]) {
        [webSocket.jud_WebSocketDelegate didOpen];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    if (webSocket.jud_WebSocketDelegate && [webSocket.jud_WebSocketDelegate respondsToSelector:@selector(didFailWithError:)]) {
        [webSocket.jud_WebSocketDelegate didFailWithError:error];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    if (webSocket.jud_WebSocketDelegate && [webSocket.jud_WebSocketDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [webSocket.jud_WebSocketDelegate didReceiveMessage:message];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    if (webSocket.jud_WebSocketDelegate && [webSocket.jud_WebSocketDelegate respondsToSelector:@selector(didCloseWithCode:reason:wasClean:)]) {
        [webSocket.jud_WebSocketDelegate didCloseWithCode:code reason:reason wasClean:wasClean];
    }
}
@end
