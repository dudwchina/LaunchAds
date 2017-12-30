//
//  LaunchPlayer.m
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#import "LaunchPlayer.h"
@interface LaunchPlayer()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
@property (nonatomic, strong) UIView *showView;
@end

@implementation LaunchPlayer

+ (instancetype)sharedInstance {
    static LaunchPlayer *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)playWithURL:(NSURL *)url showView:(UIView *)showView {
    
    [self.player pause];
    [self resetPlayer];
    
    self.showView = showView;
    
    self.currentPlayerItem = [[AVPlayerItem alloc] initWithURL:url];
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    }
    
    self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.currentPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.currentPlayerLayer.frame = showView.bounds;
    
    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterForeground) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playItemDidPlayToEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayerItem];
}


- (void)resetPlayer {
    if (!self.currentPlayerItem) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status"];
}

- (void)pause {
    if (!self.currentPlayerItem) {
        return;
    }
    [self.player pause];
}

- (void)resume {
    if (!self.currentPlayerItem) {
        return;
    }
    
    [self.player play];
}

- (void)replay {
    if (!self.currentPlayerItem) {
        return;
    }
    [self.player pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC)
          completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

- (void)stop {
    [self.player pause];
    [self resetPlayer];
}

- (void)stopPlay {
    [self.player pause];
    [self.currentPlayerLayer removeFromSuperlayer];
}
- (void)appDidEnterBackground {
    [self pause];
}

- (void)appDidEnterForeground {
    [self resume];
}

- (void)playItemDidPlayToEnd {
    [self replay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.showView.layer insertSublayer:self.currentPlayerLayer
                                          below:self.showView.subviews.lastObject.layer];

            [self.player play];
        } else if (playerItem.status == AVPlayerStatusFailed || playerItem.status == AVPlayerItemStatusUnknown) {
            [self stop];
        }
    }
}
@end
