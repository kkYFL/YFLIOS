//
//  PublicMethod.h
//  Ewt360
//
//  Created by ZengQingNian on 15/7/20.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface PublicMethod : NSObject
#pragma mark - /***** ***** ***** ***** ***** 加密 ***** ***** ***** ***** *****/
// MD5 加密
+ (NSString *)MD5Encrypt:(NSString*)string;

//是否是手机号
+ (BOOL)checkIsPhone:(NSString *)str;
// String AES128 加密
+ (NSString *)AES128EncryptWithString:(NSString *)string key:(NSString *)key;
// String AES128 解密
+ (NSString *)AES128DecryptWithString:(NSString *)string key:(NSString *)key;

// NSData AES 加密
+ (NSData *)AESEncryptWithData:(NSData *)data key:(NSString *)key;
// NSData AES 解密
+ (NSData *)AESDecryptWithData:(NSData *)data key:(NSString *)key;

// NSData 转十六进制String
+ (NSString *)sixteenHexStringFromData:(NSData *)data;

// 序列化key

+ (NSString*)serializeWithDictionary:(NSDictionary*)dict;

+(NSString *)serializeNoCharacterWithDictionary:(NSDictionary *)dict;

#pragma mark - /***** ***** ***** ***** ***** 系统级 ***** ***** ***** ***** *****/
// 获取系统 document 目录
+ (NSString *)documentDirectory;
// 获得设备型号
+ (NSString *)getCurrentDeviceModel;
//获取网络状态 文字
+ (NSString *)getTheNetworkStateText;
// 获取网络状态 枚举
+ (NetworkStatus)getNetWorkStates;
//获取当前IP地址 YES ipv4 NO ipv6
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses;

//获取设备型号
+(NSString *)getDeveiceVersion;

+(void)getNetStatusHasNet:(void (^)(BOOL hasNet))hasNet;

#pragma mark - /***** ***** ***** ***** ***** 公共接口 ***** ***** ***** ***** *****/
// 当前日期（yy/MM/dd HH:mm）
+ (NSString *)currentDate;
+ (NSString *)currentDateWithFormat:(NSString *)format;
// 当前时间戳
+ (NSString *)currentTimeInterval;
//根据时间获取时间戳 formatTime: 时间  format:格式(@"YYYY-MM-dd hh:mm:ss")
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
//服务器返回时间（yy/MM/dd HH:mm）
+ (NSString *)serverDateformatWithSecond:(NSString *)second;

+ (NSString *)serverDateformatWithSecond:(NSString *)second byFormat:(NSString*)format;


// 获取服务器返回码说明
//+ (NSString *)getServerCodeDescriptionWithCode:(NSString *)code;
// 判断账号登录状态
//+ (void)accountStatusDecideInCode:(NSString *)code navigation:(UINavigationController *)nav;

//缓存服务器时间戳到本地
//+(void)cacheServerTimestamp;

//从本地读取缓存服务器时间
//+(void)getServerTimestampBack:(void (^)(NSString *serverTimeStamp))serverTimeStamp;

//从Keychain获取当前设备UUID
//+(NSString *)readDeviceUUIDFromKeychain;

//传入科目id返回科目
+ (NSString *)getSubjectTypeWithId:(NSString *)string;

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//获取dd日期 如: 22
+ (NSString *)returnTime;

//计算学分
//+ (void)calculateCredit:(NSInteger)time downloaded:(NSString *)downloaded;
//观看视频,增加学分
//+ (void)watchTheVideoAddCredit:(NSInteger)addCredit remainder:(NSInteger)remainder downloaded:(NSString *)downloaded;
//有网状态下上传学分
//+ (void)uploadCreditsHaveNetworkCondition;

//获取文件夹的大小
+ (CGFloat )folderSizeAtPath:(NSString *)folderPath;
//获取剩余手机内存的大小
+ (NSString *)freeDiskSpace;

