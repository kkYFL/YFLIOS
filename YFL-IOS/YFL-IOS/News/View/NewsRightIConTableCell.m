//
//  NewsRightIConTableCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsRightIConTableCell.h"

@interface NewsRightIConTableCell ()
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *laiyunLabel;
@property (nonatomic, strong) UILabel *pinlunLabel;


@end


@implementation NewsRightIConTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *cellImageView = [[UIImageView alloc]init];
    [cellImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:cellImageView];
    self.cellImageView = cellImageView;
    [cellImageView setContentMode:UIViewContentModeScaleToFill];
    [cellImageView setImage:[UIImage imageNamed:@"Pfofession_card-bg-11"]];

    
    UILabel *cellTitleLabel = [[UILabel alloc] init];
    cellTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    cellTitleLabel.numberOfLines = 2;
    cellTitleLabel.text = @"北京清热暴晒继续 周末或有雷阵雨热度不减！北京清热暴晒继续 周末或有雷阵雨热度不减！北京清热暴晒继续 周末或有雷阵雨热度不减！北京清热暴晒继续 周末或有雷阵雨热度不减！";
    cellTitleLabel.textColor = [UIColor colorWithHexString:@"#2A333A"];
    cellTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitleLabel];
    self.cellTitleLabel = cellTitleLabel;
    
    
    UILabel *laiyunLabel = [[UILabel alloc] init];
    laiyunLabel.font = [UIFont systemFontOfSize:12.0f];
    laiyunLabel.text = @"中国天气网";
    laiyunLabel.textColor = [UIColor colorWithHexString:@"#A7ACB9"];
    laiyunLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:laiyunLabel];
    self.laiyunLabel = laiyunLabel;
    
    
    UILabel *pinlunLabel = [[UILabel alloc] init];
    pinlunLabel.font = [UIFont systemFontOfSize:12.0f];
    pinlunLabel.text = @"70评论";
    pinlunLabel.textColor = [UIColor colorWithHexString:@"#A7ACB9"];
    pinlunLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:pinlunLabel];
    self.pinlunLabel = pinlunLabel;
    
    

    
    CGFloat imageW = (75-20)*5/3.0;
    [self.cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self.mas_right).offset(-12);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(imageW);
    }];
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(cellImageView.mas_top).offset(2);
        make.right.equalTo(cellImageView.mas_left).offset(-12);
    }];
    
    [laiyunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.0);
        make.bottom.equalTo(self.cellImageView.mas_bottom).offset(0);
    }];
    
    [pinlunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.laiyunLabel.mas_right).offset(20);
        make.bottom.equalTo(self.cellImageView.mas_bottom).offset(0);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}


+(CGFloat)CellH{
    return 75.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
