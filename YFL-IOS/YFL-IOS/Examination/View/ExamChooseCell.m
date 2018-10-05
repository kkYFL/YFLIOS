//
//  ExamChooseCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/12.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamChooseCell.h"
#import "HistoryExamDetail.h"
#import "Answers.h"

@interface ExamChooseCell (){
    NSArray *_zimiArr;
}
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSMutableArray *tagViewArr;

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
    
    self.tagViewArr = [NSMutableArray array];
    _zimiArr = [NSArray arrayWithObjects:@"A: ",@"B: ",@"C: ",@"D: ",@"E: ",@"F: ",@"G: ", nil];

    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:17.0f];
    contentLabel.text = @"";
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
    

}


-(void)setCurrentExamModel:(HistoryExamDetail *)currentExamModel{
    _currentExamModel = currentExamModel;
    if (_currentExamModel && _currentExamModel.answers && _currentExamModel.answers.count) {
        while (self.tagViewArr.count < _currentExamModel.answers.count) {
            ExamChooseTagView *tagView = [[ExamChooseTagView alloc]init];
            [self.contentView addSubview:tagView];
            [self.tagViewArr addObject:tagView];
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
            tagView.cellSelectView.userInteractionEnabled = YES;
            [tagView.cellSelectView addGestureRecognizer:tap1];
        }
        
        
        NSString *content = currentExamModel.examTitle;
        self.contentLabel.text = content;
        CGFloat contentH = [PublicMethod getSpaceLabelHeight:content withWidh:SCREEN_WIDTH-30 font:17]+0.5f;
        
        for (NSInteger i = 0; i<self.tagViewArr.count; i++) {
            ExamChooseTagView *tagView = self.tagViewArr[i];
            if (i<_currentExamModel.answers.count) {
                tagView.cellSelectView.hidden = NO;
                tagView.cellSelectView.tag = 100+i;
                
                Answers *ansModel = _currentExamModel.answers[i];
                NSString *zimi = (_zimiArr.count>i)?_zimiArr[i]:@"";
                [tagView.quetionContentLabel setText:[NSString stringWithFormat:@"%@%@",zimi,ansModel.content]];
                
                CGFloat topSpace = 15+contentH+80*HEIGHT_SCALE+(25+15)*i;
                [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(0);
                    make.top.equalTo(self.contentLabel.mas_bottom).offset(topSpace);
                    make.height.mas_equalTo(25);
                    make.width.mas_equalTo(SCREEN_WIDTH);
                }];
            }else{
                tagView.hidden = YES;
                tagView.cellSelectView.tag = -1;
            }
        }
    }
}


+(CGFloat)CellHWithModel:(HistoryExamDetail *)examModel{
    if (examModel) {
        NSString *content = examModel.examTitle;
        CGFloat contentH = [PublicMethod getSpaceLabelHeight:content withWidh:SCREEN_WIDTH-30 font:17]+0.5f;
        NSInteger questionCount = examModel.answers.count;
        return 15+contentH+80*HEIGHT_SCALE+25*questionCount+15*(questionCount-1)+40;
    }
    return 0.01f;
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    UIImageView *touchView = (UIImageView *)tap.view;
    NSInteger touchIndex = touchView.tag - 100;
    for (NSInteger i = 0; i<self.tagViewArr.count; i++) {
        ExamChooseTagView *tagView = self.tagViewArr[i];
        if (touchIndex == i) {
            [tagView.cellSelectView setImage:[UIImage imageNamed:@"choosen"]];
        }else{
            [tagView.cellSelectView setImage:[UIImage imageNamed:@"Exam_no_choose"]];
        }
    }
    
    if (self.chooseActionBlock) {
        self.chooseActionBlock(touchIndex);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end




@implementation ExamChooseTagView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *cellSelectView = [[UIImageView alloc]init];
    [cellSelectView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:cellSelectView];
    self.cellSelectView = cellSelectView;
    [cellSelectView setContentMode:UIViewContentModeCenter];
    [cellSelectView setImage:[UIImage imageNamed:@"Exam_no_choose"]];
    [cellSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(25);
    }];
    
    
    UILabel *quetionContentLabel = [[UILabel alloc] init];
    quetionContentLabel.font = [UIFont systemFontOfSize:17.0f];
    quetionContentLabel.text = @"";
    quetionContentLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    quetionContentLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:quetionContentLabel];
    self.quetionContentLabel = quetionContentLabel;
    [quetionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellSelectView.mas_right).offset(10);
        make.centerY.equalTo(self.cellSelectView);
    }];
    
}

@end




