//
//  ZHWebView.m
//  ZHWebView
//
//  Created by AdminZhiHua on 16/6/3.
//  Copyright © 2016年 AdminZhiHua. All rights reserved.
//

#import "ZHWebView.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#define JSObject @"mycs"

@interface ZHWebView () <UIWebViewDelegate,WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@property (nonatomic, strong) UIProgressView *wkProgressView;

@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation ZHWebView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
        [self addSubview:self.webView];
        
        //设置webview的大小
        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        self.shouldShowProgressView = NO;
        self.scalesPageToFit = YES;
        
    }
    return self;
}

#pragma mark - Public
- (void)loadRequest:(NSURLRequest *)request {
    
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [self setRequest:request];
        [webView loadRequest:request];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        [self setRequest:request];
        [webView loadRequest:request];
    }
    
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView loadHTMLString:string baseURL:baseURL];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView loadHTMLString:string baseURL:baseURL];
    }
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView loadData:data MIMEType:MIMEType characterEncodingName:textEncodingName baseURL:baseURL];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
    }
}

- (void)reload {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView reload];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView reload];
    }
}

- (void)stopLoading {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView stopLoading];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView stopLoading];
    }
}

- (void)goBack {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView goBack];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView goBack];
    }
}

- (void)goForward {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView goForward];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        [webView goForward];
    }
}

