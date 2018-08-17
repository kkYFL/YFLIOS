//
//  NSDate+EWT.m
//  Ewt360
//
//  Created by 李天露 on 2018/1/17.
//  Copyright © 2018年 铭师堂. All rights reserved.
//

#import "NSDate+EWT.h"

@implementation NSDate (EWT)

- (BOOL)betweenFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    if ([self compare:fromDate] == NSOrderedDescending && [self compare:toDate] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

/**
 *  比较两个日期之间的差值
 */
- (NSDateComponents *)deltaFromDate:(NSDate *)fromDate
{
    // 日历
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 返回日期的差值
    return [calender components:unit fromDate:fromDate toDate:self options:0];
}

/**
 *  判断是否为今年
 */
- (BOOL)isThisYear
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    return nowYear == selfYear;
}

/**
 *  判断是否为今天
 */
- (BOOL)isToday
{
    // 2015-07-28 18:30:00 -> 2015-07-28
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 日期转化为字符串
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}
/**
 *  判断是否为昨天
 */
-(BOOL)isYesterday
{
    // 2015-07-28 18:30:00 -> 2015-07-28
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 转换日期
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    // 日历(比较时间)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    return timestamp_str;
}

@end
