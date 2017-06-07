/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDWebSocketModule.h"
#import "JUDUtility.h"
#import "JUDWebSocketHandler.h"
#import "JUDHandlerFactory.h"
#import "JUDWebSocketLoader.h"
#import "JUDConvert.h"

@interface JUDWebSocketModule()

@property(nonatomic,copy)JUDModuleKeepAliveCallback errorCallBack;
@property(nonatomic,copy)JUDModuleKeepAliveCallback messageCallBack;
@property(nonatomic,copy)JUDModuleKeepAliveCallback openCallBack;
@property(nonatomic,copy)JUDModuleKeepAliveCallback closeCallBack;

@end

@implementation JUDWebSocketModule
{
    JUDWebSocketLoader *loader;
}
JUD_EXPORT_METHOD(@selector(WebSocket:protocol:))
JUD_EXPORT_METHOD(@selector(send:))
JUD_EXPORT_METHOD(@selector(close:reason:))
JUD_EXPORT_METHOD(@selector(onerror:))
JUD_EXPORT_METHOD(@selector(onmessage:))
JUD_EXPORT_METHOD(@selector(onopen:))
JUD_EXPORT_METHOD(@selector(onclose:))

@synthesize judInstance;

- (void)WebSocket:(NSString *)url protocol:(NSString *)protocol
{
    if(loader)
    {
        [loader clear];
    }
    loader = [[JUDWebSocketLoader alloc] initWithUrl:url protocol:protocol];
    __weak typeof(self) weakSelf = self;
    loader.onReceiveMessage = ^(id message) {
        if (weakSelf) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            if([message isKindOfClass:[NSString class]]) {
                [dic setObject:message forKey:@"data"];
            }
            if (weakSelf.messageCallBack) {
                weakSelf.messageCallBack(dic,true);;
            }
        }
    };
    loader.onOpen = ^() {
        if (weakSelf) {
            if (weakSelf.openCallBack) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                weakSelf.openCallBack(dict,true);;
            }
        }
    };
    loader.onFail = ^(NSError *error) {
        if (weakSelf) {
            JUDLogError(@":( Websocket Failed With Error %@", error);
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:error.userInfo forKey:@"data"];
            if (weakSelf.errorCallBack) {
                weakSelf.errorCallBack(dict, true);
            }
        }
    };
    loader.onClose = ^(NSInteger code,NSString *reason,BOOL wasClean) {
        if (weakSelf) {
            if (weakSelf.closeCallBack) {
                JUDLogInfo(@"Websocket colse ");
                NSMutableDictionary * callbackRsp = [[NSMutableDictionary alloc] init];
                [callbackRsp setObject:[NSNumber numberWithInteger:code] forKey:@"code"];
                [callbackRsp setObject:reason forKey:@"reason"];
                [callbackRsp setObject:wasClean?@true:@false forKey:@"wasClean"];
                if (weakSelf.closeCallBack) {
                    weakSelf.closeCallBack(callbackRsp,false);
                }
            }
        }
    };
    
    [loader open];
}

- (void)send:(NSString *)data
{
    [loader send:data];
}

- (void)close
{
    [loader close];
}

- (void)close:(NSString *)code reason:(NSString *)reason
{
    if(!code)
    {
        [loader close];
        return;
    }
    [loader close:[code integerValue] reason:reason];
}

- (void)onerror:(JUDModuleKeepAliveCallback)callback
{
    self.errorCallBack = callback;
}

- (void)onmessage:(JUDModuleKeepAliveCallback)callback
{
    self.messageCallBack = callback;
}

- (void)onopen:(JUDModuleKeepAliveCallback)callback
{
    self.openCallBack = callback;
}

- (void)onclose:(JUDModuleKeepAliveCallback)callback
{
    self.closeCallBack = callback;
}

-(void)dealloc
{
    [loader clear];
}

@end
