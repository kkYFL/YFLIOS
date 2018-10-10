//
//  LearningTaskModel.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "LearningTaskModel.h"

@implementation LearningTaskModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.taskId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskId"]];
        self.userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userId"]];
        self.taskThumb = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskThumb"]];
        self.taskSummary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskSummary"]];
        self.taskTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskTitle"]];
        self.taskContent = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskContent"]];
        self.taskType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"taskType"]];
        self.nowState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nowState"]];
        self.learnTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"learnTime"]];
        self.createTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
        self.nowNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nowNum"]];
        //vedioUrl
        self.vedioUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vedioUrl"]];

    }
    return self;
}

@end

/*
 //任务id
 //用户id
 //缩略图
 //简介
 @property(nonatomic, copy) NSString *;
 //标题
 @property(nonatomic, copy) NSString *;
 //任务内容
 @property(nonatomic, copy) NSString *;
 //任务类型 1 文字 2 视频 3 音频 4 图片
 @property(nonatomic, assign) NSNumber *;
 //学习状态 1：未学习 2：学习中 3：已学习
 @property(nonatomic, assign) NSNumber *;
 //学习时长（分钟）
 @property(nonatomic, assign) NSNumber *;
 //创建时间
 @property(nonatomic, assign) NSNumber *;
 //查看数量
 @property(nonatomic, assign) NSNumber *;
 */
