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
//ID
@property (nonatomic, copy) NSString *ID;
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
//
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *userDepartment;

@property (nonatomic, copy) NSString *userPic;


@end

NS_ASSUME_NONNULL_END


/*
 browsingNum = 122;
 clickNum = 122;
 commonNum = 0;
 createTime = "2018-08-18 17:51:01";
 id = "4d43ac47-f48e-4df5-9831-f4af927b1c09";
 imgUrl = "/20180818174859_05c9d9a7-8bd8-4359-a03f-7560191ee85b.jpg";
 infoId = 4323dccc6bb14e308691bc50f0a8d2cb;
 infoType = 1;
 shortInfo = "";
 sourceFrom = "\U7ec4\U7ec7\U90e8";
 title = "\U8003\U8bd5\U7ba1\U7406";
 types = "f11be9b9-d136-4123-90cd-ea49063d344c";
 userDepartment = "";
 userPic = "";
 */
