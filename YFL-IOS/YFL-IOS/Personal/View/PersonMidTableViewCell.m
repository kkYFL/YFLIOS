//
//  PersonMidTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/2.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonMidTableViewCell.h"

@interface PersonMidTableViewCell ()
@property (nonatomic, strong) UIImageView *leftBackView;
@property (nonatomic, strong) UIImageView *rightBackView;


@end


@implementation PersonMidTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIImageView *leftBackView = [[UIImageView alloc]init];
    [leftBackView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:leftBackView];
    self.leftBackView = leftBackView;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    leftBackView.userInteractionEnabled = YES;
    [leftBackView addGestureRecognizer:tap1];
    [leftBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
    }];
    
    
    UIImageView *rightBackView = [[UIImageView alloc]init];
    [rightBackView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:rightBackView];
    self.rightBackView = rightBackView;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    rightBackView.userInteractionEnabled = YES;
    [rightBackView addGestureRecognizer:tap2];
    [rightBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SCREEN_WIDTH/2.0);
        make.top.bottom.equalTo(self).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH/2.0);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#9C9C9C"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(0.5);
        make.centerX.equalTo(self);
    }];
    
    
    UIImageView *leftIcon = [[UIImageView alloc]init];
    [self.leftBackView addSubview:leftIcon];
    [leftIcon setContentMode:UIViewContentModeCenter];
    [leftIcon setImage:[UIImage imageNamed:@"jifen"]];
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBackView).offset(27.0f);
        make.centerY.equalTo(self.leftBackView);
    }];
    
    
    UILabel *jifenNum = [[UILabel alloc] init];
    jifenNum.font = [UIFont systemFontOfSize:12.0f];
    jifenNum.text = @"积分180";
    jifenNum.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    jifenNum.textAlignment = NSTextAlignmentLeft;
    [self.leftBackView addSubview:jifenNum];
    [jifenNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right).offset(10);
        make.bottom.equalTo(leftIcon.mas_centerY).offset(-5);
    }];
    
    
    UILabel *huoqu = [[UILabel alloc] init];
    huoqu.font = [UIFont systemFontOfSize:12.0f];
    huoqu.text = @"如何获取积分？";
    huoqu.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    huoqu.textAlignment = NSTextAlignmentLeft;
    [self.leftBackView addSubview:huoqu];
    [huoqu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right).offset(10);
        make.top.equalTo(leftIcon.mas_centerY).offset(5);
    }];
    
    
    UIImageView *rightIcon = [[UIImageView alloc]init];
    [self.rightBackView addSubview:rightIcon];
    [rightIcon setContentMode:UIViewContentModeCenter];
    [rightIcon setImage:[UIImage imageNamed:@"pingfen"]];
    [rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).offset(45.0f);
        make.centerY.equalTo(self.rightBackView);
    }];
    
    
    UILabel *chakan = [[UILabel alloc] init];
    chakan.font = [UIFont systemFontOfSize:12.0f];
    chakan.text = @"查看积分";
    chakan.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    chakan.textAlignment = NSTextAlignmentLeft;
    [self.rightBackView addSubview:chakan];
    [chakan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightIcon.mas_right).offset(10);
        make.bottom.equalTo(rightIcon.mas_centerY).offset(-5);
    }];
    
    
    UILabel *jilu = [[UILabel alloc] init];
    jilu.font = [UIFont systemFontOfSize:12.0f];
    jilu.text = @"获取记录";
    jilu.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    jilu.textAlignment = NSTextAlignmentLeft;
    [self.rightBackView addSubview:jilu];
    [jilu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightIcon.mas_right).offset(10);
        make.top.equalTo(rightIcon.mas_centerY).offset(5);
    }];
    
    
    UIView *bottonLine = [[UIView alloc]init];
    bottonLine.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:bottonLine];
    [bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];

}

+(CGFloat)CellH{
    return 70.0f;
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
