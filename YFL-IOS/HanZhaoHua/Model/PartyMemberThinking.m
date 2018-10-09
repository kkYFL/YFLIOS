//
//  PartyMemberThinking.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PartyMemberThinking.h"

@implementation PartyMemberThinking


-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.pmName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pmName"]];
        self.headImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"headImg"]];
        self.ssDepartment = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ssDepartment"]];
        self.commentInfo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"commentInfo"]];
        self.createTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];

    }
    return self;
}
/*
 //用户姓名
 @property(nonatomic, copy) NSString *;
 //党员头像
 @property(nonatomic, copy) NSString *;
 //部门
 @property(nonatomic, copy) NSString *;
 //评论内容
 @property(nonatomic, copy) NSString *;
 //评论时间
 @property(nonatomic, copy) NSString *;
 */
@end
