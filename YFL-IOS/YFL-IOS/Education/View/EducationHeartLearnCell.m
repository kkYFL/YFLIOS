//
//  EducationHeartLearnCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationHeartLearnCell.h"
#import "LearningTaskModel.h"
#import "LearningHistory.h"
#import "AppDelegate.h"


#define iconW WIDTH_SCALE*121
#define iconH HEIGHT_SCALE*91

@interface EducationHeartLearnCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *seeNum;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *button;


@end

@implementation EducationHeartLearnCell


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
    [icon setImage:[UIImage imageNamed:@""]];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(iconH);
        make.width.mas_equalTo(iconW);
    }];
    
    
    UILabel *cellTitle = [[UILabel alloc] init];
    cellTitle.font = [UIFont boldSystemFontOfSize:14.0f];
    cellTitle.text = @"《巡视利剑》第一集：利剑高悬";
    cellTitle.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitle];
    self.cellTitle = cellTitle;
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.top.equalTo(self.icon.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-15.0f);
    }];

    
    UIImageView *seeimage = [[UIImageView alloc]init];
    [seeimage setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:seeimage];
    [seeimage setContentMode:UIViewContentModeCenter];
    [seeimage setImage:[UIImage imageNamed:@"education_see"]];
    [seeimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.bottom.equalTo(self.icon.mas_bottom).offset(-10);
    }];
    
    
    UILabel *seeNum = [[UILabel alloc] init];
    seeNum.font = [UIFont systemFontOfSize:11];
    seeNum.text = @"96631条";
    seeNum.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    seeNum.textAlignment = NSTextAlignmentLeft;
    self.seeNum = seeNum;
    [self.contentView addSubview:seeNum];
    [seeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seeimage.mas_right).offset(6);
        make.centerY.equalTo(seeimage);
    }];
    
    
    UIImageView *timeimage = [[UIImageView alloc]init];
    [timeimage setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:timeimage];
    [timeimage setContentMode:UIViewContentModeCenter];
    [timeimage setImage:[UIImage imageNamed:@"education_time"]];
    [timeimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seeNum.mas_right).offset(18);
        make.centerY.equalTo(seeimage);
    }];
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.text = @"1.45学时";
    timeLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeimage.mas_right).offset(6);
        make.centerY.equalTo(seeimage);
    }];
    
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
    button.layer.masksToBounds = YES;
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 4.0f;
    [button setTitle:NSLocalizedString(@"weixuexi", nil) forState:UIControlStateNormal];
    self.button = button;
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(seeimage);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(44);
    }];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

+(CGFloat)CellH{
    return 30+iconH;
}

-(void)setHistroyModel:(LearningHistory *)histroyModel{
    _histroyModel = histroyModel;
    if (_histroyModel) {
       
//        [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,_learnModel.taskThumb]]];
//        [self.timeLabel setText:_learnModel.taskTitle];
//        self.seeNum.text = [NSString stringWithFormat:@"%@条",_learnModel.nowNum];
//        self.timeLabel.text = [NSString stringWithFormat:@"%@学时",_learnModel.learnTime];
//        if ([_learnModel.nowState integerValue] == 1) {
//            [self.button setTitle:@"未学习" forState:UIControlStateNormal];
//        }else if ([_learnModel.nowState integerValue] == 2){
//            [self.button setTitle:@"学习中" forState:UIControlStateNormal];
//        }else if ([_learnModel.nowState integerValue] == 3){
//            [self.button setTitle:@"已学习" forState:UIControlStateNormal];
//        }
    }
}


-(void)setLearnModel:(LearningTaskModel *)learnModel{
    _learnModel = learnModel;
    if (_learnModel) {
/*
 
 @property (nonatomic, strong) UIImageView *icon;
 @property (nonatomic, strong) UILabel *cellTitle;
 @property (nonatomic, strong) UILabel *seeNum;
 @property (nonatomic, strong) UILabel *timeLabel;*/
        
        
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,_learnModel.taskThumb]]];
        [self.timeLabel setText:_learnModel.taskTitle];
        self.seeNum.text = [NSString stringWithFormat:@"%@%@",_learnModel.nowNum,NSLocalizedString(@"tiao", nil)];
        self.timeLabel.text = [NSString stringWithFormat:@"%@%@",_learnModel.learnTime,NSLocalizedString(@"xueshi", nil)];
        if ([_learnModel.nowState integerValue] == 1) {
            [self.button setTitle:NSLocalizedString(@"weixuexi", nil) forState:UIControlStateNormal];
        }else if ([_learnModel.nowState integerValue] == 2){
            [self.button setTitle:NSLocalizedString(@"xuexizhong", nil) forState:UIControlStateNormal];
        }else if ([_learnModel.nowState integerValue] == 3){
            [self.button setTitle:NSLocalizedString(@"yixuexi", nil) forState:UIControlStateNormal];
        }
        
        
        //学习状态 1：未学习 2：学习中 3：已学习
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
