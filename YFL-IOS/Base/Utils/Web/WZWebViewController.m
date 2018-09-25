//
//  WZWebViewController.m
//  WZWebView
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 赵伟争. All rights reserved.
//

#import "WZWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DisnetView.h"
#import "EWTWebNativeBridge.h"
//#import "EvaluationViewController.h"


static CGFloat const NAVIGATIONBAR_HEIGHT = 0;
@interface WZWebViewController () <WKNavigationDelegate, WKUIDelegate,UIGestureRecognizerDelegate,DisnetViewDelegate>

@property (nonatomic, strong) WKWebView* wk_webView;
@property (nonatomic, strong) UIBarButtonItem           *backBarButtonItem;         //返回按钮
@property (nonatomic, strong) UIBarButtonItem           *closeBarButtonItem;        //关闭按钮
@property (nonatomic, strong) UIRefreshControl          *refreshControl;            //刷新(下拉)
@property (nonatomic, strong) UIProgressView            *loadingProgress;           //加载进度条
@property (nonatomic, strong) UIButton                  *reloadButton;              //刷新按钮
@property (nonatomic, weak)   UIButton                  *backItem;                  //返回按钮
@property (nonatomic, weak)   UIButton                  *closeItem;                 //关闭按钮
@property (nonatomic, strong) UIView                    *backView;                  //leftView

@property (nonatomic, weak) id <UIGestureRecognizerDelegate> delegate;
@property (strong, nonatomic) JSContext *context;

@property (nonatomic, strong) DisnetView *disView;

@property (nonatomic, strong) EWTWebNativeBridge* bridge;

@end

@implementation WZWebViewController

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.titleVC.length != 0) {
        self.title = self.titleVC;
    }
    
    [self initView];
    @weakify(self);
    [_wk_webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
        
        NSString *userAgent = result;
        NSString* appendStr = [NSString stringWithFormat:@" EWT/%@/com.mistong.ewt",APP_VERSION];
        NSString *newUserAgent = [userAgent stringByAppendingString:appendStr];
        if ([result rangeOfString:appendStr].location == NSNotFound) {
            if (@available(iOS 9.0, *)) {
                [self->_wk_webView setCustomUserAgent:newUserAgent];
            }else {
                [self->_wk_webView setValue:newUserAgent forKey:@"applicationNameForUserAgent"];
            }
        }
        [weak_self loadData];
        
        weak_self.bridge = [[EWTWebNativeBridge alloc] initWithWebView:weak_self.wk_webView webViewDelegate:weak_self];
    }];
    
    
}

-(void)initView{
    [self createWebView];
    [self initNaviBar];
    [self.view addSubview:self.disView];
}

-(void)loadData{
    if (self.loadPath) {
        [self loadRequestPath];
    } else {
        [self loadRequest];
    }
}

- (void)createWebView {

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.reloadButton];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.view addSubview:self.wk_webView];
        [self.view addSubview:self.loadingProgress];
    } else {
        //[self.view addSubview:self.webView];
    }
}

- (WKWebView *)wk_webView {
    
    if (!_wk_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _wk_webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAVIGATIONBAR_HEIGHT - 64) configuration:configuration];
        _wk_webView.navigationDelegate = self;
        _wk_webView.UIDelegate = self;
        
        //添加此属性可触发侧滑返回上一网页与下一网页操作
        _wk_webView.allowsBackForwardNavigationGestures = YES;
        //下拉刷新 (需求暂时不用)
        if (@available(iOS 10.0, *)) {
            if (_canDownRefresh) {
                 _wk_webView.scrollView.refreshControl = self.refreshControl;
            }
        }
        
        //进度监听
        [_wk_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
        if([self respondsToSelector:@selector(webviewExternalConfiguration:)]){
            
            [self webviewExternalConfiguration:_wk_webView];
        }
        WKUserScript* script = [[WKUserScript alloc]initWithSource:@"var isLoadInMSTApp = true;" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        
        [_wk_webView.configuration.userContentController addUserScript:script];
    }
    return _wk_webView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _loadingProgress.progress = [change[@"new"] floatValue];
        if (_loadingProgress.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->_loadingProgress.hidden = YES;
            });
        }
    }
}

