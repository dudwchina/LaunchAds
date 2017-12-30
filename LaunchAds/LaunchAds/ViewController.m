//
//  ViewController.m
//  LaunchAds
//
//  Created by dudw on 2017/12/30.
//  Copyright © 2017年 dudw. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "CommonMacro.h"

@interface ViewController ()<WKUIDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
   
    [self.view addSubview:self.webview];
    
    NSURL *url = [NSURL URLWithString:@"https://developer.apple.com/cn/ios/update-apps-for-iphone-x/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}

- (WKWebView *)webview {
    if (_webview) {
        return _webview;
    }
    
    CGFloat naviH = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusH = [UIApplication sharedApplication].statusBarFrame.size.height;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, naviH + statusH, KScreenWidth, KScreenHeight) configuration:config];
    _webview.UIDelegate = self;
    return _webview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
