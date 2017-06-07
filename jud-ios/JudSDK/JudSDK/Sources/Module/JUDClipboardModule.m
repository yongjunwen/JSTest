/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDClipboardModule.h"

@implementation JUDClipboardModule

JUD_EXPORT_METHOD(@selector(setString:))
JUD_EXPORT_METHOD(@selector(getString:))

- (dispatch_queue_t)targetExecuteQueue {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

- (void)setString:(NSString *)content
{
    UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
    clipboard.string = (content ? : @"");
}

- (void)getString:(JUDModuleCallback)callback{
    UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
    NSDictionary *result = [@{} mutableCopy];
    if(clipboard.string)
    {
        [result setValue:clipboard.string forKey:@"data"];
        [result setValue:@"success" forKey:@"result"];
    }else
    {
        [result setValue:@"" forKey:@"data"];
        [result setValue:@"fail" forKey:@"result"];
    }
    if (callback) {
        callback(result);
    }

}

@end
