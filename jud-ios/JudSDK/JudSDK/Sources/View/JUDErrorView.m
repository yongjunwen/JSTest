/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDErrorView.h"

@implementation JUDErrorView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        NSString *file = [bundle pathForResource:@"jud_load_error@3x" ofType:@"png"];
        imageView.image = [UIImage imageWithContentsOfFile:file];
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)sender
{
    [self.delegate onclickErrorView];
}

@end
