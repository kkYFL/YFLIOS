//
//  HistoryExamDetail.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "HistoryExamDetail.h"
#import "Answers.h"

@implementation HistoryExamDetail

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.userAnswer = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userAnswer"]];
        self.examTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"examTitle"]];
        self.examUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"examUrl"]];
        self.examId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"examId"]];
        self.examType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"examType"]];
        self.score = [NSString stringWithFormat:@"%@",[dic objectForKey:@"score"]];
        self.showOrder = [NSString stringWithFormat:@"%@",[dic objectForKey:@"showOrder"]];
        self.titleType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"titleType"]];

        
        self.answers = [NSMutableArray array];
        if ([dic objectForKey:@"answers"] && [[dic objectForKey:@"answers"] isKindOfClass:[NSArray class]]) {
            NSArray *list = [dic objectForKey:@"answers"];
            for (NSDictionary *objDic in list) {
                Answers *ansModel = [[Answers alloc]initWithDic:objDic];
                [self.answers addObject:ansModel];
            }
        }
        
    }
    return self;
}



@end
