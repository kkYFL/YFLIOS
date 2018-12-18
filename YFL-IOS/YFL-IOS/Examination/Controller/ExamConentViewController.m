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
#import "ExamTimuTitleViewCell.h"


typedef NS_ENUM(NSInteger,ExamContentViewType) {
    ExamContentViewTypeDefault,
    ExamContentViewTypeTextIn
};

@interface ExamConentViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextViewDelegate>{
    HistoryExamDetail *_currentExamModel;
    NSString *_currentInputStr;
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
    if (_viewType == ExamContentViewTypeDefault) {
        return 3;
    }else{
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [ExamTopTitleTableViewCell CellH];
    }else if (indexPath.row == 1){
        return [ExamTimuTitleViewCell CellHWithContent:_currentExamModel.examTitle];
    }else if (indexPath.row == 2){
        if (_viewType == ExamContentViewTypeDefault) {
            return [ExamChooseCell CellHWithModel:_currentExamModel]+60;
        }
        return [ExamTextInViewCell CellHWithExamModel:_currentExamModel];
    }else if (indexPath.row == 3){
        return [ExamTextViewPutINCell CellH];
    }
    
    return 0.01f;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ExamTopTitleTableViewCell *topTitleCell = [tableView dequeueReusableCellWithIdentifier:@"topTitleCell"];
        NSString *typeStr = @"";
        if ([_currentExamModel.examType integerValue] == 1) {
            typeStr = [AppDelegate getURLWithKey:@"danxuan"];
        }else if ([_currentExamModel.examType integerValue] == 2){
            typeStr = [AppDelegate getURLWithKey:@"duoxuan"];
        }else if ([_currentExamModel.examType integerValue] == 3){
            typeStr = [AppDelegate getURLWithKey:@"tiankong"];
        }else if ([_currentExamModel.examType integerValue] == 4){
            typeStr = [AppDelegate getURLWithKey:@"panduan"];
        }else if ([_currentExamModel.examType integerValue] == 5){
            typeStr = [AppDelegate getURLWithKey:@"jieda"];
        }
        topTitleCell.titleLabel.text = [NSString stringWithFormat:@"%@%ld%@  %@%@",[AppDelegate getURLWithKey:@"di"],(_currentIndex+1),[AppDelegate getURLWithKey:@"timu"],typeStr,[AppDelegate getURLWithKey:@"timu"]];
        return topTitleCell;

        
    }else if (indexPath.row == 1){
        ExamTimuTitleViewCell *ExamTitleCell = [tableView dequeueReusableCellWithIdentifier:@"ExamTitleCell"];
        ExamTitleCell.cellTitle = _currentExamModel.examTitle;
        return ExamTitleCell;
        
    }else if (indexPath.row == 2){
        if (_viewType == ExamContentViewTypeDefault) {
            ExamChooseCell *chooseCell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
            if (_currentExamModel) {
                [chooseCell setExamModel:_currentExamModel isHistory:self.isWaiting?NO:YES];
            }
            chooseCell.chooseActionBlock = ^(NSInteger chooseIndex) {
            };
            return chooseCell;
        }
        
        
        ExamTextInViewCell *textInCell = [tableView dequeueReusableCellWithIdentifier:@"textInCell"];
        if (_currentExamModel) {
            textInCell.examModel = _currentExamModel;
        }
        return textInCell;
        
    }else if (indexPath.row == 3){
        ExamTextViewPutINCell *putInCell = [tableView dequeueReusableCellWithIdentifier:@"putInCell"];
        putInCell.textView.delegate =self;
        putInCell.textView.text = @"";
        if (!self.isWaiting && _currentExamModel.answers.count) {
            putInCell.placeHolderView.hidden = YES;
            Answers *ansModel = _currentExamModel.answers[0];
            putInCell.textView.text = ansModel.content;
            putInCell.isHistory = YES;
        }
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
        [_table registerClass:[ExamTextInViewCell class] forCellReuseIdentifier:@"textInCell"];
        [_table registerClass:[ExamTextViewPutINCell class] forCellReuseIdentifier:@"putInCell"];
        [_table registerClass:[ExamTimuTitleViewCell class] forCellReuseIdentifier:@"ExamTitleCell"];
    }
    return _table;
}

-(void)loadData{
    // 待开始详情
    // 测试结果: 通过
    [HanZhaoHua getWaitingToStartDetailWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId paperId:(self.ruleDic.paperId)?self.ruleDic.paperId:@"0" isWaiting:self.isWaiting success:^(NSArray * _Nonnull detailList) {
        self.detailList = detailList;
        [self refreshViewWithWithIndex:_currentIndex];
        NSLog(@"");
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    //等待考试
    if (self.isWaiting) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[AppDelegate getURLWithKey:@"tishi"] message:[NSString stringWithFormat:@"%@%@%@,%@",[AppDelegate getURLWithKey:@"shengyu"],@"1",[AppDelegate getURLWithKey:@"ci"],[AppDelegate getURLWithKey:@"jihui"],[AppDelegate getURLWithKey:@"fangqibencidati"]] delegate:self cancelButtonTitle:[AppDelegate getURLWithKey:@"quxiao"] otherButtonTitles:[AppDelegate getURLWithKey:@"queding"], nil];
        
        [alert show];
        
    //历史考试
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

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
        [button1 setTitle:[AppDelegate getURLWithKey:@"shangyiti"] forState:UIControlStateNormal];
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
        [button2 setTitle:[AppDelegate getURLWithKey:@"xiayiti"] forState:UIControlStateNormal];
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
        if (_currentIndex == 0) {
            return;
        }
        
        //上一题
        _currentIndex --;
        
        
        [self refreshViewWithWithIndex:_currentIndex];
        
        [self.table reloadData];
        
    //下一题
    }else if (viewTag == 102){

        //历史答题
        if (!self.isWaiting) {
            //是否最后一题
            if (_currentIndex >= (self.detailList.count-1)) {
                [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"zuihouyiti"] ToView:self.view];
                return;
            }
            
            
            //继续下一题
            _currentIndex++;
            [self refreshViewWithWithIndex:_currentIndex];
            [self.table reloadData];
            
        //等待答题
        }else{
            //答案存储以及判断
            //简答
            if ([_currentExamModel.examType integerValue] == 5){
                //简答已经输入
                if (![NSString isBlankString:_currentInputStr]) {
                    //答案存储 默认应该数组个数为1
                    for (NSInteger i=0; i<_currentExamModel.answers.count; i++) {
                        Answers *ansModel = _currentExamModel.answers[i];
                        ansModel.content = [NSString stringWithFormat:@"%@",_currentInputStr];
                    }
                    //清空数据
                    _currentInputStr = @"";
                    //简答未输入
                }else{
                    return;
                }
                
            }else{
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
                //选择未做任何选择返回
                if (!hasAnswered) {
                    return;
                }
            }
            
            
            //2 是否答题结束
            if (_currentIndex >= (self.detailList.count-1)) {
                //答题结束提交答案
                [self submitData];
                return;
            }
            
            
            
            //case 3
            //继续答题
            _currentIndex++;
            [self refreshViewWithWithIndex:_currentIndex];
            
            [self.table reloadData];
        }
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
        if ([_currentExamModel.examType integerValue] != 5) {
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = [AppDelegate getURLWithKey:@"KaoshiDati"];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    //历史考试返回
    if (!self.isWaiting) {
        return;
    }
    
    NSLog(@"textViewDidChange：%@", textView.text);
    _currentInputStr = textView.text;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    //历史考试返回
    if (!self.isWaiting) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
