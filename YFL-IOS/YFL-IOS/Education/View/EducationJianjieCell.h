//
//  EducationJianjieCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/7.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LearningTaskModel;
@interface EducationJianjieCell : UITableViewCell
@property (nonatomic, strong) LearningTaskModel *model;
+(CGFloat)CellHWithModel:(LearningTaskModel *)model;
@end
