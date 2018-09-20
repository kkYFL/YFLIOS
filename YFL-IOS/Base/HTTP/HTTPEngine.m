//
//  HTTPEngine.m
//  Ewt360
//
//  Created by ZengQingNian on 15/7/20.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import "HTTPEngine.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "HttpConfig.h"

@interface HTTPEngine ()

@property (nonatomic, strong) AFHTTPSessionManager *requestSessionManager;

@end

@implementation HTTPEngine

+ (HTTPEngine *)sharedEngine
{
    static HTTPEngine *engine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        engine = [[HTTPEngine alloc] init];
    });
    
    return engine;
}

+ (NSString *)getURLWithKey:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HTTPURL" ofType:@"plist"];
    NSString* environment = nil;
#ifdef DEBUG
    NSString* env = [[NSUserDefaults standardUserDefaults] objectForKey:@"environment"];
    environment = env ? : @"development";
#else
    environment = @"production";
#endif
    
    NSDictionary *dic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:environment]; // development:开发环境。production:发布环境
    return [dic objectForKey:key];
}

+(AFHTTPRequestSerializer*)requestSerializer{
    
    static AFHTTPRequestSerializer* requestSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestSerializer = [[AFHTTPRequestSerializer alloc]init];
    });
    return requestSerializer;
}

+(AFJSONRequestSerializer*)jsonRequestSerializer{
    
    static AFJSONRequestSerializer* jsonRequestSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsonRequestSerializer = [[AFJSONRequestSerializer alloc]init];
    });
    return jsonRequestSerializer;
}

- (AFHTTPSessionManager *)requestSessionManager
{
    
    if (_requestSessionManager == nil) {
        _requestSessionManager = [AFHTTPSessionManager manager];
        _requestSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    if (_jsonBody) {
        _requestSessionManager.requestSerializer = [HTTPEngine jsonRequestSerializer];
        _jsonBody = NO;
    }else{
        _requestSessionManager.requestSerializer = [HTTPEngine requestSerializer];
    }
    if (self.timeoutInterval && self.timeoutInterval >0){
        _requestSessionManager.requestSerializer.timeoutInterval = self.timeoutInterval;
    } else {
        _requestSessionManager.requestSerializer.timeoutInterval = 30.0f;
    }
    
    if (_targetClass && [_targetClass respondsToSelector:@selector(extraHttpHeaderFields)]) {
        
        NSDictionary* extraHttpHeaderFields = [_targetClass extraHttpHeaderFields];
        
        [extraHttpHeaderFields enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [_requestSessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    if (_stringEncoding == gbk) {
        _requestSessionManager.requestSerializer.stringEncoding = gbk;
        _stringEncoding = NSUTF8StringEncoding;
    }else{
        _requestSessionManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    }
    // commen fields
    
    NSString *clientInfo = [NSString stringWithFormat:@"mst_iOS_%@/%@/xiaomi/HM2LTE-CU",APP_VERSION,@""];
    [_requestSessionManager.requestSerializer setValue:clientInfo forHTTPHeaderField:@"Client-Agent"];
    [_requestSessionManager.requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"Accept-Charset"];
    [_requestSessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_requestSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"imei"];
    [_requestSessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"imsi"];
    [_requestSessionManager.requestSerializer setValue:@"2" forHTTPHeaderField:@"sid"];//平台号 安卓：1 iOS：2
    [_requestSessionManager.requestSerializer setValue:APP_VERSION forHTTPHeaderField:@"version"];//app的版本
    return _requestSessionManager;
}

- (void)postWithURL:(NSString *)url
          parameter:(NSDictionary *)parameter
            success:(void (^)( NSDictionary *responseObject))success
            failure:(void (^)( NSError *error))failure {
    
    [self.requestSessionManager POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            //数据请求返回码判断
            if ([[dic allKeys] containsObject:@"code"]){
                NSString *resultCode = [NSString stringWithFormat:@"%@",dic[@"code"]];
                if ([resultCode integerValue] == CommunityLogin) {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCommunityNeedLogin object:nil];
                }else if ([resultCode integerValue] == KickedofLine) {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserWasKickedofLine object:nil];
                }
            }
        }
        if (success) success( dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure( error);
    }];
    
}


- (void)postRequestWithURL:(NSString *)url
                 parameter:(NSDictionary *)parameter
                   success:(void (^)( NSDictionary *responseObject))success
                   failure:(void (^)( NSError *error))failure
{
    [self.requestSessionManager POST:url
                          parameters:parameter
           constructingBodyWithBlock:^(id  _Nonnull formData) {
               // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
               
           } progress:^(NSProgress * _Nonnull uploadProgress) {
               // 这里可以获取到目前的数据请求的进度
               
           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               //
               NSError *error = nil;
               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
               if ([dic isKindOfClass:[NSDictionary class]]) {
                   
                   //数据请求返回码判断
                   if ([[dic allKeys] containsObject:@"code"]){
                       NSString *resultCode = [NSString stringWithFormat:@"%@",dic[@"code"]];
                       if ([resultCode integerValue] == CommunityLogin) {
//                           [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationCommunityNeedLogin object:nil];
                       }else if ([resultCode integerValue] == KickedofLine) {
//                           [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationUserWasKickedofLine object:nil];
                       }
                   }
               }
               if (success) success( dic);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
               if (failure) failure( error);
           }];
}


- (void)getRequestWithURL:(NSString *)url
                parameter:(NSDictionary *)parameter
                  success:(void (^)( NSDictionary *responseObject))success
                  failure:(void (^)( NSError *error))failure
{
    [self.requestSessionManager GET:url parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (success) success( dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure( error);
        
    }];
    
}

-(void)uploadData:(NSData *)data url:(NSString *)url fileName:(NSString *)fileName mimeType:(NSString *)type success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    
    [self.requestSessionManager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data
                                    name:@"File"
                                fileName:fileName
                                mimeType:type];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (success) success( dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) failure( error);
    }];
    
}



- (void)postRequestWithBodyUrl:(NSString *)url
                        params:(NSDictionary *)params
                       success:(void (^)( NSDictionary *responseObject))success
                       failure:(void (^)( NSError *error))failure{
    NSLog(@"请求路径: %@ \n\t请求参数: %@", url, params?:@"nil");
    

    NSString *requestURL= url;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:requestURL parameters:nil error:nil];
    
    request.timeoutInterval= 5;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData *bodyData= [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    [request setHTTPBody:bodyData];
    
    
    [[self.requestSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, NSData * responseObject, NSError * _Nullable error) {
        NSError *error1 = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error1];
        NSInteger code = [[dic objectForKey:@"code"] integerValue];
        
        if (2000 == code) {
            success(dic);
        }else {
            failure(error);
        }
 
    }] resume];
    
}


@end

