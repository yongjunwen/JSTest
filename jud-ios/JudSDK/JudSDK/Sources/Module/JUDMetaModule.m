/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */
#import "JUDMetaModule.h"
#import "JUDConvert.h"
#import "JUDUtility.h"
#import "JUDSDKInstance_private.h"

@implementation JUDMetaModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(setViewport:))

- (void)setViewport:(NSDictionary *)viewportArguments
{
    CGFloat viewportWidthFloat;
    id viewportWidth = viewportArguments[@"width"];
    if ([viewportWidth isKindOfClass:[NSString class]]) {
        if ([viewportWidth isEqualToString:@"device-width"]) {
            viewportWidthFloat = [JUDUtility portraitScreenSize].width * JUDScreenScale();
        } else if ([viewportWidth isEqualToString:@"device-height"]) {
            viewportWidthFloat = [JUDUtility portraitScreenSize].height * JUDScreenScale();
        } else {
            viewportWidthFloat = [JUDConvert CGFloat:viewportWidth];
        }
    } else {
        viewportWidthFloat = [JUDConvert CGFloat:viewportWidth];
    }
    
    if (viewportWidthFloat > 0) {
        self.judInstance.viewportWidth = viewportWidthFloat;
    }
}

@end
