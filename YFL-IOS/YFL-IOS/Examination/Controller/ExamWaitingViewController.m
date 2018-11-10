//
//  ExamWaitingViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamWaitingViewController.h"
#import "ExamWaitingTableViewCell.h"
#import "ExamhomeViewController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "MYBlanKView.h"


@interface ExamWaitingViewController ()<UITableViewDelegate,UITableViewDataSource>{
    MYBlanKView *_blanView;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *list;
@end

@implementation ExamWaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    
    
    //
    _blanView = [[MYBlanKView alloc]initWithFrame:self.view.bounds];
    _blanView.hidden = YES;
    [self.view addSubview:_blanView];
}

-(void)loadData{
    
    // 历史考试列表/待开始列表
    // 测试结果: 通过
    [HanZhaoHua getExamListWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId page:1 pageNum:10 queryType:(self.type == ExamViewTypeDefault)?@"1":@"2" success:^(NSArray * _Nonnull list) {
            for (HistoryExam *model in list) {
                NSLog(@"%@", model.times);
                NSLog(@"%@", model.totalTime);
                NSLog(@"%@", model.totalTimes);
                NSLog(@"%@", model.paperTitle);
                NSLog(@"%@", model.beginTime);
                NSLog(@"%@", model.finalTime);
                NSLog(@"%@", model.state);
                NSLog(@"%@", model.summary);
                NSLog(@"%@", model.examId);
                NSLog(@"%@", model.paperId);
            }
        self.list = list;
        
        if (self.list.count == 0) {
            [self showBlanVuiew];
        }else{
            [self hidenBlankView];
        }
        
        [self.table reloadData];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    
}



#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list?self.list.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ExamWaitingTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ExamWaitingTableViewCell *waitingExam = [tableView dequeueReusableCellWithIdentifier:@"waitingExam"];
    if (_type == ExamViewTypeDefault) {
        waitingExam.hideRemindLabel = NO;
    }else{
        waitingExam.hideRemindLabel = YES;
    }
    if (self.list && self.list.count > indexPath.row) {
        HistoryExam *examModel = self.list[indexPath.row];
        waitingExam.examModel = examModel;
    }
    return waitingExam;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == ExamViewTypeDefault) {
        return;
    }
    
    if (self.list && self.list.count > indexPath.row) {
        HistoryExam *examModel = self.list[indexPath.row];
        ExamhomeViewController *examHomeVC = [[ExamhomeViewController alloc]init];
        examHomeVC.examModel = examModel;
        [self.navigationController pushViewController:examHomeVC animated:YES];
    }
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[ExamWaitingTableViewCell class] forCellReuseIdentifier:@"waitingExam"];
    }
    return _table;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = (_type == ExamViewTypeDefault)?[AppDelegate getURLWithKey:@"LishiKaoshi"]:[AppDelegate getURLWithKey:@"Daikaoshi"];
}


-(void)showBlanVuiew{
    [self.view bringSubviewToFront:_blanView];
    _blanView.hidden = NO;
}

-(void)hidenBlankView{
    _blanView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
