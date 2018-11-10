//
//  TestRanking.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestRanking : NSObject

//党员得分
@property(nonatomic, assign) NSNumber *score;
//党员名称
@property(nonatomic, copy) NSString *name;
//党员头像
@property(nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *nameZy;

@end

NS_ASSUME_NONNULL_END
