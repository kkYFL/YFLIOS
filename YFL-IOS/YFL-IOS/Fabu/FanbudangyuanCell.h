//
//  FanbudangyuanCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/24.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FanbuDangyuanMode;

@interface FanbudangyuanCell : UITableViewCell
@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *cellContent;

@property (nonatomic, strong) FanbuDangyuanMode *dangyunModel;
+(CGFloat)CellH;
@end
