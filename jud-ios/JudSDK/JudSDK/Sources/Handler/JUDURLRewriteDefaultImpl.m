/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDURLRewriteDefaultImpl.h"
#import "JUDLog.h"
#import "JUDSDKInstance.h"


NSString *const JUDURLLocalScheme = @"local";

@implementation JUDURLRewriteDefaultImpl

- (NSURL *)rewriteURL:(NSString *)url
     withResourceType:(JUDResourceType)resourceType
         withInstance:(JUDSDKInstance *)instance
{
    NSURL *completeURL = [NSURL URLWithString:url];
    if ([completeURL isFileURL]) {
        return completeURL;
    } else if ([self isLocalURL:completeURL]) {
        NSString *resourceName = [[completeURL host] stringByAppendingString:[completeURL path]];
        NSURL *resourceURL = [[NSBundle mainBundle] URLForResource:resourceName withExtension:@""];
        if (!resourceURL) {
            JUDLogError(@"Invalid local resource URL:%@, no resouce found.", url);
        }
        
        return resourceURL;
    } else {
        return [instance completeURL:url];
    }
}

- (BOOL)isLocalURL:(NSURL *)url
{
    return[[[url scheme] lowercaseString] isEqualToString:JUDURLLocalScheme];
}

@end
