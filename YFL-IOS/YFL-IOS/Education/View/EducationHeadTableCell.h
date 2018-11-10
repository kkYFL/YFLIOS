//
//  EducationHeadTableCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Banner;
@interface EducationHeadTableCell : UITableViewCell
@property (nonatomic, strong) UILabel *cellContentLabel;
@property (nonatomic, strong) Banner *videoModel;
+(CGFloat)CellHWithModel:(Banner *)videoModel;
@end

