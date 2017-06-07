/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDCanvasModule.h"
#import "JUDCanvasComponent.h"
#import "JUDSDKManager.h"
#import "JUDSDKInstance_private.h"
#import "JUDUtility.h"

@interface JUDCanvasModule()
@property (nonatomic, strong) NSMutableDictionary *cacheMap;
@property (nonatomic, strong) EAGLContext *glcontext;
@end

@implementation JUDCanvasModule

@synthesize judInstance;

JUD_EXPORT_METHOD(@selector(addDrawActions:actions:))
JUD_EXPORT_METHOD(@selector(initTexture:callbackId:))

- (instancetype) init
{
    _cacheMap = [NSMutableDictionary new];
    _glcontext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glcontext];
    return [super init];
}

- (void) dealloc
{
    [_cacheMap removeAllObjects];
    _cacheMap = nil;
}

- (void)performBlockWithCanvas:(NSString *)elemRef block:(void (^)(JUDCanvasComponent *))block
{
    if (!elemRef) {
        return;
    }

    __weak typeof(self) weakSelf = self;

    JUDPerformBlockOnComponentThread(^{
        JUDCanvasComponent *canvas = (JUDCanvasComponent *)[weakSelf.judInstance componentForRef:elemRef];
        if (!canvas) {
            return;
        }

        [weakSelf performSelectorOnMainThread:@selector(doBlock:) withObject:^() {
            block(canvas);
        } waitUntilDone:NO];
    });
}


- (void)doBlock:(void (^)())block
{
    block();
}

- (void)addDrawActions:(NSString *)elemRef actions:(NSArray *)actions
{
    [self performBlockWithCanvas:elemRef block:^(JUDCanvasComponent *canvas) {
        [canvas addDrawActions:actions canvasModule:self];
    }];
}


-(UIImage *) getImage:(NSString *)imageURL {
    NSString *key = [NSString stringWithFormat:@"image~%@", imageURL];
    if ([_cacheMap objectForKey:key]) {
        return (UIImage *)[_cacheMap objectForKey:key];
    }
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];

    if (image != nil) {
        [_cacheMap setObject:image forKey:key];
    }
    return image;
}

-(void) initTexture:(NSString *)imgURL callbackId:(NSInteger)callbackId
{
    __weak typeof(self) weakSelf = self;
    JUDPerformBlockOnComponentThread(^{
        UIImage *image = [weakSelf getImage:imgURL];
        NSDictionary *data = @{
                               @"url": imgURL,
                               @"width": @(image.size.width),
                               @"height": @(image.size.height)
                               };

        [[JUDSDKManager bridgeMgr] callBack:self.judInstance.instanceId funcId:[@(callbackId) stringValue] params:[JUDUtility JSONString:data]];
    });
}

@end
