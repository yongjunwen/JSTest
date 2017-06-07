/**
 * Created by JUD.
 * Copyright (c) 2017, JD, Inc. All rights reserved.
 */

#import "JUDVideoComponent.h"
#import "JUDHandlerFactory.h"
#import "JUDURLRewriteProtocol.h"

#import <AVFoundation/AVPlayer.h>
#import <AVKit/AVPlayerViewController.h>
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <AVFoundation/AVPlayerItem.h>

@interface JUDPlayer : NSObject

@end

@implementation JUDPlayer

@end

@interface JUDVideoView()

@property (nonatomic, strong) UIViewController* playerViewController;
@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic, strong) JUDSDKInstance* judSDKInstance;

@end

@implementation JUDVideoView

- (id)init
{
    if (self = [super init]) {
        if ([self greater8SysVer]) {
            _playerViewController = [AVPlayerViewController new];
            
        } else {
            _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:nil];
            MPMoviePlayerViewController *MPVC = (MPMoviePlayerViewController*)_playerViewController;
            MPVC.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
            MPVC.moviePlayer.shouldAutoplay = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playFinish)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:MPVC.moviePlayer];
            [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackStateDidChangeNotification object:MPVC.moviePlayer queue:nil usingBlock:^(NSNotification *notification)
             {
                 if (MPVC.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
                     if (_playbackStateChanged)
                         _playbackStateChanged(JUDPlaybackStatePlaying);
                 }
                 if (MPVC.moviePlayer.playbackState == MPMoviePlaybackStateStopped) {
                     //stopped
                 } if (MPVC.moviePlayer.playbackState == MPMoviePlaybackStatePaused) {
                     //paused
                     if (_playbackStateChanged) {
                         _playbackStateChanged(JUDPlaybackStatePaused);
                     }
                 } if (MPVC.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted) {
                     //interrupted
                 } if (MPVC.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward) {
                     //seeking forward
                 } if (MPVC.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward) {
                     //seeking backward
                 }
             }];
        }
        
        [self addSubview:_playerViewController.view];
    }
    return self;
}

- (void)dealloc
{
    _judSDKInstance = nil;
    if ([self greater8SysVer]) {
        AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
        [AVVC.player removeObserver:self forKeyPath:@"rate"];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object: _playerItem];
    }
    else {
        MPMoviePlayerViewController *MPVC = (MPMoviePlayerViewController*)_playerViewController;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:MPVC.moviePlayer];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:MPVC.moviePlayer];
    }
}

- (BOOL)greater8SysVer
{
    //return NO;
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    return [currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"rate"]) {
        float rate = [change[NSKeyValueChangeNewKey] floatValue];
        if (rate == 0.0) {
            if (_playbackStateChanged)
                _playbackStateChanged(JUDPlaybackStatePaused);
        } else if (rate == 1.0) {
            if (_playbackStateChanged)
                _playbackStateChanged(JUDPlaybackStatePlaying);
        } else if (rate == -1.0) {
            // Reverse playback
        }
    } else if ([keyPath isEqualToString:@"status"]) {
        NSInteger status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerStatusFailed) {
            if (_playbackStateChanged)
                _playbackStateChanged(JUDPlaybackStateFailed);
        }
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect videoFrame = frame;
    videoFrame.origin.x = 0;
    videoFrame.origin.y = 0;
    [_playerViewController.view setFrame:videoFrame];
}

- (void)setURL:(NSURL *)URL
{
    NSMutableString *urlStr = nil;
    JUD_REWRITE_URL(URL.absoluteString, JUDResourceTypeVideo, self.judSDKInstance, &urlStr)
    
    if (!urlStr) {
        return;
    }
    NSURL *newURL = [NSURL URLWithString:urlStr];
    if ([self greater8SysVer]) {
        
        AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
        if (AVVC.player && _playerItem) {
            [_playerItem removeObserver:self forKeyPath:@"status"];
            [AVVC.player removeObserver:self forKeyPath:@"rate"];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object: _playerItem];
        }
        _playerItem = [[AVPlayerItem alloc] initWithURL:newURL];
        AVPlayer *player = [AVPlayer playerWithPlayerItem: _playerItem];
        AVVC.player = player;
        
        [player addObserver:self
                 forKeyPath:@"rate"
                    options:NSKeyValueObservingOptionNew
                    context:NULL];
        
        [_playerItem addObserver:self
                     forKeyPath:@"status"
                        options:NSKeyValueObservingOptionNew
                        context:NULL];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object: _playerItem];
    }
    else {
        MPMoviePlayerViewController *MPVC = (MPMoviePlayerViewController*)_playerViewController;
        [MPVC moviePlayer].contentURL = newURL;
    }
}

