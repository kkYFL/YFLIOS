//
//  ExamWaitingTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamWaitingTableViewCell.h"
#import "HistoryExam.h"
#import "AppDelegate.h"

@interface ExamWaitingTableViewCell ()
@property (nonatomic, strong) UILabel *cellTitleLabel;
@property (nonatomic, strong) UIImageView *cellNewImageVIew;
@property (nonatomic, strong) UIImageView *biaoImageView;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *remainTimes;
@property (nonatomic, strong) UILabel *examLabel;



@end

@implementation ExamWaitingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *cellTitleLabel = [[UILabel alloc] init];
    cellTitleLabel.font = [UIFont systemFontOfSize:17.0f];
    cellTitleLabel.text = @"《党章党规》 知识答题 第562期";
    cellTitleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitleLabel];
    self.cellTitleLabel = cellTitleLabel;
    [self.cellTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self).offset(15.0f);
    }];
    
    
    UIImageView *cellNewImageVIew = [[UIImageView alloc]init];
    [cellNewImageVIew setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:cellNewImageVIew];
    self.cellNewImageVIew = cellNewImageVIew;
    [cellNewImageVIew setContentMode:UIViewContentModeCenter];
    [cellNewImageVIew setImage:[UIImage imageNamed:@"new"]];
    [self.cellNewImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellTitleLabel.mas_right).offset(10.0f);
        make.centerY.equalTo(self.cellTitleLabel);
        make.height.mas_equalTo(18.0f);
    }];

    
    //
    UIImageView *biaoImageView = [[UIImageView alloc]init];
    [biaoImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:biaoImageView];
    self.biaoImageView = biaoImageView;
    [biaoImageView setContentMode:UIViewContentModeCenter];
    [biaoImageView setImage:[UIImage imageNamed:@"biao"]];
    [self.biaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.cellTitleLabel.mas_bottom).offset(17.0f);
        make.height.width.mas_equalTo(12.0f);
    }];
    
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:11.0f];
    timeLabel.text = @"2018-07-11 到 2018-07-13";
    timeLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.biaoImageView.mas_right).offset(11.0f);
        make.centerY.equalTo(self.biaoImageView);
    }];
    
    
    
    UILabel *remainTimes = [[UILabel alloc] init];
    remainTimes.font = [UIFont systemFontOfSize:11.0f];
    remainTimes.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    remainTimes.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:remainTimes];
    self.remainTimes = remainTimes;
    [self.remainTimes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(30.0f);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    
    
    UILabel *examLabel = [[UILabel alloc] init];
    examLabel.font = [UIFont systemFontOfSize:14.0f];
    examLabel.textColor = [UIColor colorWithHexString:@"#0DA2E8"];
    examLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:examLabel];
    self.examLabel = examLabel;
    [self.examLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.centerY.equalTo(self.timeLabel);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    
}



+(CGFloat)CellH{
    return 15+18+17+12+15;
}

-(void)setHideRemindLabel:(BOOL)hideRemindLabel{
    _hideRemindLabel = hideRemindLabel;
    if (_hideRemindLabel) {
        self.remainTimes.hidden = YES;
    }else{
        self.remainTimes.hidden = NO;
    }
}

-(void)setExamModel:(HistoryExam *)examModel{
    _examModel = examModel;
    if (_examModel) {
        [self.cellTitleLabel setText:_examModel.paperTitle];
        [self.timeLabel setText:[NSString stringWithFormat:@"%@%@%@",_examModel.beginTime,[AppDelegate getURLWithKey:@"dao"],_examModel.finalTime]];
        self.remainTimes.text = [NSString stringWithFormat:@"%@%ld%@",[AppDelegate getURLWithKey:@"shengyu"],([_examModel.totalTimes integerValue]-[_examModel.times integerValue]),[AppDelegate getURLWithKey:@"ci"]];
        NSString *statueStr = @"";
        if ([_examModel.state integerValue] == 1) {
            statueStr = [AppDelegate getURLWithKey:@"yikaoshi"];
        }else if ([_examModel.state integerValue] == 2){
            statueStr = [AppDelegate getURLWithKey:@"Daikaoshi"];
        }else if ([_examModel.state integerValue] == 3){
            statueStr = [AppDelegate getURLWithKey:@"yiwancheng"];
        }
        self.examLabel.text = statueStr;
        
        /*
         //考试状态：1-已考试 2-待考试 3-已完成

         */
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
