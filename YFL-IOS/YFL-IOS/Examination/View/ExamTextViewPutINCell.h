//
//  ExamTextViewPutINCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/15.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTextViewPutINCell : UITableViewCell
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderView;
@property (nonatomic, assign) BOOL isHistory;

+(CGFloat)CellH;
@end
