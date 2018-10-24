//
//  FanbuDangyuanMode.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/24.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "FanbuDangyuanMode.h"

@implementation FanbuDangyuanMode
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.headImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"headImg"]];
        self.pmEnterTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmEnterTime"]];
        self.pmName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmName"]];
        self.nowState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nowState"]];
        self.paperState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"paperState"]];

    }
    return self;
}
@end
