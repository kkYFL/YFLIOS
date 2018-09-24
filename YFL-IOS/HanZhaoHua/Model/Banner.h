//
//  Banner.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Banner : NSObject

//图片地址
@property(nonatomic, copy) NSString *imgUrl;
//位置编号
@property(nonatomic, copy) NSString *positionNo;
//简介
@property(nonatomic, copy) NSString *summary;
//链接类型 1:外链接 2：内链接
@property(nonatomic, assign) NSNumber *foreignType;
//链接地址
@property(nonatomic, copy) NSString *foreignUrl;

@end

NS_ASSUME_NONNULL_END
