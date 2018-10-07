//
//  SignMoel.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/7.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignMoel : NSObject
@property (nonatomic, copy) NSString *continueSignIn;
@property (nonatomic, copy) NSString *todayTotalNum;
@property (nonatomic, copy) NSString *totalSignIn;


@property (nonatomic, copy) NSString *pmId;
@property (nonatomic, copy) NSString *ID;


@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, strong) NSMutableArray *signDatArr;



-(id)initWithDic:(NSDictionary *)dic;

@end