- (void)dealloc {
    [_wk_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wk_webView stopLoading];
    _wk_webView.UIDelegate = nil;
    _wk_webView.navigationDelegate = nil;
    
}

- (void)setButtomHight:(NSInteger)buttomHight {
    _buttomHight = buttomHight;
    _wk_webView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - NAVIGATIONBAR_HEIGHT - 64 - _buttomHight);//self.buttomHight 高度多减了20是为了适配有底部导航栏的页面
}

- (UIProgressView *)loadingProgress {

    if (!_loadingProgress) {
        _loadingProgress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.bounds.size.width, 2)];
        _loadingProgress.progressTintColor = [UIColor greenColor];
    }
    return _loadingProgress;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.view.center;
        _reloadButton.layer.cornerRadius = 75.0;
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"common_wifi_icon_1"] forState:UIControlStateNormal];
        [_reloadButton setTitle:@"您的网络有问题，请检查您的网络设置" forState:UIControlStateNormal];
        [_reloadButton setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        _reloadButton.titleLabel.numberOfLines = 0;
        _reloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 100;
        _reloadButton.frame = rect;
        _reloadButton.enabled = NO;
    }
    return _reloadButton;
}

#pragma mark 导航按钮
- (void)createNaviItem {
   
    [self showLeftBarButtonItem];
    [self showRightBarButtonItem];
}

- (void)showLeftBarButtonItem {
    
    if ([_wk_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem]; //增加关闭按钮
    } else {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
}

- (void)showRightBarButtonItem {
    
}

- (void)initNaviBar{
    
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    UIButton * backItem = [UIButton buttonWithType:UIButtonTypeCustom];
    backItem.frame = CGRectMake(0, 0, 42, 44);
    [backItem setImage:[UIImage imageNamed:@"navigaitionBar_back_normal"] forState:UIControlStateNormal];
    [backItem setImage:[UIImage imageNamed:@"navigationBar_back_select"] forState:UIControlStateSelected];
    [backItem addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    [self.backView addSubview:backItem];
    
    UIButton * closeItem = [UIButton buttonWithType:UIButtonTypeCustom];
    closeItem.frame = CGRectMake(42+8, 1, 44, 44);
    
    [closeItem setTitle:@"关闭" forState:UIControlStateNormal];
    [closeItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeItem addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    closeItem.hidden = YES;
    self.closeItem = closeItem;
    [self.backView addSubview:closeItem];
    
    UIBarButtonItem * leftItemBar = [[UIBarButtonItem alloc]initWithCustomView:self.backView];
    self.navigationItem.leftBarButtonItem = leftItemBar;
    
}

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 42, 15);
        [button setImage:[UIImage imageNamed:@"navigaitionBar_back_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationBar_back_select"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem*)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    }
    return _closeBarButtonItem;
}

- (void)back:(UIBarButtonItem *)item {
    if ([_wk_webView canGoBack]) {
       
        [_wk_webView goBack];
        self.backView.frame = CGRectMake(0, 0, 100, 44);
        self.closeItem.hidden = NO;
    } else {
        [self close:nil];
    }
}

- (void)close:(UIBarButtonItem*)item {
    
    //具体让业务自己实现  不要让父类控制器过度臃肿

    if(self.uidelegate && [self.uidelegate respondsToSelector:@selector(webViewWillClose:)]){
        
        [self.uidelegate webViewWillClose:self];
        
    }else{
        NSString *js = @"MSTAnalytics.destroy()";
        [self.wk_webView evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)spiritTestPop {

    
}

#pragma mark 自定义导航按钮支持侧滑手势处理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        
        if (_delegate) {
            self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
    
    if ([PublicMethod getNetWorkStates] == NotReachable) {
        self.disView.hidden = NO;
    }else{
        self.disView.hidden = YES;
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSString * fromClassName = @"";
    if(_fromNotifiCenter) fromClassName = @"systemNotifityCenter";
    NSString *outputStr = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self.webUrl,NULL,(CFStringRef)@"!*'();:@&=+ $,/?%#[]",kCFStringEncodingUTF8));
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}


#pragma mark 加载请求

- (void)loadRequest {
    
    if (self.webUrl.length != 0) {
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            NSURLRequestCachePolicy policy = NSURLRequestUseProtocolCachePolicy;
            if ([self.webUrl rangeOfString:@"zt.ewt360.com"].location != NSNotFound) {
                policy = NSURLRequestReloadIgnoringCacheData;
            }
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl] cachePolicy:policy timeoutInterval:30];
            [_wk_webView loadRequest:request];
        } else {
           // [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
        }
        return;
    }
    
    if (self.loadHtmlString.length != 0) {
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            [_wk_webView loadHTMLString:self.loadHtmlString baseURL:nil];
        } else {
            //[_webView loadHTMLString:self.loadHtmlString baseURL:nil];
        }
        return;
    }
    
}

