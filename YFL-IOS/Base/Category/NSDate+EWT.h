//
//  NSDate+EWT.h
//  Ewt360
//
//  Created by 李天露 on 2018/1/17.
//  Copyright © 2018年 铭师堂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (EWT)


/**
 是否在时间段内

 @param fromDate 开始时间
 @param toDate 结束时间
 @return BOOL
 */
- (BOOL)betweenFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/**
 
 *  是否为今天
 
 */

- (BOOL)isToday;

/**
 
 *  是否为昨天
 
 */

- (BOOL)isYesterday;

/**
 
 *  是否为今年
 
 */

- (BOOL)isThisYear;


/**
 NSDate转NSString

 @param format yyyy/MM/dd HH:mm
 @return dateStr
 */
- (NSString *)stringWithFormat:(NSString *)format;

/**
 *  比较两个日期之间的差值
 */
- (NSDateComponents *)deltaFromDate:(NSDate *)fromDate;

@end
