//
//  NewsRightIConTableCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsRightIConTableCell : UITableViewCell
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *laiyunLabel;
@property (nonatomic, strong) UILabel *pinlunLabel;
+(CGFloat)CellH;
@end
