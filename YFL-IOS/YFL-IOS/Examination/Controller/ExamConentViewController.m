//
//  ExamConentViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/12.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamConentViewController.h"
#import "ExamTopTitleTableViewCell.h"
#import "ExamChooseCell.h"
#import "ExamTextViewPutINCell.h"
#import "ExamTextInViewCell.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "ExamRuleModel.h"


typedef NS_ENUM(NSInteger,ExamContentViewType) {
    ExamContentViewTypeDefault,
    ExamContentViewTypeTextIn
};

@interface ExamConentViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    HistoryExamDetail *_currentExamModel;
    NSInteger _currentIndex;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) ExamContentViewType viewType;
@property (nonatomic, strong) NSArray *detailList;
@property (nonatomic, strong) NSMutableDictionary *answersDic;

@end

@implementation ExamConentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
    
    [self loadData];
}

-(void)initView{
    self.title = NSLocalizedString(@"KaoshiDati", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
}

-(void)initData{
    _currentIndex = 0;
    self.answersDic = [NSMutableDictionary dictionary];
}


#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_viewType == ExamContentViewTypeDefault) {
            return [ExamTopTitleTableViewCell CellH];
        }
        
        return [ExamTextInViewCell CellH];
        
    }else if (indexPath.row == 1){
        if (_viewType == ExamContentViewTypeDefault) {
            return [ExamChooseCell CellHWithModel:_currentExamModel]+60;
        }
        
        return [ExamTextViewPutINCell CellH];
    }
    return 0.01f;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        if (_viewType == ExamContentViewTypeDefault) {
            ExamTopTitleTableViewCell *topTitleCell = [tableView dequeueReusableCellWithIdentifier:@"topTitleCell"];
            NSString *typeStr = @"";
            if ([_currentExamModel.examType integerValue] == 1) {
                typeStr = NSLocalizedString(@"danxuan", nil);
            }else if ([_currentExamModel.examType integerValue] == 2){
                typeStr = NSLocalizedString(@"duoxuan", nil);
            }else if ([_currentExamModel.examType integerValue] == 3){
                typeStr = NSLocalizedString(@"tiankong", nil);
            }else if ([_currentExamModel.examType integerValue] == 4){
                typeStr = NSLocalizedString(@"panduan", nil);
            }else if ([_currentExamModel.examType integerValue] == 5){
                typeStr = NSLocalizedString(@"jieda", nil);
            }
            topTitleCell.titleLabel.text = [NSString stringWithFormat:@"%@%ld%@  %@%@",NSLocalizedString(@"di", nil),(_currentIndex+1),NSLocalizedString(@"timu", nil),typeStr,NSLocalizedString(@"timu", nil)];
            return topTitleCell;
        }
        
        ExamTextInViewCell *textInCell = [tableView dequeueReusableCellWithIdentifier:@"textInCell"];
        return textInCell;
        
    }else if (indexPath.row == 1){
        if (_viewType == ExamContentViewTypeDefault) {
            ExamChooseCell *chooseCell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
            if (_currentExamModel) {chooseCell.currentExamModel = _currentExamModel; }
            chooseCell.chooseActionBlock = ^(NSInteger chooseIndex) {
//                if (weakSelf.detailList.count ) {
//
//                }
                
                //if (_currentIndex < self.detailList.count && chooseIndex<self.detailList.count) //{
//                    HistoryExamDetail *examDetailModel = self.detailList[_currentIndex];
//                    for (NSInteger i=0; i<examDetailModel.answers.count; i++) {
//                        Answers *ansModel = examDetailModel.answers[i];
//
//                        //单选
//                        if ([examDetailModel.examType integerValue] == 1) {
//                            //选择项
//                            if (chooseIndex == i) {
//                                ansModel.selected = @"1";
//                            }else{
//                                ansModel.selected = @"2";
//                            }
//                        //多选
//                        }else{
//                            //选择项
//                            if (chooseIndex == i) {
//                                ansModel.selected = @"1";
//                            }
//                        }
//
//
//                    }
//                }

            };
            return chooseCell;
        }
        
        ExamTextViewPutINCell *putInCell = [tableView dequeueReusableCellWithIdentifier:@"putInCell"];
        return putInCell;
    }
    
    static NSString *identify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-EWTTabbar_SafeBottomMargin)];
        _table = table;
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        _table.tableFooterView = self.footerView;
        
        [_table registerClass:[ExamTopTitleTableViewCell class] forCellReuseIdentifier:@"topTitleCell"];
        [_table registerClass:[ExamChooseCell class] forCellReuseIdentifier:@"chooseCell"];

        //
        [_table registerClass:[ExamTextInViewCell class] forCellReuseIdentifier:@"textInCell"];
        [_table registerClass:[ExamTextViewPutINCell class] forCellReuseIdentifier:@"putInCell"];
    }
    return _table;
}

