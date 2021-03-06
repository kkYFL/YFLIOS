//
//  FabuHomeViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "FabuHomeViewController.h"
#import "EducationHeartLearnCell.h"
#import "FanbudangyuanCell.h"
#import "ExamWaitingTableViewCell.h"
#import "FanbuDetailViewController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "FanbuDangyuanMode.h"
#import "LearningTaskModel.h"
#import "EWTWebView.h"
#import "MYBlanKView.h"


@interface FabuHomeViewController ()<UITableViewDelegate,UITableViewDataSource,EWTWebViewDelegate,UIScrollViewDelegate>{
    NSInteger _selectIndex;
    UIView * _bottonLine;
    NSInteger _pageIndex;
    BOOL hasLoadAll;
    
    NSString *_htmlUrl;
    
    MYBlanKView *_blanView;
}
@property (nonatomic, strong) UIView *pageItemView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UITableView *table;


@property (nonatomic, strong) NSMutableArray *dataArr1;
@property (nonatomic, strong) NSMutableArray *dataArr2;
@property (nonatomic, strong) NSMutableArray *dataArr3;

@property (nonatomic, strong) EWTWebView *webView;
@end

@implementation FabuHomeViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLuanguageAction:) name:KNotificationChangeLaunuageNoti object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectIndex = 1;
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar addSubview:self.pageItemView];
    [self.view addSubview:self.table];
    [self initRefresh];
    
    
    //
    _blanView = [[MYBlanKView alloc]initWithFrame:self.view.bounds];
    _blanView.hidden = YES;
    [self.view addSubview:_blanView];

}


-(void)initData{
    _pageIndex = 1;
    hasLoadAll = NO;
    
    self.dataArr1 = [NSMutableArray array];
    self.dataArr2 = [NSMutableArray array];
    self.dataArr3 = [NSMutableArray array];
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    
    if (_selectIndex == 1) {
        [self getDangyunSourceList];
    }else if (_selectIndex == 2){
        [self getTaskJianduSourceList];
    }else if (_selectIndex == 3){
        [self getTaskKaoshiSourceList];
    }
    
}

-(void)getDangyunSourceList{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKeyPath:@"userId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanListWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (self.dataArr1.count) {
                [self.dataArr1 removeAllObjects];
            }
            if (arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i<arr.count; i++) {
                    NSDictionary *tmpDic = arr[i];
                    FanbuDangyuanMode *model = [[FanbuDangyuanMode alloc] initWithDic:tmpDic];
                    [self.dataArr1 addObject:model];
                    //FanbuDangyuanMode
                }
            }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (arr.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasLoadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        if (self.dataArr1.count == 0) {
            [self showBlanVuiew];
        }else{
            [self hidenBlankView];
        }
        
        [self.table reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}


-(void)getTaskJianduSourceList{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKeyPath:@"userId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanJianduListWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (self.dataArr2.count) {
                [self.dataArr2 removeAllObjects];
            }
            if (arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i<arr.count; i++) {
                    NSDictionary *tmpDic = arr[i];
                    LearningTaskModel *model = [[LearningTaskModel alloc] initWithDic:tmpDic];
                    [self.dataArr2 addObject:model];
                    //FanbuDangyuanMode
                }
            }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (arr.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasLoadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        if (self.dataArr2.count == 0) {
            [self showBlanVuiew];
        }else{
            [self hidenBlankView];
        }
            
        [self.table reloadData];

    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}



-(void)getTaskKaoshiSourceList{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKeyPath:@"userId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanKaoshiJianduListWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (self.dataArr3.count) {
                [self.dataArr3 removeAllObjects];
            }
            if (arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i<arr.count; i++) {
                    NSDictionary *tmpDic = arr[i];
                    HistoryExam *model = [[HistoryExam alloc] initWithDic:tmpDic];
                    [self.dataArr3 addObject:model];
                    //FanbuDangyuanMode
                }
            }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (arr.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasLoadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        if (self.dataArr3.count == 0) {
            [self showBlanVuiew];
        }else{
            [self hidenBlankView];
        }
        
        [self.table reloadData];
        

    } failure:^(NSError * _Nonnull error) {
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
    if (hasLoadAll) {
        [self.table.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    _pageIndex++;
    [self loadMore];
}

-(void)refershHeader{
    [self initData];
    [self loadData];
}

-(void)loadMore{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];

    if (_selectIndex == 1) {
        [self getDangyunSourceListMore];
    }else if (_selectIndex == 2){
        [self getTaskJianduSourceListMore];
    }else if (_selectIndex == 3){
        [self getTaskKaoshiSourceListMore];
    }
}

-(void)getDangyunSourceListMore{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKeyPath:@"userId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanListWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i<arr.count; i++) {
                    NSDictionary *tmpDic = arr[i];
                    FanbuDangyuanMode *model = [[FanbuDangyuanMode alloc] initWithDic:tmpDic];
                    [self.dataArr1 addObject:model];
                    //FanbuDangyuanMode
                }
            }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (arr.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasLoadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        [self.table reloadData];

    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}

