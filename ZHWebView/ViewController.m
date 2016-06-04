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

@interface ViewController () <ZHWebViewDelegate,JSExportDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZHWebView *view = [ZHWebView new];
    view.frame = self.view.bounds;
    
    [self.view addSubview:view];
    
    NSURL *fileURl = [[NSBundle mainBundle] URLForResource:@"UIWebView测试.html" withExtension:nil];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURl];
    
    [view loadRequest:request];
    
    view.shouldShowProgressView = YES;
    
    view.delegate = self;
    
    view.progressColor = [UIColor blueColor];
    
    view.JSExportObject = self;
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

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];

}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];

}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];

}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message.body);
}

// JS调用此方法来调用OC的系统相册方法
- (void)callSystemCamera {
    NSLog(@"%s",__func__);
}

// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
- (void)showAlert:(NSString *)title msg:(NSString *)msg {
    NSLog(@"%s",__func__);
}

// 通过JSON传过来
- (void)callWithDict:(NSDictionary *)params {
    NSLog(@"%s",__func__);
}

// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params {
    NSLog(@"%s",__func__);
}

@end
