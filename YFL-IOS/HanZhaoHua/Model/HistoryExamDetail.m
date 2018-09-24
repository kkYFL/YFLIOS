//
//  HistoryExamDetail.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "HistoryExamDetail.h"

@implementation HistoryExamDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"answers"]) {
        NSArray * list = value;
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in list) {
            Answers *model = [[Answers alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [result addObject:model];
        }
        self.answers = [[NSArray alloc] initWithArray:result];
    }
}

@end
