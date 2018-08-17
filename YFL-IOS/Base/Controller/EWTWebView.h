//
//  EWTWebView.h
//  UITabbarAndUINav
//
//  Created by zwz on 2017/12/5.
//  Copyright © 2017年 zwz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class EWTWebView;
@protocol EWTWebViewDelegate <NSObject>

- (void)ewtWebView:(EWTWebView *)webView didFinishLoadingURL:(NSURL *)url;

- (void)ewtWebView:(EWTWebView *)webView didFailToLoadURL:(NSURL *)url error:(NSError *)error;

- (void)ewtWebView:(EWTWebView *)webView shouldStartLoadWithURL:(NSURL *)url;

- (void)ewtWebViewDidStartLoad:(EWTWebView *)webView;

@end

@interface EWTWebView : UIView <WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>

@property (nonatomic, weak) id<EWTWebViewDelegate> delegate;

@property (nonatomic, assign) BOOL isTearchDeatil;


@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) WKWebView *wkWebView;


@property (nonatomic, strong) UIBarButtonItem *actionButton;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *barTintColor;

@property (nonatomic, assign) BOOL actionButtonHidden;

@property (nonatomic, assign) BOOL showsURLInNavigationBar;

@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;

@property (nonatomic, strong) NSArray *customActivityItems;


/**
 初始化方法
 @param frame
 @param messageHandlerNameArr handler数组
 */
//- (instancetype)initWithFrame:(CGRect)frame messageHandlerNameArr:(NSArray *)messageHandlerNameArr;

- (void)loadRequest:(NSURLRequest *)request;

- (void)loadURL:(NSURL *)url;

- (void)loadURLString:(NSString *)urlString;

- (void)loadHTMLString:(NSString *)htmlString;

@end
