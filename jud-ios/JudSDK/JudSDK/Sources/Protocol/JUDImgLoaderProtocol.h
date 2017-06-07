/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDModuleProtocol.h"
#import "JUDType.h"

@protocol JUDImageOperationProtocol <NSObject>

- (void)cancel;

@end

@protocol JUDImgLoaderProtocol <JUDModuleProtocol>

/**
 * @abstract Creates a image download handler with a given URL
 *
 * @param url The URL of the image to download
 *
 * @param imageFrame  The frame of the image you want to set
 *
 * @param options : The options to be used for this download
 *
 * @param completedBlock : A block called once the download is completed.
 *                 image : the image which has been download to local.
 *                 error : the error which has happened in download.
 *              finished : a Boolean value indicating whether download action has finished.
 */
- (id<JUDImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)options completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock;

@end
