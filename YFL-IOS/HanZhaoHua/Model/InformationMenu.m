//
//  InformationMenu.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "InformationMenu.h"

@implementation InformationMenu


-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.imgUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]];
        self.typeInfo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"typeInfo"]];
        self.menuId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        self.appPositon = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appPositon"]];
        self.typeName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"typeName"]];

    }
    return self;
}



@end
