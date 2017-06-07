/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDNavigationDefaultImpl.h"
#import "JUDBaseViewController.h"
#import "JUDSDKManager.h"
#import "JUDComponent.h"
#import "JUDImgLoaderProtocol.h"
#import "JUDHandlerFactory.h"
#import "JUDConvert.h"

@interface JUDBarButton :UIButton

@property (nonatomic, strong) NSString *instanceId;
@property (nonatomic, strong) NSString *nodeRef;
@property (nonatomic)  JUDNavigationItemPosition position;

@end

@implementation JUDBarButton

@end

@implementation JUDNavigationDefaultImpl

#pragma mark -
#pragma mark JUDNavigationProtocol

- (id<JUDImgLoaderProtocol>)imageLoader
{
    static id<JUDImgLoaderProtocol> imageLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageLoader = [JUDHandlerFactory handlerForProtocol:@protocol(JUDImgLoaderProtocol)];
    });
    return imageLoader;
}

- (id)navigationControllerOfContainer:(UIViewController *)container
{
    return container.navigationController;
}

- (void)pushViewControllerWithParam:(NSDictionary *)param completion:(JUDNavigationResultBlock)block
                      withContainer:(UIViewController *)container
{
    if (0 == [param count] || !param[@"url"] || !container) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    BOOL animated = YES;
    NSString *obj = [[param objectForKey:@"animated"] lowercaseString];
    if (obj && [obj isEqualToString:@"false"]) {
        animated = NO;
    }
    
    JUDBaseViewController *vc = [[JUDBaseViewController alloc]initWithSourceURL:[NSURL URLWithString:param[@"url"]]];
    vc.hidesBottomBarWhenPushed = YES;
    [container.navigationController pushViewController:vc animated:animated];
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)popViewControllerWithParam:(NSDictionary *)param completion:(JUDNavigationResultBlock)block
                     withContainer:(UIViewController *)container
{
    BOOL animated = YES;
    id obj = [param objectForKey:@"animated"];
    if (obj) {
        animated = [JUDConvert BOOL:obj];
    }
    
    [container.navigationController popViewControllerAnimated:animated];
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)popToRootViewControllerWithParam:(NSDictionary *)param
                              completion:(JUDNavigationResultBlock)block
                           withContainer:(UIViewController *)container
{
    BOOL animated = YES;
    NSString *obj = [[param objectForKey:@"animated"] lowercaseString];
    if (obj && [obj isEqualToString:@"false"]) {
        animated = NO;
    }
    
    [container.navigationController popToRootViewControllerAnimated:animated];
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
                 withContainer:(UIViewController *)container
{
    if (![container isKindOfClass:[JUDBaseViewController class]]) {
        return;
    }
    
    container.navigationController.navigationBarHidden = hidden;
}

- (void)setNavigationBackgroundColor:(UIColor *)backgroundColor
                       withContainer:(UIViewController *)container
{
    if (backgroundColor) {
        container.navigationController.navigationBar.barTintColor = backgroundColor;
    }
}

- (void)setNavigationItemWithParam:(NSDictionary *)param
                          position:(JUDNavigationItemPosition)position
                        completion:(JUDNavigationResultBlock)block
                     withContainer:(UIViewController *)container
{
    switch (position) {
        case JUDNavigationItemPositionLeft:
            [self setNaviBarLeftItem:param completion:block withContainer:container];
            break;
        case JUDNavigationItemPositionRight:
            [self setNaviBarRightItem:param completion:block withContainer:container];
            break;
        case JUDNavigationItemPositionMore:
            break;
        case JUDNavigationItemPositionCenter:
            [self setNaviBarTitle:param completion:block withContainer:container];
            break;
        default:
            break;
    }
}

- (void)clearNavigationItemWithParam:(NSDictionary *)param
                            position:(JUDNavigationItemPosition)position
                          completion:(JUDNavigationResultBlock)block
                       withContainer:(UIViewController *)container
{
    switch (position) {
        case JUDNavigationItemPositionLeft:
            [self clearNaviBarLeftItem:param completion:block withContainer:container];
            break;
        case JUDNavigationItemPositionRight:
            [self clearNaviBarRightItem:param completion:block withContainer:container];
            break;
        case JUDNavigationItemPositionMore:
            break;
        case JUDNavigationItemPositionCenter:
            [self clearNaviBarTitle:param completion:block withContainer:container];
            break;
        default:
            break;
    }
}

- (void)setNaviBarLeftItem:(NSDictionary *)param completion:(JUDNavigationResultBlock)block
              withContainer:(UIViewController *)container
{
    if (0 == [param count]) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    UIView *view = [self barButton:param position:JUDNavigationItemPositionLeft withContainer:container];
    
    if (!view) {
        [self callback:block code:MSG_FAILED data:nil];
        return;
    }
    
    container.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)clearNaviBarLeftItem:(NSDictionary *) param completion:(JUDNavigationResultBlock)block
                withContainer:(UIViewController *)container
{
    container.navigationItem.leftBarButtonItem = nil;
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)setNaviBarRightItem:(NSDictionary *)param completion:(JUDNavigationResultBlock)block
              withContainer:(UIViewController *)container
{
    if (0 == [param count]) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    UIView *view = [self barButton:param position:JUDNavigationItemPositionRight withContainer:container];
    
    if (!view) {
        [self callback:block code:MSG_FAILED data:nil];
        return;
    }
    
    container.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)clearNaviBarRightItem:(NSDictionary *) param completion:(JUDNavigationResultBlock)block
                withContainer:(UIViewController *)container
{
    container.navigationItem.rightBarButtonItem = nil;
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (void)setNaviBarTitle:(NSDictionary *)param completion:(JUDNavigationResultBlock)block
          withContainer:(UIViewController *)container
{
    if (0 == [param count]) {
        [self callback:block code:MSG_PARAM_ERR data:nil];
        return;
    }
    
    container.navigationItem.title = param[@"title"];
    
    [self callback:block code:MSG_SUCCESS data:nil];;
}

- (void)clearNaviBarTitle:(NSDictionary *)param completion:(JUDNavigationResultBlock)block
            withContainer:(UIViewController *)container
{
    container.navigationItem.title = @"";
    
    [self callback:block code:MSG_SUCCESS data:nil];
}

- (UIView *)barButton:(NSDictionary *)param position:(JUDNavigationItemPosition)position
        withContainer:(UIViewController *)container
{
    if (param[@"title"]) {
        NSString *title = param[@"title"];

        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
        CGSize size = [title boundingRectWithSize:CGSizeMake(70.0f, 18.0f) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        JUDBarButton *button = [JUDBarButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, size.width, size.height);
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onClickBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.instanceId = param[@"instanceId"];
        button.nodeRef = param[@"nodeRef"];
        button.position = position;
        
        NSString *color = param[@"titleColor"];
        if (color) {
            [button setTitleColor:[JUDConvert UIColor:color] forState:UIControlStateNormal];
            [button setTitleColor:[JUDConvert UIColor:color] forState:UIControlStateHighlighted];
        }
        
        return button;
    }
    else if (param[@"icon"]) {
        NSString *icon = param[@"icon"];
        
        if (icon) {
            JUDBarButton *button = [JUDBarButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(0, 0, 25, 25);
            button.instanceId = param[@"instanceId"];
            button.nodeRef = param[@"nodeRef"];
            button.position = position;
            [button addTarget:self action:@selector(onClickBarButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [[self imageLoader] downloadImageWithURL:icon imageFrame:CGRectMake(0, 0, 25, 25) userInfo:nil completed:^(UIImage *image, NSError *error, BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                    [button setBackgroundImage:image forState:UIControlStateHighlighted];
                });
            }];
            
            return button;
        }
    }
    
    return nil;
}

- (UIView *)titleView:(NSDictionary *)param
{
    UIView *titleView = nil;
    
    if (param[@"title"]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 20.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.text = param[@"title"];
        
        UIColor *titleColor = param[@"titleColor"];
        if (titleColor) {
            label.textColor = [JUDConvert UIColor:titleColor];
        }
        else {
            label.textColor = [UIColor blueColor];
        }
        titleView = label;
    }
    
    return titleView;
}

- (void)onClickBarButton:(id)sender
{
    JUDBarButton *button = (JUDBarButton *)sender;
    if (button.instanceId) {
        if (button.nodeRef)
        {
            [[JUDSDKManager bridgeMgr] fireEvent:button.instanceId ref:button.nodeRef type:@"click" params:nil domChanges:nil] ;
        }
        else
        {
            NSString *eventType;
            switch (button.position) {
                case JUDNavigationItemPositionLeft:
                    eventType = @"clickleftitem";
                    break;
                case JUDNavigationItemPositionRight:
                    eventType = @"clickrightitem";
                    break;
                case JUDNavigationItemPositionMore:
                    eventType = @"clickmoreitem";
                    break;
                default:
                    break;
            }
            
           [[JUDSDKManager bridgeMgr] fireEvent:button.instanceId ref:JUD_SDK_ROOT_REF type:eventType params:nil domChanges:nil];
        }
    }
}

- (void)callback:(JUDNavigationResultBlock)block code:(NSString *)code data:(NSDictionary *)reposonData
{
    if (block) {
        block(code, reposonData);
    }
}

@end
