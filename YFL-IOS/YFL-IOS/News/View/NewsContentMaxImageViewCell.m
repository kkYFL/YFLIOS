//
//  NewsContentMaxImageViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsContentMaxImageViewCell.h"

#define NewsIconH HEIGHT_SCALE*170

@interface NewsContentMaxImageViewCell ()
@property (nonatomic, strong) UILabel *cellTitleLab;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *playIcon;


@end

@implementation NewsContentMaxImageViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *cellTitleLab = [[UILabel alloc] init];
    cellTitleLab.font = [UIFont boldSystemFontOfSize:17.0f];
    cellTitleLab.text = @"美国耗资15亿，修建518米通道，鱼儿像坐滑梯一样过大坝";
    cellTitleLab.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitleLab.textAlignment = NSTextAlignmentLeft;
    cellTitleLab.numberOfLines = 0;
    [self.contentView addSubview:cellTitleLab];
    self.cellTitleLab = cellTitleLab;
    
    NSString *content = @"美国耗资15亿，修建518米通道，鱼儿像坐滑梯一样过大坝";
    CGFloat contentH = [NewsContentMaxImageViewCell getSpaceLabelHeightwithString:content Speace:4.0 withFont:[UIFont boldSystemFontOfSize:17.0f] withWidth:SCREEN_WIDTH-30]+0.5;
    self.cellTitleLab.attributedText = [NewsContentMaxImageViewCell getAttriHeightwithString:content Speace:4.0f withFont:[UIFont boldSystemFontOfSize:17.0f]];
    
    [self.cellTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(contentH);
    }];
    
    
    
    UIImageView *iconImageView = [[UIImageView alloc]init];
    [iconImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView setContentMode:UIViewContentModeScaleToFill];
    [iconImageView setImage:[UIImage imageNamed:@"Pfofession_card-bg-2"]];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:tap1];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.cellTitleLab.mas_bottom).offset(10.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(NewsIconH);
    }];
    
    
    //
    UIImageView *playIcon = [[UIImageView alloc]init];
    [iconImageView addSubview:playIcon];
    self.playIcon = playIcon;
    [playIcon setContentMode:UIViewContentModeCenter];
    [playIcon setImage:[UIImage imageNamed:@"news_play_icon"]];
    [playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(iconImageView);
        make.centerY.equalTo(iconImageView);
    }];

    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    
}

+(NSMutableAttributedString *)getAttriHeightwithString:(NSString *)string Speace:(CGFloat)lineSpeace withFont:(UIFont*)font{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0C0C0C"]};
    [attri addAttributes:dic range:NSMakeRange(0, string.length)];
    return attri;
}

+(CGFloat)getSpaceLabelHeightwithString:(NSString *)string Speace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0C0C0C"]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat textHeight = size.height;
    
    return textHeight;
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    if (self.selectBlock) {
        self.selectBlock(@"");
    }
}

+(CGFloat)CellH{
    NSString *content = @"美国耗资15亿，修建518米通道，鱼儿像坐滑梯一样过大坝";
    CGFloat contentH = [NewsContentMaxImageViewCell getSpaceLabelHeightwithString:content Speace:4.0 withFont:[UIFont boldSystemFontOfSize:17.0f] withWidth:SCREEN_WIDTH-30]+0.5;
    return NewsIconH+contentH+15*2+10;
    
    //return 44.0f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
