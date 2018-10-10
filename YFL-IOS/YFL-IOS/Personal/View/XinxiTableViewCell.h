//
//  XinxiTableViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XinxiCellType) {
    XinxiCellTypeWithJustRow,      //箭头
    XinxiCellTypeWithIconAndRow,   //箭头和icon
    XinxiCellTypeWithJustContent   //无箭头和icon
};

@interface XinxiTableViewCell : UITableViewCell
+(CGFloat)CellH;
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UITextField *cellContentLabel;
@property (nonatomic, strong) UIImageView *headerIcon;
@property (nonatomic, strong) UIImageView *cellNewImageView;
@property (nonatomic, assign) XinxiCellType type;

@end
