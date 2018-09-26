//
//  NewsContentViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/26.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsContentViewCell.h"

@interface NewsContentViewCell ()

@end

@implementation NewsContentViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
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
    

    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [laiyunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    
    [pinlunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.laiyunLabel.mas_right).offset(20);
        make.centerY.equalTo(self.laiyunLabel);
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
