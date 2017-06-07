/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import <JudSDK/JudSDK.h>
#import "JUDCanvasModule.h"
#import <GLKit/GLKit.h>

@interface JUDCanvasComponent : JUDComponent <GLKViewDelegate>

- (void) addDrawActions:(NSArray *)actions canvasModule:(JUDCanvasModule*)canvasModule;

@end
