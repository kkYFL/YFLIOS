//
//  EWTWebNativeBridge.m
//  EWTWebViewKit_Example
//
//  Created by Tony on 2017/12/20.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "EWTWebNativeBridge.h"
#import "WKWebViewJavascriptBridge.h"
#import "WebViewJavascriptBridge.h"
#import "EWTWebViewJumperConfig.h"
//#import <EWTMediator/EWTMediator+EWTUserCenter.h>
//#import <EWTMediator/EWTMediator+EWTRouter.h>

#define kNativeHandler @"nativeHandler"
#define kJsHandler @"jsHandler"

@interface EWTWebNativeBridge()

@property (nonatomic, strong) WKWebViewJavascriptBridge* wkbridge;

@property (nonatomic, strong) NSMutableArray* handlers;

@property (nonatomic, strong) WebViewJavascriptBridge* bridge;


@end

@implementation EWTWebNativeBridge

-(instancetype)initWithWebView:(UIView*)webView webViewDelegate:(id)webViewDelegate{
    
    if (self = [super init]) {
        
        @weakify(self);

        if ([webView isKindOfClass:[UIWebView class]]) {
            
            _webView = (UIWebView*)webView;
            
            _bridge = [WebViewJavascriptBridge bridgeForWebView:(UIWebView*)webView webViewDelegate:webViewDelegate handler:^(id data, WVJBResponseCallback responseCallback) {
               
                @strongify(self);
                
                [self webViewJumperWithData:data];
            }];
            
        }else if ([webView isKindOfClass:[WKWebView class]]){
            
            _wkwebView = (WKWebView*)webView;
            
            _wkbridge = [WKWebViewJavascriptBridge bridgeForWebView:(WKWebView*)webView webViewDelegate:webViewDelegate handler:^(id data, WVJBResponseCallback responseCallback) {
                
                @strongify(self);

                [self webViewJumperWithData:data];
            }];
            
        }
        
        [self dynamicRegistHandler:kJsHandler];
        
        _handlers = [NSMutableArray array];
    }
    return self;
}

// 通过路由处理分发 如果要返回给web，通过标准格式返回

-(void)dynamicRegistHandler:(NSString *)script{
    
    id bridge = _wkbridge ? _wkbridge : _bridge;
    
    [bridge registerHandler:script handler:^(id data,WVJBResponseCallback responseCallback) {
        
        //  取出data中  url参数  identityIdentiifer: 用户身份  进行鉴权
//        [EWTMediator EWTRouter_handleWithUrl:data identityIdentifer:[[EWTMediator EWTUserCenter_getPersonInfo].accessType integerValue] completionHandler:^(NSError *error, NSString *responseData) {
//            if (responseData) {
//                if (responseCallback) {
//                    // 某些业务需要将数据回传给js
//                    responseCallback(responseData);
//                }
//            }
//        }];
    }];
    
}

-(void)dynamicCallHandler:(NSString*)script data:(id)data callBack:(EWTWebNativeBridgeCallBack)callback{
    
    id bridge = _wkbridge ? _wkbridge : _bridge;

    [bridge callHandler:script data:data responseCallback:^(id responseData) {
        
        if (callback) {
            callback(responseData);
        }
    }];
}

-(void)removeHandler:(NSString *)handler{
    
    [_handlers removeObject:handler];

    id bridge = _wkbridge ? _wkbridge : _bridge;

    [bridge removeHandler:handler];
    
}

-(void)removeAllHandlers{
    
    id bridge = _wkbridge ? _wkbridge : _bridge;

    for (NSString* handler in _handlers) {
        
        [bridge removeHandler:handler];
    }
}

-(void)webViewJumperWithData:(id)data {
    
    
}

@end
