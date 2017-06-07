/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDRuleManager.h"
#import "JUDThreadSafeMutableDictionary.h"
#import "JUDUtility.h"
#import "JUDConvert.h"
#import "JUDHandlerFactory.h"
#import "JUDURLRewriteProtocol.h"
#import "JUDComponentManager.h"
#import "JUDDefine.h"

@interface JUDRuleManager()
@property (nonatomic, strong) JUDThreadSafeMutableDictionary *fontStorage;
@end

@implementation JUDRuleManager

static JUDRuleManager *_sharedInstance = nil;

+ (JUDRuleManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
            _sharedInstance.fontStorage = [[JUDThreadSafeMutableDictionary alloc] init];
        }
    });
    return _sharedInstance;
}

- (void)removeRule:(NSString *)type rule:(NSDictionary *)rule
{
    if ([type isEqualToString:@"fontFace"]) {
        if (rule[@"fontFamily"]) {
            [_fontStorage removeObjectForKey:rule[@"fontFamily"]];
        } else {
            [_fontStorage removeAllObjects];
        }
    }
}

- (void)addRule:(NSString*)type rule:(NSDictionary *)rule
{
    if ([type isEqualToString:@"fontFace"] && [rule[@"src"] isKindOfClass:[NSString class]]) {
        if (rule[@"src"] && rule[@"fontFamily"] && ![JUDUtility isBlankString:rule[@"src"]]) {
            NSString *ruleSrc = [JUDConvert NSString:rule[@"src"]];
            if (!ruleSrc) {
                JUDLogError(@"%@ is illegal for font src",rule[@"src"]);
                return;
            }
            NSUInteger start = [rule[@"src"] rangeOfString:@"url('"].location + @"url('".length;
            NSUInteger end  = [rule[@"src"] rangeOfString:@"')" options:NSBackwardsSearch].location;
            if (end <= start || start == NSNotFound || end == NSNotFound) {
                JUDLogWarning(@"font url is not specified");
                return;
            }
            
            NSString *fontSrc = [rule[@"src"] substringWithRange:NSMakeRange(start, end-start)];
            NSMutableString *newFontSrc = [fontSrc mutableCopy];
            JUD_REWRITE_URL(fontSrc, JUDResourceTypeFont, self.instance, &newFontSrc)
            
            if (!newFontSrc) {
                return;
            }
            
            fontSrc = newFontSrc;
            NSMutableDictionary * fontFamily = [self.fontStorage objectForKey:rule[@"fontFamily"]];
            if (fontFamily && [fontFamily[@"src"] isEqualToString:fontSrc]) {
                // if the new src is same as src in dictionary , ignore it, or update it
                return;
            }
            if (!fontFamily) {
                fontFamily = [NSMutableDictionary dictionary];
            }
            NSURL *fontURL = [NSURL URLWithString:fontSrc];
            if (!fontURL) {
                // if the fontSrc string is illegal, the fontURL will be nil
                return;
            }
            if([fontURL isFileURL]){
                [fontFamily setObject:fontSrc forKey:@"src"];
            }else {
                [fontFamily setObject:fontSrc forKey:@"tempSrc"];
            }
            
            [_fontStorage setObject:fontFamily forKey:rule[@"fontFamily"]];
            // remote font file
            NSString *fontfile = [NSString stringWithFormat:@"%@/%@",JUD_FONT_DOWNLOAD_DIR,[JUDUtility md5:[fontURL absoluteString]]];
            if ([JUDUtility isFileExist:fontfile]) {
                // if has been cached, load directly
                [fontFamily setObject:[NSURL fileURLWithPath:fontfile] forKey:@"localSrc"];
                return;
            }
            __weak typeof(self) weakSelf = self;
            [JUDUtility getIconfont:fontURL completion:^(NSURL * _Nonnull url, NSError * _Nullable error) {
                if (!error && url) {
                    // load success
                    NSMutableDictionary * dictForFontFamily = [weakSelf.fontStorage objectForKey:rule[@"fontFamily"]];
                    NSString *fontSrc = [dictForFontFamily objectForKey:@"tempSrc"];
                    [dictForFontFamily setObject:fontSrc forKey:@"src"];
                    [dictForFontFamily setObject:url forKey:@"localSrc"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:JUD_ICONFONT_DOWNLOAD_NOTIFICATION object:nil userInfo:@{@"fontFamily":rule[@"fontFamily"]}];
                } else {
                    //there was some errors during loading
                    JUDLogError(@"load font failed %@",error.description);
                }
            }];
        }
    }
}

- (JUDThreadSafeMutableDictionary *)getRule:(NSString *)type
{
    if ([type isEqualToString:@"fontFace"]) {
        return _fontStorage;
    }
    
    return nil;
}

@end