-(void)loadData{
    
    // 待开始详情
    // 测试结果: 通过
    [HanZhaoHua getWaitingToStartDetailWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId paperId:(self.ruleDic.paperId)?self.ruleDic.paperId:@"0" success:^(NSArray * _Nonnull detailList) {
        self.detailList = detailList;
        [self refreshViewWithWithIndex:_currentIndex];
        //[self refreshViewWithData];
            NSLog(@"");
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    
    

    
    
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
    //fangqibencidati
    //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您好，您还有1次答题的机会,是否确定放弃本次答题？" delegate:self cancelButtonTitle:NSLocalizedString(@"quxiao", nil) otherButtonTitles:NSLocalizedString(@"queding", nil), nil];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tishi", nil) message:[NSString stringWithFormat:@"%@%@%@,%@",NSLocalizedString(@"shengyu", nil),@"1",NSLocalizedString(@"ci", nil),NSLocalizedString(@"jihui", nil),NSLocalizedString(@"fangqibencidati", nil)] delegate:self cancelButtonTitle:NSLocalizedString(@"quxiao", nil) otherButtonTitles:NSLocalizedString(@"queding", nil), nil];

    [alert show];
    }

-(UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]init];
        [footerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        _footerView = footerView;
        
        UIButton *button1 = [[UIButton alloc]init];
        [button1 setBackgroundColor:[UIColor colorWithHexString:@"#BBBBBB"]];
        [button1 addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 101;
        button1.layer.masksToBounds = YES;
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button1 setTitle:NSLocalizedString(@"shangyiti", nil) forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button1.layer.cornerRadius = 10.0f;
        [_footerView addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(0);
            make.right.equalTo(_footerView.mas_centerX).offset(-30);
            make.bottom.equalTo(_footerView.mas_bottom).offset(0);
            make.width.mas_equalTo(WIDTH_SCALE*120);
        }];
        
        
        
        UIButton *button2 = [[UIButton alloc]init];
        [button2 setBackgroundColor:[UIColor colorWithHexString:@"#E51C23"]];
        [button2 addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 102;
        button2.layer.masksToBounds = YES;
        [button2.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button2 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button2.layer.cornerRadius = 10.0f;
        [button2 setTitle:NSLocalizedString(@"xiayiti", nil) forState:UIControlStateNormal];
        [_footerView addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(0);
            make.left.equalTo(_footerView.mas_centerX).offset(30);
            make.bottom.equalTo(_footerView.mas_bottom).offset(0);
            make.width.mas_equalTo(WIDTH_SCALE*120);
        }];
        
    }
    return _footerView;
}


//下一题  上一题
-(void)selectSource:(UIButton *)sender{
    NSInteger viewTag = sender.tag;
    
    //上一题
    if (viewTag == 101) {
        //返回到第一题点击返回按钮无效
        if (_currentIndex <= 0) {
            return;
        }
        
        //上一题
        _currentIndex --;
        
        
        
        
        //_viewType = ExamContentViewTypeDefault;
        
    //下一题
    }else if (viewTag == 102){
        //_viewType = ExamContentViewTypeTextIn;
        //case 1
        if (_currentIndex >= self.detailList.count) {
            //答题结束提交答案
            [self submitData];
            return;
        }
        
        //case 2
        //未答题禁止进入下一题
//        NSString *key = [NSString stringWithFormat:@"%ld",(long)_currentIndex];
//        if (![self.answersDic objectForKey:key]) {
//            //未答题禁止进入下一题
//            return;
//        }
        BOOL hasAnswered = NO;
        for (NSInteger i=0; i<_currentExamModel.answers.count; i++) {
            Answers *ansModel = _currentExamModel.answers[i];
            if ([ansModel.selected integerValue] == 1) {
                hasAnswered = YES;
            }
        }
        if (!hasAnswered) {
            return;
        }
        
        
        
        //case 3
        //继续答题
        _currentIndex++;
        
        [self refreshViewWithWithIndex:_currentIndex];

        [self.table reloadData];
    }
    
    
    
}

-(void)refreshViewWithWithIndex:(NSInteger)index{
    if (self.detailList && self.detailList.count && self.detailList.count > _currentIndex) {
        HistoryExamDetail *examDetailModel = self.detailList[_currentIndex];
        _currentExamModel = examDetailModel;
        /*
         //试题类型【1、单选 2、多选 3、填空 4、判断 5、简答】
         @property(nonatomic, assign) NSNumber *examType;
         */
        //单选 多选
        if ([_currentExamModel.examType integerValue] == 1 || [_currentExamModel.examType integerValue] == 2) {
            _viewType = ExamContentViewTypeDefault;
        //简答
        }else{
            _viewType = ExamContentViewTypeTextIn;
        }
        
        [self.table reloadData];
    }
}


-(void)submitData{
    // 党员开始交卷
    // 测试结果: 通过
//    NSDictionary *paraDic = @{@"userToken":APP_DELEGATE.userToken,
//                              @"userId":APP_DELEGATE.userId,
//                              @"paperId":self.papidID,
//                              @"data": @{@"userAnswer":@"",
//                                         @"examTitle":@"",
//                                         @"totalTimes": [[NSNumber alloc] initWithInteger:2],
//                                         @"paperTitle":@"",
//                                         @"examUrl":@"",
//                                         @"examId":@"",
//                                         @"examType":@"",
//                                         @"summary":@"",
//                                         @"answers":@[@{}]
//                                         }
//                              };
    
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKey:@"userId"];
    [para setValue:(self.ruleDic.paperId)?self.ruleDic.paperId:@"" forKey:@"paperId"];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSInteger i = 0; i<self.detailList.count; i++) {
        HistoryExamDetail *examDetailModel = self.detailList[i];
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        [tmpDic setValue:examDetailModel.userAnswer?examDetailModel.userAnswer:@"" forKey:@"userAnswer"];
        [tmpDic setValue:examDetailModel.examTitle?examDetailModel.examTitle:@"" forKey:@"examTitle"];
        [tmpDic setValue:examDetailModel.examUrl?examDetailModel.examUrl:@"" forKey:@"examUrl"];
        [tmpDic setValue:examDetailModel.examId?examDetailModel.examId:@"" forKey:@"examId"];
        [tmpDic setValue:[NSNumber numberWithInteger:[examDetailModel.examType integerValue]] forKey:@"examType"];
        [tmpDic setValue:examDetailModel.score?examDetailModel.score:@"" forKey:@"score"];
        [tmpDic setValue:[NSNumber numberWithInteger:[examDetailModel.showOrder integerValue]] forKey:@"showOrder"];
        [tmpDic setValue:[NSNumber numberWithInteger:[examDetailModel.titleType integerValue]] forKey:@"titleType"];

        NSMutableArray *ansArr = [NSMutableArray array];
        for (NSInteger j = 0; j<examDetailModel.answers.count; j++) {
            Answers *ansModel = examDetailModel.answers[j];
            NSMutableDictionary *ansDic = [NSMutableDictionary dictionary];
            [ansDic setValue:ansModel.content forKey:@"content"];
            [ansDic setValue:ansModel.answerId forKey:@"id"];
            [ansDic setValue:[NSNumber numberWithInteger:[ansModel.isAnswer integerValue]] forKey:@"isAnswer"];
            [ansDic setValue:[NSNumber numberWithInteger:[ansModel.selected integerValue]] forKey:@"selected"];
            [ansArr addObject:ansDic];
        }
        [tmpDic setValue:ansArr forKey:@"answers"];
        [dataArr addObject:tmpDic];
        
    }
    
    [para setValue:dataArr forKey:@"data"];
    
    
    /*
     content = "\U5546\U5468\U65f6\U4ee3\U7684\U827a\U672f\U6210\U5c31--\U300a\U4e2d\U56fd\U9752\U94dc\U65f6\U4ee3\U300b";
     id = ecd1fe6fb15542caafe0e329409168d6;
     isAnswer = 2;
     selected = 2;
     
     
     
     //试题内容
     //考试视频或音频链接地址
     //考试试题ID
     //答案列表
     @property(nonatomic, strong) NSMutableArray *answers;
     //试题类型【1、单选 2、多选 3、填空 4、判断 5、简答】
     //
     //
     //
     */
    
    
    
    [HanZhaoHua submitExamPaperWithParaDic:para success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        [self back];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
