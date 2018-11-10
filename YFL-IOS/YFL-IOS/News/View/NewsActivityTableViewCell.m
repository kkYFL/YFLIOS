//
//  NewsActivityTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsActivityTableViewCell.h"
#import "NewsMessage.h"
#import "AppDelegate.h"

@interface NewsActivityTableViewCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *cellTitle1;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *cellTitle2;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation NewsActivityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *icon = [[UIImageView alloc]init];
    [self.contentView addSubview:icon];
    self.icon = icon;
    [icon setContentMode:UIViewContentModeScaleToFill];
    //[icon setImage:[UIImage imageNamed:@""]];
    icon.layer.masksToBounds = YES;
    icon.layer.cornerRadius = 20.0f;
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.height.width.mas_equalTo(40);
    }];

    
    
    UILabel *cellTitle1 = [[UILabel alloc] init];
    cellTitle1.font = [UIFont systemFontOfSize:14.0f];
    cellTitle1.text = @"组织部门";
    cellTitle1.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitle1.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitle1];
    self.cellTitle1 = cellTitle1;
    [self.cellTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(16);
        make.centerY.equalTo(icon);
    }];
    
    
    UILabel *time = [[UILabel alloc] init];
    time.font = [UIFont systemFontOfSize:14.0f];
    time.text = @"2018-07-06";
    time.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    time.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:time];
    self.time = time;
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(icon);
    }];
    

    UILabel *cellTitle2 = [[UILabel alloc] init];
    cellTitle2.font = [UIFont systemFontOfSize:16.0f];
    //cellTitle2.text = @"如果你无法简洁的表达你的想法，那只说明你还不够了解它。";
    cellTitle2.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitle2.textAlignment = NSTextAlignmentLeft;
    cellTitle2.numberOfLines = 0;
    [self.contentView addSubview:cellTitle2];
    self.cellTitle2 = cellTitle2;
    
    NSString *title2 = @"如果你无法简洁的表达你的想法，那只说明你还不够了解它。";
    self.cellTitle2.attributedText = [NewsActivityTableViewCell getAttriHeightwithString:title2 Speace:3 withFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor colorWithHexString:@"#0C0C0C"]];
    
    CGFloat title2H = [NewsActivityTableViewCell getSpaceLabelHeightwithString:title2 Speace:3 withFont:[UIFont systemFontOfSize:16.0f] withWidth:(SCREEN_WIDTH-32)]+0.5;
    
    [self.cellTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon);
        make.top.equalTo(icon.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.mas_equalTo(title2H);
    }];
    
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:11.0f];
    contentLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    NSString *content = @"推动新旧动能转换，做大做强新兴产业集群，改造提升传统产业情况。实施重大短板装备专项工程，发展工业互联网平台情况。进一步完善中央财政科研项目资金管理等政策的若干意见落实情况...";
    self.contentLabel.attributedText = [NewsActivityTableViewCell getAttriHeightwithString:content Speace:3 withFont:[UIFont systemFontOfSize:11.0f] textColor:[UIColor colorWithHexString:@"#9C9C9C"]];
    
    CGFloat contentH = [NewsActivityTableViewCell getSpaceLabelHeightwithString:content Speace:3 withFont:[UIFont systemFontOfSize:11.0f] withWidth:(SCREEN_WIDTH-32)]+0.5;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon);
        make.top.equalTo(self.cellTitle2.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.mas_equalTo(contentH);
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


+(NSMutableAttributedString *)getAttriHeightwithString:(NSString *)string Speace:(CGFloat)lineSpeace withFont:(UIFont*)font textColor:(UIColor *)textColor{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:textColor};
    [attri addAttributes:dic range:NSMakeRange(0, string.length)];
    return attri;
}

+(CGFloat)getSpaceLabelHeightwithString:(NSString *)string Speace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#A7ACB9"]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat textHeight = size.height;
    
    return textHeight;
}


+(CGFloat)CellHWithMoel:(NewsMessage *)newModel{
    if (newModel) {
        NSString *title2 = newModel.title;
        CGFloat title2H = [NewsActivityTableViewCell getSpaceLabelHeightwithString:title2 Speace:3 withFont:[UIFont systemFontOfSize:16.0f] withWidth:(SCREEN_WIDTH-32)]+0.5;
        
        NSString *content = newModel.shortInfo;
        CGFloat contentH = [NewsActivityTableViewCell getSpaceLabelHeightwithString:content Speace:3 withFont:[UIFont systemFontOfSize:11.0f] withWidth:(SCREEN_WIDTH-32)]+0.5;
        
        
        return 10+40+10+title2H+10+contentH+14;
    }
    return 0.01f;
}



-(void)setMessModel:(NewsMessage *)messModel{
    _messModel = messModel;
    if (_messModel) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,_messModel.userPic]]];
        [self.cellTitle1 setText:_messModel.userDepartment];
        [self.time setText:_messModel.createTime];
        
        
        NSString *title2 = _messModel.title;
        self.cellTitle2.attributedText = [NewsActivityTableViewCell getAttriHeightwithString:title2 Speace:3 withFont:[UIFont systemFontOfSize:16.0f] textColor:[UIColor colorWithHexString:@"#0C0C0C"]];
        CGFloat title2H = [NewsActivityTableViewCell getSpaceLabelHeightwithString:title2 Speace:3 withFont:[UIFont systemFontOfSize:16.0f] withWidth:(SCREEN_WIDTH-32)]+0.5;
        [self.cellTitle2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon);
            make.top.equalTo(self.icon.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(title2H);
        }];
        
        
        NSString *content = _messModel.shortInfo;
        self.contentLabel.attributedText = [NewsActivityTableViewCell getAttriHeightwithString:content Speace:3 withFont:[UIFont systemFontOfSize:11.0f] textColor:[UIColor colorWithHexString:@"#9C9C9C"]];
        CGFloat contentH = [NewsActivityTableViewCell getSpaceLabelHeightwithString:content Speace:3 withFont:[UIFont systemFontOfSize:11.0f] withWidth:(SCREEN_WIDTH-32)]+0.5;
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon);
            make.top.equalTo(self.cellTitle2.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(contentH);
        }];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
