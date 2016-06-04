//
//  ZHWebView.h
//  ZHWebView
//
//  Created by AdminZhiHua on 16/6/3.
//  Copyright © 2016年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol ZHWebViewDelegate <NSObject>

@optional
- (BOOL)ZHWebView:(UIView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)ZHWebViewDidStartLoad:(UIView *)webView;

- (void)ZHWebViewDidFinishLoad:(UIView *)webView;

- (void)ZHWebView:(UIView *)webView didFailLoadWithError:(NSError *)error;

//@required
//iOS8以后需要实现,否则不会弹窗
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler ;

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler;

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler;

@end

@interface ZHWebView : UIView

@property (nonatomic,assign) BOOL iOS8_OR_LATER;

@property (nonatomic,strong) UIView *webView;

@property (nonatomic,weak) id<ZHWebViewDelegate> delegate;

//是否显示加载进度条-》默认NO
@property (nonatomic,assign) BOOL shouldShowProgressView;
//进度条的颜色->默认是orange
@property (nonatomic,strong) UIColor *progressColor;

@property (nonatomic, readonly, strong) UIScrollView *scrollView;

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;

@property (nonatomic, readonly, strong) NSURLRequest *request;

- (void)reload;
- (void)stopLoading;

- (void)goBack;
- (void)goForward;

@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

- (void)evaluatingJavaScriptFromString:(NSString *)js completionHandler:(void (^)(id, NSError *))completionHandler;

@property (nonatomic) BOOL scalesPageToFit;

@end
