//
//  NewsPolicyTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsPolicyTableViewCell.h"

@interface NewsPolicyTableViewCell ()
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *cellContent;

@end

@implementation NewsPolicyTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //
    UIImageView *leftImageView = [[UIImageView alloc]init];
    [leftImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    [leftImageView setContentMode:UIViewContentModeCenter];
    [leftImageView setImage:[UIImage imageNamed:@"news_qian"]];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.centerY.equalTo(self);
    }];

    
    UILabel *cellContent = [[UILabel alloc] init];
    cellContent.font = [UIFont systemFontOfSize:14.0f];
    cellContent.text = @"国务院关于开展2018年国务院大督";
    cellContent.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellContent.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellContent];
    self.cellContent = cellContent;
    [self.cellContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(6);
        make.centerY.equalTo(self);
        //make.height.mas_equalTo(<#Height#>);
    }];

    
    
    UIImageView *rowImageView = [[UIImageView alloc]init];
    [rowImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:rowImageView];
    [rowImageView setContentMode:UIViewContentModeCenter];
    [rowImageView setImage:[UIImage imageNamed:@"row"]];
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
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
    return 47.0f;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
