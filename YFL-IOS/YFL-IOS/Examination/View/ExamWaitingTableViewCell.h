//
//  ExamWaitingTableViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryExam;
@interface ExamWaitingTableViewCell : UITableViewCell
+(CGFloat)CellH;
@property (nonatomic, assign) BOOL hideRemindLabel;
@property (nonatomic, strong) HistoryExam *examModel;
@end
