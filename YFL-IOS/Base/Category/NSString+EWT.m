//
//  NSString+EWT.m
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import "NSString+EWT.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+EWT.h"

static int const minitue = 60;         //分
static int const hour = 3600;          //时
static int const day = 86400;          //天

#pragma mark - NSString (EWT)
@implementation NSString (EWT)

- (instancetype)md5String {
    if ([NSString isBlankString:self]) {
        return @"";//防止crash
    }
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}

+(NSString *)dateStringWithTmp:(NSInteger)tmp{
    
    NSInteger localTime = [[self accessToLocalTime] integerValue];
    NSInteger timeInterval  = localTime - tmp;
    NSString *timeString = [NSString stringWithFormat:@"%zi",tmp];
    return [self needViewTime:timeInterval timeStamp:timeString];
    
}

+(NSString *)dateTimeNumberStringWithTmp:(NSInteger)tmp{
    
    NSInteger localTime = [[self accessToLocalTime] integerValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:tmp];
    NSString * targetTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:tmp]];
    NSString * localTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:localTime]];
    
    NSArray * targetDateArray = [((NSArray *)[targetTimeStr componentsSeparatedByString:@" "])[0] componentsSeparatedByString:@"-"];
    NSArray * localDateArray = [((NSArray *)[localTimeStr componentsSeparatedByString:@" "])[0] componentsSeparatedByString:@"-"];
    
    if ([targetDateArray[0] isEqualToString:localDateArray[0]]) {//同一年
        
        if ([targetDateArray[1] isEqualToString:localDateArray[1]] && [targetDateArray[2] isEqualToString:localDateArray[2]]){
            
            NSInteger timeInterval  = localTime - tmp;
            NSString *timeString = [NSString stringWithFormat:@"%zi",tmp];
            return [self needViewWithNumberTime:timeInterval timeStamp:timeString];
        }else{
            return [NSString stringWithFormat:@"%@-%@",targetDateArray[1],targetDateArray[2]];
        }
    }else{
        return ((NSArray *)[targetTimeStr componentsSeparatedByString:@" "])[0];
    }
    
}

//获取本地时间戳
+ (NSString *)accessToLocalTime{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

//根据相差时间返回不同显示时间结果 不显示xx分钟以前
+ (NSString *)needViewWithNumberTime:(NSInteger)timeInterval timeStamp:(NSString *)timeStamp{
    
    NSString *timeDate = [[NSString alloc] init];
    NSTimeInterval time=[timeStamp doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    float hour = timeInterval/60./60.;
    
    
    if (timeInterval < 120) {
        timeDate = @"刚刚";
    }else if (hour < 1){
        timeDate = [NSString stringWithFormat:@"%zi分钟前",timeInterval/60];
    }else{
        [dateFormatter setDateFormat:@"HH:mm"];
        timeDate = [dateFormatter stringFromDate: detaildate];
    }
    return timeDate;
}

//根据相差时间返回不同显示时间结果
+ (NSString *)needViewTime:(NSInteger)timeInterval timeStamp:(NSString *)timeStamp{
    
    NSString *timeDate = [[NSString alloc] init];
    NSTimeInterval time=[timeStamp doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    float hour = timeInterval/60./60.;
    if (hour < 1 && hour >0) {
        //
        timeDate = [NSString stringWithFormat:@"%zi分钟前", timeInterval/60];
    } else if (hour < 12 && hour >= 1){
        //
        
        [dateFormatter setDateFormat:@"HH:mm"];
        timeDate = [dateFormatter stringFromDate: detaildate];
    } else if (hour < 12 * 365 && hour >= 12) {
        //
        [dateFormatter setDateFormat:@"MM月dd日"];
        timeDate = [dateFormatter stringFromDate: detaildate];
    } else if (hour >= 12 * 365) {
        //
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        timeDate = [dateFormatter stringFromDate: detaildate];
    } else {
        timeDate = @"0 分钟前";
    }
    
    return timeDate;
}


+(NSDictionary *)JSONSTringToNSDictionary:(NSString *)JSONString{
    
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
    
    
}

- (NSDictionary*)ewt_URLParameters {
    NSRange range = [self rangeOfString:@"?"];
    
    if(range.location == NSNotFound || range.length <= 0) {return nil;}
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    
    if([parametersString containsString:@"&"]) {
        
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for(NSString *keyValuePair in urlComponents) {
            
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            //key不能为nil
            
            if(key == nil|| value == nil) {continue;}
            
            id existValue = [params valueForKey:key];
            
            if(existValue != nil) {
                
                //已存在的值，生成数组。
                
                if([existValue isKindOfClass:[NSArray class]]) {
                    
                    //已存在的值生成数组
                    
                    NSMutableArray*items = [NSMutableArray arrayWithArray:existValue];
                    
                    [items addObject:value];
                    
                    [params setValue:items forKey:key];
                    
                }else{
                    [params setValue:@[existValue,value]forKey:key];
                }
            }else{
                //设置值
                [params setValue:value forKey:key];
            }
        }
    }else{
        
        //单个参数生成key/value
        
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        if(pairComponents.count == 1) {return nil;}
        
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        //key不能为nil
        
        if(key == nil || value == nil) {
            
            return nil;
        }
        //设置值
        [params setValue:value forKey:key];
    }
    return params;
}

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的长度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}


+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    // NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"%u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    /*
    NSString* returnStr = [ NSPropertyListSerialization  propertyListFromData:tempData
                                                             mutabilityOption:NSPropertyListImmutable
                                                                       format:NULL
                                                             errorDescription:NULL];
    */
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData
                                                                    options:NSPropertyListImmutable
                                                                     format:NULL error:NULL];
    
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}

