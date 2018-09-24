//
//  HistoryExam.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryExam : NSObject

//已考试次数
@property(nonatomic, assign) NSNumber *times;
//允许考试次数
@property(nonatomic, assign) NSNumber *totalTimes;
//考试总时间
@property(nonatomic, assign) NSNumber *totalTime;
//考试标题
@property(nonatomic, copy) NSString *paperTitle;
//考试开始时间
@property(nonatomic, copy) NSString *beginTime;
//考试结束时间
@property(nonatomic, copy) NSString *finalTime;
//考试状态：1-已考试 2-待考试 3-已完成
@property(nonatomic, assign) NSNumber *state;
//考试简介
@property(nonatomic, copy) NSString *summary;
//考试id
@property(nonatomic, assign) NSNumber *examId;
//考试试卷id
@property(nonatomic, assign) NSNumber *paperId;

@end

NS_ASSUME_NONNULL_END
