//
//  ExamWaitingViewController.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EWTBaseViewController.h"

typedef NS_ENUM(NSInteger,ExamViewType) {
    ExamViewTypeDefault,  //考试历史
    ExamViewTypeHistory   //等待考试
};

@interface ExamWaitingViewController : EWTBaseViewController
@property (nonatomic, assign) ExamViewType type;

@end
