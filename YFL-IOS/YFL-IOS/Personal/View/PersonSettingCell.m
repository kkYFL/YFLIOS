//
//  PersonSettingCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/18.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonSettingCell.h"

@interface PersonSettingCell ()

@end

@implementation PersonSettingCell

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
    cellTitleLabel.font = [UIFont systemFontOfSize:18.0f];
    cellTitleLabel.textColor = [UIColor colorWithHexString:@"#6B7884"];
    cellTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitleLabel];
    self.cellTitleLabel = cellTitleLabel;
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.0f);
        make.centerY.equalTo(self);
    }];
    
    
    
    UILabel *cellContentLabel = [[UILabel alloc] init];
    cellContentLabel.font = [UIFont systemFontOfSize:18.0f];
    cellContentLabel.text = @"";
    cellContentLabel.textColor = [UIColor colorWithHexString:@"#6B7884"];
    cellContentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:cellContentLabel];
    self.cellContentLabel = cellContentLabel;
    [self.cellContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12.0f);
        make.centerY.equalTo(self);
    }];
    
    
}

+(CGFloat)CellH{
    return 44.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
