### [ZHWebView](https://github.com/ZHDeveloper/ZHWebView)

为了解决UIWebView系统占用内存过大的问题，苹果官方新出了WebKit框架。WKWebView在性能方面比UIWebView好多，并且WKWebView可以通过KVO监听网页加载的进度。然而WKWeView也有缺陷，就是不支持离线缓存。

ZHWebView是为了兼容iOS7,是对UIWebView和WKWebView的封装。在iOS8以上的系统会自动选择WKWebView，API的设计参考UIWebView的API。使用前需要导入`WebKit`和`JavaScriptCore`框架

新特性：

* 添加加载进度的显示
* 根据系统版本选择UIWebView或者WKWebView
* 添加WebView与JS的交互

#### UIWebView与js的交互
设置步骤

1. ZHWebView.h文件中的JSExportDelegate定义JS调用OC的方法。
2. 在控制器或者其他对象实现JSExportDelegate协议方法
3. 设置交互对象view.JSExportObject = self;

注意点:

当js调用OC的方法中有多个参数值，html中定义的方法为OC的方法实用驼峰命名拼接起来。

例如:
	
	//JSExportDelegate中定义
	- (void)showAlert:(NSString *)title msg:(NSString *)msg;
	
	//html中的调用
	mycs.showAlertMsg('js title', 'js message')

#### WKWebView与js交互

只需要在代理中实现一下方法就可以

	- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

#### 部分API
	
	#import <UIKit/UIKit.h>
	#import <WebKit/WebKit.h>
	#import <JavaScriptCore/JavaScriptCore.h>
	
	@protocol ZHWebViewDelegate <NSObject>
	
	@optional
	- (BOOL)ZHWebView:(UIView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
	
	- (void)ZHWebViewDidStartLoad:(UIView *)webView;
	
	- (void)ZHWebViewDidFinishLoad:(UIView *)webView;
	
	- (void)ZHWebView:(UIView *)webView didFailLoadWithError:(NSError *)error;
	
	//WKWebView中JS调用OC代码
	- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
	
	//iOS8以后需要实现,否则不会弹窗
	@required
	- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler ;
	
	- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler;
	
	- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler;
	
	@end
	
	//UIWebView中JS调用OC方法
	@protocol JSExportDelegate <JSExport>
	
	@required
	- (void)callSystemCamera;
	// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
	- (void)showAlert:(NSString *)title msg:(NSString *)msg;
	// 通过JSON传过来
	- (void)callWithDict:(NSDictionary *)params;
	// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
	- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;
	
	@end
	
	@interface ZHWebView : UIView
	
	@property (nonatomic,assign) BOOL iOS8_OR_LATER;
	
	@property (nonatomic,strong) UIView *webView;
	
	@property (nonatomic,weak) id<ZHWebViewDelegate> delegate;
	
	//是否显示加载进度条-》默认NO
	@property (nonatomic,assign) BOOL shouldShowProgressView;
	//进度条的颜色->默认是orange
	@property (nonatomic,strong) UIColor *progressColor;
	
	//UIWebView与JS交互的对象
	@property (nonatomic,strong) id<JSExportDelegate> JSExportObject;
	
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


	
	@property (nonatomic) BOOL scalesPageToFit;
	
	@end
