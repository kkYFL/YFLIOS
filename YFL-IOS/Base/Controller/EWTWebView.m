//
//  EWTWebView.m
//  UITabbarAndUINav
//
//  Created by zwz on 2017/12/5.
//  Copyright © 2017年 zwz. All rights reserved.
//


#import "EWTWebView.h"
#import "EWTWebNativeBridge.h"

static void *EWTWebBrowserContext = &EWTWebBrowserContext;
@interface EWTWebView ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) BOOL webViewIsLoading;
@property (nonatomic, strong) NSURL *webViewCurrentURL;
@property (nonatomic, strong) NSURL *urlToLaunchWithPermission;
@property (nonatomic, strong) EWTWebNativeBridge *wkBridge;
@end
@implementation EWTWebView

- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWebView loadRequest:request];
}

- (void)loadURL:(NSURL *)url {
    [self loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)loadURLString:(NSString *)urlString {
    [self loadURL:[NSURL URLWithString:urlString]];
}

- (void)loadHTMLString:(NSString *)htmlString {
    [self.wkWebView loadHTMLString:htmlString baseURL:nil];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    _barTintColor = barTintColor;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (webView == self.wkWebView && [self.delegate respondsToSelector:@selector(ewtWebViewDidStartLoad:)]) {
        [self.delegate ewtWebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (webView == self.wkWebView && [self.delegate respondsToSelector:@selector(ewtWebView:didFinishLoadingURL:)]) {
        [self.delegate ewtWebView:self didFinishLoadingURL:self.wkWebView.URL];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (webView == self.wkWebView && [self.delegate respondsToSelector:@selector(ewtWebView:didFailToLoadURL:error:)]) {
        [self.delegate ewtWebView:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (webView == self.wkWebView && [self.delegate respondsToSelector:@selector(ewtWebView:didFailToLoadURL:error:)]) {
        [self.delegate ewtWebView:self didFailToLoadURL:self.wkWebView.URL error:error];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (webView == self.wkWebView) {
        NSURL *url = navigationAction.request.URL;
        if (![self externalAppRequiredToOpenURL:url]) {
            if (!navigationAction.targetFrame) {
                [self loadURL:url];
                decisionHandler(WKNavigationActionPolicyCancel);
                return;
            }
            [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
        } else if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [self launchExternalAppWithURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
     decisionHandler(WKNavigationActionPolicyAllow);
}

- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType{
    // back delegate
    if ([self.delegate respondsToSelector:@selector(ewtWebView:shouldStartLoadWithURL:)]) {
        [self.delegate ewtWebView:self shouldStartLoadWithURL:request.URL];
    }

    return YES;
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    /*
     若需要限制只允许某些前缀的scheme通过请求，则取消下述注释，并在数组内添加自己需要放行的前缀
     NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https",@"file"]];
     return ![validSchemes containsObject:URL.scheme];
     */
    
    return !URL;
}

- (void)launchExternalAppWithURL:(NSURL *)URL {
    self.urlToLaunchWithPermission = URL;
 
}

#pragma mark - self Life cycle

- (void)dealloc {
    
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
        [self.wkWebView setNavigationDelegate:self];
        [self.wkWebView setUIDelegate:self];
        [self addSubview:self.wkWebView];
        self.wkWebView.scrollView.bounces = NO;
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:EWTWebBrowserContext];
        
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        
        /*
         If there is no navigation bar, then here to write like this
         - [self.progressView setFrame:self.bounds];
         */
        [self.progressView setFrame:CGRectMake(0, 0, self.frame.size.width, self.progressView.frame.size.height)];
        self.progressView.hidden = YES;
        // progress bar Color
        [self setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
        [self addSubview:self.progressView];
        _wkBridge = [[EWTWebNativeBridge alloc] initWithWebView:self.wkWebView webViewDelegate:self];
        
        
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setIsTearchDeatil:(BOOL)isTearchDeatil {
    _isTearchDeatil = isTearchDeatil;
    _wkBridge.isTeacherDeatil = _isTearchDeatil;
}

//HTTPS认证
-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust)
    {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    }else{
        
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,nil);
    }
}


@end
