//
//  SuggestionFeedback.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

/// 意见反馈列表

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuggestionFeedback : NSObject

//处理状态； 1：解决中 2：已处理
@property(nonatomic, copy) NSString *answerState;
//反馈时间(时间戳)
@property(nonatomic, copy) NSString *createTime;
//问题描述
@property(nonatomic, copy) NSString *problemInfo;
//主题
@property(nonatomic, copy) NSString *title;
//回复信息
@property(nonatomic, copy) NSString *answer;

-(id)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
