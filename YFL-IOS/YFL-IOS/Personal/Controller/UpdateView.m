//
//  UpdateView.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/31.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "UpdateView.h"

@interface UpdateView ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIImageView *cancelIMageView;
@end

@implementation UpdateView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        //取得window
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        //加弹出动画
        self.transform = CGAffineTransformMakeScale(.3, .3);
        [UIView animateWithDuration:.3 animations:^{
            
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            
            self.transform = CGAffineTransformMakeScale(1.0, 1.);
        }];
        
        //
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.masksToBounds = YES;
        backView.layer.cornerRadius = 10.0f;
        [self addSubview:backView];
        self.backView = backView;

        
        
        //
        UIImageView *topImageView = [[UIImageView alloc]init];
        [self addSubview:topImageView];
        self.topImageView = topImageView;
        [topImageView setContentMode:UIViewContentModeScaleToFill];
        [topImageView setImage:[UIImage imageNamed:@"updateImage"]];
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self.mas_right).offset(-30);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(100);
        }];

        
        
        //
        NSString *contentStr = @"sdjdoifjsoidjfoisdjfoijsdofjsidjfoisjdfojsdojfidsjfijdifjdjfoi";
        CGFloat contentH = [self getSpaceLabelHeightwithString:contentStr Speace:4.0 withFont:[UIFont systemFontOfSize:18.0f] withWidth:SCREEN_WIDTH-90];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:18.0f];
        contentLabel.numberOfLines = 0;
        contentLabel.text = @"";
        contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        self.contentLabel.attributedText = [self getAttriHeightwithString:contentStr Speace:4.0 withFont:[UIFont systemFontOfSize:18.0f]];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageView).offset(15);
            make.top.equalTo(topImageView.mas_bottom).offset(15);
            make.right.equalTo(topImageView.mas_right).offset(-15);
            make.height.mas_equalTo(contentH);
        }];
        

        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor colorWithHexString:@"#F9FAFC"];
        [button addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15.0f;
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [button setTitleColor:[UIColor colorWithHexString:@"#667480"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 4.0f;
        self.sureBtn = button;
        [self addSubview:button];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15.0f);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(30);
        }];
        
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageView).offset(0);
            make.top.equalTo(topImageView).offset(0);
            make.right.equalTo(topImageView.mas_right).offset(0);
            make.bottom.equalTo(self.sureBtn.mas_bottom).offset(10);
        }];
        
        
        UIImageView *cancelIMageView = [[UIImageView alloc]init];
        cancelIMageView.backgroundColor = [UIColor whiteColor];
        cancelIMageView.layer.masksToBounds = YES;
        cancelIMageView.layer.cornerRadius = 15.0f;
        [self addSubview:cancelIMageView];
        self.cancelIMageView = cancelIMageView;
        [cancelIMageView setContentMode:UIViewContentModeCenter];
        [cancelIMageView setImage:[UIImage imageNamed:@"Zj_MySlectDelete"]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelGestureAction:)];
        cancelIMageView.userInteractionEnabled = YES;
        [cancelIMageView addGestureRecognizer:tap1];
        [cancelIMageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topImageView).offset(-8);
            make.top.equalTo(topImageView).offset(-6);
            make.height.width.mas_equalTo(30);
        }];
        
    }
        
    return self;
}


-(NSMutableAttributedString *)getAttriHeightwithString:(NSString *)string Speace:(CGFloat)lineSpeace withFont:(UIFont*)font{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:string];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2A333A"]};
    [attri addAttributes:dic range:NSMakeRange(0, string.length)];
    return attri;
}

-(CGFloat)getSpaceLabelHeightwithString:(NSString *)string Speace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpeace;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2A333A"]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat textHeight = size.height;
    return textHeight;
}

-(void)cancelGestureAction:(UITapGestureRecognizer *)tap{
    self.hidden = YES;
    [self removeFromSuperview];
}


-(void)selectSource:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(updateDelegate)]) {
        [self.delegate updateDelegate];
    }
}




@end
