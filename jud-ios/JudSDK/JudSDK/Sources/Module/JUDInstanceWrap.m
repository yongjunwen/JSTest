/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDInstanceWrap.h"
#import "JUDEmbedComponent.h"

@implementation JUDInstanceWrap

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(error:code:info:))
JUD_EXPORT_METHOD(@selector(refresh))

- (void)error:(NSInteger)type code:(NSInteger)code info:(NSString *)info
{
    NSString *domain = [NSString stringWithFormat:@"%ld", (long)type];
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:info };
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    if (judInstance.onFailed)
        judInstance.onFailed(error);
}

- (void)refresh
{
    if (self.judInstance.parentInstance) {
        JUDSDKInstance *instance = self.judInstance.parentInstance;
        NSString *nodeRef = self.judInstance.parentNodeRef;
        JUDEmbedComponent *embedComponent= (JUDEmbedComponent *)[instance componentForRef:nodeRef];
        [embedComponent refreshJud];
    }
    else {
        UIViewController *controller = self.judInstance.viewController;
        if ([controller respondsToSelector:@selector(refreshJud)]) {
            [controller performSelector:@selector(refreshJud) withObject:nil];
        }
    }
}

@end
