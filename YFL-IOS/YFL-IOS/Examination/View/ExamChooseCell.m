//
//  ExamChooseCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/12.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamChooseCell.h"

@interface ExamChooseCell ()
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *A;
@property (nonatomic, strong) UIImageView *B;
@property (nonatomic, strong) UIImageView *C;
@property (nonatomic, strong) UIImageView *D;


@end

@implementation ExamChooseCell


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
    contentLabel.text = @"《中国共产党纪律处分条例》规定，在考试、录取工作中，有泄露试题、考场舞弊、涂改考卷、违规录取等违反有关规定行为，情节严重的，给与（ ）处分？（3分）";
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
    
    
    UIImageView *A = [[UIImageView alloc]init];
    [A setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:A];
    self.A = A;
    [A setContentMode:UIViewContentModeCenter];
    [A setImage:[UIImage imageNamed:@"choosen"]];
    A.tag = 101;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    A.userInteractionEnabled = YES;
    [A addGestureRecognizer:tap1];
    [A mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(HEIGHT_SCALE*80);
        make.height.width.mas_equalTo(25);
    }];
    
    
    UILabel *labelA = [[UILabel alloc] init];
    labelA.font = [UIFont systemFontOfSize:17.0f];
    labelA.text = @"A：撤销党内职务";
    labelA.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    labelA.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:labelA];
    [labelA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.A.mas_right).offset(10);
        make.centerY.equalTo(self.A);
    }];
    
    
    
    UIImageView *B = [[UIImageView alloc]init];
    [B setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:B];
    self.B = B;
    [B setContentMode:UIViewContentModeCenter];
    [B setImage:[UIImage imageNamed:@"choosen"]];
    B.tag = 102;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    B.userInteractionEnabled = YES;
    [B addGestureRecognizer:tap2];
    [B mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.A.mas_bottom).offset(15);
        make.height.width.mas_equalTo(25);
    }];
    
    UILabel *labelB = [[UILabel alloc] init];
    labelB.font = [UIFont systemFontOfSize:17.0f];
    labelB.text = @"B：撤销党内职务";
    labelB.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    labelB.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:labelB];
    [labelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.B.mas_right).offset(10);
        make.centerY.equalTo(self.B);
    }];

    
    
    
    UIImageView *C = [[UIImageView alloc]init];
    [C setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:C];
    self.C = C;
    [C setContentMode:UIViewContentModeCenter];
    [C setImage:[UIImage imageNamed:@"choosen"]];
    C.tag = 103;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    C.userInteractionEnabled = YES;
    [C addGestureRecognizer:tap3];
    [C mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.B.mas_bottom).offset(15);
        make.height.width.mas_equalTo(25);
    }];
    
    UILabel *labelC = [[UILabel alloc] init];
    labelC.font = [UIFont systemFontOfSize:17.0f];
    labelC.text = @"B：撤销党内职务";
    labelC.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    labelC.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:labelC];
    [labelC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.C.mas_right).offset(10);
        make.centerY.equalTo(self.C);
    }];
    
    
    
    UIImageView *D = [[UIImageView alloc]init];
    [D setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:D];
    self.D = D;
    [D setContentMode:UIViewContentModeCenter];
    [D setImage:[UIImage imageNamed:@"choosen"]];
    D.tag = 104;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    D.userInteractionEnabled = YES;
    [D addGestureRecognizer:tap4];
    [D mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.C.mas_bottom).offset(15);
        make.height.width.mas_equalTo(25);
    }];
    
    UILabel *labelD = [[UILabel alloc] init];
    labelD.font = [UIFont systemFontOfSize:17.0f];
    labelD.text = @"B：撤销党内职务";
    labelD.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    labelD.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:labelD];
    [labelD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.D.mas_right).offset(10);
        make.centerY.equalTo(self.D);
    }];
    
    
    
    


    
}

+(CGFloat)CellH{
    NSString *content = @"《中国共产党纪律处分条例》规定，在考试、录取工作中，有泄露试题、考场舞弊、涂改考卷、违规录取等违反有关规定行为，情节严重的，给与（ ）处分？（3分）";
    CGFloat contentH = [PublicMethod getSpaceLabelHeight:content withWidh:SCREEN_WIDTH-30 font:17]+0.5f;
    
    return 15+contentH+80*HEIGHT_SCALE+25*4+15*3+40;
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
