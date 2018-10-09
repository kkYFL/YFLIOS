//
//  LearHistroyListiViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LearningHistory;
@interface LearHistroyListiViewCell : UITableViewCell
@property (nonatomic, strong) LearningHistory *historyModel;
+(CGFloat)CellH;
@end
