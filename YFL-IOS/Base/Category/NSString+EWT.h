//
//  NSString+EWT.h
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSString (EWT)

@interface NSString (EWT)

/*!
 @brief 字符串的MD5加密
 */
- (instancetype)md5String;

+(NSString *)dateStringWithTmp:(NSInteger)tmp;

+(NSString *)dateTimeNumberStringWithTmp:(NSInteger)tmp;

/**
 *  @author raojie
 *
 *  @brief 反序列化json串，转成字典
 *
 *  @param JSONString 序列化的json串
 *
 *  @return 字典
 */
+(NSDictionary *)JSONSTringToNSDictionary:(NSString *)JSONString;

/**
 *
 */
- (NSDictionary*)ewt_URLParameters;

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

/**
 *  @brief 计算文字的长度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

//根据一个时间戳 和 当前时间做比较  返回值  YES:目标时间戳比当前时间小，可以生效（执行后续操作） NO:目标时间戳比当前时间大，可以生效（不能执行后续操作，直接到过期页面)
+(BOOL)nowTimeCompareTargetTime:(NSInteger)targetTime;

//根据两个时间戳的差 计算时间
+ (NSString *)formateDate:(NSString *)dateString ServerTime:(NSString *)timeServer;


//根据时间戳返回时间
+(NSString *)timestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp;

//直播支付成功时间戳转换 ->2017/08/31 14:11
+(NSString *)livePaySuccessTimestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp;

//我的作业时间戳转换 ->2018-01-01 14:11
+(NSString *)homeWorkTimestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp;

//根据时间戳返回时间(区分今天、明天、昨天)
+(NSString *)timestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp andServerTimestamp:(NSInteger)timestamp;

/**
 关键字 正则判断
 */
-(NSString *)regularPattern:(NSArray *)keys;


/**
 学分记录任务时间显示规则

 @param date 服务器时间
 @return NSString
 */
+ (NSString *)getBeforeNow:(NSDate *)date;


/**
 判断字符串为空

 @param string string
 @return return value description
 */
+ (BOOL)isBlankString:(NSString *)string;


/**
 字符串显示

 @param str 显示字符串
 @param defStr 默认显示字符串
 @return 输出字符串
 */
+ (instancetype)stringValue:(NSString *)str defString:(NSString *)defStr;


/**
 显示的内容
 
 @param practicalCount 实际数量
 @return 赞、粉丝、评论数目，超过1w，显示1.x万
 */
+ (NSString *)showCountText:(NSInteger)practicalCount;

@end

#pragma mark -  NSString (Base64)

@interface NSString (Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end
