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
@property(nonatomic, assign) NSNumber *applyState;
//
@property(nonatomic, copy) NSString *bgImg;
//
@property(nonatomic, copy) NSString *birthTime;
//头像地址
@property(nonatomic, copy) NSString *headImg;
//
@property(nonatomic, assign) NSNumber *createMan;
//创建时间
@property(nonatomic, copy) NSString *createTime;
//用户id
@property(nonatomic, assign) NSNumber *userId;
//
@property(nonatomic, assign) NSNumber *integral;
//
@property(nonatomic, assign) NSNumber *modifyMan;
//
@property(nonatomic, copy) NSString *modifyTime;
//
@property(nonatomic, copy) NSString *motto;
//
@property(nonatomic, copy) NSString *pmEmail;
//
@property(nonatomic, copy) NSString *pmAddress;
//创建时间
@property(nonatomic, assign) NSNumber *pmAge;
//
@property(nonatomic, copy) NSString *pmEnterTime;
//
@property(nonatomic, assign) NSNumber *pmIdcard;
//
@property(nonatomic, copy) NSString *pmName;
//
@property(nonatomic, copy) NSString *pmNum;
//
@property(nonatomic, assign) NSNumber *pmSex;
//
@property(nonatomic, copy) NSString *remark;
//
@property(nonatomic, copy) NSString *ssDepartment;
//
@property(nonatomic, assign) NSNumber *state;
//
@property(nonatomic, copy) NSString *userName;
//
@property(nonatomic, copy) NSString *userPass;
//
@property(nonatomic, assign) NSNumber *userToken;

@end

NS_ASSUME_NONNULL_END
