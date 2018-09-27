//
//  TestRanking.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "TestRanking.h"

@implementation TestRanking
//找未找到的Key
- (id) valueForUndefinedKey:(NSString *)key{
    NSLog(@"Undefined Key: %@",key);
    return nil;
}

//设置未找到的Key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"Undefined Key: %@",key);
}
@end
