//
//  NewsDetail.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetail : NSObject

//用户id
@property(nonatomic, copy) NSString *userId;
//用户token
@property(nonatomic, copy) NSString *userToken;
//图片地址
@property(nonatomic, copy) NSString *imgUrl;
//位置编号
@property(nonatomic, copy) NSString *positionNo;
//简介
@property(nonatomic, copy) NSString *summary;
//链接地址
@property(nonatomic, copy) NSString *foreignUrl;
//链接类型 1:外链接 2：内链接
@property(nonatomic, assign) NSNumber *foreignType;


//视频url
@property (nonatomic, copy) NSString *videoUrl;
//title
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sourceFrom;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *createTime;




@end

NS_ASSUME_NONNULL_END
