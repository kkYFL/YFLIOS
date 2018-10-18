//
//  PersonSettingCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/18.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonSettingCell : UITableViewCell
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *cellContentLabel;
+(CGFloat)CellH;
@end
