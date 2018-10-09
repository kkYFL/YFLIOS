//
//  EducationLearnCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudyNotes;
@interface EducationLearnCell : UITableViewCell
+(CGFloat)CellHWithContent:(NSString *)content;
@property (nonatomic, strong) StudyNotes *model;
@end
