/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDDomModule.h"
#import "JUDDefine.h"
#import "JUDSDKManager.h"
#import "JUDComponentManager.h"
#import "JUDSDKInstance_private.h"
#import "JUDLog.h"
#import "JUDModuleProtocol.h"
#import "JUDUtility.h"
#import "JUDRuleManager.h"
#import "JUDSDKInstance.h"

@interface JUDDomModule ()

@end

@implementation JUDDomModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(createBody:))
JUD_EXPORT_METHOD(@selector(addElement:element:atIndex:))
JUD_EXPORT_METHOD(@selector(removeElement:))
JUD_EXPORT_METHOD(@selector(moveElement:parentRef:index:))
JUD_EXPORT_METHOD(@selector(addEvent:event:))
JUD_EXPORT_METHOD(@selector(removeEvent:event:))
JUD_EXPORT_METHOD(@selector(createFinish))
JUD_EXPORT_METHOD(@selector(updateFinish))
JUD_EXPORT_METHOD(@selector(refreshFinish))
JUD_EXPORT_METHOD(@selector(scrollToElement:options:))
JUD_EXPORT_METHOD(@selector(updateStyle:styles:))
JUD_EXPORT_METHOD(@selector(updateAttrs:attrs:))
JUD_EXPORT_METHOD(@selector(addRule:rule:))
JUD_EXPORT_METHOD(@selector(getComponentRect:callback:))


- (void)performBlockOnComponentManager:(void(^)(JUDComponentManager *))block
{
    if (!block) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    JUDPerformBlockOnComponentThread(^{
        JUDComponentManager *manager = weakSelf.judInstance.componentManager;
        if (!manager.isValid) {
            return;
        }
        [manager startComponentTasks];
        block(manager);
    });
}
- (void)performSelectorOnRuleManager:(void(^)(void))block{
    if (!block) {
        return;
    }
    JUDPerformBlockOnComponentThread(^{
        block();
    });
}

- (NSThread *)targetExecuteThread
{
    return [JUDComponentManager componentThread];
}

- (void)createBody:(NSDictionary *)body
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager createRoot:body];
    }];
}

- (void)addElement:(NSString *)parentRef element:(NSDictionary *)element atIndex:(NSInteger)index
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager addComponent:element toSupercomponent:parentRef atIndex:index appendingInTree:NO];
    }];
}

- (void)removeElement:(NSString *)ref
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager removeComponent:ref];
    }];
}

- (void)moveElement:(NSString *)elemRef parentRef:(NSString *)parentRef index:(NSInteger)index
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager moveComponent:elemRef toSuper:parentRef atIndex:index];
    }];
}

- (void)addEvent:(NSString *)elemRef event:(NSString *)event
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager addEvent:event toComponent:elemRef];
    }];
}

- (void)removeEvent:(NSString *)elemRef event:(NSString *)event
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager removeEvent:event fromComponent:elemRef];
    }];
}

- (void)createFinish
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager createFinish];
    }];
}

- (void)updateFinish
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager updateFinish];
    }];
}

- (void)refreshFinish
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager refreshFinish];
    }];
}

- (void)scrollToElement:(NSString *)elemRef options:(NSDictionary *)dict
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager scrollToComponent:elemRef options:dict];
    }];
}

-(void)updateStyle:(NSString *)elemRef styles:(NSDictionary *)styles
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager updateStyles:styles forComponent:elemRef];
    }];
}

- (void)updateAttrs:(NSString *)elemRef attrs:(NSDictionary *)attrs
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager updateAttributes:attrs forComponent:elemRef];
    }];
}

- (void)addRule:(NSString*)type rule:(NSDictionary *)rule {
    if ([JUDUtility isBlankString:type] || ![rule count]) {
        return;
    }
    
    [self performSelectorOnRuleManager:^{
        [JUDRuleManager sharedInstance].instance = judInstance;
        [[JUDRuleManager sharedInstance] addRule:type rule:rule];
        
    }];
}

- (void)getComponentRect:(NSString*)ref callback:(JUDModuleKeepAliveCallback)callback {
    [self performBlockOnComponentManager:^(JUDComponentManager * manager) {
        UIView *rootView = manager.judInstance.rootView;
        CGRect rootRect = [rootView.superview convertRect:rootView.frame toView:rootView];
        if ([ref isEqualToString:@"viewport"]) {
            NSMutableDictionary * callbackRsp = nil;
            callbackRsp = [self _componentRectInfoWithViewFrame:rootRect];
            [callbackRsp setObject:@(true) forKey:@"result"];
            if (callback) {
                callback(callbackRsp, false);
            }
        } else {
            JUDComponent *component = [manager componentForRef:ref];
            __weak typeof (self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof (weakSelf) strongSelf = weakSelf;
                NSMutableDictionary * callbackRsp = nil;
                if (!component) {
                    [callbackRsp setObject:@(false) forKey:@"result"];
                    [callbackRsp setObject:[NSString stringWithFormat:@"Illegal parameter, no ref about \"%@\" can be found", ref] forKey:@"errMsg"];
                } else {
                    CGRect componentRect = [component.view.superview convertRect:component.view.frame toView:rootView];
                    callbackRsp = [strongSelf _componentRectInfoWithViewFrame:componentRect];
                    [callbackRsp setObject:@(true)forKey:@"result"];
                }
                if (callback) {
                    callback(callbackRsp, false);
                }
            });

        }
    }];
}

- (void)destroyInstance
{
    [self performBlockOnComponentManager:^(JUDComponentManager *manager) {
        [manager unload];
    }];
}

- (NSMutableDictionary*)_componentRectInfoWithViewFrame:(CGRect)componentRect
{
    CGFloat scaleFactor = self.judInstance.pixelScaleFactor;
    NSMutableDictionary * callbackRsp = [NSMutableDictionary new];
    [callbackRsp setObject:@{
                             @"width":@(componentRect.size.width /scaleFactor),
                             @"height":@(componentRect.size.height / scaleFactor),
                             @"bottom":@(CGRectGetMaxY(componentRect) / scaleFactor),
                             @"left":@(componentRect.origin.x / scaleFactor),
                             @"right":@(CGRectGetMaxX(componentRect) / scaleFactor),
                             @"top":@(componentRect.origin.y / scaleFactor)
                             } forKey:@"size"];
    return callbackRsp;
}

@end
