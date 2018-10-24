//
//  FanbuDetailViewController.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/24.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EWTBaseViewController.h"

typedef NS_ENUM(NSInteger,FanbuDetailType) {
    FanbuDetailTypeDefault,
    FanbuDetailTypeExam,
};

@interface FanbuDetailViewController : EWTBaseViewController
@property (nonatomic, assign) FanbuDetailType type;
@property (nonatomic, copy) NSString *ID;

@end
