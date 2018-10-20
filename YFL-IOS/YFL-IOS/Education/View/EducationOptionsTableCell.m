//
//  EducationOptionsTableCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/21.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationOptionsTableCell.h"
#import "SuggestionFeedback.h"

@interface EducationOptionsTableCell ()
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *cellContent;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIImageView *rowImageView;
@property (nonatomic, strong) UILabel *statuslabel;
@property (nonatomic, strong) UIImageView *cellNew;
@property (nonatomic, strong) UILabel *solveLabel;


@end

@implementation EducationOptionsTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *cellTitle = [[UILabel alloc] init];
    cellTitle.font = [UIFont systemFontOfSize:17.0f];
    cellTitle.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitle];
    self.cellTitle = cellTitle;
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self).offset(15.0f);
        make.height.mas_equalTo(16.0f);
    }];
    
    
    UILabel *cellContent = [[UILabel alloc] init];
    cellContent.font = [UIFont systemFontOfSize:14.0f];
    cellContent.text = @"2018年12月01日";
    cellContent.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    cellContent.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellContent];
    self.cellContent = cellContent;
    [self.cellContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.cellTitle.mas_bottom).offset(14.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    
    
    UIImageView *rowImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:rowImageView];
    self.rowImageView = rowImageView;
    [rowImageView setContentMode:UIViewContentModeCenter];
    [rowImageView setImage:[UIImage imageNamed:@"row"]];
    [self.rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self);
    }];
    
    
    
    UILabel *statuslabel = [[UILabel alloc] init];
    statuslabel.font = [UIFont systemFontOfSize:14.0f];
    statuslabel.textColor = [UIColor colorWithHexString:@"#259B24"];
    statuslabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:statuslabel];
    self.statuslabel = statuslabel;
    [self.statuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rowImageView.mas_left).offset(-14.0f);
        make.centerY.equalTo(self);
    }];
    

    UIImageView *cellNew = [[UIImageView alloc]init];
    [self.contentView addSubview:cellNew];
    self.cellNew = cellNew;
    [cellNew setContentMode:UIViewContentModeCenter];
    [cellNew setImage:[UIImage imageNamed:@"new"]];
    [self.cellNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statuslabel.mas_left).offset(-11.0f);
        make.centerY.equalTo(self);
    }];
    
    
    UILabel *solveLabel = [[UILabel alloc] init];
    solveLabel.font = [UIFont systemFontOfSize:14.0f];
    solveLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    solveLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:solveLabel];
    self.solveLabel = solveLabel;
    CGFloat space = [PublicMethod getTheWidthOfTheLabelWithContent:@"处理人：" font:14];
    [self.solveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cellContent);
        make.left.equalTo(self.mas_centerX).offset(-space);
    }];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
}

-(void)setFeedBackModel:(SuggestionFeedback *)feedBackModel{
    _feedBackModel = feedBackModel;
    if (_feedBackModel) {
        self.cellTitle.text = _feedBackModel.title;
        self.cellContent.text = _feedBackModel.createTime;

        if ([_feedBackModel.answerState integerValue] == 1) {
            self.statuslabel.text = NSLocalizedString(@"jiejuezhong", nil);
        }else{
            self.statuslabel.text = NSLocalizedString(@"yichuli", nil);
        }
        self.solveLabel.hidden = YES;

        
        
        
//        for (SuggestionFeedback *model in list) {
//            NSLog(@"%@", model.answerState);
//            NSLog(@"%@", model.createTime);
//            NSLog(@"%@", model.problemInfo);
//            NSLog(@"%@", model.title);
//            NSLog(@"%@", model.answer);
//        }
    }
}

+(CGFloat)CellH{
    return 15+16+14+14+15;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
