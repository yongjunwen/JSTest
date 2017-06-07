/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDWebViewModule.h"
#import "JUDWebComponent.h"
#import "JUDSDKManager.h"
#import "JUDSDKInstance_private.h"

@implementation JUDWebViewModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(notifyWebview:data:))
JUD_EXPORT_METHOD(@selector(reload:))
JUD_EXPORT_METHOD(@selector(goBack:))
JUD_EXPORT_METHOD(@selector(goForward:))

- (void)performBlockWithWebView:(NSString *)elemRef block:(void (^)(JUDWebComponent *))block {
    if (!elemRef) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    
    JUDPerformBlockOnComponentThread(^{
        JUDWebComponent *webview = (JUDWebComponent *)[weakSelf.judInstance componentForRef:elemRef];
        if (!webview) {
            return;
        }
        
        [weakSelf performSelectorOnMainThread:@selector(doBlock:) withObject:^() {
            block(webview);
        } waitUntilDone:NO];
    });
}

- (void)doBlock:(void (^)())block {
    block();
}

- (void)notifyWebview:(NSString *)elemRef data:(NSDictionary *)data {
    [self performBlockWithWebView:elemRef block:^void (JUDWebComponent *webview) {
        [webview notifyWebview:data];
    }];
}

- (void)reload:(NSString *)elemRef {
    [self performBlockWithWebView:elemRef block:^void (JUDWebComponent *webview) {
        [webview reload];
    }];
}

- (void)goBack:(NSString *)elemRef {
    [self performBlockWithWebView:elemRef block:^void (JUDWebComponent *webview) {
        [webview goBack];
    }];
}

- (void)goForward:(NSString *)elemRef {
    [self performBlockWithWebView:elemRef block:^void (JUDWebComponent *webview) {
        [webview goForward];
    }];
}

@end
