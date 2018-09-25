//
//  EWTWebNativeBridge.h
//  EWTWebViewKit_Example
//
//  Created by Tony on 2017/12/20.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef void(^EWTWebNativeBridgeCallBack)(id respondData);

@interface EWTWebNativeBridge : NSObject

{
    __weak UIWebView* _webView;
    __weak WKWebView* _wkwebView;
}

@property (nonatomic, assign) BOOL isTeacherDeatil;


-(instancetype)initWithWebView:(UIView*)webView webViewDelegate:(id)webViewDelegate;

-(void)dynamicRegistHandler:(NSString *)script;

-(void)dynamicCallHandler:(NSString*)script data:(id)data callBack:(EWTWebNativeBridgeCallBack)callback;

-(void)removeHandler:(NSString*)handler;

-(void)removeAllHandlers;

@end
