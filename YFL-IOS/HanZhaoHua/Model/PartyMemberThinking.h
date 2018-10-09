//
//  PartyMemberThinking.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

/// 党员心声

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartyMemberThinking : NSObject

//用户姓名
@property(nonatomic, copy) NSString *pmName;
//党员头像
@property(nonatomic, copy) NSString *headImg;
//部门
@property(nonatomic, copy) NSString *ssDepartment;
//评论内容
@property(nonatomic, copy) NSString *commentInfo;
//评论时间
@property(nonatomic, copy) NSString *createTime;

-(id)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
