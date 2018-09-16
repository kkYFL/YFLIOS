//
//  ExamTextInViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/15.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamTextInViewCell.h"

#define ExamTextViewH 200*HEIGHT_SCALE

@interface ExamTextInViewCell ()
@property (nonatomic, strong) UIImageView *examBG;

@end

@implementation ExamTextInViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //
    UIImageView *examBG = [[UIImageView alloc]init];
    [examBG setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:examBG];
    self.examBG = examBG;
    [examBG setContentMode:UIViewContentModeScaleAspectFill];
    [examBG setImage:[UIImage imageNamed:@"exam_bg"]];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    examBG.userInteractionEnabled = YES;
    [examBG addGestureRecognizer:tap1];
    
    
    [examBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(self).offset(15.0);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        //make.height.mas_equalTo(<#Height#>);
    }];
}


+(CGFloat)CellH{
    return ExamTextViewH;
}


-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
