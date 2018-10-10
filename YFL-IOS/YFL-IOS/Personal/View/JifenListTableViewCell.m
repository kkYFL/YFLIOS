//
//  JifenListTableViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/11.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "JifenListTableViewCell.h"
#import "ScoreRecord.h"

@interface JifenListTableViewCell ()
@property (nonatomic, strong) UIImageView *biaoImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation JifenListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *biaoImageView = [[UIImageView alloc]init];
    [biaoImageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:biaoImageView];
    self.biaoImageView = biaoImageView;
    [biaoImageView setContentMode:UIViewContentModeCenter];
    [biaoImageView setImage:[UIImage imageNamed:@"biao"]];
    [self.biaoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.centerY.equalTo(self);
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
    
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = [UIFont systemFontOfSize:11.0f];
    rightLabel.text = @"2018-07-11 到 2018-07-13";
    rightLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:rightLabel];
    self.rightLabel = rightLabel;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}


+(CGFloat)CellH{
    return 40.0f;
}

-(void)setRecord:(ScoreRecord *)record{
    _record = record;
    if (_record) {
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",_record.getTime];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//指定转date得日期格式化形式
        NSDate *learDate = [dateFormatter dateFromString:dateStr];
        
        NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        dateFormatter1.dateFormat=@"yyyy-MM-dd HH:mm";//指定转date得日期格式化形式
        NSString *dateNewStr = [dateFormatter1 stringFromDate:learDate];
        self.timeLabel.text = dateNewStr;
        
        self.rightLabel.text = [NSString stringWithFormat:@"%@",_record.remark];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