- (void)evaluatingJavaScriptFromString:(NSString *)js completionHandler:(void (^)(id, NSError *))completionHandler {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView evaluateJavaScript:js completionHandler:^(id content, NSError *error) {
            if (completionHandler)
            {
                completionHandler(content, error);
            }
        }];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        NSString *content = [webView stringByEvaluatingJavaScriptFromString:js];
        
        if (completionHandler)
        {
            completionHandler(content, nil);
        }
    }
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([self.delegate respondsToSelector:@selector(ZHWebView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate ZHWebView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidStartLoad:)]) {
        [self.delegate ZHWebViewDidStartLoad:webView];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.progressView setProgress:0 animated:YES];

    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidFinishLoad:)]) {
        [self.delegate ZHWebViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    if ([self.delegate respondsToSelector:@selector(ZHWebView:didFailLoadWithError:)]) {
        [self.delegate ZHWebView:webView didFailLoadWithError:error];
    }
}

#pragma mark - WKWebView的代理
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidStartLoad:)])
    {
        [self.delegate ZHWebViewDidStartLoad:webView];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if ([self.delegate respondsToSelector:@selector(ZHWebViewDidFinishLoad:)])
    {
        [self.delegate ZHWebViewDidFinishLoad:webView];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(ZHWebView:didFailLoadWithError:)])
    {
        [self.delegate ZHWebView:webView didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#pragma clang diagnostic pop
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    BOOL isAllow;
    
    if ([self.delegate respondsToSelector:@selector(ZHWebView:shouldStartLoadWithRequest:navigationType:)])
    {
        isAllow = [self.delegate ZHWebView:webView shouldStartLoadWithRequest:request navigationType:UIWebViewNavigationTypeLinkClicked];
    }
    else
    {
        isAllow = YES;
    }
    
    WKNavigationActionPolicy allow = isAllow ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;
    
    decisionHandler(allow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    if ([self.delegate respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.delegate webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    if ([self.delegate respondsToSelector:@selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.delegate webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    
    if ([self.delegate respondsToSelector:@selector(webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
        [self.delegate webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
    }
    
}

// 防止在HTML <a> 中的 target="_blank"不发生响应
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame)
    {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

#pragma mark - JAVAScript
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
    
}

#pragma mark - NJKWebViewProgressDelegate
- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    //先判断是否显示
    [self.progressView setProgress:progress animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    
    WKWebView *webView = (WKWebView *)self.webView;
    
    if ([keyPath isEqualToString:@"loading"])
    {
    }
    if ([keyPath isEqualToString:@"title"])
    {
    }
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.wkProgressView.alpha    = 1;
        self.wkProgressView.progress = webView.estimatedProgress;
    }
    
    //加载完成
    if (!webView.isLoading)
    {
        [self hideWKProgressView];
    }
}

- (void)hideWKProgressView {
    //不显示进度条，返回
    [UIView animateWithDuration:0.5 animations:^{
        self.wkProgressView.alpha = 0;
    }];
}

#pragma mark - Getter&Setter
- (BOOL)iOS8_OR_LATER {
    if (!_iOS8_OR_LATER) {
        _iOS8_OR_LATER = [[[UIDevice currentDevice] systemVersion] compare:@"18.0" options:NSNumericSearch] != NSOrderedAscending;
    }
    return _iOS8_OR_LATER;
}

- (UIView *)webView {
    if (!_webView) {
        if (self.iOS8_OR_LATER) {
            WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:[self wkWebViewConfiguration]];
            _webView = webView;
            webView.UIDelegate = self;
            webView.navigationDelegate = self;
            [self installObserver];
        }
        else
        {
            UIWebView *webView = [UIWebView new];
            _webView = webView;
            _webView.frame = self.bounds;
            webView.delegate = self;
        }
    }
    return _webView;
}

- (WKWebViewConfiguration *)wkWebViewConfiguration {
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    
    configuration.preferences                   = [WKPreferences new];
    configuration.preferences.minimumFontSize   = 10;
    configuration.preferences.javaScriptEnabled = YES;
    
    configuration.processPool = [WKProcessPool new];
    
    configuration.userContentController = [WKUserContentController new];
    [configuration.userContentController addScriptMessageHandler:self name:JSObject];
    
    return configuration;
}

- (void)installObserver {
    
    WKWebView *webView = (WKWebView *)self.webView;
    
    [webView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setShouldShowProgressView:(BOOL)shouldShowProgressView {
    _shouldShowProgressView = shouldShowProgressView;
    
    if (!shouldShowProgressView) {
        //隐藏progressview
        self.iOS8_OR_LATER ? (self.wkProgressView.hidden = YES) : (self.progressView.hidden = YES);
        
        return;
    }
    
    //显示progressview
    if (!self.iOS8_OR_LATER)
    {
        UIWebView *webView = (UIWebView *)self.webView;
        webView.delegate = self.progressProxy;
        self.progressView.hidden = NO;
    }
    else
    {
        self.wkProgressView.hidden = NO;
    }
    
}

- (NJKWebViewProgress *)progressProxy {
    if (!_progressProxy)
    {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = (id)self;
        _progressProxy.progressDelegate = (id)self;
    }
    
    return _progressProxy;
}

- (NJKWebViewProgressView *)progressView {
    if (!_progressView)
    {
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectZero];
        _progressView.progressColor = [UIColor orangeColor];
        
        [_progressView setProgress:0.0 animated:NO];

        [self addConstToProgressView:_progressView];
    }
    
    return _progressView;
}

- (UIProgressView *)wkProgressView {
    if (!_wkProgressView)
    {
        _wkProgressView = [[UIProgressView alloc] init];
        
        _wkProgressView.frame = CGRectZero;
        
        _wkProgressView.progressTintColor = [UIColor orangeColor];
        _wkProgressView.trackTintColor    = [UIColor whiteColor];
        
        [self addConstToProgressView:_wkProgressView];
    }
    
    return _wkProgressView;
}

- (void)addConstToProgressView:(UIView *)view {
    
    [self insertSubview:view aboveSubview:self.webView];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hVFL = @"H:|-(0)-[view]-(0)-|";
    NSString *vVFL = @"V:|-(0)-[view(3)]";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
    [self addConstraints:hConsts];
    [self addConstraints:vConsts];
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    
    self.iOS8_OR_LATER ? (self.wkProgressView.progressTintColor = progressColor) : (self.progressView.progressColor = progressColor);
    
}

- (UIScrollView *)scrollView {
    if (self.iOS8_OR_LATER) {
        WKWebView *webView = (WKWebView *)self.webView;
        return webView.scrollView;
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        return webView.scrollView;
    }
}

- (void)setRequest:(NSURLRequest *)request {
    _request = request;
}

- (BOOL)canGoBack {
    if (self.iOS8_OR_LATER) {
        WKWebView *webView = (WKWebView *)self.webView;
        return [webView canGoBack];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        return [webView canGoBack];
    }
}

- (BOOL)canGoForward {
    if (self.iOS8_OR_LATER) {
        WKWebView *webView = (WKWebView *)self.webView;
        return [webView canGoForward];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        return [webView canGoForward];
    }
}

- (BOOL)isLoading {
    if (self.iOS8_OR_LATER)
    {
        WKWebView *webView = (WKWebView *)self.webView;
        return [webView isLoading];
    }
    else
    {
        UIWebView *webView = (UIWebView *)self.webView;
        return [webView isLoading];
    }
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit {
    if (!self.iOS8_OR_LATER)
    {
        UIWebView *webView = (UIWebView *)self.webView;
        webView.scalesPageToFit = scalesPageToFit;
    }
}

- (void)setJSExportObject:(id<JSExportDelegate>)JSExportObject {
    _JSExportObject = JSExportObject;
    
    if (self.iOS8_OR_LATER) return;
    
    UIWebView *webView = (UIWebView *)self.webView;
    
    self.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[JSObject] = JSExportObject;
    
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

@end
