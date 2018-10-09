//
//  SuggestionFeedback.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "SuggestionFeedback.h"

@implementation SuggestionFeedback

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.answerState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"answerState"]];
        self.createTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
        self.problemInfo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"problemInfo"]];
        self.title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
        self.answer = [NSString stringWithFormat:@"%@",[dic objectForKey:@"answer"]];

    }
    return self;
}

/*
 //处理状态； 1：解决中 2：已处理
 @property(nonatomic, copy) NSString *;
 //反馈时间(时间戳)
 @property(nonatomic, copy) NSString *;
 //问题描述
 @property(nonatomic, copy) NSString *;
 //主题
 @property(nonatomic, copy) NSString *;
 //回复信息
 @property(nonatomic, copy) NSString *;
 */
@end
