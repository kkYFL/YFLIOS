//
//  ExamChooseCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/12.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryExamDetail;
@interface ExamChooseCell : UITableViewCell
+(CGFloat)CellHWithModel:(HistoryExamDetail *)examModel;
@property (nonatomic, copy) void (^chooseActionBlock) (NSInteger chooseIndex);
-(void)setExamModel:(HistoryExamDetail *)examModel isHistory:(BOOL)isHistory;

@end


@interface ExamChooseTagView : UIView
@property (nonatomic, strong) UIImageView *cellSelectView;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UILabel *quetionContentLabel;
@end
