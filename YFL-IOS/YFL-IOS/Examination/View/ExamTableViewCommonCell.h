//
//  ExamTableViewCommonCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/1.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TestRanking;
@interface ExamTableViewCommonCell : UITableViewCell
@property (nonatomic, strong)  TestRanking *rankModel;
+(CGFloat)CellH;

@end
