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
@property (nonatomic, strong) NSMutableArray *tagViewArr;
@property (nonatomic, strong) HistoryExamDetail *currentExamModel;
@property (nonatomic, assign) BOOL isHistoryExam;

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

}


-(void)setExamModel:(HistoryExamDetail *)examModel isHistory:(BOOL)isHistory{
    _currentExamModel = examModel;
    _isHistoryExam = isHistory;
    
    if (_currentExamModel && _currentExamModel.answers && _currentExamModel.answers.count) {
        while (self.tagViewArr.count < _currentExamModel.answers.count) {
            ExamChooseTagView *tagView = [[ExamChooseTagView alloc]init];
            [self.contentView addSubview:tagView];
            [self.tagViewArr addObject:tagView];
            
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
            tagView.cellSelectView.userInteractionEnabled = YES;
            [tagView.cellSelectView addGestureRecognizer:tap1];
        }
        
        
        
        for (NSInteger i = 0; i<self.tagViewArr.count; i++) {
            ExamChooseTagView *tagView = self.tagViewArr[i];
            if (i<_currentExamModel.answers.count) {
                tagView.cellSelectView.hidden = NO;
                tagView.cellSelectView.tag = 100+i;
                
                Answers *ansModel = _currentExamModel.answers[i];
                NSString *zimi = (_zimiArr.count>i)?_zimiArr[i]:@"";
                [tagView.quetionContentLabel setText:[NSString stringWithFormat:@"%@%@",zimi,ansModel.content]];
                
                //历史考试
                if (isHistory) {
                    if (ansModel.isSelected == 1) {
                        tagView.selected = YES;
                    }else{
                        tagView.selected = NO;
                    }
                    
                //待考试
                }else{
                    if ([ansModel.selected integerValue] == 1) {
                        tagView.selected = YES;
                    }else{
                        tagView.selected = NO;
                    }
                }

                
                CGFloat topSpace = (25+15)*i;
                [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(0);
                    make.top.equalTo(self).offset(topSpace);
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
        NSInteger questionCount = examModel.answers.count;
        return 25*questionCount+15*(questionCount-1)+40;
    }
    return 0.01f;
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    if (!_currentExamModel) {
        return;
    }
    
    //历史考试返回不能进行选择
    if (self.isHistoryExam) {
        return;
    }
    
    UIImageView *touchView = (UIImageView *)tap.view;
    NSInteger touchIndex = touchView.tag - 100;
    
    //单选
    if ([_currentExamModel.examType integerValue] == 1) {
        Answers *answerModel = _currentExamModel.answers[touchIndex];
        ExamChooseTagView *tagView = self.tagViewArr[touchIndex];
        
        if (tagView.selected) {
            tagView.selected = NO;
        }else{
            tagView.selected = YES;
        }
        
        //选中
        if (tagView.selected) {
            for (NSInteger i = 0; i<_currentExamModel.answers.count; i++) {
                Answers *Model = _currentExamModel.answers[i];
                ExamChooseTagView *tag = self.tagViewArr[i];
                Model.selected = @"2";
                tag.selected = NO;
            }
            
            answerModel.selected = @"1";
            tagView.selected = YES;
            
        }else{
            for (NSInteger i = 0; i<_currentExamModel.answers.count; i++) {
                Answers *Model = _currentExamModel.answers[i];
                ExamChooseTagView *tag = self.tagViewArr[i];
                Model.selected = @"2";
                tag.selected = NO;
            }
        }
        

        
        
    }else{
        Answers *answerModel = _currentExamModel.answers[touchIndex];
        ExamChooseTagView *tagView = self.tagViewArr[touchIndex];
        tagView.selected = !tagView.selected;
        //选中
        if (tagView.selected) {
            answerModel.selected = @"1";
        }else{
            answerModel.selected = @"2";
        }
        
    }
    
//    for (NSInteger i = 0; i<self.tagViewArr.count; i++) {
//        ExamChooseTagView *tagView = self.tagViewArr[i];
//        if (touchIndex == i) {
//            [tagView.cellSelectView setImage:[UIImage imageNamed:@"choosen"]];
//        }else{
//            [tagView.cellSelectView setImage:[UIImage imageNamed:@"Exam_no_choose"]];
//        }
//    }
    
    if (self.chooseActionBlock) {
        self.chooseActionBlock(0);
    }
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

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if (_selected) {
        [self.cellSelectView setImage:[UIImage imageNamed:@"choosen"]];
    }else{
        [self.cellSelectView setImage:[UIImage imageNamed:@"Exam_no_choose"]];
    }
}

@end