//根据一个时间戳 和 当前时间做比较  返回值  YES:目标时间戳比当前时间小，可以生效（执行后续操作） NO:目标时间戳比当前时间大，可以生效（不能执行后续操作，直接到过期页面)
+(BOOL)nowTimeCompareTargetTime:(NSInteger)targetTime{
    
    unsigned int target_time = targetTime;
    NSInteger localTime = [[self accessToLocalTime] integerValue];
    if(target_time>localTime){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)formateDate:(NSString *)dateString ServerTime:(NSString *)timeServer
{
    
    NSDate * nowDate = [NSDate dateWithTimeIntervalSince1970:[timeServer intValue]];
    NSDate *needFormatDate = [NSDate dateWithTimeIntervalSince1970:[dateString intValue]];
    
    //// 再然后，把间隔的秒数折算成天数和小时数：
    
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:needFormatDate];
    
    long temp = 0;
    
    NSString *result;
    
    if (timeInterval/60 < 1) {
        
        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    }
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    }
    
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    }
    
    else if((temp = temp/30) <12){
        
        result = [NSString stringWithFormat:@"%ld月前",temp];
        
    }
    
    else{
        
        temp = temp/12;
        
        result = [NSString stringWithFormat:@"%ld年前",temp];
        
    }
    
    return result;
    
    
}

+ (NSString *)getBeforeNow:(NSDate *)createDate
{
    if(createDate == nil){
        return nil;
    }
    NSString *retString = nil;
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    if (createDate.isThisYear) { // 今年
        if (createDate.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFromDate:createDate];
            if (cmps.hour >= 1) { // 1个小时 > 时间差
                fmt.dateFormat = @"H:m";
                return [fmt stringFromDate:createDate];
            } else if (cmps.minute >= 1) { // 1个小时 > 时间差 > 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差
                return @"刚刚";
            }
        } else if (createDate.isYesterday) {//昨天
            fmt.dateFormat = @"M-d";
            return [fmt stringFromDate:createDate];
        } else { // 其他
            fmt.dateFormat = @"M-d";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-M-d";
        return [fmt stringFromDate:createDate];
    }
}


+(NSString *)timestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp{
    
    NSString * str = [self timestampSwitchTime:timestamp andFormatter:@"MM-dd HH:mm"];
    NSString * tmpStr = [NSString stringWithFormat:@"*%@",str];
    NSString * tmpstr2 = [[[tmpStr stringByReplacingOccurrencesOfString:@"*0" withString:@""] stringByReplacingOccurrencesOfString:@"-0" withString:@"-"] stringByReplacingOccurrencesOfString:@"*" withString:@""];

    return [[tmpstr2 stringByReplacingOccurrencesOfString:@"-" withString:@"月"] stringByReplacingOccurrencesOfString:@" " withString:@"日 "];
}
//直播支付成功时间戳转换 ->2017/08/31 14:11
+(NSString *)livePaySuccessTimestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp{
    NSString * str = [self timestampSwitchTime:timestamp andFormatter:@"yyyy/MM/dd HH:mm"];
    return str;
}
//我的作业时间戳转换 ->2018-01-01 14:11
+(NSString *)homeWorkTimestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp{
    
    NSString * tmpStr = [NSString stringWithFormat:@"%zi",timestamp];
    NSInteger leng = tmpStr.length-10;
    if (leng>0) {
        NSInteger chushu = pow(10, leng);
        NSInteger newtimestamp = timestamp/chushu;
        NSString * str = [self timestampSwitchTime:newtimestamp andFormatter:@"yyyy-MM-dd HH:mm"];
        return str;
    }else{
        NSString * str = [self timestampSwitchTime:timestamp andFormatter:@"yyyy-MM-dd HH:mm"];
        return str;
    }
}
+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
    
}


