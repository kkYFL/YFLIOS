//
//  EducationJianjieCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/7.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationJianjieCell.h"
#import "LearningTaskModel.h"

@interface EducationJianjieCell ()
@property (nonatomic, strong) UILabel *mingchengLabel;
@property (nonatomic, strong) UILabel *leixingLabel;
@property (nonatomic, strong) UILabel *learnTimeLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *jianjieLabel;


@end

@implementation EducationJianjieCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *mingchengLabel = [[UILabel alloc] init];
    mingchengLabel.font = [UIFont systemFontOfSize:14.0f];
    mingchengLabel.text = @"任务名称:《巡视利剑》第一集：利剑高悬";
    mingchengLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    mingchengLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:mingchengLabel];
    self.mingchengLabel = mingchengLabel;
    [mingchengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    
    UILabel *leixingLabel = [[UILabel alloc] init];
    leixingLabel.font = [UIFont systemFontOfSize:14.0f];
    leixingLabel.text = @"任务类别：视频";
    leixingLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    leixingLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:leixingLabel];
    self.leixingLabel = leixingLabel;
    [leixingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.mingchengLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    
    UILabel *learnTimeLabel = [[UILabel alloc] init];
    learnTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    learnTimeLabel.text = @"学习时长：79分钟";
    learnTimeLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    learnTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:learnTimeLabel];
    self.learnTimeLabel = learnTimeLabel;
    [learnTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.leixingLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(14.0f);
    }];
    

    UILabel *createTimeLabel = [[UILabel alloc] init];
    createTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    createTimeLabel.text = @"创建时间：2018/07/13";
    createTimeLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    createTimeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:createTimeLabel];
    self.createTimeLabel = createTimeLabel;
    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.learnTimeLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    
    
    UILabel *jianjieLabel = [[UILabel alloc] init];
    jianjieLabel.font = [UIFont systemFontOfSize:14.0f];
    jianjieLabel.numberOfLines = 0;
    NSString *content = @"任务简介：本视频讲述的是党的十八大以来，党中央把巡视作为全面从严治党的重大举措、党内监督的战略性制度安排，巡视发挥出令人瞩目的利剑作用。十八届中央纪委执纪审查的案件中，超过60%的线索来巡视。巡视发现问题，形成震慑，成为国之利器、党值利器。《巡视利剑》第一集《利剑高悬》，敬请关注！";
    NSMutableAttributedString *attri = [EducationJianjieCell getAttriHeightwithString:content Speace:4.0f withFont:[UIFont systemFontOfSize:14.0f]];
    jianjieLabel.attributedText = attri;
    jianjieLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    jianjieLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:jianjieLabel];
    self.jianjieLabel = jianjieLabel;
    
    CGFloat H = [EducationJianjieCell getSpaceLabelHeightwithString:content Speace:4.0f withFont:[UIFont systemFontOfSize:14.0f] withWidth:SCREEN_WIDTH-30.0f];
    [jianjieLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.top.equalTo(self.createTimeLabel.mas_bottom).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.height.mas_equalTo(H);
    }];
    
    
}


+(CGFloat)CellH{
    NSString *content = @"任务简介：本视频讲述的是党的十八大以来，党中央把巡视作为全面从严治党的重大举措、党内监督的战略性制度安排，巡视发挥出令人瞩目的利剑作用。十八届中央纪委执纪审查的案件中，超过60%的线索来巡视。巡视发现问题，形成震慑，成为国之利器、党值利器。《巡视利剑》第一集《利剑高悬》，敬请关注！";
    NSMutableAttributedString *attri = [EducationJianjieCell getAttriHeightwithString:content Speace:4.0f withFont:[UIFont systemFontOfSize:14.0f]];
    CGFloat H = [EducationJianjieCell getSpaceLabelHeightwithString:content Speace:4.0f withFont:[UIFont systemFontOfSize:14.0f] withWidth:SCREEN_WIDTH-30.0f];
    return 4*(15+14)+15.0f+H+60;
}

+(CGFloat)CellHWithModel:(LearningTaskModel *)model{
    NSString *content = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@：",[AppDelegate getURLWithKey:@""]@"RenWujianjie", nil)],model.taskSummary];
    CGFloat H = [EducationJianjieCell getSpaceLabelHeightwithString:content Speace:4.0f withFont:[UIFont systemFontOfSize:14.0f] withWidth:SCREEN_WIDTH-30.0f]+0.5f;
    return 4*(15+14)+15.0f+H+60;
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

-(void)setModel:(LearningTaskModel *)model{
    _model = model;
    if (_model) {
        //任务类型 1 文字 2 视频 3 音频 4 图片

        self.mingchengLabel.text = [NSString stringWithFormat:@"%@:%@",[AppDelegate getURLWithKey:@""]@"renwumingcheng", nil),_model.taskTitle];
        NSString *taskTypeStr = @"";
        if ([_model.taskType integerValue] == 1) {
            taskTypeStr = [AppDelegate getURLWithKey:@""]@"wenzi", nil);
        }else if ([_model.taskType integerValue] == 2){
            taskTypeStr = [AppDelegate getURLWithKey:@""]@"shiping", nil);
        }else if ([_model.taskType integerValue] == 3){
            taskTypeStr = [AppDelegate getURLWithKey:@""]@"yingping", nil);
        }else if ([_model.taskType integerValue] == 4){
            taskTypeStr = [AppDelegate getURLWithKey:@""]@"tupian", nil);
        }
        
        self.leixingLabel.text = [NSString stringWithFormat:@"%@：%@",[AppDelegate getURLWithKey:@""]@"renwuleixing", nil),taskTypeStr];
        self.learnTimeLabel.text = [NSString stringWithFormat:@"%@：%@%@",[AppDelegate getURLWithKey:@""]@"xuexishixhang", nil),_model.learnTime,[AppDelegate getURLWithKey:@""]@"fenzhogn", nil)];
        self.createTimeLabel.text = [NSString stringWithFormat:@"%@：%@",[AppDelegate getURLWithKey:@""]@"chaugnjianshijian", nil),_model.createTime];
        //RenWujianjie
        NSString *content = [NSString stringWithFormat:@"%@:%@",[AppDelegate getURLWithKey:@""]@"chaugnjianshijian", nil),_model.taskSummary];
        NSMutableAttributedString *attri = [EducationJianjieCell getAttriHeightwithString:content Speace:4.0f withFont:[UIFont systemFontOfSize:14.0f]];
        self.jianjieLabel.attributedText = attri;
        //CGFloat H = [EducationJianjieCell getSpaceLabelHeightwithString:content Speace:4.0f withFont:[UIFont systemFontOfSize:14.0f] withWidth:SCREEN_WIDTH-30.0f];
        [self.jianjieLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15.0f);
            make.top.equalTo(self.createTimeLabel.mas_bottom).offset(15.0f);
            make.right.equalTo(self.mas_right).offset(-15.0f);
        }];
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
