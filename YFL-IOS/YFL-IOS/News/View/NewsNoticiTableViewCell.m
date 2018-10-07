//
//  NewsNoticiTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsNoticiTableViewCell.h"

@interface NewsNoticiTableViewCell ()


@end

@implementation NewsNoticiTableViewCell

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
    cellTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    cellTitleLabel.text = @"国务院关于开展2018年国务院大督查的通知";
    cellTitleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitleLabel];
    self.cellTitleLabel = cellTitleLabel;
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self).offset(10.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(16);
    }];
    
    
    
    UILabel *fromLabel = [[UILabel alloc] init];
    fromLabel.font = [UIFont systemFontOfSize:11];
    fromLabel.text = @"来源:中共中央";
    fromLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    fromLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:fromLabel];
    self.fromLabel = fromLabel;
    [fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.cellTitleLabel.mas_bottom).offset(10.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.text = @"2018-07-07";
    timeLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.fromLabel);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    
}

+(CGFloat)CellH{
    return 15+16+10+12+15;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
