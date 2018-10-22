//
//  PersonRowWithIconCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/20.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonRowWithIconCell : UITableViewCell
+(CGFloat)CellH;
@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *cellContentLabel;
@property (nonatomic, strong) UIImageView *cellNewImageView;
@end
