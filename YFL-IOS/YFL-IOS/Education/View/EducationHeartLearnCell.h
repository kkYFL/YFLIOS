//
//  EducationHeartLearnCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LearningTaskModel;
@class LearningHistory;

@interface EducationHeartLearnCell : UITableViewCell
@property (nonatomic, strong) LearningTaskModel *learnModel;
@property (nonatomic, strong) LearningHistory *histroyModel;
+(CGFloat)CellH;
@end
