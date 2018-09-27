//
//  UserMessage.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "UserMessage.h"

@implementation UserMessage

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.userId = value;
    }
}

//找未找到的Key
- (id) valueForUndefinedKey:(NSString *)key{
    NSLog(@"Undefined Key: %@",key);
    return nil;
}



@end