//根据时间戳返回时间(区分今天、明天)
+(NSString *)timestampFormaterMonthDayTimeSwitchTime:(NSInteger)timestamp andServerTimestamp:(NSInteger)servertimestamp{
    
    NSString * resultStr = [self distanceTimeWithBeforeTime:timestamp andServerTime:servertimestamp];
    if (resultStr.length == 0) {
        resultStr = [self timestampFormaterMonthDayTimeSwitchTime:timestamp];
    }
    
    return resultStr;
}

+(NSString *)distanceTimeWithBeforeTime:(double)beTime andServerTime:(NSInteger)serverTime
{
    //NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = serverTime - beTime;
    NSString * distanceStr = @"";
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
        
        if ([lastDay integerValue] - [nowDay integerValue] == 1 || ([nowDay integerValue] - [lastDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"明天 %@",timeStr];
        }
        
    }
    
    
    return distanceStr;
}


/**
 关键字 正则判断
 */
-(NSString *)regularPattern:(NSArray *)keys{
    NSMutableString *pattern = [[NSMutableString alloc] initWithString:@"(?i)"];
    
    for (NSString *key in keys) {
        [pattern appendFormat:@"%@|",key];
    }
    
    return pattern;
}

+ (instancetype)stringValue:(NSString *)str defString:(NSString *)defStr {
    if ([str isKindOfClass:[NSString class]]) {
        return [NSString isBlankString:str]?defStr:str;
    }else if([str isKindOfClass:[NSNumber class]]) {
        return str?[(NSNumber *)str stringValue]:defStr;
    }
    return defStr;
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || [string isEqual:[NSNull null]] || ![string isKindOfClass:[NSString class]] ||string.length == 0 || [string isEqualToString:@""] || [string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    NSString *theStr = [self removeEndSpaceFrom:string];
    if (theStr.length == 0 || [theStr isEqualToString:@""]) {
        return YES;
    }
    
    NSString *subStr = [self removeLineFeedFrom:string];
    if (subStr.length == 0 || [subStr isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (NSString *)removeEndSpaceFrom:(NSString *)strtoremove {
    NSUInteger location = 0;
    unichar charBuffer[[strtoremove length]];
    [strtoremove getCharacters:charBuffer];
    NSUInteger i = 0;
    for ( i = [strtoremove length]; i >0; i--){
        if (![[NSCharacterSet whitespaceCharacterSet] characterIsMember:charBuffer[i - 1]]){
            break;
        }
    }
    return  [strtoremove substringWithRange:NSMakeRange(location, i  - location)];
}

+ (NSString *)removeLineFeedFrom:(NSString *)headerData {
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return headerData;
}

+ (NSString *)showCountText:(NSInteger)practicalCount{
    NSString * showString = [NSString stringWithFormat:@"%ld", (long)practicalCount];
    if (practicalCount >= 10000) {
        showString = [NSString stringWithFormat:@"%.1f万", floor((double)practicalCount * 10 / 10000.0f) / 10.0];
        if ([showString rangeOfString:@".0万"].location != NSNotFound) {
            NSRange range = [showString rangeOfString:@".0万"];
            showString = [NSString stringWithFormat:@"%@万", [showString substringToIndex:range.location]];
        }
    }
    
    return showString;
}


@end

#pragma mark - NSString (Base64)

@implementation NSString (Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    if (data)
    {
        NSString *result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
#if !__has_feature(objc_arc)
        [result autorelease];
#endif
        
        return result;
    }
    return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString
{
    return [NSString stringWithBase64EncodedString:self];
}

- (NSData *)base64DecodedData
{
    return [NSData dataWithBase64EncodedString:self];
}



@end
