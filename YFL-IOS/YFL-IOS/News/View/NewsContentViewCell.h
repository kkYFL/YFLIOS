//
//  NewsContentViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/26.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContentViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UILabel *laiyunLabel;
@property (nonatomic, strong) UILabel *pinlunLabel;
+(CGFloat)CellH;
@end
