//
//  CommonMacro.h
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#ifndef CommonMacro_h
#define CommonMacro_h

#define KScreenHeight           ([[UIScreen mainScreen] bounds].size.height)
#define KScreenWidth            ([[UIScreen mainScreen] bounds].size.width)

#define COLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define KLaunchAdsAction @"KLaunchAdsAction"

#ifdef DEBUG
#   define NSLog(format, ...) printf("\n[%s]: %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else
#   define NSLog(format, ...)
#endif
#endif /* CommonMacro_h */
