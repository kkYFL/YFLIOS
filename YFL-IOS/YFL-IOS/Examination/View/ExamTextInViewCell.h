//
//  ExamTextInViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/15.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryExamDetail;

@interface ExamTextInViewCell : UITableViewCell
@property (nonatomic, copy) NSString *sourceUrl;
@property (nonatomic, strong) HistoryExamDetail *examModel;
+(CGFloat)CellHWithExamModel:(HistoryExamDetail *)examModel;

@end
