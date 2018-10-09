//
//  NewsContentViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/26.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsMessage.h"

@interface NewsContentViewCell : UITableViewCell
@property (nonatomic, strong) NewsMessage *newsModel;
+(CGFloat)CellHWithModel:(NewsMessage *)model;
@end
