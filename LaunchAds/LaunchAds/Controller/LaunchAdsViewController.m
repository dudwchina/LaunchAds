//
//  LaunchAdsViewController.m
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#import "CommonMacro.h"
#import "LaunchAdsViewController.h"
#import "LaunchAd.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import "UILaunchView.h"
#import "LaunchPlayer.h"

@interface LaunchAdsViewController ()

/**广告页图片*/
@property (nonatomic, strong) FLAnimatedImageView *adImageView;
/**跳过按钮*/
@property (nonatomic, strong) UIButton *skipBtn;
/**需要展示的广告数据*/
@property (nonatomic, strong) NSArray<LaunchAdItem *> *launchAds;
/**当前显示广告的索引*/
@property (nonatomic, assign) NSInteger currentIndex;
/**缓存除第一张之外的广告图*/
@property (nonatomic, strong) NSMutableArray<UIImage *> *cachedImage;
@end

@implementation LaunchAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = 0;
    self.cachedImage = [NSMutableArray array];
    [self.view addSubview:self.adImageView];
    
    LaunchAd *launchReq = [[LaunchAd alloc] init];
    [launchReq getLaunchInfoList:^(LaunchAdResponse *resp) {
        self.launchAds = resp.launcherInfoList;
        
        if (self.launchAds.count == 0 || !self.launchAds) {
            [self btnSkipAction:nil];
        } else {
            [self showAd:self.currentIndex];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(jumpAction)];
        [self.view addGestureRecognizer:tap];
    } failure:^(NSError *error) {
        [self btnSkipAction:nil];
    }];
}

- (void)showNext:(LaunchAdItem *)ad {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(ad.duration / 1000 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                           [self showAd:self.currentIndex];
    });
    
}

- (void)showAd:(NSInteger)currentIndex {
    if (self.currentIndex > self.launchAds.count - 1) {
        [self btnSkipAction:nil];
        return;
    }
    
    LaunchAdItem *ad = self.launchAds[currentIndex];
    
    // 显示图片
    if ([ad.adType isEqualToString:@"image"]) {
        if ([LaunchPlayer sharedInstance].currentPlayerLayer) {
            [[LaunchPlayer sharedInstance].currentPlayerLayer removeFromSuperlayer];
        }
        UIImage *placeholderImage;
        if (currentIndex == 0) {
            placeholderImage = [UILaunchView getLaunchImage];
        } else {
            placeholderImage = self.cachedImage.lastObject;
        }
        
        __weak typeof(self) weakSelf = self;
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:ad.url]
                            placeholderImage:placeholderImage
                                     options:SDWebImageProgressiveDownload
                                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                       if (weakSelf.currentIndex == 0) {
                                           [weakSelf.view addSubview:self.skipBtn];
                                       }
                                       
                                       if (image && !error) {
                                           
                                           [weakSelf.cachedImage addObject:image];
                                       }
                                       self.currentIndex++;
                                       [weakSelf showNext:ad];
                                   }];
    } else if ([ad.adType isEqualToString:@"video"]) { // 显示视频
        
        [[LaunchPlayer sharedInstance] playWithURL:[NSURL URLWithString:ad.url]
                                            showView:self.view];

        if (self.currentIndex == 0) {
            [self.view addSubview:self.skipBtn];
        }
       self.currentIndex++;
       [self showNext:ad];
    }
    
}

- (FLAnimatedImageView *)adImageView {
    if (_adImageView) {
        return _adImageView;
    }
    _adImageView = [[FLAnimatedImageView alloc] init];
    _adImageView.frame = self.view.bounds;
    _adImageView.contentMode = UIViewContentModeScaleAspectFill;
    _adImageView.image = [UILaunchView getLaunchImage];
    return _adImageView;
}

- (UIButton *)skipBtn {
    if (_skipBtn) {
        return _skipBtn;
    }
    _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _skipBtn.frame = CGRectMake(KScreenWidth - 50 - 15, 28, 50, 27);
    _skipBtn.layer.cornerRadius = 14.f;
    _skipBtn.clipsToBounds = YES;
    _skipBtn.backgroundColor = COLOR(0, 0, 0, 0.3);
    NSDictionary *attrDic = @{
                              NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                              NSForegroundColorAttributeName : COLOR(255, 255, 255, 1)
                              };
    NSAttributedString *msg = [[NSAttributedString alloc] initWithString:@"跳过" attributes:attrDic];
    [_skipBtn setAttributedTitle:msg forState:UIControlStateNormal];
    [_skipBtn addTarget:self action:@selector(btnSkipAction:) forControlEvents:UIControlEventTouchUpInside];
    return _skipBtn;
}

- (void)btnSkipAction:(UIButton *)sender {
    [self stopVideo];
    self.currentIndex = NSIntegerMax;
    [self showMainVc];
}
- (void)jumpAction {
    [self stopVideo];
    if (self.currentIndex == NSIntegerMax) {
        return;
    }
    
    [self showMainVc];
    
    NSInteger index = self.currentIndex - 1;
    if (index < 0 || index > self.launchAds.count - 1) {
        return;
    }
    
    NSString *action = self.launchAds[index].action;
    if (!action || action.length == 0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:action forKey:KLaunchAdsAction];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.currentIndex = NSIntegerMax;
}

- (void)stopVideo {
    [[LaunchPlayer sharedInstance] stopPlay];
}
- (void)showMainVc {
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.cachedImage removeAllObjects];
}

@end
