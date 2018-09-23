//
//  EducationHeadTableCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationHeadTableCell.h"

@interface EducationHeadTableCell ()
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *cellContentLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation EducationHeadTableCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *topImageView = [[UIImageView alloc]init];
    [topImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:topImageView];
    self.topImageView = topImageView;
    [topImageView setContentMode:UIViewContentModeScaleToFill];
    [topImageView setImage:[UIImage imageNamed:@"login-bg"]];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    topImageView.userInteractionEnabled = YES;
    [topImageView addGestureRecognizer:tap1];
    
    CGFloat topImageViewH = 0.5*SCREEN_WIDTH;
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self).offset(0);
        make.height.mas_equalTo(topImageViewH);
    }];
    
    
    
    UIImageView *iconImageView = [[UIImageView alloc]init];
    [topImageView addSubview:iconImageView];
    [iconImageView setContentMode:UIViewContentModeScaleToFill];
    [iconImageView setImage:[UIImage imageNamed:@"Education_play"]];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImageView);
        make.centerY.equalTo(topImageView);
        make.width.height.mas_equalTo(40);
    }];

    
    UILabel *cellContentLabel = [[UILabel alloc] init];
    cellContentLabel.font = [UIFont systemFontOfSize:14.0f];
    cellContentLabel.numberOfLines = 0;
    cellContentLabel.text = @"如果你不能准确的表达自己的想法，那只说明你还不够了解它。 -- 阿尔伯特 爱因斯坦。。。。。。如果你不能准确的表达自己的想法，那只说明你还不够了解它。。。。";
    cellContentLabel.textColor = [UIColor colorWithHexString:@"#2A333A"];
    cellContentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellContentLabel];
    self.cellContentLabel = cellContentLabel;
    
    [cellContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.topImageView.mas_bottom).offset(8);
        make.right.equalTo(self).offset(-12);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
    }];

}

+(CGFloat)CellH{
    NSString *contentStr = @"如果你不能准确的表达自己的想法，那只说明你还不够了解它。 -- 阿尔伯特 爱因斯坦。。。。。。如果你不能准确的表达自己的想法，那只说明你还不够了解它。。。。";
    CGFloat contentViewH = [contentStr heightWithFont:[UIFont systemFontOfSize:14.0f] constrainedToWidth:SCREEN_WIDTH-24]+0.5;
    CGFloat topImageViewH = 0.5*SCREEN_WIDTH;

    return topImageViewH+contentViewH+8*2;
}



-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
