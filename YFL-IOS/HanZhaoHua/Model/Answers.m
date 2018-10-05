//
//  Answers.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "Answers.h"

@implementation Answers


-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.answerId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"answerId"]];
        self.content = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        self.isAnswer = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isAnswer"]];
        self.selected = [NSString stringWithFormat:@"%@",[dic objectForKey:@"selected"]];

    }
    return self;
}



@end
