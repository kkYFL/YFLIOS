//
//  FanbuDangyuanMode.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/24.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanbuDangyuanMode : NSObject
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *pmEnterTime;
@property (nonatomic, copy) NSString *pmName;
@property (nonatomic, copy) NSString *nowState;
@property (nonatomic, copy) NSString *paperState;


-(id)initWithDic:(NSDictionary *)dic;
@end