-(void)getTaskJianduSourceListMore{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKeyPath:@"userId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanJianduListWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
            NSArray *arr = [responseObject objectForKey:@"data"];
            if (self.dataArr2.count) {
                [self.dataArr2 removeAllObjects];
            }
            if (arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i<arr.count; i++) {
                    NSDictionary *tmpDic = arr[i];
                    LearningTaskModel *model = [[LearningTaskModel alloc] initWithDic:tmpDic];
                    [self.dataArr2 addObject:model];
                    //FanbuDangyuanMode
                }
            }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (arr.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasLoadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        [self.table reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}

-(void)getTaskKaoshiSourceListMore{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKeyPath:@"userId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanKaoshiJianduListWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
            NSArray *arr = [responseObject objectForKey:@"data"];

            if (arr && [arr isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i<arr.count; i++) {
                    NSDictionary *tmpDic = arr[i];
                    HistoryExam *model = [[HistoryExam alloc] initWithDic:tmpDic];
                    [self.dataArr3 addObject:model];
                    //FanbuDangyuanMode
                }
            }
 
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (arr.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasLoadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        [self.table reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}


#pragma mark - UITableView Delegate And Datasource
//UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getNumInRowWithSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getRowHWithIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellWithIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == 1) {
        //rowNum = 10;
    }else if (_selectIndex == 2){
        if (self.dataArr2.count > indexPath.row) {
            LearningTaskModel *model = self.dataArr2[indexPath.row];
            
            FanbuDetailViewController *detailVC = [[FanbuDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.ID = model.taskId;
            detailVC.type = FanbuDetailTypeDefault;
            [self.navigationController pushViewController:detailVC animated:YES];
        }

    }else if (_selectIndex == 3){
        if (self.dataArr3 && self.dataArr3.count > indexPath.row) {
            HistoryExam *examModel = self.dataArr3[indexPath.row];
            
            FanbuDetailViewController *detailVC = [[FanbuDetailViewController alloc] init];
            detailVC.hidesBottomBarWhenPushed = YES;
            detailVC.type = FanbuDetailTypeExam;
            detailVC.ID = examModel.paperId;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    ///
}


-(NSInteger )getNumInRowWithSection:(NSInteger)section{
    NSInteger rowNum = 0;
    if (_selectIndex == 1) {
        //rowNum = 10;
        rowNum = self.dataArr1.count;
    }else if (_selectIndex == 2){
        rowNum = self.dataArr2.count;
    }else if (_selectIndex == 3){
        rowNum = self.dataArr3.count;
    }
    
    return rowNum;
}

-(CGFloat )getRowHWithIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowH = 0.01;
    if (_selectIndex == 1) {
        rowH = [FanbudangyuanCell CellH];
    }else if (_selectIndex == 2){
        rowH = [EducationHeartLearnCell CellH];
    }else if (_selectIndex == 3){
        rowH = [ExamWaitingTableViewCell CellH];
    }
    
    return rowH;
}

-(UITableViewCell *)getCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *viewCell = nil;
    if (_selectIndex == 1) {
        FanbudangyuanCell *dangyuanCell = [self.table dequeueReusableCellWithIdentifier:@"dangyuanCell"];
        if (indexPath.row < self.dataArr1.count) {
            FanbuDangyuanMode *model = self.dataArr1[indexPath.row];
            dangyuanCell.dangyunModel = model;
        }
        viewCell = dangyuanCell;
    }else if (_selectIndex == 2){
        EducationHeartLearnCell *heartCell = [self.table dequeueReusableCellWithIdentifier:@"heartCell"];
        if (self.dataArr2.count > indexPath.row) {
            LearningTaskModel *model = self.dataArr2[indexPath.row];
            heartCell.learnModel = model;
        }
        viewCell = heartCell;
    }else if (_selectIndex == 3){
        
        ExamWaitingTableViewCell *waitingExam = [self.table dequeueReusableCellWithIdentifier:@"waitingExam"];
        waitingExam.hideRemindLabel = YES;

        if (self.dataArr3 && self.dataArr3.count > indexPath.row) {
            HistoryExam *examModel = self.dataArr3[indexPath.row];
            waitingExam.examModel = examModel;
        }
        viewCell = waitingExam;
    }
    
    return viewCell;
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        

        [_table registerClass:[FanbudangyuanCell class] forCellReuseIdentifier:@"dangyuanCell"];
        [_table registerClass:[EducationHeartLearnCell class] forCellReuseIdentifier:@"heartCell"];
        [_table registerClass:[ExamWaitingTableViewCell class] forCellReuseIdentifier:@"waitingExam"];

    }
    return _table;
}

-(UIView *)pageItemView{
    if (!_pageItemView) {
        UIView *pageItemView = [[UIView alloc]init];
        pageItemView.backgroundColor = [UIColor redColor];
        [self.navigationController.navigationBar addSubview:pageItemView];
        _pageItemView = pageItemView;
        [_pageItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navigationController.navigationBar).offset(0);
            make.right.equalTo(self.navigationController.navigationBar.mas_right).offset(0);
            make.bottom.equalTo(self.navigationController.navigationBar).offset(0);
            make.height.mas_equalTo(44);
        }];
        
        
        CGFloat btnW = 80;
        CGFloat btnH = 30.0f;
        CGFloat btnMargin = (SCREEN_WIDTH-240)/3.0;
        
        
        UIButton *button = [[UIButton alloc]init];
        button.tag = 100;
        [button addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pageItemView addSubview:button];
        self.button = button;
        [button setTitle:[AppDelegate getURLWithKey:@"zhibudangyuan"] forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_pageItemView).offset(btnMargin);
            make.top.equalTo(_pageItemView).offset(10);
            make.height.mas_equalTo(btnH);
            make.width.mas_equalTo(btnW);
        }];
        
        
        
        UIButton *button1 = [[UIButton alloc]init];
        button1.tag = 101;
        self.button1 = button1;
        [button1 addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pageItemView addSubview:button1];
        [button1 setTitle:[AppDelegate getURLWithKey:@"renwujiandu"] forState:UIControlStateNormal];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_pageItemView);
            make.top.equalTo(_pageItemView).offset(10);
            make.height.mas_equalTo(btnH);
            make.width.mas_equalTo(btnW);
        }];
        
        
        
        UIButton *button2 = [[UIButton alloc]init];
        button2.tag = 102;
        self.button2 = button2;
        [button2 setTitle:[AppDelegate getURLWithKey:@"kaoshijiandu"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        [button2.titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pageItemView addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_pageItemView.mas_right).offset(-btnMargin);
            make.top.equalTo(_pageItemView).offset(10);
            make.height.mas_equalTo(btnH);
            make.width.mas_equalTo(btnW);
        }];
        
        
        UIView *bottonLine = [[UIView alloc]init];
        bottonLine.backgroundColor = [UIColor whiteColor];
        [_pageItemView addSubview:bottonLine];
        _bottonLine = bottonLine;
        [_bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button);
            make.bottom.equalTo(_pageItemView).offset(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(90);
        }];
    }
    return _pageItemView;
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
    NSInteger viewtag = sender.tag;
    if (viewtag == 100) {
        _selectIndex = 1;
        
        [_bottonLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.button);
            make.bottom.equalTo(_pageItemView).offset(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(90);
        }];
    }else if (viewtag == 101){
        _selectIndex = 2;
        
        [_bottonLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.button1);
            make.bottom.equalTo(_pageItemView).offset(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(90);
        }];
    }else if (viewtag == 102){
        _selectIndex = 3;
        
        [_bottonLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.button2);
            make.bottom.equalTo(_pageItemView).offset(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(90);
        }];
    }
    
    [self refershHeader];
    
    //[self.table reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_pageItemView) {
        _pageItemView.hidden = NO;
    }
    
    self.title = [AppDelegate getURLWithKey:@"zhibu"];

    
    if ([APP_DELEGATE.userModel.pmAuthor integerValue] == 1) {
        self.pageItemView.hidden = YES;
        self.table.hidden = YES;
        self.webView.hidden = NO;

        if ([NSString isBlankString:_htmlUrl]) {
            [self getH5Source];
        }else{
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_htmlUrl]]];
        }
        
    }else{
        self.pageItemView.hidden = NO;
        self.table.hidden = NO;
        self.webView.hidden = YES;
        
    }


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _pageItemView.hidden = YES;
    
}

