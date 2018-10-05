//
//  ExamRuleModel.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/30.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamRuleModel.h"

@implementation ExamRuleModel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.times = [NSString stringWithFormat:@"%@",[dic objectForKey:@"times"]];
        self.totalTimes = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalTimes"]];
        self.totalTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalTime"]];
        self.paperTitle = [NSString stringWithFormat:@"%@",[dic objectForKey:@"paperTitle"]];
        self.beginTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"beginTime"]];
        self.finalTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"finalTime"]];
        self.summary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"summary"]];
        self.examId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"examId"]];
        self.paperId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"paperId"]];

        self.rules = [NSMutableArray array];
        if ([dic objectForKey:@"rules"] && [[dic objectForKey:@"rules"] isKindOfClass:[NSArray class]]) {
            self.rules = (NSArray *)[dic objectForKey:@"rules"];
        }
        
    }
    return self;
}




@end
