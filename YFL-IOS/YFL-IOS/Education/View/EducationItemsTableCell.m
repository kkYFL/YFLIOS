//
//  EducationItemsTableCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationItemsTableCell.h"

#define itemMarginSpace 20
#define itemViewSpace 25
#define itemViewH 60
#define itemViewW (SCREEN_WIDTH-itemMarginSpace*2-itemViewSpace)/2.0

@interface EducationItemsTableCell ()
@property (nonatomic, strong) UILabel *cellTitleLab;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) EducationItemContentView *item1;
@property (nonatomic, strong) EducationItemContentView *item2;
@property (nonatomic, strong) EducationItemContentView *item3;
@property (nonatomic, strong) EducationItemContentView *item4;

@end

@implementation EducationItemsTableCell

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
    cellTitleLab.font = [UIFont systemFontOfSize:18.0f];
    cellTitleLab.text = @"党员热区";
    cellTitleLab.textColor = [UIColor colorWithRed:229/255.0 green:81/255.0 blue:40/255.0 alpha:1];
    cellTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:cellTitleLab];
    self.cellTitleLab = cellTitleLab;
    
    [cellTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.height.mas_equalTo(18);
    }];
    
    
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithRed:229/255.0 green:81/255.0 blue:40/255.0 alpha:1];
    self.line1 = line1;
    [self.contentView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cellTitleLab.mas_left).offset(-20);
        make.centerY.equalTo(self.cellTitleLab.mas_centerY).offset(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(100);
    }];
    

    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor colorWithRed:229/255.0 green:81/255.0 blue:40/255.0 alpha:1];
    self.line2 = line2;
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellTitleLab.mas_right).offset(20);
        make.centerY.equalTo(self.cellTitleLab.mas_centerY).offset(0);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(100);
    }];
    

    CGFloat itemTop = 25*2+18;
    self.item1 = [[EducationItemContentView alloc]initWithFrame:CGRectMake(itemMarginSpace, itemTop, itemViewW, itemViewH)];
    self.item1.titleLabel.text = @"学习任务";
    [self.contentView addSubview:self.item1];
    
    self.item2 = [[EducationItemContentView alloc]initWithFrame:CGRectMake(itemMarginSpace+itemViewW+itemViewSpace, itemTop, itemViewW, itemViewH)];
    self.item2.titleLabel.text = @"学习痕迹";
    [self.contentView addSubview:self.item2];
    
    
    self.item3 = [[EducationItemContentView alloc]initWithFrame:CGRectMake(itemMarginSpace, itemTop+itemViewH+itemViewSpace, itemViewW, itemViewH)];
    self.item3.titleLabel.text = @"意见反馈";
    [self.contentView addSubview:self.item3];
    
    
    self.item4 = [[EducationItemContentView alloc]initWithFrame:CGRectMake(itemMarginSpace+itemViewW+itemViewSpace, itemTop+itemViewH+itemViewSpace, itemViewW, itemViewH)];
    self.item4.titleLabel.text = @"学习心得";
    [self.contentView addSubview:self.item4];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
    }];

}

+(CGFloat)CellH{
    return 25*2+18+itemViewH*2+itemViewSpace+25;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end


#pragma mark - EducationItemContentView
@interface EducationItemContentView ()


@end

@implementation EducationItemContentView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *backView = [[UIImageView alloc]init];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:backView];
    self.backView = backView;
    [backView setContentMode:UIViewContentModeScaleToFill];
    [backView setImage:[UIImage imageNamed:@"Pfofession_card-bg-2"]];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:tap1];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    

    UIImageView *icon = [[UIImageView alloc]init];
    [icon setBackgroundColor:[UIColor whiteColor]];
    [backView addSubview:icon];
    self.icon = icon;
    [icon setContentMode:UIViewContentModeCenter];
    [icon setImage:[UIImage imageNamed:@"ZjDoubtView"]];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-20);
        make.centerY.equalTo(backView);
        make.height.width.mas_equalTo(40);
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.text = @"学习任务";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [backView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(20);
        make.right.equalTo(backView.mas_left).offset(-10);
        make.centerY.equalTo(icon.mas_centerY).offset(0);
    }];

}


-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}


@end


