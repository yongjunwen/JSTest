/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDModalUIModule.h"
#import <objc/runtime.h>
#import "JUDUtility.h"
#import "JUDAssert.h"

static NSString *JUDModalCallbackKey;

typedef enum : NSUInteger {
    JUDModalTypeToast = 1,
    JUDModalTypeAlert,
    JUDModalTypeConfirm,
    JUDModalTypePrompt
} JUDModalType;

@interface JUDToastInfo : NSObject

@property (nonatomic, strong) UIView *toastView;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, assign) double duration;

@end

@implementation JUDToastInfo

@end

@interface JUDToastManager : NSObject

@property (strong, nonatomic) NSMutableArray<JUDToastInfo *> *toastQueue;
@property (strong, nonatomic) UIView *toastingView;

+ (JUDToastManager *)sharedManager;

@end

@implementation JUDToastManager

+ (JUDToastManager *)sharedManager{
    static JUDToastManager * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JUDToastManager alloc] init];
        shareInstance.toastQueue = [NSMutableArray new];
    });
    return shareInstance;
}

@end

@interface JUDModalUIModule () <UIAlertViewDelegate>

@end

@implementation JUDModalUIModule
{
    NSMutableSet *_alertViews;
}

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(toast:))
JUD_EXPORT_METHOD(@selector(alert:callback:))
JUD_EXPORT_METHOD(@selector(confirm:callback:))
JUD_EXPORT_METHOD(@selector(prompt:callback:))

- (instancetype)init
{
    if (self = [super init]) {
        _alertViews = [NSMutableSet setWithCapacity:1];
    }
    
    return self;
}

- (void)dealloc
{
    if (JUD_SYS_VERSION_LESS_THAN(@"8.0")) {
        for (UIAlertView *alerView in _alertViews) {
            alerView.delegate = nil;
        }
    }
    
    [_alertViews removeAllObjects];
}

#pragma mark - Toast

static const double JUDToastDefaultDuration = 3.0;
static const CGFloat JUDToastDefaultFontSize = 16.0;
static const CGFloat JUDToastDefaultWidth = 230.0;
static const CGFloat JUDToastDefaultHeight = 30.0;
static const CGFloat JUDToastDefaultPadding = 30.0;

- (void)toast:(NSDictionary *)param
{
    NSString *message = [self stringValue:param[@"message"]];
    
    if (!message) return;
    
    double duration = [param[@"duration"] doubleValue];
    if (duration <= 0) {
        duration = JUDToastDefaultDuration;
    }
    
    JUDPerformBlockOnMainThread(^{
        [self toast:message duration:duration];
    });
}

- (void)toast:(NSString *)message duration:(double)duration
{
    JUDAssertMainThread();
    UIView *superView =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if (!superView) {
        superView =  self.judInstance.rootView;
    }
    UIView *toastView = [self toastViewForMessage:message superView:superView];
    JUDToastInfo *info = [JUDToastInfo new];
    info.toastView = toastView;
    info.superView = superView;
    info.duration = duration;
    [[JUDToastManager sharedManager].toastQueue addObject:info];
    
    if (![JUDToastManager sharedManager].toastingView) {
        [self showToast:toastView superView:superView duration:duration];
    }
}

- (UIView *)toastViewForMessage:(NSString *)message superView:(UIView *)superView
{
    CGFloat padding = JUDToastDefaultPadding;
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding/2, padding/2, JUDToastDefaultWidth, JUDToastDefaultHeight)];
    messageLabel.numberOfLines =  0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = message;
    messageLabel.font = [UIFont boldSystemFontOfSize:JUDToastDefaultFontSize];
    messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    [messageLabel sizeToFit];

    UIView *toastView = [[UIView alloc] initWithFrame:
                         CGRectMake(
                                    (superView.frame.size.width-messageLabel.frame.size.width-padding)/2,
                                    (superView.frame.size.height-messageLabel.frame.size.height-padding)/2,
                                    messageLabel.frame.size.width+padding,
                                    messageLabel.frame.size.height+padding
                                    )];
    
    CGPoint point = CGPointZero;
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    // adjust to screen orientation
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait: {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown: {
            toastView.transform = CGAffineTransformMakeRotation(M_PI);
            float width = window.frame.size.width;
            float height = window.frame.size.height;
            point = CGPointMake(width/2, height/2);
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            toastView.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            toastView.transform = CGAffineTransformMakeRotation(-M_PI/2);
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            break;
        }
        default:
            break;
    }
    
    toastView.center = point;
    toastView.frame = CGRectIntegral(toastView.frame);
    
    [toastView addSubview:messageLabel];
    toastView.layer.cornerRadius = 7;
    toastView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.7];
    
    return toastView;
}

