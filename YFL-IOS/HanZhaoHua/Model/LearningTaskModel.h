//
//  LearningTaskModel.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

/// 学习任务列表

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LearningTaskModel : NSObject

//任务id
@property(nonatomic, copy) NSString *taskId;
//用户id
@property(nonatomic, copy) NSString *userId;
//缩略图
@property(nonatomic, copy) NSString *taskThumb;
//简介
@property(nonatomic, copy) NSString *taskSummary;
//标题
@property(nonatomic, copy) NSString *taskTitle;
//任务内容
@property(nonatomic, copy) NSString *taskContent;
//任务类型 1 文字 2 视频 3 音频 4 图片
@property(nonatomic, assign) NSNumber *taskType;
//学习状态 1：未学习 2：学习中 3：已学习
@property(nonatomic, assign) NSNumber *nowState;
//学习时长（分钟）
@property(nonatomic, assign) NSNumber *learnTime;
//创建时间
@property(nonatomic, assign) NSNumber *createTime;
//查看数量
@property(nonatomic, assign) NSNumber *nowNum;

@end

NS_ASSUME_NONNULL_END
