//
//  ScoreRecord.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ScoreRecord.h"

@implementation ScoreRecord

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.scoreId = value;
    }
}

//找未找到的Key
- (id) valueForUndefinedKey:(NSString *)key{
    NSLog(@"Undefined Key: %@",key);
    return nil;
}



@end
