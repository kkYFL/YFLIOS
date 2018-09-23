//
//  EducationLearnCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationLearnCell.h"

@interface EducationLearnCell ()
@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *timerLabel;


@property (nonatomic, strong) UILabel *cellContent;
@property (nonatomic, strong) UILabel *zanNum;
@property (nonatomic, strong) UIImageView *rowImageView;
@property (nonatomic, strong) UIView *line;

@end

@implementation EducationLearnCell



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
    [cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self).offset(15.0f);
        make.height.mas_equalTo(HEIGHT_SCALE*75);
    }];

    
    
    UILabel *cellTitle = [[UILabel alloc] init];
    cellTitle.font = [UIFont systemFontOfSize:16.0f];
    cellTitle.text = @"张红梅";
    cellTitle.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitle];
    self.cellTitle = cellTitle;
    [cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellIcon.mas_right).offset(16.0f);
        make.top.equalTo(cellIcon).offset(0);
        make.height.mas_equalTo(16.0f);
    }];
    
    
    
    UILabel *address = [[UILabel alloc] init];
    address.font = [UIFont systemFontOfSize:12.0f];
    address.text = @"西宁市城西区五四小学";
    address.textColor = [UIColor colorWithHexString:@"#888888"];
    address.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:address];
    self.address = address;
    [address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellIcon.mas_right).offset(16.0f);
        make.top.equalTo(cellTitle.mas_bottom).offset(9.0f);
        make.height.mas_equalTo(12);
    }];
    
    
    UILabel *timerLabel = [[UILabel alloc] init];
    timerLabel.font = [UIFont systemFontOfSize:12.0f];
    timerLabel.text = @"2018-09-13    11:59";
    timerLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    timerLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timerLabel];
    self.timerLabel = timerLabel;
    [timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellIcon.mas_right).offset(16.0f);
        make.top.equalTo(address.mas_bottom).offset(9.0f);
        make.height.mas_equalTo(12);
    }];
    
    
    
    UILabel *cellContent = [[UILabel alloc] init];
    cellContent.font = [UIFont systemFontOfSize:14.0f];
    cellContent.numberOfLines = 0;
    cellContent.text = @"要自觉把两个绝对，作为组织原则，保持绝对纯洁。";
    cellContent.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellContent.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellContent];
    self.cellContent = cellContent;
    [cellContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellIcon.mas_right).offset(16.0f);
        make.top.equalTo(timerLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
    
    
    UILabel *zanNum = [[UILabel alloc] init];
    zanNum.font = [UIFont systemFontOfSize:14.0f];
    zanNum.text = @"8";
    zanNum.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    zanNum.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:zanNum];
    self.zanNum = zanNum;
    [zanNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-30);
        make.centerY.equalTo(address);
    }];
    
    
    
    UIImageView *rowImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:rowImageView];
    self.rowImageView = rowImageView;
    [rowImageView setContentMode:UIViewContentModeCenter];
    [rowImageView setImage:[UIImage imageNamed:@"zan_light"]];
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zanNum.mas_left).offset(-6);
        make.centerY.equalTo(zanNum);
    }];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    
}


+(CGFloat)CellHWithContent:(NSString *)content{
    CGFloat contentW = SCREEN_WIDTH-15-75*HEIGHT_SCALE-16-15;
    CGFloat contentH = [PublicMethod getSpaceLabelHeight:content withWidh:contentW font:14]+0.5;
    return 15+16+9+12+9+12+15+contentH+HEIGHT_SCALE*32;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
