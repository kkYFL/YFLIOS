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

@interface NewsPolicyViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

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
    
    [self initData];
    
    [self loadData];
}

-(void)initView{
    self.title = @"政策法规";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.scrollView;
    [self addObserver:self forKeyPath:@"serverCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];


}

-(void)initData{
    self.bannerList = [NSMutableArray array];
    self.newsList = [NSMutableArray array];
    self.serverCount = 0;
}

-(void)loadData{
    //[self setContentData:nil];

    
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
    [HanZhaoHua getNewsListWithUserToken:APP_DELEGATE.userToken typesId:self.menuModel.menuId page:1 pageNum:10 success:^(NSArray * _Nonnull newsList) {
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
        detailVc.infoId = newsModel.ID;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
        //文本
    }else if ([newsModel.infoType integerValue] == 2){
        NewsDetailNoVideoController *detailVc = [[NewsDetailNoVideoController alloc] init];
        detailVc.infoId = newsModel.ID;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
        //视频
    }else if ([newsModel.infoType integerValue] == 3){
        NewsVideoDetailViewController *videoVC = [[NewsVideoDetailViewController alloc]init];
        videoVC.hidesBottomBarWhenPushed = YES;
        videoVC.infoId = newsModel.ID;
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
    
    //    if ([data isKindOfClass:[EWTBannerModule class]]) {
    //
//    NSMutableArray* images = [NSMutableArray array];
//    for (NSInteger i = 0; i<5; i++) {
//        [images addObject:[NSString stringWithFormat:@"Pfofession_card-bg-%d",i+1]];
//    }
    //
    //        _model = [(EWTBannerModule*)data copy];
    //
    //        for (EWTBannerItem* item in _model.bannerArray) {
    //
    //            [images addObject:item.imageUrl];
    //        }
    //_scrollView.imageURLStringsGroup = images;
    //    }
    
    NSMutableArray* images = [NSMutableArray array];
    for (NSInteger i = 0; i<self.bannerList.count; i++) {
        Banner *bannerModel = self.bannerList[i];
        NSString *str = [NSString stringWithFormat:@"http://47.100.247.71/protal%@",bannerModel.imgUrl];
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
    
    //    NewsBannerDetailViewController *bannerNewsVC = [[NewsBannerDetailViewController alloc]init];
    //    bannerNewsVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:bannerNewsVC animated:YES];
    
    if (self.bannerList.count > index) {
        WZWebViewController *wzweb  = [[WZWebViewController alloc] init];
        Banner *bannerModel = self.bannerList[index];
        wzweb.titleVC               =  @"详情";
        wzweb.webUrl = [NSString stringWithFormat:@"%@%@", APP_DELEGATE.host,bannerModel.foreignUrl];
        wzweb.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wzweb animated:YES];
    }

    
    
    
    //    EWTBannerItem* item = _model.bannerArray[index];
    //
    //    NSDictionary* dict = nil;
    //
    //    if (item.oldItem) {
    //
    //        dict = @{@"PicUrl":item.oldItem.imageUrl,@"RedirectType":item.oldItem.redirectType,@"LinkUrl":item.oldItem.linkUrl,@"Title":item.oldItem.title,@"index":@(index)};
    //    }
    //
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleCell:routerInfo:userInfo:)]) {
    //
    //        [self.delegate moduleCell:self routerInfo:item.router userInfo:dict];
    //    }
    
    
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
