/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDBaseViewController.h"
#import "JUDRootViewController.h"
#import "JUDSDKInstance.h"
#import "JUDSDKInstance_private.h"
#import "JUDSDKEngine.h"
#import "JUDSDKManager.h"
#import "JUDUtility.h"

@interface JUDBaseViewController ()

@property (nonatomic, strong) JUDSDKInstance *instance;
@property (nonatomic, strong) UIView *judView;
@property (nonatomic, strong) NSURL *sourceURL;

@end

@implementation JUDBaseViewController

- (void)dealloc
{
    [_instance destroyInstance];
    [self _removeObservers];
}

- (instancetype)initWithSourceURL:(NSURL *)sourceURL
{
    if ((self = [super init])) {
        self.sourceURL = sourceURL;
        self.hidesBottomBarWhenPushed = YES;
        
        [self _addObservers];
    }
    return self;
}

/**
 *  After setting the navbar hidden status , this function will be called automatically. In this function, we
 *  set the height of mainView equal to screen height, because there is something wrong with the layout of
 *  page content.
 */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if ([self.navigationController isKindOfClass:[JUDRootViewController class]]) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.view.frame = frame;
    }    
}

/**
 *  We assume that the initial state of viewController's navigtionBar is hidden.  By setting the attribute of
 *  'dataRole' equal to 'navbar', the navigationBar hidden will be NO.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addEdgePop];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self _renderWithURL:_sourceURL];
    
    if ([self.navigationController isKindOfClass:[JUDRootViewController class]]) {
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_instance fireGlobalEvent:JUD_APPLICATION_WILL_RESIGN_ACTIVE params:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_instance fireGlobalEvent:JUD_APPLICATION_DID_BECOME_ACTIVE params:nil];
    [self _updateInstanceState:JudInstanceAppear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self _updateInstanceState:JudInstanceDisappear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self _updateInstanceState:JudInstanceMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshJud
{
    [self _renderWithURL:_sourceURL];
}

- (void)addEdgePop
{
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!self.navigationController || [self.navigationController.viewControllers count] == 1) {
        return NO;
    }
    return YES;
}

- (void)_renderWithURL:(NSURL *)sourceURL
{
    if (!sourceURL) {
        return;
    }

    [_instance destroyInstance];
    _instance = [[JUDSDKInstance alloc] init];
    _instance.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    _instance.pageObject = self;
    _instance.pageName = [[JUDUtility urlByDeletingParameters:sourceURL] absoluteString];
    _instance.viewController = self;
    
    NSString *newURL = nil;
    
    if ([sourceURL.absoluteString rangeOfString:@"?"].location != NSNotFound) {
        newURL = [NSString stringWithFormat:@"%@&random=%d", sourceURL.absoluteString, arc4random()];
    } else {
        newURL = [NSString stringWithFormat:@"%@?random=%d", sourceURL.absoluteString, arc4random()];
    }
    [_instance renderWithURL:[NSURL URLWithString:newURL] options:@{@"bundleUrl":sourceURL.absoluteString} data:nil];
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.judView removeFromSuperview];
        weakSelf.judView = view;
        [weakSelf.view addSubview:weakSelf.judView];
    };
    
    _instance.onFailed = ^(NSError *error) {
        
    };
    
    _instance.renderFinish = ^(UIView *view) {
        [weakSelf _updateInstanceState:JudInstanceAppear];
    };
}

- (void)_updateInstanceState:(JUDState)state
{
    if (_instance && _instance.state != state) {
        _instance.state = state;
        
        if (state == JudInstanceAppear) {
            [[JUDSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:JUD_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
        } else if (state == JudInstanceDisappear) {
            [[JUDSDKManager bridgeMgr] fireEvent:_instance.instanceId ref:JUD_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
        }
    }
}

- (void)_appStateDidChange:(NSNotification *)notify
{
    if ([notify.name isEqualToString:@"UIApplicationDidBecomeActiveNotification"]) {
        [self _updateInstanceState:JudInstanceForeground];
    } else if([notify.name isEqualToString:@"UIApplicationDidEnterBackgroundNotification"]) {
        [self _updateInstanceState:JudInstanceBackground]; ;
    }
}

- (void)_addObservers
{
    for (NSString *name in @[UIApplicationDidBecomeActiveNotification,
                             UIApplicationDidEnterBackgroundNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_appStateDidChange:)
                                                     name:name
                                                   object:nil];
    }
}

- (void)_removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
