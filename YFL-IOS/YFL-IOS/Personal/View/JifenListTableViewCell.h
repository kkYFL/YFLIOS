//
//  JifenListTableViewCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/11.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreRecord;
@interface JifenListTableViewCell : UITableViewCell
@property (nonatomic, strong)  ScoreRecord *record;
+(CGFloat)CellH;
@end
