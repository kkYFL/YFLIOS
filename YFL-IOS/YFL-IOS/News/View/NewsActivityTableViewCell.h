//
//  NewsActivityTableViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsMessage;

@interface NewsActivityTableViewCell : UITableViewCell
@property (nonatomic, strong) NewsMessage *messModel;
+(CGFloat)CellHWithMoel:(NewsMessage *)newModel;
@end
