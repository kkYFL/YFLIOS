//
//  EducationLearHeartViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationLearHeartViewController.h"
#import "EducationHeartLearnCell.h"
#import "EducationTaskDetailController.h"
#import "EducationTaskHistoryController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"

@interface EducationLearHeartViewController ()<UITableViewDelegate,UITableViewDataSource
>{
    NSInteger _pageIndex;
    BOOL hasLoadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *itemsView;
@property (nonatomic, strong) NSMutableArray *learnListArr;
@property (nonatomic, strong) NSMutableArray *historyLearnListArr;

@end

@implementation EducationLearHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.title = (_type == MYEducationViewTypeDefault)?@"学习任务":@"党员教育";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    
    [self initRefresh];
    
}

-(void)initData{
    self.learnListArr = [NSMutableArray array];
    self.historyLearnListArr = [NSMutableArray array];
    _pageIndex = 1;
    hasLoadAll = NO;
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
    
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    
    // 学习任务
    if (self.type == MYEducationViewTypeDefault) {
        // 学习任务列表
        // 测试结果: 通过
            [HanZhaoHua getLearningTaskListWithUserId:APP_DELEGATE.userId type:1 page:_pageIndex pageNum:10 success:^(NSArray * _Nonnull listArray) {

                for (LearningTaskModel *item in listArray) {
                    NSLog(@"%@", item.taskId);
                }
                
                [[PromptBox sharedBox] removeLoadingView];
                [self.table.mj_header endRefreshing];
                if (listArray.count<10) {
                    [self.table.mj_footer endRefreshingWithNoMoreData];
                    hasLoadAll = YES;
                }else{
                    [self.table.mj_footer endRefreshing];
                }
                if (_pageIndex == 1) {
                    self.learnListArr = [NSMutableArray arrayWithArray:listArray];
                }else{
                    [self.learnListArr addObjectsFromArray:listArray];
                }
                
                
                [self.table reloadData];
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];

    }else{
        
//        // 学习任务列表
//        // 测试结果: 通过
        [HanZhaoHua getLearningTaskListWithUserId:APP_DELEGATE.userId type:2 page:_pageIndex pageNum:10 success:^(NSArray * _Nonnull listArray) {

            for (LearningTaskModel *item in listArray) {
                NSLog(@"%@", item.taskId);
            }
            
            
            [[PromptBox sharedBox] removeLoadingView];
            [self.table.mj_header endRefreshing];
            if (listArray.count<10) {
                [self.table.mj_footer endRefreshingWithNoMoreData];
                hasLoadAll = YES;
            }else{
                [self.table.mj_footer endRefreshing];
            }
            if (_pageIndex == 1) {
                self.learnListArr = [NSMutableArray arrayWithArray:listArray];
            }else{
                [self.learnListArr addObjectsFromArray:listArray];
            }
            
            
            [self.table reloadData];
        } failure:^(NSError * _Nonnull error) {
            [[PromptBox sharedBox] removeLoadingView];
            [self.table.mj_footer endRefreshing];
            [self.table.mj_header endRefreshing];
        }];
    }
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





#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.learnListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EducationHeartLearnCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationHeartLearnCell *heartCell = [tableView dequeueReusableCellWithIdentifier:@"heartCell"];
    if (self.learnListArr.count > indexPath.row) {
        LearningTaskModel *model = self.learnListArr[indexPath.row];
        heartCell.learnModel = model;
    }

    if (self.type == MYEducationViewTypeDefault) {

    }else{

    }
    
    return heartCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.type == MYEducationViewTypeDefault) {
        EducationTaskDetailController *detailVC = [[EducationTaskDetailController alloc]init];
        if (self.learnListArr.count > indexPath.row) {
            LearningTaskModel *model = self.learnListArr[indexPath.row];
            detailVC.model = model;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        
        EducationTaskHistoryController *hisoryVC = [[EducationTaskHistoryController alloc]init];
        if (self.learnListArr.count > indexPath.row) {
            LearningTaskModel *model = self.learnListArr[indexPath.row];
            hisoryVC.model = model;
        }
        [self.navigationController pushViewController:hisoryVC animated:YES];
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
        
        [_table registerClass:[EducationHeartLearnCell class] forCellReuseIdentifier:@"heartCell"];
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
