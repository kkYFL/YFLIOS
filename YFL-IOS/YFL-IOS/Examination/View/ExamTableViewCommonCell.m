//
//  ExamTableViewCommonCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/1.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamTableViewCommonCell.h"

@interface ExamTableViewCommonCell ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *paimingLabel;
@end


@implementation ExamTableViewCommonCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *headerImageView = [[UIImageView alloc]init];
    [headerImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:headerImageView];
    self.headerImageView = headerImageView;
    [headerImageView setContentMode:UIViewContentModeCenter];
    [headerImageView setImage:[UIImage imageNamed:@"exam_header"]];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.centerY.equalTo(self);
    }];

    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.font = [UIFont systemFontOfSize:14.0f];
    numLabel.text = @"95分";
    numLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14.0f];
    nameLabel.text = @"张三";
    nameLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(25);
        make.centerY.equalTo(self);
    }];
    
    
    UILabel *paimingLabel = [[UILabel alloc] init];
    paimingLabel.font = [UIFont systemFontOfSize:14.0f];
    paimingLabel.text = @"排名第一";
    paimingLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    paimingLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:paimingLabel];
    self.paimingLabel = paimingLabel;
    [paimingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-54);
        make.centerY.equalTo(self);
    }];

    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}

+(CGFloat)CellH{
    return 60.0f;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
