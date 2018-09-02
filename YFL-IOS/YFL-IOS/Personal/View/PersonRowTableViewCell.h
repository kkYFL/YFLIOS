//
//  PersonRowTableViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/2.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonRowTableViewCell : UITableViewCell
+(CGFloat)CellH;
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *cellContentLabel;
@property (nonatomic, strong) UIImageView *cellNewImageView;
@end
