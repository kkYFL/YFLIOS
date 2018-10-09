//
//  NewsContentMaxImageViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsContentMaxImageViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) NSString *content;
+(CGFloat)CellHWithContent:(NSString *)content;
@property (nonatomic, copy) void (^selectBlock) (NSString *content);

@end
