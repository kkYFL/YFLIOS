//
//  NewsNoticiTableViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsNoticiTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *timeLabel;
+(CGFloat)CellH;

@end
