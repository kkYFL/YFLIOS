//
//  XinxiTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "XinxiTableViewCell.h"

@interface XinxiTableViewCell ()
@property (nonatomic, strong) UIImageView *rowImageView;

@end

@implementation XinxiTableViewCell


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
    cellTitleLabel.font = [UIFont systemFontOfSize:17.0f];
    cellTitleLabel.text = @"";
    cellTitleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitleLabel];
    self.cellTitleLabel = cellTitleLabel;
    
    [cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
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
    self.rowImageView = rowImageView;
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self);
    }];
    
    
    UIImageView *headerIcon = [[UIImageView alloc]init];
    [headerIcon setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:headerIcon];
    self.headerIcon = headerIcon;
    headerIcon.layer.masksToBounds = YES;
    headerIcon.layer.cornerRadius = 35/2.0f;
    [headerIcon setContentMode:UIViewContentModeCenter];
    [headerIcon setImage:[UIImage imageNamed:@""]];
    [headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rowImageView.mas_left).offset(-14);
        make.centerY.equalTo(self.rowImageView);
        make.height.width.mas_equalTo(35.0f);
    }];

    
    
    UILabel *cellContentLabel = [[UILabel alloc] init];
    cellContentLabel.font = [UIFont systemFontOfSize:14.0f];
    cellContentLabel.text = @"";
    cellContentLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
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

-(void)setType:(XinxiCellType)type{
    _type = type;
    
    if (_type == XinxiCellTypeWithJustRow) {
        self.rowImageView.hidden = NO;
        self.cellContentLabel.hidden = YES;
        self.headerIcon.hidden = YES;
        
    }else if (_type == XinxiCellTypeWithIconAndRow){
        self.rowImageView.hidden = NO;
        self.headerIcon.hidden = NO;
        self.cellContentLabel.hidden = YES;
        
    }else if (_type == XinxiCellTypeWithJustContent){
        self.rowImageView.hidden = YES;
        self.headerIcon.hidden = YES;
        self.cellContentLabel.hidden = NO;
        [self.cellContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.left.equalTo(self.cellTitleLabel.mas_right).offset(20);
            make.centerY.equalTo(self);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
