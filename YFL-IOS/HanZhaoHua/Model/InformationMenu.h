//
//  InformationMenu.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationMenu : NSObject

//图片地址
@property(nonatomic, copy) NSString *imgUrl;
//菜单内容
@property(nonatomic, copy) NSString *typeInfo;
//菜单id
@property(nonatomic, assign) NSNumber *menuId;
//未知
@property(nonatomic, assign) NSNumber *appPositon;
//菜单名称
@property(nonatomic, copy) NSString *typeName;

@end

NS_ASSUME_NONNULL_END
