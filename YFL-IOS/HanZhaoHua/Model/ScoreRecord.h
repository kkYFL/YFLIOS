//
//  ScoreRecord.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScoreRecord : NSObject

//到期时间
@property(nonatomic, copy) NSString *expireTime;
//得到时间
@property(nonatomic, copy) NSString *getTime;
//说明
@property(nonatomic, copy) NSString *remark;
//分值
@property(nonatomic, copy) NSString *score;
//来源：sign_in - 签到
@property(nonatomic, copy) NSString *source;
//
@property(nonatomic, copy) NSString *pmId;
//
@property(nonatomic, copy) NSString *scoreId;

@end

NS_ASSUME_NONNULL_END
