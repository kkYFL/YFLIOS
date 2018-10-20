//
//  EducationAddOptionController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/21.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationAddOptionController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"

#define contentH HEIGHT_SCALE*240

@interface EducationAddOptionController ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UILabel *contentTitle;
@property (nonatomic, strong) UITextField *topicTextfield;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *placeHolderView;
@property (nonatomic, strong) UILabel *reindLabel;
@property (nonatomic, strong) UIButton *submitBtn;


@end

@implementation EducationAddOptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = NSLocalizedString(@"XiangzengFankui", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    //
    [self.contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.view).offset(15.0f);
        make.height.mas_equalTo(14.0f);
    }];
    
    
    //
    [self.topicTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.contentTitle.mas_bottom).offset(15.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
        make.height.mas_equalTo(40.f);
    }];
    
    


    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0);
        make.top.equalTo(self.topicTextfield.mas_bottom).offset(15.0);
        make.right.equalTo(self.view.mas_right).offset(-15.0);
        make.height.mas_equalTo(contentH);
    }];
    
    
    [self.placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTextView).offset(5);
        make.top.equalTo(self.contentTextView).offset(5);
    }];
    
    
    [self.reindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.contentTextView.mas_bottom).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
    }];
    
    
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.reindLabel.mas_bottom).offset(50.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
        make.height.mas_equalTo(40.0f);
    }];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewConentChange:) name:UITextViewTextDidChangeNotification object:nil];

    
}

-(void)loadData{
//    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
//
//    [HTTPEngineGuide VolunteerJinduGetAllCategorySourceSuccess:^(NSDictionary *responseObject) {
//        NSString *code = [[responseObject objectForKey:@"code"] stringValue];
//
//        if ([code isEqualToString:@"200"]) {
//            [self hideDisnetView];
//            // 数据加载完成
//            [[PromptBox sharedBox] removeLoadingView];
//            //
//            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
//            NSArray *listArr = [dataDic objectForKey:@"list"];
//
//            [<#tableName#> reloadData];
//        }
//
//    }else{
//        //数据刷新
//        [[PromptBox sharedBox] removeLoadingView];
//        [self hideDisnetView];
//
//        //数据异常情况处理
//        if ([code isEqualToString:@"702"] || [code isEqualToString:@"704"] || [code isEqualToString:@"706"]) {
//            [PublicMethod OfflineNotificationWithCode:code];//其他code值，错误信息展示
//        }else{
//            NSString *msg=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"msg"]];
//            [[PromptBox sharedBox] showPromptBoxWithText:msg onView:self.view hideTime:2 y:0];
//        }
//    }
//
//     } failure:^(NSError *error) {
//         [[PromptBox sharedBox] removeLoadingView];
//         [self showDisnetView];
//     }];
}


#pragma mark - 懒加载
-(UILabel *)contentTitle{
    if (!_contentTitle) {
        UILabel *contentTitle = [[UILabel alloc] init];
        contentTitle.font = [UIFont systemFontOfSize:14.0f];
        contentTitle.text = @"您有什么问题或建议想对我们说？";
        contentTitle.textColor = [UIColor colorWithHexString:@"#E51C23"];
        contentTitle.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:contentTitle];
        _contentTitle = contentTitle;
    }
    return _contentTitle;
}

-(UITextField *)topicTextfield{
    if (!_topicTextfield) {
        UITextField *cellTextfield = [[UITextField alloc]init];
        //设置边框样式，只有设置了才会显示边框样式
        cellTextfield.borderStyle = UITextBorderStyleRoundedRect;
        //设置输入框内容的字体样式和大小
        cellTextfield.font = [UIFont systemFontOfSize:14.0f];
        //设置字体颜色
        cellTextfield.textColor = [UIColor colorWithHexString:@"#888888"];
        //当输入框没有内容时，水印提示 提示内容为password
        cellTextfield.placeholder = @"您的主题";
        //内容对齐方式
        cellTextfield.textAlignment = NSTextAlignmentLeft;
        //设置键盘的样式
        cellTextfield.keyboardType = UIKeyboardTypeDefault;
        //return键变成什么键
        cellTextfield.returnKeyType =UIReturnKeyDone;
        cellTextfield.delegate = self;
        _topicTextfield = cellTextfield;
        [self.view addSubview:_topicTextfield];
    }
    return _topicTextfield;
}

-(UITextView *)contentTextView{
    if (!_contentTextView) {
        UITextView *textView = [[UITextView alloc]init];
        textView.layer.masksToBounds = YES;
        textView.textColor = [UIColor colorWithHexString:@"#888888"];
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor = [UIColor colorWithHexString:@"#9C9C9C"].CGColor;
        [self.view addSubview:textView];
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeyDone;
        _contentTextView = textView;
        
        
        UILabel *placeHolderView = [[UILabel alloc] init];
        placeHolderView.font = [UIFont systemFontOfSize:14.0f];
        placeHolderView.text = @"您的宝贵意见，就是我们进步的源泉";
        placeHolderView.textColor = [UIColor colorWithHexString:@"#888888"];
        placeHolderView.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:placeHolderView];
        self.placeHolderView = placeHolderView;

    }
    return _contentTextView;
}

-(UILabel *)reindLabel{
    if (!_reindLabel) {
        UILabel *reindLabel = [[UILabel alloc] init];
        reindLabel.font = [UIFont systemFontOfSize:14.0f];
        reindLabel.text = @"      请详细描述您遇到的问题或疑问，有助于我们快速定位并解决，或留下您宝贵的意见或建议，我们会认真进行评估！";
        reindLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
        reindLabel.textAlignment = NSTextAlignmentLeft;
        reindLabel.numberOfLines = 0;
        [self.view addSubview:reindLabel];
        _reindLabel = reindLabel;
    }
    return _reindLabel;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
        [button addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        [button setTitle:@"问题提交" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 4.0f;
        _submitBtn = button;
        [self.view addSubview:_submitBtn];
    }
    return _submitBtn;
}



#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

-(void)selectSource:(UIButton *)sender{
    if (!self.topicTextfield.text.length || !self.contentTextView.text.length) {
        [[PromptBox sharedBox] showPromptBoxWithText:@"请输入你的反馈信息" onView:self.view hideTime:2 y:0];
        return;
    }
    
    // 意见反馈
    // 测试结果: 通过
        [HanZhaoHua suggestionFeedbackWithUserId:APP_DELEGATE.userId title:self.topicTextfield.text problemInfo:self.contentTextView.text success:^(NSDictionary * _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"feedBackViewRfershList" object:nil];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 通知
-(void)textViewConentChange:(NSNotification *)noti{
    UITextView *currentobj = (UITextView *)noti.object;
    if (currentobj.text.length) {
        self.placeHolderView.hidden = YES;
    }else{
        self.placeHolderView.hidden = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
       [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
