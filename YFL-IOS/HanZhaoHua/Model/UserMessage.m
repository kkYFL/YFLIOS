//
//  UserMessage.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "UserMessage.h"

@implementation UserMessage


-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.applyNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"applyNum"]];
        self.applyState = [NSString stringWithFormat:@"%@",[dic objectForKey:@"applyState"]];
        self.bgImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bgImg"]];
        self.birthTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"birthTime"]];
        self.headImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"headImg"]];
        self.createMan = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createMan"]];
        self.createTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
        self.userId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        self.integral = [NSString stringWithFormat:@"%@",[dic objectForKey:@"integral"]];
        self.modifyMan = [NSString stringWithFormat:@"%@",[dic objectForKey:@"modifyMan"]];
        self.modifyTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"modifyTime"]];
        self.motto = [NSString stringWithFormat:@"%@",[dic objectForKey:@"motto"]];
        self.pmEmail = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmEmail"]];
        self.pmAddress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmAddress"]];
        self.pmAge = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmAge"]];
        self.pmEnterTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmEnterTime"]];
        self.pmIdcard = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmIdcard"]];
        self.pmName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmName"]];
        self.pmNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmNum"]];
        self.pmSex = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmSex"]];
        self.remark = [NSString stringWithFormat:@"%@",[dic objectForKey:@"remark"]];
        self.ssDepartment = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ssDepartment"]];
        self.state = [NSString stringWithFormat:@"%@",[dic objectForKey:@"state"]];
        self.userName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userName"]];
        self.userPass = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userPass"]];
        self.userToken = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userToken"]];

    }
    return self;
}



@end
