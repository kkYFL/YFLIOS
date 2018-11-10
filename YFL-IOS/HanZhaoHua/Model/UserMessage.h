//
//  UserMessage.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserMessage : NSObject

//未标注释部分, 是接口文档没有说明
//
@property(nonatomic, copy) NSString *applyNum;
//
@property(nonatomic, copy) NSString *applyState;
//
@property(nonatomic, copy) NSString *bgImg;
//
@property(nonatomic, copy) NSString *birthTime;
//头像地址
@property(nonatomic, copy) NSString *headImg;
//
@property(nonatomic, copy) NSString *createMan;
//创建时间
@property(nonatomic, copy) NSString *createTime;
//用户id
@property(nonatomic, copy) NSString *userId;
//
@property(nonatomic, copy) NSString *integral;
//
@property(nonatomic, copy) NSString *modifyMan;
//
@property(nonatomic, copy) NSString *modifyTime;
//
@property(nonatomic, copy) NSString *motto;
//
@property(nonatomic, copy) NSString *pmEmail;
//
@property(nonatomic, copy) NSString *pmAddress;
//创建时间
@property(nonatomic, copy) NSString *pmAge;
//
@property(nonatomic, copy) NSString *pmEnterTime;
//
@property(nonatomic, copy) NSString *pmIdcard;
//
@property(nonatomic, copy) NSString *pmName;
//
@property(nonatomic, copy) NSString *pmNum;
//
@property(nonatomic, copy) NSString *pmSex;
//
@property(nonatomic, copy) NSString *remark;
//
@property(nonatomic, copy) NSString *ssDepartment;
//
@property(nonatomic, copy) NSString *state;
//
@property(nonatomic, copy) NSString *userName;
//
@property(nonatomic, copy) NSString *userPass;
//
@property(nonatomic, copy) NSString *userToken;
//1 部长   2 支部书记  5  普通党员
@property (nonatomic, copy) NSString *pmAuthor;


-(id)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
