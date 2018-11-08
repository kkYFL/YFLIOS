//
//  CLInputToolbar.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLInputToolbar.h"
#import "UIView+CLSetRect.h"
#import "AppDelegate.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface CLInputToolbar ()<UITextViewDelegate>{
    CGFloat fatherViewH;
}
/**文本输入框*/
@property (nonatomic, strong) UITextView *textView;
/**边框*/
@property (nonatomic, strong) UIView *edgeLineView;

@property (nonatomic, strong) UILabel *topLabel;
/**顶部线条*/
@property (nonatomic, strong) UIView *topLine;
/**底部线条*/
@property (nonatomic, strong) UIView *bottomLine;
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendButton;
/**键盘高度*/
@property (nonatomic, assign) CGFloat keyboardHeight;
/**发送回调*/
@property (nonatomic, copy) inputTextBlock inputTextBlock;


@end

@implementation CLInputToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0,frame.size.height, CLscreenWidth, 80);
        fatherViewH = frame.size.height;
        [self initView];
        [self addNotification];
    }
    return self;
}
-(void)initView {
    //顶部线条
    self.backgroundColor = [UIColor whiteColor];
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.CLwidth, 0.5)];
    self.topLine.backgroundColor = [UIColor colorWithHexString:@"#9C9C9C"];
    [self addSubview:self.topLine];
    //底部线条
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.CLheight - 0.5, self.CLwidth, 0.5)];
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"#9C9C9C"];
    [self addSubview:self.bottomLine];
    
    
    //
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.font = [UIFont systemFontOfSize:14.0f];
    topLabel.text = [AppDelegate getURLWithKey:@"TextInputTitle"];
    topLabel.textColor = [UIColor colorWithHexString:@"#179EE8"];
    [self addSubview:topLabel];
    self.topLabel = topLabel;
    [self.topLabel setFrame:CGRectMake(15, 15, self.CLwidth-15, 15.0f)];
    
    //边框
    self.edgeLineView = [[UIView alloc]init];
    //self.edgeLineView.CLwidth = self.CLwidth - 50 - 30;
    [self.edgeLineView setFrame:CGRectMake(15, 40, self.CLwidth - 50 - 45, 30)];
    //self.edgeLineView.CLleft = 10;
    self.edgeLineView.layer.cornerRadius = 5.0f;
    self.edgeLineView.layer.borderColor = [UIColor colorWithHexString:@"#9C9C9C"].CGColor;
    self.edgeLineView.layer.borderWidth = 1.0f;
    self.edgeLineView.layer.masksToBounds = YES;
    [self addSubview:self.edgeLineView];
    
    
    //输入框
    self.textView = [[UITextView alloc] init];;
    //self.textView.CLwidth = self.CLwidth - 50 - 46;
    //self.textView.CLleft = 18;
    [self.textView setFrame:CGRectMake(25, 45, self.CLwidth - 50 - 45-10-10, 20)];
    //self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    self.textView.scrollsToTop = NO;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textContainer.lineFragmentPadding = 0;
    [self addSubview:self.textView];
    
    
    //占位文字
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
    //self.placeholderLabel.CLwidth = self.textView.CLwidth - 10;
    self.placeholderLabel.textColor = [UIColor colorWithHexString:@"#888888"];
    //self.placeholderLabel.CLleft = 23;
    [self addSubview:self.placeholderLabel];
    [self.placeholderLabel setFrame:CGRectMake(25, 45, self.CLwidth - 50 - 45-10-10, 20)];
    
    
    //发送按钮
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.CLwidth - 50 - 15, 40, 50, 30)];
    [self.sendButton.layer setBorderWidth:1.0f];
    [self.sendButton.layer setCornerRadius:5.0];
    self.sendButton.layer.borderColor = [UIColor colorWithHexString:@"#9C9C9C"].CGColor;
    self.sendButton.enabled = NO;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.sendButton setTitle:[AppDelegate getURLWithKey:@"TextSend"] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(didClicksendButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];
    self.fontSize = 20;
    self.textViewMaxLine = 3;
}

// 添加通知
-(void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;

    self.textView.font = [UIFont systemFontOfSize:_fontSize];
    self.placeholderLabel.font = self.textView.font;
//    CGFloat lineH = self.textView.font.lineHeight;
//    self.CLheight = ceil(lineH) + 10 + 10+20;
//    self.textView.CLheight = lineH;
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine {
    _textViewMaxLine = textViewMaxLine;
    if (!_textViewMaxLine || _textViewMaxLine <= 0) {
        _textViewMaxLine = 3;
    }
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}
#pragma mark keyboardnotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardFrame.size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.CLy = fatherViewH - _keyboardHeight- 80-NAVIGATION_BAR_HEIGHT;
    }];
    
    
    /** 键盘完全弹出时间 */
//    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] intValue];
//
//    /** 动画趋势 */
//    int curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
//
//    /** 动画执行完毕frame */
//    CGRect keyboard_frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//    /** 获取键盘y值 */
//    CGFloat keyboard_y = keyboard_frame.origin.y;
//
//    /** view上平移的值 */
//    CGFloat offset = SCREEN_HEIGHT - keyboard_y;
//
//    /** 执行动画  */
//    [UIView animateWithDuration:duration animations:^{
//
//        [UIView setAnimationCurve:curve];
//        self.transform = CGAffineTransformMakeTranslation(0, -offset);
//    }];
}


- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.CLy = fatherViewH;
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length;
    if (textView.text.length == 0) {
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
    }else{
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#179EE8"] forState:UIControlStateNormal];
    }
    
//    CGFloat contentSizeH = textView.contentSize.height;
//    CGFloat lineH = textView.font.lineHeight;
//    CGFloat maxTextViewHeight = ceil(lineH * self.textViewMaxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
//    if (contentSizeH <= maxTextViewHeight) {
//        textView.CLheight = contentSizeH;
//    }else{
//        textView.CLheight = maxTextViewHeight;
//    }
    
    //self.CLheight = ceil(textView.CLheight) + 10 + 10+20;
    
    //self.CLbottom = CLscreenHeight - _keyboardHeight-self.CLheight;
    //[textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        return NO;
    }
    return YES;
}

// 发送按钮
-(void)didClicksendButton {
    if (self.inputTextBlock) {
        self.inputTextBlock(self.textView.text);
    }
}
- (void)inputToolbarSendText:(inputTextBlock)sendText{
    self.inputTextBlock = sendText;
}
- (void)popToolbar{
    self.fontSize = _fontSize;
    [self.textView becomeFirstResponder];
}
// 发送成功 清空文字 更新输入框大小
-(void)bounceToolbar {
    self.textView.text = nil;
    [self.textView.delegate textViewDidChange:self.textView];
    [self endEditing:YES];
}
-(void)layoutSubviews{
    [super layoutSubviews];

//    CGFloat r1 = 20.0/(self.textView.CLheight+10+10+15+5)*0.5;
//    self.edgeLineView.CLheight = self.textView.CLheight + 10;
//    self.textView.CLcenterY = self.CLheight * (0.5+r1);
//    self.placeholderLabel.CLheight = self.textView.CLheight;
//    self.placeholderLabel.CLcenterY = self.CLheight * (0.5+r1);
//    self.sendButton.CLcenterY = self.CLheight * (0.5+r1);
//    self.edgeLineView.CLcenterY = self.CLheight * (0.5+r1);
//    self.bottomLine.CLy = self.CLheight - 0.5;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
