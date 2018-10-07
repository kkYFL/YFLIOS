//
//  Banner.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "Banner.h"

@implementation Banner


-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.imgUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]];
        self.positionNo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"positionNo"]];
        self.summary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"summary"]];
        self.foreignType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"foreignType"]];
        self.foreignUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"foreignUrl"]];

    }
    return self;
}



@end
