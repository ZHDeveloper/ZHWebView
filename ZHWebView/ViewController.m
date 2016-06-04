//
//  ViewController.m
//  ZHWebView
//
//  Created by AdminZhiHua on 16/6/3.
//  Copyright © 2016年 AdminZhiHua. All rights reserved.
//

#import "ViewController.h"
#import "ZHWebView.h"

#define ScreenSize [UIScreen mainScreen].bounds.size
#define ScreenWidth ScreenSize.width
#define ScreenHeight ScreenSize.height

@interface ViewController () <ZHWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHWebView *view = [ZHWebView new];
    view.frame = self.view.bounds;
    
    [self.view addSubview:view];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [view loadRequest:request];
    
    view.shouldShowProgressView = YES;
    
    view.delegate = self;
    
    view.progressColor = [UIColor blueColor];
    
}

#pragma mark - ZHWebViewDelegate
- (BOOL)ZHWebView:(UIView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)ZHWebViewDidStartLoad:(UIView *)webView {
    NSLog(@"开始加载");
}

- (void)ZHWebViewDidFinishLoad:(UIView *)webView {
    NSLog(@"完成加载");
}

- (void)ZHWebView:(UIView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"加载失败");
}


@end
