//
//  ExamConentViewController.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/12.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EWTBaseViewController.h"
@class ExamRuleModel;

@interface ExamConentViewController : EWTBaseViewController
@property (nonatomic, strong) ExamRuleModel *ruleDic;
@property (nonatomic, assign) BOOL isWaiting;//是否等待

@end
