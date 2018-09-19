//
//  HTTPEngineGuide.m
//  Ewt360
//
//  Created by ZengQingNian on 15/7/20.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import "HTTPEngineGuide.h"
#import "YFKeychainUUID.h"


// HTTPEngine.m 里面也有key
static NSString *signKey = @"ios5f576beec73f652a045904ef15101";
static NSString *signKey2 = @"eo^nye1j#!wt2%v)";
static NSString *liveSigenKey = @"mnw9f5upxgbfv4ddgrg5qdxbs3ge2aba";
static NSString *community_app_id = @"150201";
static NSString *community_app_key = @"ba85c4b58d71a78db48a7c816903870a";
static NSString *plogKey = @"plogd1500112a181e590c958c7480f3e"; //当虹播放统计
static NSString *community_tourist_signKey = @"30435d6237a145c9d19dfddb1c46089a"; //社区游客模式的sign

#define gbk CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)

static NSString *domain = @"http://192.168.1.1:8080/hnx/";


static NSString * MoYunLoginUrl = @"userCtrl/doLogin";



@implementation HTTPEngineGuide

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HTTPEngine sharedEngine].targetClass = [HTTPEngineGuide class];
    });
}



+ (void)getServerDateWithSuccess:(void (^)(NSDictionary *responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSString *urlStr = [NSMutableString stringWithString:[HTTPEngine getURLWithKey:@"get_time"]];
    [[HTTPEngine sharedEngine] postRequestWithURL:urlStr
                                        parameter:nil
                                          success:^(NSDictionary *responseObject) {
                                              if (success) success(responseObject);
                                          } failure:^(NSError *error) {
                                              if (failure) failure(error);
                                          }];
}

+ (void)getSecurityCodeBindingWithPhoneNumber:(NSString *)phoneNumber
                                      success:(void (^)(NSDictionary *responseObject))success
                                      failure:(void (^)(NSError *error))failure {
    NSMutableString *urlStr = [NSMutableString stringWithString:[HTTPEngine getURLWithKey:@"security_code_binding"]];
    
    NSString *sidStr = @"7";
    NSString *signStr = [PublicMethod MD5Encrypt:[NSString stringWithFormat:@"%@%@%@",signKey2,phoneNumber,signKey2]];
    
    NSDictionary *paraDic = @{@"phoneNumber":phoneNumber,
                              @"sign":signStr,
                              @"sid":sidStr};
    
    [[HTTPEngine sharedEngine] postRequestWithURL:urlStr
                                        parameter:paraDic
                                          success:^(NSDictionary *responseObject) {
                                              if (success) success(responseObject);
                                          } failure:^(NSError *error) {
                                              if (failure) failure(error);
                                          }];
}


+ (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
                         date:(NSString *)date
                      success:(void (^)(NSDictionary *responseObject))success
                      failure:(void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:[HTTPEngine getURLWithKey:@"user_login"]];
    
    NSString *sidStr = @"7";
    NSString *signStr = [PublicMethod MD5Encrypt:[NSString stringWithFormat:@"%@%@%@",sidStr,signKey,date]];
    
    NSDictionary *paraDic = @{@"Sid":sidStr,
                              @"Now":date,
                              @"Platform":@"2",
                              @"username":userName,
                              @"password":[PublicMethod AES128EncryptWithString:password key:signKey2],
                              @"sign":signStr};
    
    [[HTTPEngine sharedEngine] postRequestWithURL:urlStr
                                        parameter:paraDic
                                          success:^(NSDictionary *responseObject) {
                                              if (success) success(responseObject);
                                          } failure:^(NSError *error) {
                                              if (failure) failure(error);
                                          }];
}


+ (void)thirdPartyLoginWithAppID:(NSString *)appID
                            name:(NSString *)name
                            type:(NSString *)type
                            date:(NSString *)date
                         success:(void (^)(NSDictionary *responseObject))success
                         failure:(void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:[HTTPEngine getURLWithKey:@"third_party_login"]];
    
    NSString *sidStr = @"7";
    NSString *signStr = [PublicMethod MD5Encrypt:[NSString stringWithFormat:@"%@%@%@",sidStr,signKey,date]];
    
    NSDictionary *paraDic = @{@"Sid":sidStr,
                              @"Now":date,
                              @"Platform":@"2",
                              @"sign":signStr,
                              @"OpenID":appID,
                              @"NickName":name,
                              @"Types":type};
    
    [[HTTPEngine sharedEngine] postRequestWithURL:urlStr
                                        parameter:paraDic
                                          success:^(NSDictionary *responseObject) {
                                              if (success) success(responseObject);
                                          } failure:^(NSError *error) {
                                              if (failure) failure(error);
                                          }];
}


+(void)MYGetSeverTimerStampSuccess:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(NSError *error))failure{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/memberTaskCtrl/getSysDate"];
    NSDictionary *paraDic = @{@"userToken":@"1",
                              @"userId":@"1"};
    [[HTTPEngine sharedEngine] getRequestWithURL:urlStr parameter:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
    
    
}


+(void)MYLessonListSourceWithType:(NSInteger)type Page:(NSInteger)page PageNum:(NSInteger)pageNum Success:(void (^)(NSDictionary *responseObject))success
                          failure:(void (^)(NSError *error))failure{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/memberTaskCtrl/getData"];
    NSDictionary *paraDic = @{@"type":[NSNumber numberWithInteger:type],
                              @"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum],
                              @"userId":@"1"};
    
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
    
}






@end