-(void)changeLuanguageAction:(NSNotification *)noti{
    
    
    self.title = [AppDelegate getURLWithKey:@"zhibu"];


    [self.button setTitle:[AppDelegate getURLWithKey:@"zhibudangyuan"] forState:UIControlStateNormal];
    [self.button1 setTitle:[AppDelegate getURLWithKey:@"renwujiandu"] forState:UIControlStateNormal];
    [self.button2 setTitle:[AppDelegate getURLWithKey:@"kaoshijiandu"] forState:UIControlStateNormal];
    
    
    [self refershHeader];
}

-(EWTWebView *)webView{
    if (!_webView) {
        EWTWebView *webView = [[EWTWebView alloc]initWithFrame:self.view.bounds];
        webView.delegate = self;
        webView.wkWebView.scrollView.delegate = self;
        _webView = webView;
        [self.view addSubview:webView];
    }
    return _webView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}



-(void)getH5Source{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"SYS_TJ" forKey:@"queryType"];
    [HanZhaoHua MYGetFanbuGetH5SouceWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString *htmlSouce = [data objectForKey:@"htmlUrl"];
            if (![NSString isBlankString:htmlSouce]) {
                _htmlUrl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,htmlSouce];
                
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_htmlUrl]]];
                
            }
        }
        NSLog(@"");
    } failure:^(NSError * _Nonnull error) {
        
    }];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
