//
//  PersonRowWithIconCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/20.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonRowWithIconCell.h"


@implementation PersonRowWithIconCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIImageView *cellIcon = [[UIImageView alloc]init];
    [cellIcon setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:cellIcon];
    self.cellIcon = cellIcon;
    [cellIcon setContentMode:UIViewContentModeCenter];
    [cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(19.0f);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(15.0f);
    }];
    
    
    UILabel *cellTitleLabel = [[UILabel alloc] init];
    cellTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    cellTitleLabel.text = @"";
    cellTitleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitleLabel];
    self.cellTitleLabel = cellTitleLabel;
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellIcon.mas_right).offset(10.0f);
        make.centerY.equalTo(self);
    }];
    
    
    UIImageView *cellNewImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:cellNewImageView];
    self.cellNewImageView = cellNewImageView;
    [cellNewImageView setContentMode:UIViewContentModeCenter];
    [cellNewImageView setImage:[UIImage imageNamed:@"new"]];
    [cellNewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellTitleLabel.mas_right).offset(5.0f);
        make.centerY.equalTo(self);
    }];
    cellNewImageView.hidden = YES;
    
    
    
    UIImageView *rowImageView = [[UIImageView alloc]init];
    [rowImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:rowImageView];
    [rowImageView setContentMode:UIViewContentModeCenter];
    [rowImageView setImage:[UIImage imageNamed:@"row"]];
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self);
    }];
    
    
    UILabel *cellContentLabel = [[UILabel alloc] init];
    cellContentLabel.font = [UIFont systemFontOfSize:14.0f];
    cellContentLabel.text = @"";
    cellContentLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    cellContentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:cellContentLabel];
    self.cellContentLabel = cellContentLabel;
    
    [cellContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rowImageView.mas_left).offset(-5);
        make.centerY.equalTo(self);
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
    return 50.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
