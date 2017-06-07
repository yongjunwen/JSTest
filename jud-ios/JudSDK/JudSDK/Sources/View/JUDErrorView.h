/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <UIKit/UIKit.h>

@protocol JUDErrorViewDelegate <NSObject>

- (void)onclickErrorView;

@end

@interface JUDErrorView : UIView

@property (nonatomic, weak) id<JUDErrorViewDelegate>  delegate;

@end
