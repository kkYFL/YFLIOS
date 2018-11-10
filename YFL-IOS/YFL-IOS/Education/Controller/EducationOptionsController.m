//
//  EducationOptionsController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/21.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationOptionsController.h"
#import "EducationOptionsTableCell.h"
#import "EducationAddOptionController.h"
#import "EducationDetailController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"

@interface EducationOptionsController ()<UITableViewDelegate,UITableViewDataSource
>{
    NSInteger _pageIndex;
    BOOL hasLoadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *feedbackArr;
@end

@implementation EducationOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"options_right", @"options_right", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    [self initRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"feedBackViewRfershList" object:nil];;
    
}

-(void)initData{
    _pageIndex = 1;
    hasLoadAll = NO;
    self.feedbackArr = [NSMutableArray array];
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:[NSString stringWithFormat:@"%@...",[AppDelegate getURLWithKey:@"jiazaizhong"]] onView:self.view];


    // 获取意见反馈列表
    // 测试结果: 通过
        [HanZhaoHua getSuggestionFeedbackWithPage:_pageIndex pageNum:10 success:^(NSArray * _Nonnull list) {
            for (SuggestionFeedback *model in list) {
                NSLog(@"%@", model.answerState);
                NSLog(@"%@", model.createTime);
                NSLog(@"%@", model.problemInfo);
                NSLog(@"%@", model.title);
                NSLog(@"%@", model.answer);
            }
            
            [[PromptBox sharedBox] removeLoadingView];
            [self.table.mj_header endRefreshing];
            if (list.count < 10) {
                [self.table.mj_footer endRefreshingWithNoMoreData];
                hasLoadAll = YES;
            }else{
                [self.table.mj_footer endRefreshing];
            }
            
            if (_pageIndex == 1) {
                self.feedbackArr = [NSMutableArray arrayWithArray:list];
            }else{
                [self.feedbackArr addObjectsFromArray:list];
            }
            
            
            [self.table reloadData];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            [[PromptBox sharedBox] removeLoadingView];
            [self.table.mj_footer endRefreshing];
            [self.table.mj_header endRefreshing];
        }];
    

}



#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedbackArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EducationOptionsTableCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationOptionsTableCell *optionsCell = [tableView dequeueReusableCellWithIdentifier:@"optionsCell"];
    if (self.feedbackArr.count > indexPath.row) {
        SuggestionFeedback *model = self.feedbackArr[indexPath.row];
        optionsCell.feedBackModel = model;
    }
    return optionsCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.feedbackArr.count > indexPath.row) {
        SuggestionFeedback *model = self.feedbackArr[indexPath.row];
        EducationDetailController *optionDetailVC = [[EducationDetailController alloc]init];
        optionDetailVC.feedBackModel = model;
        [self.navigationController pushViewController:optionDetailVC animated:YES];
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
        
        [_table registerClass:[EducationOptionsTableCell class] forCellReuseIdentifier:@"optionsCell"];
    }
    return _table;
}


#pragma mark 上下拉刷新
- (void)initRefresh{
    MJRefershHeader *header = [MJRefershHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershHeader)];
    self.table.mj_header = header;
    MJBachFooter *footer = [MJBachFooter footerWithRefreshingTarget:self refreshingAction:@selector(refershFooter)];
    self.table.mj_footer = footer;
    self.table.mj_footer.automaticallyChangeAlpha = YES;
}

-(void)refershFooter{
    if (hasLoadAll) {
        [self.table.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    _pageIndex++;
    [self loadData];
}

-(void)refershHeader{
    [self initData];
    
    [self loadData];
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
    EducationAddOptionController *addVC = [[EducationAddOptionController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - 通知
-(void)refreshList:(NSNotification *)noti{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = [AppDelegate getURLWithKey:@"Yijianfankui"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}


@end
