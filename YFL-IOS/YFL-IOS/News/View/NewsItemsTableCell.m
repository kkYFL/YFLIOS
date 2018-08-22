//
//  NewsItemsTableCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsItemsTableCell.h"

#define marginSpace 12
#define topSpce 10
#define viewSpace 15
#define contentH 60
#define contentW (SCREEN_WIDTH-marginSpace*2-viewSpace)/2.0

@interface NewsItemsTableCell ()
@property (nonatomic, strong) NewsItemContentView *item1;
@property (nonatomic, strong) NewsItemContentView *item2;
@property (nonatomic, strong) NewsItemContentView *item3;
@property (nonatomic, strong) NewsItemContentView *item4;
@property (nonatomic, strong) UIView *line;
@end

@implementation NewsItemsTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.item1 = [[NewsItemContentView alloc]initWithFrame:CGRectMake(marginSpace, topSpce, contentW, contentH)];
    [self.contentView addSubview:self.item1];
    self.item1.titleLab.text = @"要闻速递";
    self.item1.contentLab.text = @"最新信息你先知";
    
    self.item2 = [[NewsItemContentView alloc]initWithFrame:CGRectMake(marginSpace+contentW+viewSpace, topSpce, contentW, contentH)];
    [self.contentView addSubview:self.item2];
    self.item2.titleLab.text = @"政策法规";
    self.item2.contentLab.text = @"遵从党的安排";
    
    self.item3 = [[NewsItemContentView alloc]initWithFrame:CGRectMake(marginSpace, topSpce+contentH+viewSpace, contentW, contentH)];
    [self.contentView addSubview:self.item3];
    self.item3.titleLab.text = @"通知公告";
    self.item3.contentLab.text = @"最新通知你先知";
    
    self.item4 = [[NewsItemContentView alloc]initWithFrame:CGRectMake(marginSpace+contentW+viewSpace, topSpce+contentH+viewSpace, contentW, contentH)];
    [self.contentView addSubview:self.item4];
    self.item4.titleLab.text = @"组织活动";
    self.item4.contentLab.text = @"活动不能缺你";
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.line = line;
    [self.contentView addSubview:line];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
    }];
}

+(CGFloat)CellH{
    return topSpce*2+contentH*2+viewSpace;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end


#pragma mark - NewsItemContentView

@interface NewsItemContentView ()
@property (nonatomic, strong) UIImageView *backView;

@end

@implementation NewsItemContentView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *backView = [[UIImageView alloc]init];
    [backView setBackgroundColor:[UIColor colorWithHexString:@"#F7FAFF"]];
    [self addSubview:backView];
    self.backView = backView;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:tap1];
    
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.text = @"";
    titleLab.textColor = [UIColor colorWithHexString:@"#2A333A"];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.font = [UIFont systemFontOfSize:14.0f];
    contentLab.text = @"";
    contentLab.textColor = [UIColor colorWithHexString:@"#A7ACB9"];
    contentLab.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:contentLab];
    self.contentLab = contentLab;
    
    
    //huo
    UIImageView *iconImageView = [[UIImageView alloc]init];
    [iconImageView setBackgroundColor:[UIColor whiteColor]];
    [backView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView setContentMode:UIViewContentModeScaleToFill];
    [iconImageView setImage:[UIImage imageNamed:@"huo"]];
    //
//    <#name#>.layer.masksToBounds = YES;
//    <#name#>.layer.cornerRadius = <#cornerRadius#>;
//    <#name#>.layer.borderColor = [UIColor colorWithHexString:<#color#>].CGColor;
//    <#name#>.layer.borderWidth = <#borderWidth#>;

    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self).offset(0);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(5);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-5);
        
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(12);
        make.top.equalTo(self.iconImageView.mas_top).offset(3);
        make.right.equalTo(self.iconImageView.mas_left).offset(-5);
    }];
    
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(12);
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.right.equalTo(self.iconImageView.mas_left).offset(-5);
    }];
    
}


-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}

@end




