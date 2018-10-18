//
//  NewsPolicyViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//
#define SDViewH 150

#import "NewsPolicyViewController.h"
#import "SDCycleScrollView.h"
#import "NewsPolicyTableViewCell.h"
#import "NewsPolicyDetailViewController.h"
#import "InformationMenu.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "WZWebViewController.h"
#import "NewsDetailNoVideoController.h"
#import "NewsVideoDetailViewController.h"

@interface NewsPolicyViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>{
    NSInteger _pageIndex;
    BOOL hasloadAll;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, strong) NSMutableArray *bannerList;
@property (nonatomic, assign) NSInteger serverCount;


@end

@implementation NewsPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.title = @"政策法规";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.scrollView;
    [self initRefresh];
    [self addObserver:self forKeyPath:@"serverCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

}

-(void)initData{
    self.bannerList = [NSMutableArray array];
    self.newsList = [NSMutableArray array];
    self.serverCount = 0;
    _pageIndex = 1;
    hasloadAll = NO;
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    
    // banner接口   positionType:@"MPOS_1"
    // 热区菜单接口  positionType:@"MPOS_4"
    // 测试结果: 通过
    [HanZhaoHua getInformationBannerWithUserToken:APP_DELEGATE.userToken positionType:@"MPOS_5" success:^(NSArray * _Nonnull bannerList) {
        for (Banner *model in bannerList) {
            NSLog(@"%@", model.imgUrl);
            NSLog(@"%@", model.positionNo);
            NSLog(@"%@", model.summary);
            NSLog(@"%@", model.foreignUrl);
            NSLog(@"%@", model.foreignType);
        }
        self.bannerList = [NSMutableArray arrayWithArray:bannerList];
        self.serverCount ++;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        self.serverCount ++;
    }];
    
    
    
    // 新闻列表接口
    // 测试结果: 通过
    [HanZhaoHua getNewsListWithUserToken:APP_DELEGATE.userToken typesId:self.menuModel.menuId Title:@"" page:1 pageNum:10 success:^(NSArray * _Nonnull newsList) {
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
        self.newsList = [NSMutableArray arrayWithArray:newsList];
        //        self.serverCount ++;
        self.serverCount ++;

        //[self.table reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        //self.serverCount ++;
        self.serverCount ++;

    }];
}

-(void)loadMoreData{
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
            hasloadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        

        
        [self.newsList addObjectsFromArray:newsList];
        
        [self.table reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
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
    if (hasloadAll) {
        [self.table.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    _pageIndex++;
    [self loadMoreData];
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
    return [NewsPolicyTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NewsPolicyTableViewCell *policyCell = [tableView dequeueReusableCellWithIdentifier:@"policyCell"];
    if (self.newsList.count > indexPath.row) {
        NewsMessage *messModel = self.newsList[indexPath.row];
        [policyCell.cellContent setText:messModel.title];
    }
    return policyCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsMessage *newsModel = nil;
    if (self.newsList.count>indexPath.row) {
        newsModel = self.newsList[indexPath.row];
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
    
    
    
    //NewsPolicyDetailViewController *detailVC = [[NewsPolicyDetailViewController alloc]init];
    //[self.navigationController pushViewController:detailVC animated:YES];
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
        
        [_table registerClass:[NewsPolicyTableViewCell class] forCellReuseIdentifier:@"policyCell"];
    }
    return _table;
}



-(void)setContentData:(id)data{
    
    NSMutableArray* images = [NSMutableArray array];
    for (NSInteger i = 0; i<self.bannerList.count; i++) {
        Banner *bannerModel = self.bannerList[i];
        NSString *str = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,bannerModel.imgUrl];
        NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [images addObject:urlStr];
    }
    _scrollView.imageURLStringsGroup = images;
}

-(SDCycleScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SDViewH) delegate:self placeholderImage:nil];
    }
    return _scrollView;
}

#pragma mark - SDCycleScrollViewDelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if (self.bannerList.count > index) {
        WZWebViewController *wzweb  = [[WZWebViewController alloc] init];
        Banner *bannerModel = self.bannerList[index];
        wzweb.titleVC               =  @"详情";
        wzweb.webUrl = [NSString stringWithFormat:@"%@%@", APP_DELEGATE.sourceHost,bannerModel.foreignUrl];
        wzweb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wzweb animated:YES];
    }

}

#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self initData];
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context{
    NSInteger new = [[change objectForKey:@"new"] integerValue];
    
    //数据渲染
    if (new == 2) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (self.newsList.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        [self setContentData:nil];
        [self.table reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"serverCount"];
}



@end
