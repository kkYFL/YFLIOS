//
//  ExamTimuTitleViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/11/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamTimuTitleViewCell.h"

@interface ExamTimuTitleViewCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@end


@implementation ExamTimuTitleViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:17.0f];
    contentLabel.text = @"";
    contentLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contentLabel];
    contentLabel.numberOfLines = 0;
    self.contentLabel = contentLabel;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];
    
    
}


-(void)setCellTitle:(NSString *)cellTitle{
    _cellTitle = cellTitle;
    
    if (_cellTitle.length) {
        NSString *content = cellTitle;
        NSMutableAttributedString *attri = [ExamTimuTitleViewCell getAttriHeightwithString:content Speace:3.0f withFont:[UIFont systemFontOfSize:17.0f]];
        self.contentLabel.attributedText = attri;
        //self.contentLabel.text = content;
        //        CGFloat contentH = [PublicMethod getSpaceLabelHeight:content withWidh:SCREEN_WIDTH-30 font:17]+0.5f;
        CGFloat contentH = [ExamTimuTitleViewCell getSpaceLabelHeightwithString:content Speace:3.0f withFont:[UIFont systemFontOfSize:17.0f] withWidth:SCREEN_WIDTH-30.0f]+0.5f;
        
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15.0f);
            make.top.equalTo(self).offset(15.0f);
            make.right.equalTo(self.mas_right).offset(-15.0f);
            make.height.mas_equalTo(contentH);
        }];
    }
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

+(CGFloat)CellHWithContent:(NSString *)cellTitle{
    if (cellTitle.length) {
        NSString *content = cellTitle;
        CGFloat contentH = [ExamTimuTitleViewCell getSpaceLabelHeightwithString:content Speace:3.0f withFont:[UIFont systemFontOfSize:17.0f] withWidth:SCREEN_WIDTH-30.0f]+0.5f;
        
        return 15+contentH+15.0f;
    }
    
    return 0.01f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
