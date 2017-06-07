/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDImageComponent.h"
#import "JUDHandlerFactory.h"
#import "JUDComponent_internal.h"
#import "JUDImgLoaderProtocol.h"
#import "JUDLayer.h"
#import "JUDType.h"
#import "JUDConvert.h"
#import "JUDURLRewriteProtocol.h"

@interface JUDImageView : UIImageView

@end

@implementation JUDImageView

+ (Class)layerClass
{
    return [JUDLayer class];
}

@end

static dispatch_queue_t JUDImageUpdateQueue;

@interface JUDImageComponent ()

@property (nonatomic, strong) NSString *imageSrc;
@property (nonatomic, strong) NSString *placeholdSrc;
@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, assign) UIViewContentMode resizeMode;
@property (nonatomic, assign) JUDImageQuality imageQuality;
@property (nonatomic, assign) JUDImageSharp imageSharp;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) id<JUDImageOperationProtocol> imageOperation;
@property (nonatomic, strong) id<JUDImageOperationProtocol> placeholderOperation;
@property (nonatomic) BOOL imageLoadEvent;
@property (nonatomic) BOOL imageDownloadFinish;

@end

@implementation JUDImageComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance]) {
        _async = YES;
        if (!JUDImageUpdateQueue) {
            JUDImageUpdateQueue = dispatch_queue_create("com.jingdong.jud.ImageUpdateQueue", DISPATCH_QUEUE_SERIAL);
        }
        if (attributes[@"src"]) {
            _imageSrc = [[JUDConvert NSString:attributes[@"src"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else {
            JUDLogWarning(@"image src is nil");
        }
        [self configPlaceHolder:attributes];
        _resizeMode = [JUDConvert UIViewContentMode:attributes[@"resize"]];
        [self configFilter:styles];
        _imageQuality = [JUDConvert JUDImageQuality:styles[@"quality"]];
        _imageSharp = [JUDConvert JUDImageSharp:styles[@"sharpen"]];
        _imageLoadEvent = NO;
        _imageDownloadFinish = NO;
    }
    
    return self;
}

- (void)configPlaceHolder:(NSDictionary*)attributes {
    if (attributes[@"placeHolder"] || attributes[@"placeholder"]) {
        _placeholdSrc = [[JUDConvert NSString:attributes[@"placeHolder"]?:attributes[@"placeholder"]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

- (void)configFilter:(NSDictionary *)styles {
    if (styles[@"filter"]) {
        NSString *filter = styles[@"filter"];
        
        NSString *pattern = @"blur\\((\\d+)(px)?\\)";
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *matches = [regex matchesInString:filter options:0 range:NSMakeRange(0, filter.length)];
        if (matches && matches.count > 0) {
            NSTextCheckingResult *match = matches[matches.count - 1];
            NSRange matchRange = [match rangeAtIndex:1];
            NSString *matchString = [filter substringWithRange:matchRange];
            if (matchString && matchString.length > 0) {
                _blurRadius = [matchString doubleValue];
            }
        }
    }
}

- (UIView *)loadView
{
    return [[JUDImageView alloc] init];
}

- (void)addEvent:(NSString *)eventName {
    if ([eventName isEqualToString:@"load"]) {
        _imageLoadEvent = YES;
    }
}

- (void)removeEvent:(NSString *)eventName {
    if ([eventName isEqualToString:@"load"]) {
        _imageLoadEvent = NO;
    }
}

- (void)updateStyles:(NSDictionary *)styles
{
    if (styles[@"quality"]) {
        _imageQuality = [JUDConvert JUDImageQuality:styles[@"quality"]];
        [self updateImage];
    }
    
    if (styles[@"sharpen"]) {
        _imageSharp = [JUDConvert JUDImageSharp:styles[@"sharpen"]];
        [self updateImage];
    }
    [self configFilter:styles];
}

- (void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"src"]) {
        _imageSrc = [[JUDConvert NSString:attributes[@"src"]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self updateImage];
    }
    
    [self configPlaceHolder:attributes];
    
    if (attributes[@"resize"]) {
        _resizeMode = [JUDConvert UIViewContentMode:attributes[@"resize"]];
        self.view.contentMode = _resizeMode;
    }
}

- (void)viewDidLoad
{
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.contentMode = _resizeMode;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    imageView.exclusiveTouch = YES;
    
    [self updateImage];
    
}

- (JUDDisplayBlock)displayBlock
{
    if ([self isViewLoaded]) {
        // if has a image view, image is setted by image view, displayBlock is not needed
        return nil;
    }
    
    __weak typeof(self) weakSelf = self;
    return ^UIImage *(CGRect bounds, BOOL(^isCancelled)(void)) {
        if (isCancelled()) {
            return nil;
        }
        
        if (!weakSelf.image) {
            [weakSelf updateImage];
            return nil;
        }
        
        if (isCancelled && isCancelled()) {
            return nil;
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, self.layer.opaque, 1.0);
        
        [weakSelf.image drawInRect:bounds];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image;
    };
}

- (void)viewWillUnload
{
    [super viewWillUnload];
    [self cancelImage];
    _image = nil;
}

- (void)setImageSrc:(NSString*)src
{
    if (![src isEqualToString:_imageSrc]) {
        _imageSrc = src;
        _imageDownloadFinish = NO;
        [self updateImage];
    }
}

- (void)updateImage
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(JUDImageUpdateQueue, ^{
        [self cancelImage];
       
        void(^downloadFailed)(NSString *, NSError *) = ^void(NSString *url, NSError *error) {
            weakSelf.imageDownloadFinish = YES;
            JUDLogError(@"Error downloading image: %@, detail:%@", url, [error localizedDescription]);
        };
        
        [self updatePlaceHolderWithFailedBlock:downloadFailed];
        [self updateContentImageWithFailedBlock:downloadFailed];
        
        if (!weakSelf.imageSrc && !weakSelf.placeholdSrc) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.layer.contents = nil;
                weakSelf.imageDownloadFinish = YES;
                [weakSelf readyToRender];
            });
        }
    });
}

- (void)updatePlaceHolderWithFailedBlock:(void(^)(NSString *, NSError *))downloadFailedBlock
{
    NSString *placeholderSrc = self.placeholdSrc;
    
    if (placeholderSrc) {
        JUDLogDebug(@"Updating image, component:%@, placeholder:%@ ", self.ref, placeholderSrc);
        NSMutableString *newURL = [_placeholdSrc mutableCopy];
        JUD_REWRITE_URL(_placeholdSrc, JUDResourceTypeImage, self.judInstance, &newURL)
        
        __weak typeof(self) weakSelf = self;
        self.placeholderOperation = [[self imageLoader] downloadImageWithURL:newURL imageFrame:self.calculatedFrame userInfo:nil completed:^(UIImage *image, NSError *error, BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(self) strongSelf = weakSelf;
                UIImage *viewImage = ((UIImageView *)strongSelf.view).image;
                if (error) {
                    downloadFailedBlock(placeholderSrc,error);
                    if ([strongSelf isViewLoaded] && !viewImage) {
                        ((UIImageView *)(strongSelf.view)).image = nil;
                        [self readyToRender];
                    }
                    return;
                }
                if (![placeholderSrc isEqualToString:strongSelf.placeholdSrc]) {
                    return;
                }
                
                if ([strongSelf isViewLoaded] && !viewImage) {
                    ((UIImageView *)strongSelf.view).image = image;
                    weakSelf.imageDownloadFinish = YES;
                    [self readyToRender];
                }
            });
        }];
    }
}

