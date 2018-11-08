//
//  PersonJifenListController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/11.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonJifenListController.h"
#import "JifenListTableViewCell.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"

@interface PersonJifenListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *scoreList;
@end

@implementation PersonJifenListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.title = [AppDelegate getURLWithKey:@""]@"JifenJilu", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    [self initRefresh];
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:[NSString stringWithFormat:@"%@...",[AppDelegate getURLWithKey:@""]@"jiazaizhong", nil)] onView:self.view];

    // 积分列表
    // 测试结果: 接口通过, 但是无数据返回
    [HanZhaoHua getScoreListWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId success:^(NSArray * _Nonnull scoreList) {
        for (ScoreRecord *score in scoreList) {
            NSLog(@"%@", score.expireTime);
            NSLog(@"%@", score.getTime);
            NSLog(@"%@", score.scoreId);
            NSLog(@"%@", score.remark);
            NSLog(@"%@", score.score);
            NSLog(@"%@", score.source);
            NSLog(@"%@", score.pmId);
        }
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        
        self.scoreList = scoreList;
        
        [self.table reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];

    }];
}


#pragma mark 上下拉刷新
- (void)initRefresh{
    MJRefershHeader *header = [MJRefershHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershHeader)];
    self.table.mj_header = header;
}


-(void)refershHeader{
    [self loadData];
}

#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scoreList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JifenListTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JifenListTableViewCell *JifenCell = [tableView dequeueReusableCellWithIdentifier:@"JifenCell"];
    if (self.scoreList.count > indexPath.row) {
        ScoreRecord *record = self.scoreList[indexPath.row];
        JifenCell.record = record;
    }
    return JifenCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-EWTTabbar_SafeBottomMargin)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[JifenListTableViewCell class] forCellReuseIdentifier:@"JifenCell"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}





@end
