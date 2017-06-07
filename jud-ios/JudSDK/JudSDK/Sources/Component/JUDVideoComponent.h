/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDComponent.h"

typedef NS_ENUM(NSInteger, JUDPlaybackState) {
    JUDPlaybackStatePlaying,
    JUDPlaybackStatePaused,
    //    JUDPlaybackStateStopped,
    JUDPlaybackStatePlayFinish,
    JUDPlaybackStateFailed,
};

@interface JUDVideoView : UIView

@property (nonatomic, copy) void (^playbackStateChanged)(JUDPlaybackState state);

- (void) setURL:(NSURL*)URL;

- (void) play;
- (void) pause;

@end

@interface JUDVideoComponent : JUDComponent

@end


