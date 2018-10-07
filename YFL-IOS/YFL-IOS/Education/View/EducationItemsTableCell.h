//
//  EducationItemsTableCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationItemsTableCell : UITableViewCell
+(CGFloat)CellH;
@property (nonatomic, strong) NSArray *dataArr;
@end

@interface EducationItemContentView : UIView
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;
@end
