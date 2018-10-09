//
//  EducationOptionsTableCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/21.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SuggestionFeedback;

@interface EducationOptionsTableCell : UITableViewCell
@property (nonatomic, strong) SuggestionFeedback *feedBackModel;
+(CGFloat)CellH;
@end