- (void)playFinish
{
    if (_playbackStateChanged)
        _playbackStateChanged(JUDPlaybackStatePlayFinish);
    if ([self greater8SysVer]) {
        AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
        [[AVVC player] seekToTime:CMTimeMultiply([AVVC player].currentTime, 0)];
    } else {
        MPMoviePlayerViewController *MPVC = (MPMoviePlayerViewController*)_playerViewController;
        [[MPVC moviePlayer] stop];
    }
}

- (void)play
{
    if ([self greater8SysVer]) {
        AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;

        [[AVVC player] play];
    } else {
        MPMoviePlayerViewController *MPVC = (MPMoviePlayerViewController*)_playerViewController;
        [[MPVC moviePlayer] play];
    }
}

- (void)pause
{
    if ([self greater8SysVer]) {
        AVPlayerViewController *AVVC = (AVPlayerViewController*)_playerViewController;
        [[AVVC player] pause];
    } else {
        MPMoviePlayerViewController *MPVC = (MPMoviePlayerViewController*)_playerViewController;
        [[MPVC moviePlayer] pause];
    }
}

@end

@interface JUDVideoComponent()

@property (nonatomic, weak) JUDVideoView *videoView;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic) BOOL autoPlay;
@property (nonatomic) BOOL playStatus;

@end

@implementation JUDVideoComponent

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events judInstance:(JUDSDKInstance *)judInstance {
    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events judInstance:judInstance];
    if (self) {
        if (attributes[@"src"]) {
            _videoURL = [NSURL URLWithString: attributes[@"src"]];
        }
        if (attributes[@"autoPlay"]) {
            _autoPlay = [attributes[@"autoPlay"] boolValue];
        }
        if ([attributes[@"playStatus"] compare:@"play" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            _playStatus = true;
        }
        if ([attributes[@"playStatus"] compare:@"pause" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            _playStatus = false;
        }
    }
    return self;
}

-(UIView *)loadView
{
    JUDVideoView* videoView = [[JUDVideoView alloc] init];
    videoView.judSDKInstance = self.judInstance;
    
    return videoView;
}

-(void)viewDidLoad
{
    _videoView = (JUDVideoView *)self.view;
    [_videoView setURL:_videoURL];
    if (_playStatus) {
        [_videoView play];
    } else {
        [_videoView pause];
    }
    if (_autoPlay) {
        [_videoView play];
    }
    __weak __typeof__(self) weakSelf = self;
    _videoView.playbackStateChanged = ^(JUDPlaybackState state) {
        NSString *eventType = nil;
        switch (state) {
            case JUDPlaybackStatePlaying:
                eventType = @"start";
                break;
            case JUDPlaybackStatePaused:
                eventType = @"pause";
                break;
            case JUDPlaybackStatePlayFinish:
                eventType = @"finish";
                break;
            case JUDPlaybackStateFailed:
                eventType = @"fail";
                break;
                
            default:
                NSCAssert(NO, @"");
                break;
        }
        [weakSelf fireEvent:eventType params:nil];
    };
}

-(void)updateAttributes:(NSDictionary *)attributes
{
    if (attributes[@"src"]) {
        _videoURL = [NSURL URLWithString: attributes[@"src"]];
        [_videoView setURL:_videoURL];
    }
    if (attributes[@"autoPlay"]) {
        _autoPlay = [attributes[@"autoPlay"] boolValue];
        [_videoView play];
    }
    if ([attributes[@"playStatus"] compare:@"play" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        _playStatus = true;
        [_videoView play];
    }
    if ([attributes[@"playStatus"] compare:@"pause" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        _playStatus = false;
        [_videoView pause];
    }
}

@end
