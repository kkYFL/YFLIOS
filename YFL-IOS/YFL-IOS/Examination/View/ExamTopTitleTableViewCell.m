//
//  ExamTopTitleTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/12.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamTopTitleTableViewCell.h"

@interface ExamTopTitleTableViewCell ()
@property (nonatomic, strong) UIImageView *imagView;

@end


@implementation ExamTopTitleTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imagView = [[UIImageView alloc]init];
    [imagView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:imagView];
    self.imagView = imagView;
    [imagView setContentMode:UIViewContentModeCenter];
    [imagView setImage:[UIImage imageNamed:@"Exam_hat"]];
    [imagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.centerY.equalTo(self);
    }];

    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17.0f];
    titleLabel.text = @"第1题  单选题";
    titleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagView.mas_right).offset(11.0f);
        make.centerY.equalTo(self.imagView);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

+(CGFloat)CellH{
    return 50.0f;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
