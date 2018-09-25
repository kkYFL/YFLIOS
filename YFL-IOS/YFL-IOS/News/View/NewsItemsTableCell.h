//
//  NewsItemsTableCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsItemContentView;

@interface NewsItemsTableCell : UITableViewCell
@property (nonatomic, strong) NewsItemContentView *item1;
@property (nonatomic, strong) NewsItemContentView *item2;
@property (nonatomic, strong) NewsItemContentView *item3;
@property (nonatomic, strong) NewsItemContentView *item4;
+(CGFloat)CellH;
@end

@interface NewsItemContentView : UIView
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *backView;
@end
