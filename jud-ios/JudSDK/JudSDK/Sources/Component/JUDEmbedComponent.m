/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDEmbedComponent.h"
#import "JUDComponent_internal.h"
#import "JUDSDKInstance_private.h"
#import "JUDComponent+Navigation.h"
#import "JUDSDKInstance.h"
#import "JUDSDKManager.h"
#import "JUDConvert.h"
#import "JUDUtility.h"

@interface JUDEmbedComponent ()

@property (nonatomic, strong) JUDSDKInstance *embedInstance;
@property (nonatomic, strong) UIView *embedView;
@property (nonatomic, assign) BOOL createFinished;
@property (nonatomic, assign) BOOL renderFinished;
@property (nonatomic, assign) JUDVisibility visible;
@property (nonatomic, strong) NSURL *sourceURL;
@property (nonatomic, strong) JUDErrorView *errorView;

@end

@implementation JUDEmbedComponent 

#pragma mark Life Cycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.embedInstance) {
        [self.embedInstance destroyInstance];
    }
}

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance]) {
        
        _createFinished = NO;
        _renderFinished = NO;
        
        _sourceURL = [NSURL URLWithString: attributes[@"src"]];
        _visible =  [JUDConvert JUDVisibility:styles[@"visibility"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeInstanceState:) name:JUD_INSTANCE_NOTIFICATION_UPDATE_STATE object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self _layoutEmbedView];
}

- (void)updateStyles:(NSDictionary *)styles
{
    [super updateStyles:styles];
    
    if (styles[@"visibility"]) {
        JUDVisibility visible = [JUDConvert JUDVisibility:styles[@"visibility"]];
        if (_visible != visible) {
            _visible = visible;
            [self _layoutEmbedView];
        }
    }
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    [super updateAttributes:attributes];
    
    if (attributes[@"src"]) {
        NSURL *sourceURL = [NSURL URLWithString:attributes[@"src"]];
        if (!sourceURL|| ![[sourceURL absoluteString] isEqualToString:[_sourceURL absoluteString]]) {
            _sourceURL = sourceURL;
            _createFinished = NO;
            [self _layoutEmbedView];
        }
    }
}

- (void)refreshJud
{
    [self _renderWithURL:_sourceURL];
}

- (void)_layoutEmbedView
{
    if (_visible == JUDVisibilityShow) {
        [self _updateState:JudInstanceAppear];
        if (!_createFinished && !CGRectEqualToRect(CGRectZero, self.calculatedFrame)) {
            [self _renderWithURL:_sourceURL];
        }
    }
    else {
        [self _updateState:JudInstanceDisappear];
    }
}

- (void)_renderWithURL:(NSURL *)sourceURL
{
    if (!sourceURL || [[sourceURL absoluteString] length] == 0) {
        return;
    }
    
    [_embedInstance destroyInstance];
    _embedInstance = [[JUDSDKInstance alloc] init];
    _embedInstance.parentInstance = self.judInstance;
    _embedInstance.parentNodeRef = self.ref;
    _embedInstance.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    _embedInstance.pageName = [[JUDUtility urlByDeletingParameters:sourceURL]  absoluteString];
    _embedInstance.pageObject = self.judInstance.viewController;
    _embedInstance.viewController = self.judInstance.viewController;
    
    NSString *newURL = nil;
    
    if ([sourceURL.absoluteString rangeOfString:@"?"].location != NSNotFound) {
        newURL = [NSString stringWithFormat:@"%@&random=%d", sourceURL.absoluteString, arc4random()];
    }
    else {
        newURL = [NSString stringWithFormat:@"%@?random=%d", sourceURL.absoluteString, arc4random()];
    }
    
    [_embedInstance renderWithURL:[NSURL URLWithString:newURL] options:@{@"bundleUrl":[sourceURL absoluteString]} data:nil];
    
    __weak typeof(self) weakSelf = self;
    _embedInstance.onCreate = ^(UIView *view) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.errorView) {
                [weakSelf.errorView removeFromSuperview];
                weakSelf.errorView = nil;
            }
        
            [weakSelf.embedView removeFromSuperview];
            weakSelf.embedView = view;
            [weakSelf.view addSubview:weakSelf.embedView];
            
            weakSelf.createFinished = YES;
        });
    };
    
    _embedInstance.onFailed = ^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.errorView) {
                return ;
            }
            
            JUDErrorView *errorView = [[JUDErrorView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 135.0f, 130.0f)];
            errorView.center = CGPointMake(weakSelf.view.bounds.size.width / 2.0f, weakSelf.view.bounds.size.height / 2.0f);
            errorView.delegate = weakSelf;
            [weakSelf.view addSubview:errorView];
            
            weakSelf.errorView = errorView;
        });
    };
    
    _embedInstance.renderFinish = ^(UIView *view) {
         weakSelf.renderFinished = YES;
        [weakSelf _updateState:JudInstanceAppear];
    };
}

- (void)_updateState:(JUDState)state
{
    if (_renderFinished && _embedInstance && _embedInstance.state != state) {
        _embedInstance.state = state;
        
        if (state == JudInstanceAppear) {
            [self setNavigationWithStyles:self.embedInstance.naviBarStyles];
            [[JUDSDKManager bridgeMgr] fireEvent:self.embedInstance.instanceId ref:JUD_SDK_ROOT_REF type:@"viewappear" params:nil domChanges:nil];
        }
        else if (state == JudInstanceDisappear) {
            [[JUDSDKManager bridgeMgr] fireEvent:self.embedInstance.instanceId ref:JUD_SDK_ROOT_REF type:@"viewdisappear" params:nil domChanges:nil];
        }
    }
}

- (void)onclickErrorView
{
    if (self.errorView) {
        [self.errorView removeFromSuperview];
        self.errorView = nil;
    }
    
    [self _renderWithURL:self.sourceURL];
}

- (void)observeInstanceState:(NSNotification *)notification
{
    JUDSDKInstance *instance = notification.object;
    
    if (instance == self.judInstance) {
        NSDictionary *userInfo = notification.userInfo;
        JUDState state = [userInfo[@"state"] integerValue];
        if (_visible == JUDVisibilityHidden) {
            switch (state) {
                case JudInstanceBackground:
                    [self _updateState:JudInstanceBackground];
                    break;
                default:
                    [self _updateState:JudInstanceDisappear];
                    break;
            }
        }
        else {
            [self _updateState:state];
        }
    }
}

@end
