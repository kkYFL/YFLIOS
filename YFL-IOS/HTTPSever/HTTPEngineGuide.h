//
//  HTTPEngineGuide.h
//  Ewt360
//
//  Created by ZengQingNian on 15/7/20.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPEngine.h"


@interface HTTPEngineGuide : NSObject<HTTPEngineDelegate>

#pragma mark - /***** ***** ***** ***** ***** 获取服务器时间 ***** ***** ***** ***** *****/
+ (void)getServerDateWithSuccess:(void (^)(NSDictionary *responseObject))success
                         failure:(void (^)(NSError *error))failure;









#pragma mark - /***** ***** ***** ***** ***** 登陆、注册 ***** ***** ***** ***** *****/
/*!
 *  @method         获取绑定手机验证码
 *  @param          phoneNumber 手机号码
 *  @discussion
 */
+ (void)getSecurityCodeBindingWithPhoneNumber:(NSString *)phoneNumber
                               success:(void (^)(NSDictionary *responseObject))success
                               failure:(void (^)(NSError *error))failure;

/*!
 *  @method         用户登陆
 *  @param          userName    用户名
 *  @param          password    密码
 *  @discussion
 */
+ (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
                         date:(NSString *)date
                      success:(void (^)(NSDictionary *responseObject))success
                      failure:(void (^)(NSError *error))failure;
/*!
 *  @method         第三方登陆
 *  @param          appID   用户名
 *  @param          name    名字
 *  @param          type    类型（1:QQ登陆）
 */
+ (void)thirdPartyLoginWithAppID:(NSString *)appID
                            name:(NSString *)name
                            type:(NSString *)type
                            date:(NSString *)date
                         success:(void (^)(NSDictionary *responseObject))success
                         failure:(void (^)(NSError *error))failure;
/*!
 *  @method         会员激活
 *  @param          number          认证码/激活码/卡号
 *  @param          password        卡号密码（可能为空）
 *  @param          provinceCode    省份Code
 */
+ (void)memberActivationWithNumber:(NSString *)number
                          password:(NSString *)password
                      provinceCode:(NSString *)provinceCode
                              date:(NSString *)date
                           success:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(NSError *error))failure;



/**
 墨云-获取服务器时间

 */
+(void)MYGetSeverTimerStampSuccess:(void (^)(NSDictionary *responseObject))success
                           failure:(void (^)(NSError *error))failure;


/**
 墨云-获取学习任务列表

 @param type      类型   1:学习任务列表  2:学习痕迹列表
 @param page      页码
 @param pageNum   每页数据数量
 */
+(void)MYLessonListSourceWithType:(NSInteger)type Page:(NSInteger)page PageNum:(NSInteger)pageNum Success:(void (^)(NSDictionary *responseObject))success
                          failure:(void (^)(NSError *error))failure;

@end
