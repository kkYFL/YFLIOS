//
//  HistoryExamDetail.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Answers.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryExamDetail : NSObject

//用户答案
@property(nonatomic, copy) NSString *userAnswer;
//试题内容
@property(nonatomic, copy) NSString *examTitle;
//考试视频或音频链接地址
@property(nonatomic, copy) NSString *examUrl;
//考试试题ID
@property(nonatomic, copy) NSString *examId;
//答案列表
@property(nonatomic, strong) NSMutableArray *answers;
//试题类型【1、单选 2、多选 3、填空 4、判断 5、简答】
@property(nonatomic, copy) NSString *examType;
//
@property(nonatomic, copy) NSString *score;
//
@property(nonatomic, copy) NSString *showOrder;
//1 文字  2 视频  3 音频  4 图片 
@property(nonatomic, copy) NSString *titleType;

-(id)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
