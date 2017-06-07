//
//  JUDEventModule.m


#import "JUDEventModule.h"
#import "ViewController.h"
#import <JudSDK/JudSDK.h>
@implementation JUDEventModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(openURL:))

- (void)openURL:(NSString *)url
{
    NSString *newURL = url;
    if ([url hasPrefix:@"//"]) {
        newURL = [NSString stringWithFormat:@"http:%@", url];
    } else if (![url hasPrefix:@"http"]) {
        // relative path
        newURL = [NSURL URLWithString:url relativeToURL:judInstance.scriptURL].absoluteString;
    }
    
    UIViewController *controller = [[ViewController alloc] init];
    ((ViewController *)controller).url = [NSURL URLWithString:newURL];
    
    [[judInstance.viewController navigationController] pushViewController:controller animated:YES];
}

@end
