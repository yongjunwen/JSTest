//
//  JUDImgLoaderDefaultImpl.m

#import "JUDImgLoaderDefaultImpl.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define MIN_IMAGE_WIDTH 36
#define MIN_IMAGE_HEIGHT 36


#if OS_OBJECT_USE_OBJC
#undef  JUDDispatchQueueRelease
#undef  JUDDispatchQueueSetterSementics
#define JUDDispatchQueueRelease(q)
#define JUDDispatchQueueSetterSementics strong
#else
#undef  JUDDispatchQueueRelease
#undef  JUDDispatchQueueSetterSementics
#define JUDDispatchQueueRelease(q) (dispatch_release(q))
#define JUDDispatchQueueSetterSementics assign
#endif

@interface JUDImgLoaderDefaultImpl()

@property (JUDDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

@end

@implementation JUDImgLoaderDefaultImpl

#pragma mark -
#pragma mark JUDImgLoaderProtocol

- (id<JUDImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)userInfo completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock
{
    if ([url hasPrefix:@"//"]) {
        url = [@"http:" stringByAppendingString:url];
    }
    return (id<JUDImageOperationProtocol>)[[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, finished);
        }
    }];
}

@end
