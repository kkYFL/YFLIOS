//
//  NewsContentMaxImageViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContentMaxImageViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *cellTitleLab;
@property (nonatomic, strong) UIImageView *iconImageView;
+(CGFloat)CellH;
@property (nonatomic, copy) void (^selectBlock) (NSString *content);

@end
