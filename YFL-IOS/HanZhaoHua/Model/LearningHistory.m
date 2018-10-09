//
//  LearningHistory.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "LearningHistory.h"

@implementation LearningHistory
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.startTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"startTime"]];
        self.endTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"endTime"]];
        self.learnTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"learnTime"]];

    }
    return self;
}

@end