//根据积分获取头衔
+ (NSString *)accordingToTheIntegralForTheTitle:(NSInteger)credits;
//根据字符串获取Label的宽度
+ (CGFloat)getTheWidthOfTheLabelWithContent:(NSString *)content font:(CGFloat)font;
//字符串不同的颜色
+ (NSMutableAttributedString *)accordingToStringGetDicColorNSString:(NSString *)contentStr color:(UIColor *)color startingPoint:(NSInteger)point width:(NSInteger)width;
//表情key值
+ (NSMutableArray *)faceKey;
//表情Value值
+ (NSMutableArray *)faceValue;
//文本解析()
+ (NSDictionary *)faceDic;
// 本地表情名字 转换成 服务器字符
+ (NSDictionary *)expressionServerToLocal;
// URL 特殊字符编码
+ (NSString *)stringEscapes:(NSString *)string;
// URL 特殊字符反编码
+ (NSString *)stringEscapesDecode:(NSString *)string;
// 是否包含iOS自带表情
+ (BOOL)findEmoji:(NSString *)string;
//退出登录处理数据
//+ (void)exitSignProcessingData:(UINavigationController *)nav;
// 下线通知
//+ (void)OfflineNotificationWithCode:(NSString *)code;


//行高
+ (CGFloat)getSpaceLabelHeight:(NSString *)str withWidh:(CGFloat)width font:(NSInteger)font;
//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string;

//是否忽略0   YES 不会过滤0   NO  直接过滤0
+ (BOOL)isPureInt:(NSString *)string ignoreZore:(BOOL)ignoreZore;
//字符串判断是否为整数
+ (BOOL)isPureInt:(NSString *)string;
// 获取支付 用户ID
//+ (NSString *)getLoadPayUserID;
//由数字返回的卡类型
//+ (NSString *)byDigitalReturnCardType;

//启动数据库
//+ (void)startTheDatabase;

/*  权限判断
    目前涉及到的权限有: 游客, 注册会员, 过期会员, 普卡, 金卡, VIP, SVIP  (权限依次递增)
    tag: 传入不同的数值,得到不同的权限
    tag: 传"1", 允许 SVIP, VIP 其他不允许,弹框
         传"2", 允许 SVIP, VIP, 金卡, 普卡, 不允许 游客, 过期, 注册会员
         传"3", 允许 SVIP, VIP, 金卡, 普卡, 过期  不允许 游客, 注册会员
         传"4", 不允许 游客, 其他都允许
         传"5", 允许 SVIP, VIP, 普卡  其他权限则不允许
         传"6", 允许 SVIP, 其他不允许
   
    viewController:传入当前VC, 用于导航跳转, 如果传入的是nil 则仅做判断, 不弹框
    
 例如: 1:
 if ([PublicMethod whetherTheTriggerPermissionsWithNavigation:self tag:@"1"]) {
    //如果yes 执行方法体 NO 则在JudgeAuthority类中处理弹框问题
 }

 2:
 if (![PublicMethod whetherTheTriggerPermissionsWithNavigation:nil tag:@"1"]) {
    //如果NO ! 执行方法体 不弹框
    //如果viewController 为空nil, 即使权限不够 也不弹框, 用于处理一些不需要弹框的权限问题..
 }
 
 
 {
 除去上面的6中tag值以外,还可以单独去做判断
 比如:  [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"overdue"];
       [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"registeredUsers"];
               overdue: YES: 过期      NO: 未过期
       registeredUsers: YES: 注册会员,  NO: 过期会员
 
        APP_DELEGATE.touristsMode = YES;  touristsMode: yes: 游客, NO: 非游客
 
        NSString *st = [PublicMethod byDigitalReturnCardType];
        st : 普卡会员 金卡会员 VIP会员 至尊会员 四种类型
 }
 
 */
//是否 触发权限  tag值 1: 听记单词, 我的学分
//+ (BOOL)whetherTheTriggerPermissionsWithNavigation:(UIViewController *)viewController tag:(NSString *)tag;




#pragma mark - /***** ***** ***** ***** ***** 业务接口 ***** ***** ***** ***** *****/

/**
 视频解压

 @param location  地址
 @param fileName  文件名
 @param fileExtension 后缀名
 @param result (isMemorySpace 是否有空间, 先判断这个, 后使用 URLPath)
 */
+ (void)videoDecryptWithURL:(NSURL *)location
                   fileName:(NSString *)fileName
              fileExtension:(NSString *)fileExtension
                     result:(void (^)(BOOL isMemorySpace, NSURL *urlPath))result;
// 表情解析
+ (NSString *)emoticonAnalyzeWithServerCode:(NSString *)code;
// 获得本地直播弹幕本地下载路径
//+ (NSString *)getBarrageLocalPathWithId:(NSString *)liveId;
// 获得在线直播弹幕本地下载路径
//+ (NSString *)getBarrageOnlinePathWithId:(NSString *)liveId;