- (void)showToast:(UIView *)toastView superView:(UIView *)superView duration:(double)duration
{
    if (!toastView || !superView) {
        return;
    }
    
    [JUDToastManager sharedManager].toastingView = toastView;
    [superView addSubview:toastView];
    
    [UIView animateWithDuration:0.2 delay:duration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toastView.transform = CGAffineTransformConcat(toastView.transform, CGAffineTransformMakeScale(0.8, 0.8)) ;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toastView.alpha = 0;
        } completion:^(BOOL finished){
            [toastView removeFromSuperview];
            [JUDToastManager sharedManager].toastingView = nil;
            
            NSMutableArray *queue = [JUDToastManager sharedManager].toastQueue;
            if (queue.count > 0) {
                [queue removeObjectAtIndex:0];
                if (queue.count > 0) {
                    JUDToastInfo *info = [queue firstObject];
                    [self showToast:info.toastView superView:info.superView duration:info.duration];
                }
            }
        }];
    }];
}

#pragma mark - Alert

- (void)alert:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    NSString *message = [self stringValue:param[@"message"]];
    NSString *okTitle = [self stringValue:param[@"okTitle"]];
    
    if ([JUDUtility isBlankString:okTitle]) {
        okTitle = @"OK";
    }

    [self alert:message okTitle:nil cancelTitle:okTitle defaultText:nil type:JUDModalTypeAlert callback:callback];
}

#pragma mark - Confirm

- (void)confirm:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    NSString *message = [self stringValue:param[@"message"]];
    NSString *okTitle = [self stringValue:param[@"okTitle"]];
    NSString *cancelTitle = [self stringValue:param[@"cancelTitle"]];
    
    if ([JUDUtility isBlankString:okTitle]) {
        okTitle = @"OK";
    }
    if ([JUDUtility isBlankString:cancelTitle]) {
        cancelTitle = @"Cancel";
    }

    [self alert:message okTitle:okTitle cancelTitle:cancelTitle defaultText:nil type:JUDModalTypeConfirm callback:callback];
}

#pragma mark - Prompt

- (void)prompt:(NSDictionary *)param callback:(JUDModuleCallback)callback
{
    NSString *message = [self stringValue:param[@"message"]];
    NSString *defaultValue = [self stringValue:param[@"default"]];
    NSString *okTitle = [self stringValue:param[@"okTitle"]];
    NSString *cancelTitle = [self stringValue:param[@"cancelTitle"]];
    
    if ([JUDUtility isBlankString:okTitle]) {
        okTitle = @"OK";
    }
    if ([JUDUtility isBlankString:cancelTitle]) {
        cancelTitle = @"Cancel";
    }
    
    [self alert:message okTitle:okTitle cancelTitle:cancelTitle defaultText:defaultValue type:JUDModalTypePrompt callback:callback];
}


#pragma mark - Private

- (void)alert:(NSString *)message okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle defaultText:(NSString *)defaultText type:(JUDModalType)type callback:(JUDModuleCallback)callback
{
    if (!message) {
        if (callback) {
            callback(@"Error: message should be passed correctly.");
        }
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    alertView.tag = type;
    if (type == JUDModalTypePrompt) {
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [alertView textFieldAtIndex:0];
        textField.placeholder = defaultText;
    }
    objc_setAssociatedObject(alertView, &JUDModalCallbackKey, [callback copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [_alertViews addObject:alertView];
    
    JUDPerformBlockOnMainThread(^{
        [alertView show];
    });
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    JUDModuleCallback callback = objc_getAssociatedObject(alertView, &JUDModalCallbackKey);
    if (!callback) return;
    
    id result = @"";
    switch (alertView.tag) {
        case JUDModalTypeAlert: {
            result = @"";
            break;
        }
        case JUDModalTypeConfirm: {
            NSString *clickTitle = [alertView buttonTitleAtIndex:buttonIndex];
            result = clickTitle;
            break;
        }
        case JUDModalTypePrompt: {
            NSString *clickTitle = [alertView buttonTitleAtIndex:buttonIndex];
            NSString *text= [[alertView textFieldAtIndex:0] text] ?: @"";
            result = @{ @"result": clickTitle, @"data": text };
        }
        default:
            break;
    }
    
    callback(result);
    
    [_alertViews removeObject:alertView];
}

- (NSString*)stringValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    return nil;
}

@end