- (void)loadRequestPath {
    if (@available(iOS 9.0, *)) {
        NSURL *fileURL = [NSURL fileURLWithPath:self.loadPath];
        [self.wk_webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    }else {
        NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:self.loadPath]];
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        [self.wk_webView loadRequest:request];
    }
}

#pragma mark WKNavigationDelegate


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSURL* url = navigationAction.request.URL;
    
    if (!navigationAction.targetFrame) {
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    // support custom link to launch app handle url
    
    if (![url.scheme isEqualToString:@"https"] && ![url.scheme isEqualToString:@"http"])
    {
       if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            
            return;
        }
    }
    else{
        
        if ([url.host isEqualToString:@"itunes.apple.com"]) {
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
                
                decisionHandler(WKNavigationActionPolicyCancel);
                
                return;
            }
        }
        
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    webView.hidden = NO;
    _loadingProgress.hidden = NO;
    
    if ([webView.URL.scheme isEqual:@"about"]&&self.webUrl.length != 0) {
        webView.hidden = YES;
    }
}

//页面加载完成
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    //导航栏配置
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    [self showLeftBarButtonItem];
    [_refreshControl endRefreshing];
}

//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    webView.hidden = YES;
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

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    // set target nil forbidden to open a new frame
    //根据web内容改变控制器的title
    if (self.isNeedChangeTitleWithWebcontent && webView.title && webView.title.length) {
        self.title = webView.title;
    }
    
    [webView evaluateJavaScript:@"var a = document.getElementsByTagName('form');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
}


- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

#ifdef DEBUG

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{

    if (message) {

        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

        [alert show];
    }

    completionHandler();

}
#endif


#pragma mark - 板报评论刷新
- (void)plateNewspaperDetailLikeCountRefresh:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSString *commentId = dic[@"commentId"];
    NSString *js = [NSString stringWithFormat:@"addzan(\"%@\")",commentId];
    [self.wk_webView evaluateJavaScript:js completionHandler:nil];
}

#pragma mark - 板报评论点赞刷新
- (void)plateNewspaperDetailCommentCountRefresh:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSString *commentId = dic[@"commentId"];
    NSString *commentCount = dic[@"count"];
    NSString *js = [NSString stringWithFormat:@"addpl(%@,%@)",commentId,commentCount];
    [self.wk_webView evaluateJavaScript:js completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - DisnetViewDelehate
- (void)refreshNet{
    self.disView.hidden = YES;
    [self loadData];
}

#pragma mark -- 懒加载
-(DisnetView *)disView{
    if (!_disView) {
        DisnetView *disView = [[DisnetView alloc]initWithFrame:self.view.bounds];
        disView.delegate = self;
        [self.view addSubview:disView]; 
        self.disView = disView;
    }
    return _disView;
}

@end
