//
//  WZWebViewController.h
//  WZWebView
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 赵伟争. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

//typedef enum : NSUInteger {
//    DefaultPage,       // 默认
//    SpiritTestPage,    // 心理测试页面
//    EvalationAnswerPage, //fm评测答题页面
//} WebPageType;


@protocol WebViewDelegate<NSObject>

@optional

-(void)webviewExternalConfiguration:(WKWebView*)webView;

@end

@class WZWebViewController;

@protocol WebViewUIDelegate<NSObject>

@optional

-(void)webViewWillClose:(WZWebViewController*)controller;

@end

@interface WZWebViewController : UIViewController<WebViewDelegate>

@property (nonatomic, strong) NSString   *titleVC;   //控制器的名字
@property (nonatomic, copy)   NSString   *webUrl;      //URL
@property (nonatomic, copy)   NSString   *loadHtmlString; //html 代码
@property (nonatomic, assign) NSInteger  buttomHight;   //底部导航高度
@property (nonatomic, assign) BOOL       canDownRefresh; //是否需要刷新
@property (nonatomic, strong) NSString   *msg_id_bigdataCount; //埋点使用
@property (nonatomic, assign) BOOL       fromNotifiCenter;//大数据埋点使用
@property (nonatomic, strong) NSString   *loadPath;       //本地路径URL
@property (nonatomic, strong ,readonly) WKWebView* wk_webView;
@property (nonatomic, weak) id<WebViewUIDelegate> uidelegate;
//@property (nonatomic, assign) WebPageType webPageType;   //页面类型
@property (nonatomic, assign) BOOL isNeedChangeTitleWithWebcontent; //是否需要改变控制器标题随着web内容的改变

- (void)loadRequest;

@end
