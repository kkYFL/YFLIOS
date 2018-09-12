//
//  BannerScrollViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "BannerScrollViewCell.h"

@interface BannerScrollViewCell ()
@property (nonatomic, strong) UIImageView *remindView;
@property (nonatomic, strong) UILabel *contentLab;
@end


@implementation BannerScrollViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView{
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    
    UIImageView *remindView = [[UIImageView alloc]init];
    [remindView setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:remindView];
    self.remindView = remindView;
    [remindView setContentMode:UIViewContentModeCenter];
    [remindView setImage:[UIImage imageNamed:@""]];
    
    [remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(15);
    }];
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = [UIFont systemFontOfSize:16.0f];
    contentLab.text = @"djfsjdfojdofjdsfoksdofksdkfokdofk";
    contentLab.textColor = [UIColor blackColor];
    contentLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contentLab];
    self.contentLab = contentLab;
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(remindView.mas_right).offset(8);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(0);
    }];
}

@end