- (void)updateContentImageWithFailedBlock:(void(^)(NSString *, NSError *))downloadFailedBlock
{
    NSString *imageSrc = self.imageSrc;
    if (imageSrc) {
        JUDLogDebug(@"Updating image:%@, component:%@", self.imageSrc, self.ref);
        NSDictionary *userInfo = @{@"imageQuality":@(self.imageQuality), @"imageSharp":@(self.imageSharp), @"blurRadius":@(self.blurRadius)};
        NSMutableString * newURL = [imageSrc mutableCopy];
        JUD_REWRITE_URL(imageSrc, JUDResourceTypeImage, self.judInstance, &newURL)
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageOperation = [[weakSelf imageLoader] downloadImageWithURL:newURL imageFrame:weakSelf.calculatedFrame userInfo:userInfo completed:^(UIImage *image, NSError *error, BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong typeof(self) strongSelf = weakSelf;
                    
                    if (weakSelf.imageLoadEvent) {
                        NSMutableDictionary *sizeDict = [NSMutableDictionary new];
                        sizeDict[@"naturalWidth"] = @(image.size.width * image.scale);
                        sizeDict[@"naturalHeight"] = @(image.size.height * image.scale);
                        [strongSelf fireEvent:@"load" params:@{ @"success": error? @false : @true,@"size":sizeDict}];
                    }
                    if (error) {
                        downloadFailedBlock(imageSrc, error);
                        [strongSelf readyToRender];
                        return ;
                    }
                    
                    if (![imageSrc isEqualToString:strongSelf.imageSrc]) {
                        return ;
                    }
                    if ([strongSelf isViewLoaded]) {
                        strongSelf.imageDownloadFinish = YES;
                        ((UIImageView *)strongSelf.view).image = image;
                        [strongSelf readyToRender];
                    }
                });
            }];
        });
    }
}

- (void)readyToRender
{
    // when image download completely (success or failed)
    if (self.judInstance.trackComponent && _imageDownloadFinish) {
        [super readyToRender];
    }
}

- (void)cancelImage
{
    [_imageOperation cancel];
    _imageOperation = nil;
    [_placeholderOperation cancel];
    _placeholderOperation = nil;
}

- (id<JUDImgLoaderProtocol>)imageLoader
{
    static id<JUDImgLoaderProtocol> imageLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        imageLoader = [JUDHandlerFactory handlerForProtocol:@protocol(JUDImgLoaderProtocol)];
    });
    return imageLoader;
}

- (BOOL)_needsDrawBorder
{
    return NO;
}

#ifdef UITEST
- (NSString *)description
{
    NSString *superDescription = super.description;
    NSRange semicolonRange = [superDescription rangeOfString:@";"];
    NSString *replacement = [NSString stringWithFormat:@"; imageSrc: %@; imageQuality: %@; imageSharp: %@; ",_imageSrc,_imageQuality,_imageSharp];
    return [superDescription stringByReplacingCharactersInRange:semicolonRange withString:replacement];
}
#endif

@end
