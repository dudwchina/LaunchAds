//
//  UILaunchView.m
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#import "UILaunchView.h"
#import "AppDelegate.h"

@implementation UILaunchView

+ (UIImage *)getLaunchImage {
    // 获取Assets.xcassets中launchImage
    CGSize viewSize = [[UIApplication sharedApplication] keyWindow].frame.size;
    NSString *viewOrientation = @"Portrait"; //横屏请设置成 @”Landscape”
    NSString *launchImage = nil;
    // build后app包里面有一个info.plist，其中有个UIlaunchImages的array
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}

@end
