//
//  LaunchAd.m
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#import "LaunchAd.h"

@implementation LaunchAdItem

@end

@implementation LaunchAd
- (NSString *)requestUrl {
    return @"banner/getLauncherInfo";
}

- (void)getLaunchInfoList:(Completed)complete failure:(Failure)failure {
    
//    {
//        action = "\U2018\U2019";
//        adType = image;
//        duration = 3000;
//        endTime = "2018-01-03 23:59:00.0";
//        id = 2;
//        osType = 3;
//        startTime = "2017-12-27 11:03:00.0";
//        title = "2018\U5143\U65e6";
//        url = "https://xiaofanapp.finupgroup.com/xiaofan/launchFile/20171227112239.jpg";
//    }
    
    // TODO 从网络请求数据
    LaunchAdItem *imageItem = [[LaunchAdItem alloc] init];
    imageItem.adType = @"image";
    imageItem.duration = 5000;
    imageItem.url = @"https://developer.apple.com/iphone/images/iphone-hero_2x.png";
    
//    LaunchAdItem *videoItem = [[LaunchAdItem alloc] init];
    NSArray<LaunchAdItem *> *launcherInfoList = @[imageItem];
    LaunchAdResponse *resp = [[LaunchAdResponse alloc] init];
    resp.launcherInfoList = launcherInfoList;
    !complete ? : complete(resp);

}
    
@end

@implementation LaunchAdResponse
//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"launcherInfoList" : @"LaunchAdItem"};
//}
@end