/*!
 *  @method         UITextField     默认提示文字
 *  @param          holderText      提示文字
 *  @param          hexColor        十六进制颜色值(eg:@"#333333")
 *  @param          font            提示文字字体大小
 *  @discussion
 */
+ (NSMutableAttributedString *)textFieldAttributedPlaceholderWithText:(NSString *)holderText hexColor:(NSString *)hexColor font:(CGFloat)font;



// 业务方法  暂时放在这里

// 获取服务器返回码说明
+ (NSString *)getServerCodeDescriptionWithCode:(NSString *)code;
// 判断账号登录状态
+ (void)accountStatusDecideInCode:(NSString *)code navigation:(UINavigationController *)nav;

//缓存服务器时间戳到本地
+(void)cacheServerTimestamp;

//从本地读取缓存服务器时间
+(void)getServerTimestampBack:(void (^)(NSString *serverTimeStamp))serverTimeStamp;


//计算学分
+ (void)calculateCredit:(NSInteger)time downloaded:(NSString *)downloaded;
//观看视频,增加学分
+ (void)watchTheVideoAddCredit:(NSInteger)addCredit remainder:(NSInteger)remainder downloaded:(NSString *)downloaded;
//有网状态下上传学分
+ (void)uploadCreditsHaveNetworkCondition;

//退出登录处理数据
+ (void)exitSignProcessingData:(UINavigationController *)nav;
// 下线通知
+ (void)OfflineNotificationWithCode:(NSString *)code;

//有网状态下上传离线视频所得学分
+ (void)haveUploadedOfflineVideoNetworkStateIncomeCredits;


// 获取支付 用户ID
+ (NSString *)getLoadPayUserID;
//由数字返回的卡类型
+ (NSString *)byDigitalReturnCardType;

//启动数据库
+ (void)startTheDatabase;

/*  权限判断
 目前涉及到的权限有: 游客, 注册会员, 过期会员, 普卡, 金卡, VIP, SVIP  (权限依次递增)
 tag: 传入不同的数值,得到不同的权限
 tag: 传"1", 允许 SVIP, VIP 其他不允许,弹框
 传"2", 允许 SVIP, VIP, 金卡, 普卡, 不允许 游客, 过期, 注册会员
 传"3", 允许 SVIP, VIP, 金卡, 普卡, 过期  不允许 游客, 注册会员
 传"4", 不允许 游客, 其他都允许
 传"5", 允许 SVIP, VIP, 普卡  其他权限则不允许
 传"6", 允许 SVIP, 其他不允许
 
 viewController:传入当前VC, 用于导航跳转, 如果传入的是nil 则仅做判断, 不弹框
 
 例如: 1:
 if ([PublicMethod whetherTheTriggerPermissionsWithNavigation:self tag:@"1"]) {
 //如果yes 执行方法体 NO 则在JudgeAuthority类中处理弹框问题
 }
 
 2:
 if (![PublicMethod whetherTheTriggerPermissionsWithNavigation:nil tag:@"1"]) {
 //如果NO ! 执行方法体 不弹框
 //如果viewController 为空nil, 即使权限不够 也不弹框, 用于处理一些不需要弹框的权限问题..
 }
 
 
 {
 除去上面的6中tag值以外,还可以单独去做判断
 比如:  [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"overdue"];
 [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"registeredUsers"];
 overdue: YES: 过期      NO: 未过期
 registeredUsers: YES: 注册会员,  NO: 过期会员
 
 APP_DELEGATE.touristsMode = YES;  touristsMode: yes: 游客, NO: 非游客
 
 NSString *st = [PublicMethod byDigitalReturnCardType];
 st : 普卡会员 金卡会员 VIP会员 至尊会员 四种类型
 }
 
 */
//是否 触发权限  tag值 1: 听记单词, 我的学分
+ (BOOL)whetherTheTriggerPermissionsWithNavigation:(UIViewController *)viewController tag:(NSString *)tag;

// 获得本地直播弹幕本地下载路径
+ (NSString *)getBarrageLocalPathWithId:(NSString *)liveId;
// 获得在线直播弹幕本地下载路径
+ (NSString *)getBarrageOnlinePathWithId:(NSString *)liveId;

@end
