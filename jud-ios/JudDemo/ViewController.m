//
//  ViewController.m
//  JudDemo
//
//  Created by huokun on 10/05/2017.
//  Copyright © 2017 huokun. All rights reserved.
//

#import "ViewController.h"

#import <JudSDK/JudSDK.h>
#import "JUDCallNative.h"

@interface ViewController ()

@property (nonatomic, strong) JUDCommunicate *communicate;
@property (nonatomic, strong) JUDSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, assign) CGFloat weexHeight;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.communicate = [[JUDCommunicate alloc] init];
    self.communicate.eventName = @"HelloWorld";
    [self.communicate setEvent:^(NSDictionary *userInfo, JUDModuleCallback callJS){
        NSLog(@"%@", userInfo);
        callJS(@"Reply HelloWorld");
    }];
    
    // [_instance fireGlobalEvent:@"" params:@{}];
    // Do any additional setup after loading the view, typically from a nib.
    _weexHeight = self.view.frame.size.height - 20;
    [self.navigationController.navigationBar setHidden:YES];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = [UIColor colorWithRed:1.00 green:0.40 blue:0.00 alpha:1.0];
    }
    
    [self render];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JUDCommunicate send:@"START"
                    userInfo:@{@"Hello": @"World"}];
    });
}

- (void)dealloc
{
    [_instance destroyInstance];
}

- (void)render
{
    _instance = [[JUDSDKInstance alloc] init];
    _instance.viewController = self;
    CGFloat width = self.view.frame.size.width;
    _instance.frame = CGRectMake(self.view.frame.size.width-width, 20, width, _weexHeight);
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
//        [weakSelf.weexView removeFromSuperview];
//        weakSelf.weexView = view;
//        [weakSelf.view addSubview:weakSelf.weexView];
//        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);
    };
    _instance.onFailed = ^(NSError *error) {
        NSLog(@"failed %@",error);
    };
    
    _instance.renderFinish = ^(UIView *view) {
        NSLog(@"render finish");
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);
    };
    
    _instance.updateFinish = ^(UIView *view) {
        NSLog(@"update Finish");
    };
    NSString *url = [NSString stringWithFormat:@"file://%@/PromotionHome.js",[NSBundle mainBundle].bundlePath];
    
    [_instance renderWithURL:[NSURL URLWithString:url] options:@{@"bundleUrl":url} data:nil];
    
    [JUDCallNative registEvent:@"kToSeeBrandKey"
                      callBack:^(NSDictionary *info, JUDModuleCallback callJS) {
                          //
                          NSLog(@"kToSeeBrandKey====");
//                          [JDNativeJumpManager jump:[JDNativeJumpWebModel modelWithAddress:info[@"index"]]];
                      }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
