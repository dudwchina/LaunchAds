//
//  LaunchPlayer.h
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LaunchPlayer : NSObject
@property (nonatomic, strong) AVPlayerLayer *currentPlayerLayer;
+ (instancetype)sharedInstance;
- (void)playWithURL:(NSURL *)url showView:(UIView *)showView;
- (void)stopPlay;
@end
