//
//  NewsNoticeViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsNoticeViewController.h"
#import "NewsNoticiTableViewCell.h"
#import "InformationMenu.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "NewsDetailNoVideoController.h"
#import "NewsVideoDetailViewController.h"


@interface NewsNoticeViewController ()<UITableViewDelegate,UITableViewDataSource
>{
    NSInteger _pageIndex;
    BOOL hasLoadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *newsList;


@end

@implementation NewsNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.title = @"通知公告";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    [self initRefresh];
}

-(void)initData{
    _pageIndex = 1;
    hasLoadAll = NO;
    self.newsList = [NSMutableArray array];
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];

    // 新闻列表接口
    // 测试结果: 通过
    [HanZhaoHua getNewsListWithUserToken:APP_DELEGATE.userToken typesId:self.menuModel.menuId Title:@"" page:_pageIndex pageNum:10 success:^(NSArray * _Nonnull newsList) {
        for (NewsMessage *news in newsList) {
            NSLog(@"%@", news.browsingNum);
            NSLog(@"%@", news.clickNum);
            NSLog(@"%@", news.commonNum);
            NSLog(@"%@", news.imgUrl);
            NSLog(@"%@", news.infoId);
            NSLog(@"%@", news.infoType);
            NSLog(@"%@", news.shortInfo);
            NSLog(@"%@", news.sourceFrom);
            NSLog(@"%@", news.title);
            NSLog(@"%@", news.types);
        }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (newsList.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasLoadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        //fresh
        if (_pageIndex == 1) {
            self.newsList = [NSMutableArray arrayWithArray:newsList];

        //more
        }else{
            [self.newsList addObjectsFromArray:newsList];
        }
        
        [self.table reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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
    return self.newsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewsNoticiTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NewsNoticiTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
    if (self.newsList.count>indexPath.row) {
        NewsMessage *newsModel = self.newsList[indexPath.row];
        [noticeCell.cellTitleLabel setText:newsModel.title];
        [noticeCell.fromLabel setText:newsModel.sourceFrom];
        [noticeCell.timeLabel setText:newsModel.createTime];
    }
    return noticeCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsMessage *newsModel = nil;
    if (self.newsList.count>indexPath.row) {
        newsModel = self.newsList[indexPath.row];
    }else{
        return;
    }
    //文字加图片
    if ([newsModel.infoType integerValue] == 1) {
        NewsDetailNoVideoController *detailVc = [[NewsDetailNoVideoController alloc] init];
        detailVc.newsModel = newsModel;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
        //文本
    }else if ([newsModel.infoType integerValue] == 2){
        NewsDetailNoVideoController *detailVc = [[NewsDetailNoVideoController alloc] init];
        detailVc.newsModel = newsModel;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
        //视频
    }else if ([newsModel.infoType integerValue] == 3){
        NewsVideoDetailViewController *videoVC = [[NewsVideoDetailViewController alloc]init];
        videoVC.hidesBottomBarWhenPushed = YES;
        videoVC.newsModel = newsModel;
        [self.navigationController pushViewController:videoVC animated:YES];
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
        
        [_table registerClass:[NewsNoticiTableViewCell class] forCellReuseIdentifier:@"noticeCell"];
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
