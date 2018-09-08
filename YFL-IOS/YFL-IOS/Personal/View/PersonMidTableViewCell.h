//
//  PersonMidTableViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/2.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonMidTableViewCell : UITableViewCell
+(CGFloat)CellH;
@property (nonatomic, copy) void (^selectViewBlock) (NSInteger viewIndex);

@end
