//
//  ExamTimuTitleViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/11/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTimuTitleViewCell : UITableViewCell

@property (nonatomic, strong) NSString *cellTitle;
+(CGFloat)CellHWithContent:(NSString *)cellTitle;

@end
