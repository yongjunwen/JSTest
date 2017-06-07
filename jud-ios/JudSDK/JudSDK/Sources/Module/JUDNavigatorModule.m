 /**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDNavigatorModule.h"
#import "JUDSDKManager.h"
#import "JUDUtility.h"
#import "JUDBaseViewController.h"
#import "JUDNavigationProtocol.h"
#import "JUDHandlerFactory.h"
#import "JUDConvert.h"

@implementation JUDNavigatorModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(open:success:failure:))
JUD_EXPORT_METHOD(@selector(close:success:failure:))
JUD_EXPORT_METHOD(@selector(push:callback:))
JUD_EXPORT_METHOD(@selector(pop:callback:))
JUD_EXPORT_METHOD(@selector(setNavBarBackgroundColor:callback:))
JUD_EXPORT_METHOD(@selector(setNavBarLeftItem:callback:))
JUD_EXPORT_METHOD(@selector(clearNavBarLeftItem:callback:))
JUD_EXPORT_METHOD(@selector(setNavBarRightItem:callback:))
JUD_EXPORT_METHOD(@selector(clearNavBarRightItem:callback:))
JUD_EXPORT_METHOD(@selector(setNavBarMoreItem:callback:))
JUD_EXPORT_METHOD(@selector(clearNavBarMoreItem:callback:))
JUD_EXPORT_METHOD(@selector(setNavBarTitle:callback:))
JUD_EXPORT_METHOD(@selector(clearNavBarTitle:callback:))
JUD_EXPORT_METHOD(@selector(setNavBarHidden:callback:))

- (id<JUDNavigationProtocol>)navigator
{
    id<JUDNavigationProtocol> navigator = [JUDHandlerFactory handlerForProtocol:@protocol(JUDNavigationProtocol)];
    return navigator;
}

#pragma mark Jud Application Interface

- (void)open:(NSDictionary *)param success:(JUDModuleCallback)success failure:(JUDModuleCallback)failure
{
    id<JUDNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self.judInstance.viewController;
    if (navigator && [navigator respondsToSelector:@selector(open:success:failure:withContainer:)]) {
        [navigator open:param success:success failure:failure withContainer:container];
    }
}
    
- (void)close:(NSDictionary *)param success:(JUDModuleCallback)success failure:(JUDModuleCallback)failure
{
    id<JUDNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self.judInstance.viewController;
    if (navigator && [navigator respondsToSelector:@selector(close:success:failure:withContainer:)]) {
        [navigator close:param success:success failure:failure withContainer:container];
    }
}
    
- (void)push:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    id<JUDNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self.judInstance.viewController;
    [navigator pushViewControllerWithParam:param completion:^(NSString *code, NSDictionary *responseData) {
        if (callback && code) {
            callback(code);
        }
    } withContainer:container];
}

- (void)pop:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    id<JUDNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self.judInstance.viewController;
    [navigator popViewControllerWithParam:param completion:^(NSString *code, NSDictionary *responseData) {
        if (callback && code) {
            callback(code);
        }
    } withContainer:container];
}

- (void)setNavBarHidden:(NSDictionary*)param callback:(JUDModuleCallback)callback
{
    NSString *result = MSG_FAILED;
    if ([[NSArray arrayWithObjects:@"0",@"1",@0,@1, nil] containsObject:param[@"hidden"]]) {
        id<JUDNavigationProtocol> navigator = [self navigator];
        [navigator setNavigationBarHidden:[param[@"hidden"] boolValue] animated:[param[@"animated"] boolValue] withContainer:self.judInstance.viewController];
        result = MSG_SUCCESS;
    }
    if (callback) {
        callback(result);
    }
}

#pragma mark Navigation Setup

- (void)setNavBarBackgroundColor:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    NSString *backgroundColor = param[@"backgroundColor"];
    if (!backgroundColor) {
        if (callback) {
            callback(MSG_PARAM_ERR);
        }
    }
    
    id<JUDNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self.judInstance.viewController;
    [navigator setNavigationBackgroundColor:[JUDConvert UIColor:backgroundColor] withContainer:container];
    if (callback) {
        callback(MSG_SUCCESS);
    }
}

- (void)setNavBarRightItem:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self setNavigationItemWithParam:param position:JUDNavigationItemPositionRight withCallback:callback];
}

- (void)clearNavBarRightItem:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self clearNavigationItemWithParam:param position:JUDNavigationItemPositionRight withCallback:callback];
}

- (void)setNavBarLeftItem:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self setNavigationItemWithParam:param position:JUDNavigationItemPositionLeft withCallback:callback];
}

- (void)clearNavBarLeftItem:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self clearNavigationItemWithParam:param position:JUDNavigationItemPositionLeft withCallback:callback];
}

- (void)setNavBarMoreItem:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self setNavigationItemWithParam:param position:JUDNavigationItemPositionMore withCallback:callback];
}

- (void)clearNavBarMoreItem:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self clearNavigationItemWithParam:param position:JUDNavigationItemPositionMore withCallback:callback];
}

- (void)setNavBarTitle:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self setNavigationItemWithParam:param position:JUDNavigationItemPositionCenter withCallback:callback];
}

- (void)clearNavBarTitle:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    [self clearNavigationItemWithParam:param position:JUDNavigationItemPositionCenter withCallback:callback];
}

- (void)setNavigationItemWithParam:(NSDictionary *)param position:(JUDNavigationItemPosition)position withCallback:(JUDModuleCallback)callback
{
    id<JUDNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self.judInstance.viewController;
    
    NSMutableDictionary *mutableParam = [param mutableCopy];
    [mutableParam setObject:self.judInstance.instanceId forKey:@"instanceId"];
    
    [navigator setNavigationItemWithParam:mutableParam position:position completion:^(NSString *code, NSDictionary *responseData) {
        if (callback && code) {
            callback(code);
        }
    } withContainer:container];
}

- (void)clearNavigationItemWithParam:(NSDictionary *)param position:(JUDNavigationItemPosition)position withCallback:(JUDModuleCallback)callback
{
    id<JUDNavigationProtocol> navigator = [self navigator];
    UIViewController *container = self.judInstance.viewController;
    [navigator clearNavigationItemWithParam:param position:position completion:^(NSString *code, NSDictionary *responseData) {
        if (callback && code) {
            callback(code);
        }
    } withContainer:container];
}

@end
