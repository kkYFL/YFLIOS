//
//  NewsMessage.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsMessage : NSObject

//浏览量
@property(nonatomic, assign) NSNumber *browsingNum;
//点赞量
@property(nonatomic, assign) NSNumber *clickNum;
//评论条数
@property(nonatomic, assign) NSNumber *commonNum;
//首页图片地址
@property(nonatomic, copy) NSString *imgUrl;
//新闻id
@property(nonatomic, copy) NSString *infoId;
//新闻类型
@property(nonatomic, copy) NSString *infoType;
//资讯简介
@property(nonatomic, copy) NSString *shortInfo;
//新闻来源
@property(nonatomic, copy) NSString *sourceFrom;
//标题
@property(nonatomic, copy) NSString *title;
//资讯类型
@property(nonatomic, copy) NSString *types;

@end

NS_ASSUME_NONNULL_END
