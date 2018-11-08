//
//  LearHistroyListiViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "LearHistroyListiViewCell.h"
#import "LearningHistory.h"
#import "AppDelegate.h"

@interface LearHistroyListiViewCell ()
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation LearHistroyListiViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:11];
    leftLabel.text = @"2018-07-13";
    leftLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:leftLabel];
    self.leftLabel = leftLabel;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(38.0f);
        make.centerY.equalTo(self);
    }];
    
    
    UILabel *midLabel = [[UILabel alloc] init];
    midLabel.font = [UIFont systemFontOfSize:11.0f];
    midLabel.text = @"13:20 - 14:00";
    midLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    midLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:midLabel];
    self.midLabel = midLabel;
    [self.midLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
    }];
    
    
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = [UIFont systemFontOfSize:11.0f];
    rightLabel.text = @"时长 40分钟";
    rightLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-38.0f);
        make.centerY.equalTo(self);
    }];

    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    
    
}

+(CGFloat)CellH{
    return 33.0f;
}

-(void)setHistoryModel:(LearningHistory *)historyModel{
    _historyModel = historyModel;
    if (_historyModel) {
        
        //
        NSString *dateStr = _historyModel.startTime;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//指定转date得日期格式化形式
        NSDate *learDate = [dateFormatter dateFromString:dateStr];
        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm";//指定转date得日期格式化形式
        NSString *dateNewStr = [dateFormatter stringFromDate:learDate];
        self.leftLabel.text = dateNewStr;

        

        //
        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//指定转date得日期格式化形式
        NSString *startTimeStr = _historyModel.startTime;
        NSString *startEndStr = _historyModel.endTime;
        NSDate *startDate = [dateFormatter dateFromString:startTimeStr];
        NSDate *endDate = [dateFormatter dateFromString:startEndStr];
        dateFormatter.dateFormat=@"HH:mm";//指定转date得日期格式化形式
        NSString *startNewsStr = [dateFormatter stringFromDate:startDate];
        NSString *endNewStr = [dateFormatter stringFromDate:endDate];
        self.midLabel.text = [NSString stringWithFormat:@"%@ - %@",startNewsStr,endNewStr];

        
        //
        self.rightLabel.text = [NSString stringWithFormat:@"%@ %@%@",[AppDelegate getURLWithKey:@"shichang"],_historyModel.learnTime,[AppDelegate getURLWithKey:@"fenzhogn"]];


    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
