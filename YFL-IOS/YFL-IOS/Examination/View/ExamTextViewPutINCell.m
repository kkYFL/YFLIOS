//
//  ExamTextViewPutINCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/15.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#define TextPutInView 175*HEIGHT_SCALE

#import "ExamTextViewPutINCell.h"
#import "AppDelegate.h"

@interface ExamTextViewPutINCell ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderView;

@end

@implementation ExamTextViewPutINCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextView *textView = [[UITextView alloc]init];
    textView.layer.masksToBounds = YES;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [UIColor colorWithHexString:@"#9C9C9C"].CGColor;
    [self.contentView addSubview:textView];
    textView.delegate = self;
    self.textView = textView;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(self).offset(15.0);
        make.right.equalTo(self.mas_right).offset(-15.0);
        make.height.mas_equalTo(TextPutInView);
    }];
    
    
    UILabel *placeHolderView = [[UILabel alloc] init];
    placeHolderView.font = [UIFont systemFontOfSize:14.0f];
    placeHolderView.text = [AppDelegate getURLWithKey:@"duohangshuru"];
    placeHolderView.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    placeHolderView.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:placeHolderView];
    self.placeHolderView = placeHolderView;
    
    [self.placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15+3);
        make.top.equalTo(self).offset(15+5);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidSelectAction:) name:UITextViewTextDidChangeNotification object:nil];
}

+(CGFloat)CellH{
    return TextPutInView + 15*2;
}


-(void)textViewDidSelectAction:(NSNotification *)noti{
    UITextView *text = noti.object;
    if (text.text.length) {
        self.placeHolderView.hidden = YES;
    }else{
        self.placeHolderView.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
