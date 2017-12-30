//
//  LaunchAd.h
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Completed)(id obj);
typedef void (^Success)(void);
typedef void (^Failure)(NSError *error);

/**
 启动页对象
 */
@interface LaunchAdItem : NSObject
/**标题*/
@property (nonatomic, copy) NSString *title;
/**开始时间*/
@property (nonatomic, copy) NSString *startTime;
/**结束时间*/
@property (nonatomic, copy) NSString *endTime;
/**持续时间*/
@property (nonatomic, assign) long duration;
/**图片url*/
@property (nonatomic, copy) NSString *url;
/**跳转url*/
@property (nonatomic, copy) NSString *action;
/**广告类型：图片、视频等*/
@property (nonatomic, copy) NSString *adType;
/**操作系统类型：iOS、安卓等*/
@property (nonatomic, copy) NSString *osType;
@end

@interface LaunchAd : NSObject
- (void)getLaunchInfoList:(Completed)complete failure:(Failure)failure;
@end

@interface LaunchAdResponse : NSObject
@property (nonatomic, strong) NSArray<LaunchAdItem *> *launcherInfoList;
@end


