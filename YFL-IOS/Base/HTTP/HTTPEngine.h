//
//  HTTPEngine.h
//  Ewt360
//
//  Created by ZengQingNian on 15/7/20.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HTTPEngineDelegate <NSObject>

+(NSDictionary*)extraHttpHeaderFields;

@end

@class AFHTTPSessionManager;

@interface HTTPEngine : NSObject

@property (nonatomic, assign) CGFloat timeoutInterval;          //超时时间

@property (nonatomic, assign) NSStringEncoding stringEncoding;

@property (nonatomic, strong) Class targetClass;

@property (nonatomic, strong,readonly) AFHTTPSessionManager *requestSessionManager;

@property (nonatomic, assign) BOOL jsonBody;

+ (HTTPEngine *)sharedEngine;


+ (NSString *)getURLWithKey:(NSString *)key ;

// POST 请求 (form-data)
- (void)postRequestWithURL:(NSString *)url
                 parameter:(NSDictionary *)parameter
                   success:(void (^)( NSDictionary *responseObject))success
                   failure:(void (^)( NSError *error))failure;

// POST 请求 (纯文本)
- (void)postWithURL:(NSString *)url
          parameter:(NSDictionary *)parameter
            success:(void (^)( NSDictionary *responseObject))success
            failure:(void (^)( NSError *error))failure;

// GET 请求
- (void)getRequestWithURL:(NSString *)url
                parameter:(NSDictionary *)parameter
                  success:(void (^)( NSDictionary *responseObject))success
                  failure:(void (^)( NSError *error))failure;

// 上传
-(void)uploadData:(NSData*)data url:(NSString*)url fileName:(NSString*)fileName mimeType:(NSString*)type
          success:(void (^)( NSDictionary *responseObject))success
          failure:(void (^)( NSError *error))failure;



//墨云Post请求方法
- (void)postRequestWithBodyUrl:(NSString *)url
                        params:(NSDictionary *)params
                       success:(void (^)( NSDictionary *responseObject))success
                       failure:(void (^)( NSError *error))failure;
@end

