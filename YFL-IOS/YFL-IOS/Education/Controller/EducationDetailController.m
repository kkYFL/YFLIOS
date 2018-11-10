//
//  EducationDetailController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationDetailController.h"
#import "AppDelegate.h"
#import "SuggestionFeedback.h"

@interface EducationDetailController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *questDescribeLabel;
@property (nonatomic, strong) UILabel *questContent;

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *questBackLabel;
@property (nonatomic, strong) UILabel *questBackContent;


@end

@implementation EducationDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[AppDelegate getURLWithKey:@"fankuizhuti"] ,self.feedBackModel.title];
    self.questDescribeLabel.text = [AppDelegate getURLWithKey:@"fankuiwentiMiaoshu"];
    self.questContent.text = [NSString stringWithFormat:@"      %@",self.feedBackModel.problemInfo];
    self.questBackLabel.text = [AppDelegate getURLWithKey:@"fankuihuifu"];
    self.questBackContent.text = [NSString stringWithFormat:@"      %@",self.feedBackModel.answer];

    if ([NSString isBlankString:self.feedBackModel.answer]) {
        self.line.hidden = YES;
        self.questBackLabel.hidden = YES;
        self.questBackContent.hidden = YES;
    }
    
    //
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.view).offset(15.0f);
    }];
    
    
    //
    [self.questDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.0f);
    }];
    
    
    //
    [self.questContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(26.0f);
        make.top.equalTo(self.questDescribeLabel.mas_bottom).offset(14.0f);
        make.right.equalTo(self.view.mas_right).offset(-26.0f);
    }];
    
    
    //
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.questContent.mas_bottom).offset(50.0f);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(0.5f);
    }];
    
    
    //
    [self.questBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.line.mas_bottom).offset(15.0f);
        make.right.equalTo(self.view);
    }];
    
    
    //
    [self.questBackContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(26.0f);
        make.top.equalTo(self.questBackLabel.mas_bottom).offset(14.0f);
        make.right.equalTo(self.view.mas_right).offset(-26.0f);
    }];
    
    
    
    /*
     //处理状态； 1：解决中 2：已处理
     @property(nonatomic, copy) NSString *answerState;
     //反馈时间(时间戳)
     @property(nonatomic, copy) NSString *createTime;
     //问题描述
     @property(nonatomic, copy) NSString *problemInfo;
     //主题
     @property(nonatomic, copy) NSString *title;
     //回复信息
     @property(nonatomic, copy) NSString *answer;
     */
    
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


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.text = @"主题：关于考试问题";
        titleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:titleLabel];
        _titleLabel = titleLabel;
        
    }
    return _titleLabel;
}




-(UILabel *)questDescribeLabel{
    if (!_questDescribeLabel) {
        UILabel *questDescribeLabel = [[UILabel alloc] init];
        questDescribeLabel.font = [UIFont systemFontOfSize:17.0f];
        questDescribeLabel.text = @"问题描述：";
        questDescribeLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        questDescribeLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:questDescribeLabel];
        _questDescribeLabel = questDescribeLabel;
    }
    return _questDescribeLabel;
}


-(UILabel *)questContent{
    if (!_questContent) {
        UILabel *questContent = [[UILabel alloc] init];
        questContent.font = [UIFont systemFontOfSize:14.0f];
        questContent.numberOfLines = 0;
        questContent.text = @"      对于巡视组反馈的问题,要充分认识存在的不足，按照问题导向，切实抓好整改落实。下面是爱汇网小编为大家整理的反馈问题整改报告,供大家阅读!司党委以高度警醒、负责的态度，全面贯彻“党要管党、从严治党”的要求，对省委巡视组反馈的问题全面看待、正确对待，始终把抓好反馈意见的整改作为当前公司最大的政治任务，真正做到了认识充分、措施有力、效果显著。";
        questContent.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        questContent.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:questContent];
        _questContent = questContent;
    }
    return _questContent;
}

-(UIView *)line{
    if (!_line) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
        [self.view addSubview:line];
        _line = line;
    }
    return _line;
}

-(UILabel *)questBackLabel{
    if (!_questBackLabel) {
        UILabel *questBackLabel = [[UILabel alloc] init];
        questBackLabel.font = [UIFont systemFontOfSize:17.0f];
        questBackLabel.text = @"回复：";
        questBackLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        questBackLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:questBackLabel];
        _questBackLabel = questBackLabel;
    }
    return _questBackLabel;
}

-(UILabel *)questBackContent{
    if (!_questBackContent) {
        UILabel *questBackContent = [[UILabel alloc] init];
        questBackContent.font = [UIFont systemFontOfSize:14.0f];
        questBackContent.numberOfLines = 0;
        questBackContent.text = @"      之所以考试是为了提高党员的文化水平，同时能更好的服务人民！";
        questBackContent.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        questBackContent.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:questBackContent];
        _questBackContent = questBackContent;
    }
    return _questBackContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = [AppDelegate getURLWithKey:@"FankuiXiangqing"];
}


#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
