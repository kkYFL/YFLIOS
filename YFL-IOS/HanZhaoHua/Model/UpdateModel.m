//
//  UpdateModel.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/11/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "UpdateModel.h"

@implementation UpdateModel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.appType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appType"]];
        self.version = [NSString stringWithFormat:@"%@",[dic objectForKey:@"version"]];
        self.isForceUpdate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isForceUpdate"]];
        self.filePath = [NSString stringWithFormat:@"%@",[dic objectForKey:@"filePath"]];
        self.info = [NSString stringWithFormat:@"%@",[dic objectForKey:@"info"]];
    }
    return self;
}
@end






