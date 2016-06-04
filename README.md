### ZHWebView

为了解决UIWebView系统占用内存过大的问题，苹果官方新出了WebKit框架。WKWebView在性能方面比UIWebView好多，并且WKWebView可以通过KVO监听网页加载的进度。然而WKWeView也有缺陷，就是不支持离线缓存。

ZHWebView是为了兼容iOS7,是对UIWebView和WKWebView的封装。在iOS8以上的系统会自动选择WKWebView，API的设计参考UIWebView的API。

新特性：

* 添加加载进度的显示
* 根据系统版本选择UIWebView或者WKWebView



#### 部分API

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
