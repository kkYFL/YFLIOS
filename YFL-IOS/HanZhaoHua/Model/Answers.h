//
//  Answers.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Answers : NSObject

//答案干扰项Id
@property(nonatomic, copy) NSString *answerId;
//答案内容
@property(nonatomic, copy) NSString *content;
//是否正确答案 1-是 2-否
@property(nonatomic, assign) NSNumber *isAnswer;
//
@property(nonatomic, assign) NSNumber *selected;

@end

NS_ASSUME_NONNULL_END
