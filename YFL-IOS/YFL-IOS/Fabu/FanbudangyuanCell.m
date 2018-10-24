

//
//  FanbudangyuanCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/24.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "FanbudangyuanCell.h"
#import "FanbuDangyuanMode.h"
#import "AppDelegate.h"

@interface FanbudangyuanCell ()
@property (nonatomic, strong) UIImageView *rowImageView;
@property (nonatomic, strong) UIView *line;

@end

@implementation FanbudangyuanCell



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
    [self.contentView addSubview:cellIcon];
    self.cellIcon = cellIcon;
    [cellIcon setContentMode:UIViewContentModeCenter];
    [cellIcon setImage:[UIImage imageNamed:@"exam_header"]];
    cellIcon.layer.masksToBounds = YES;
    cellIcon.layer.cornerRadius = 20.0f;
    [cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(40.0f);
    }];
    
    
    
    UILabel *cellTitle = [[UILabel alloc] init];
    cellTitle.font = [UIFont systemFontOfSize:16.0f];
    cellTitle.text = @"张三";
    cellTitle.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitle];
    self.cellTitle = cellTitle;
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellIcon.mas_right).offset(25.0f);
        make.centerY.equalTo(self.cellIcon);
    }];
    
    
    UILabel *cellContent = [[UILabel alloc] init];
    cellContent.font = [UIFont systemFontOfSize:11.0f];
    cellContent.text = @"入党时间：2018-09-21";
    cellContent.textColor = [UIColor colorWithHexString:@"#888888"];
    cellContent.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:cellContent];
    self.cellContent = cellContent;
    [self.cellContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18.0f);
        make.centerY.equalTo(self);
    }];
    
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    
    
}

+(CGFloat)CellH{
    return 60.0f;
}


-(void)setDangyunModel:(FanbuDangyuanMode *)dangyunModel{
    _dangyunModel = dangyunModel;
    if (_dangyunModel) {
        [self.cellIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,_dangyunModel.headImg]] placeholderImage:[UIImage imageNamed:@"exam_header"]];
        [self.cellTitle setText:_dangyunModel.pmName];
        [self.cellContent setText:_dangyunModel.pmEnterTime];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
