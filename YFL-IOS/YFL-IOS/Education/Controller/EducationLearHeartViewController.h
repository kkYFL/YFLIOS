//
//  EducationLearHeartViewController.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EWTBaseViewController.h"


typedef NS_ENUM(NSInteger,MYEducationViewType) {
    MYEducationViewTypeDefault,  //学习任务
    MYEducationViewTypeHistory   //学习记录
};

@interface EducationLearHeartViewController : EWTBaseViewController
@property (nonatomic, assign) MYEducationViewType type;

@end
