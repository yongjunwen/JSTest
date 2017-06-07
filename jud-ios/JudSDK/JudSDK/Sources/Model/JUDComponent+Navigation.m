/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent+Navigation.h"
#import "JUDComponent_internal.h"
#import "JUDSDKInstance_private.h"
#import "JUDBaseViewController.h"
#import "JUDHandlerFactory.h"
#import "JUDConvert.h"
#import "JUDUtility.h"

#define kBarTintColor @"barTintColor"
#define kBarItemText @"title"
#define kBarItemTextColor @"titleColor"
#define kBarItemIcon  @"icon"

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation JUDComponent (Navigation)

- (id<JUDNavigationProtocol>)navigator
{
    id<JUDNavigationProtocol> navigator = [JUDHandlerFactory handlerForProtocol:@protocol(JUDNavigationProtocol)];
    return navigator;
}

// navigtion configuration
- (void)_setupNavBarWithStyles:(NSMutableDictionary *)styles attributes:(NSMutableDictionary *)attributes
{
    NSString *dataRole = attributes[@"dataRole"];
    if (dataRole && [dataRole isEqualToString:@"navbar"]) {
        styles[@"visibility"] = @"hidden";
        styles[@"position"] = @"fixed";
        
        self.judInstance.naviBarStyles = [NSMutableDictionary new];
        
        [self setNavigationBarHidden:NO];
        
        NSString *backgroundColor = styles[@"backgroundColor"];
        [self setNavigationBackgroundColor:[JUDConvert UIColor:backgroundColor]];
    }
    
    NSString *position = attributes[@"naviItemPosition"];
    if (position) {
        NSMutableDictionary *data = [NSMutableDictionary new];
        [data setObject:_type forKey:@"type"];
        [data setObject:styles forKey:@"style"];
        [data setObject:attributes forKey:@"attr"];
        
        if ([position isEqualToString:@"left"]) {
            [self setNavigationItemWithParam:data position:JUDNavigationItemPositionLeft];
        }
        else if ([position isEqualToString:@"right"]) {
            [self setNavigationItemWithParam:data position:JUDNavigationItemPositionRight];
        }
        else if ([position isEqualToString:@"center"]) {
            [self setNavigationItemWithParam:data position:JUDNavigationItemPositionCenter];
        }
    }
}

- (void)_updateNavBarAttributes:(NSDictionary *)attributes
{
    if (attributes[@"data-role"]) {
        NSString *dataRole = attributes[@"data-role"];
        if ([dataRole isEqualToString:@"navbar"]) {
            [self setNavigationBarHidden:NO];
            
            NSDictionary *style = self.styles[@"style"];
            NSString *backgroundColor = style[@"backgroundColor"];
            [self setNavigationBackgroundColor:[JUDConvert UIColor:backgroundColor]];
        }
    }
}


- (void)setNavigationBarHidden:(BOOL)hidden
{
    UIViewController *container = self.judInstance.viewController;
    id<JUDNavigationProtocol> navigator = [self navigator];
    
    JUDPerformBlockOnMainThread(^{
        [navigator setNavigationBarHidden:hidden animated:NO withContainer:container];
    });
}

- (void)setNavigationBackgroundColor:(UIColor *)backgroundColor
{
    if (!backgroundColor) return;
    
    NSMutableDictionary *styles = self.judInstance.naviBarStyles;
    [styles setObject:backgroundColor forKey:kBarTintColor];
    
    UIViewController *container = self.judInstance.viewController;
    id<JUDNavigationProtocol> navigator = [self navigator];
    
    JUDPerformBlockOnMainThread(^{
        [navigator setNavigationBackgroundColor:backgroundColor withContainer:container];
    });
}

- (void)setNavigationItemWithParam:(NSDictionary *)param position:(JUDNavigationItemPosition)position
{
    if (!param)  return;
    
    __weak __block typeof(JUDComponent) *weakSelf = self;
    
    NSArray *array = @[@"center",@"right",@"left",@"more"];
    
    [self _parse:param resultBlock:^(NSDictionary *dict) {
        NSMutableDictionary *styles = weakSelf.judInstance.naviBarStyles;
        [styles setObject:dict forKey: array[position]];
        
        UIViewController *container = weakSelf.judInstance.viewController;
        id<JUDNavigationProtocol> navigator = [weakSelf navigator];
        
        JUDPerformBlockOnMainThread(^{
            [navigator setNavigationItemWithParam:dict position:position completion:nil withContainer:container];
        });
    }];
}

- (void)setNavigationWithStyles:(NSDictionary *)styles
{
    UIViewController *container = self.judInstance.viewController;
    id<JUDNavigationProtocol> navigator = [self navigator];

    if (styles) {
        [navigator setNavigationBarHidden:NO animated:NO withContainer:container];
        [navigator setNavigationBackgroundColor:styles[kBarTintColor] withContainer:container];
        
        NSArray *array = @[@"center",@"right",@"left",@"more"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [navigator setNavigationItemWithParam:styles[obj] position:idx completion:nil withContainer:container];
        }];
    }
    else {
        [navigator setNavigationBarHidden:YES animated:NO withContainer:container];
    }
}

- (void)_parse:(NSDictionary *)param resultBlock:(void(^)(NSDictionary *))result
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *type = param[@"type"];
    
    [dict setObject:self.judInstance.instanceId forKey:@"instanceId"];
    [dict setObject:self.ref forKey:@"nodeRef"];
    
    if ([type isEqualToString:@"text"]) {
        NSDictionary *attr = param[@"attr"];
        NSString *title = attr[@"value"];
        if (title) {
            [dict setObject:title forKey:kBarItemText];
        }
        
        NSDictionary *style = param[@"style"];
        NSString *color = style[@"color"];
        if (color) {
            [dict setObject:color forKey:kBarItemTextColor];
        }
    }
    else if ([type isEqualToString:@"image"]) {
        NSDictionary *attr = param[@"attr"];
        NSString *src = attr[@"src"];
        if (src) {
            [dict setObject:src forKey:kBarItemIcon];
        }
    }
    result(dict);
}

@end
