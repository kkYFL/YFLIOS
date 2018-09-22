//
//  LearningHistory.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

/// 学习痕迹列表

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LearningHistory : NSObject

//开始时间
@property(nonatomic, copy) NSString *startTime;
//结束时间
@property(nonatomic, copy) NSString *endTime;
//本次学习时长
@property(nonatomic, assign) NSNumber *learnTime;

@end

NS_ASSUME_NONNULL_END
