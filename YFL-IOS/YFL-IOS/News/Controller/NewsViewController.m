//
//  NewsViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/19.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsViewController.h"
#import "SDCycleScrollView.h"
#import "BannerScrollView.h"
#import "NewsItemsTableCell.h"
#import "NewsRightIConTableCell.h"
#import "NewsdeliveryViewController.h"
#import "NewsContentMaxImageViewCell.h"
#import "NewsBannerDetailViewController.h"
#import "NewsVideoDetailViewController.h"
#import "NewsPolicyViewController.h"
#import "NewsContentViewCell.h"
#import "NewsActivityViewController.h"
#import "NewsNoticeViewController.h"
#import "WZWebViewController.h"
#import "NewsDetailNoVideoController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

#define SDViewH 150

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>{
    NSInteger _pageIndex;
    BOOL hasLoadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) BannerScrollView *remindScrollHeader;

@property (nonatomic, strong) NSMutableArray *bannerList;
@property (nonatomic, strong) NSMutableArray *menuList;
@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, strong) Banner *remindModel;
@property (nonatomic, assign) NSInteger serverCount;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    [self refershHeader];
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
    [self loadMoreData];
}

-(void)refershHeader{
    [self initData];
    [self loadData];
}



    
-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"党员资讯";
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.scrollView;
    
    [self initRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSelectAction:) name:KNotificationNewsItemsSelect object:nil];
    [self addObserver:self forKeyPath:@"serverCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)initData{
    self.bannerList = [NSMutableArray array];
    self.menuList = [NSMutableArray array];
    self.newsList = [NSMutableArray array];
    self.serverCount = 0;
    _pageIndex = 1;
    hasLoadAll = NO;
}


-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    // banner接口   positionType:@"MPOS_1"
    // 热区菜单接口  positionType:@"MPOS_4"
    // 测试结果: 通过
        [HanZhaoHua getInformationBannerWithUserToken:APP_DELEGATE.userToken positionType:@"MPOS_1" success:^(NSArray * _Nonnull bannerList) {
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
    
    
    // 小喇叭接口   positionType:@"SPOS_2"
    // 教育视频接口  positionType:@"SPOS_3"
    // 测试结果: 通过
        [HanZhaoHua getInformationMessageWithUserToken:APP_DELEGATE.userToken positionType:@"SPOS_2" success:^(Banner * _Nonnull message) {
            NSLog(@"%@", message.imgUrl);
            NSLog(@"%@", message.positionNo);
            NSLog(@"%@", message.summary);
            NSLog(@"%@", message.foreignUrl);
            NSLog(@"%@", message.foreignType);
            
            self.remindModel = message;
            self.serverCount ++;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            self.serverCount ++;
        }];
    
    // 资讯菜单接口
    // 测试结果: 通过
        [HanZhaoHua getInformationMenuWithUserToken:APP_DELEGATE.userToken success:^(NSArray * _Nonnull menuList) {
            for (InformationMenu *menu in menuList) {
                NSLog(@"%@", menu.menuId);
                NSLog(@"%@", menu.imgUrl);
                NSLog(@"%@", menu.appPositon);
                NSLog(@"%@", menu.typeInfo);
                NSLog(@"%@", menu.typeName);
            }
            
            self.menuList = [NSMutableArray arrayWithArray:menuList];
            self.serverCount ++;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            self.serverCount ++;
        }];
    
    
    
    // 新闻列表接口
    // 测试结果: 通过
    [HanZhaoHua getNewsListWithUserToken:APP_DELEGATE.userToken typesId:@"0" Title:@"" page:1 pageNum:10 success:^(NSArray * _Nonnull newsList) {
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
        
        if (newsList.count < 10) {
            hasLoadAll = YES;
        }
        
        self.serverCount ++;
    } failure:^(NSError * _Nonnull error) {
        self.serverCount ++;
    }];
    
    
}

-(void)loadMoreData{
    
    /*
     [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
     [[PromptBox sharedBox] removeLoadingView];
     [self.table.mj_footer endRefreshing];
     [self.table.mj_header endRefreshing];
     */
    
    // 新闻列表接口
    // 测试结果: 通过
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    [HanZhaoHua getNewsListWithUserToken:APP_DELEGATE.userToken typesId:@"0" Title:@"" page:_pageIndex pageNum:10 success:^(NSArray * _Nonnull newsList) {
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
        
        
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
        
        if (newsList.count) {
            [self.newsList addObjectsFromArray:newsList];
            [self.table reloadData];
        }
        
        if (newsList.count < 10) {
            hasLoadAll = YES;
        }
        

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
        return 2;
    }
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        if (section == 0) return 1;
        return self.newsList.count;
    }
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section ==0) {
            return [NewsItemsTableCell CellH];
        }
        
        NewsMessage *newsModel = nil;
        if (self.newsList.count>indexPath.row) {
            newsModel = self.newsList[indexPath.row];
        }
        
        //文字加图片
        if ([newsModel.infoType integerValue] == 1) {
            return [NewsRightIConTableCell CellH];
        }
        
        //文本
        if ([newsModel.infoType integerValue] == 2) {
            return [NewsContentViewCell CellHWithModel:newsModel];
        }
        
        return [NewsContentMaxImageViewCell CellHWithContent:newsModel.title];
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        NewsItemsTableCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
        if (self.menuList.count) {
            InformationMenu *menuModel = self.menuList[0];
            itemCell.item1.titleLab.text = menuModel.typeName;
            itemCell.item1.contentLab.text = menuModel.typeInfo;
            if ([menuModel.imgUrl hasPrefix:@"http"]) {
                [itemCell.item1.iconImageView sd_setImageWithURL:[NSURL URLWithString:menuModel.imgUrl] placeholderImage:nil];
            }else{
                [itemCell.item1.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,menuModel.imgUrl]] placeholderImage:nil];
            }

        }
        if (self.menuList.count >= 2) {
            InformationMenu *menuModel = self.menuList[1];
            itemCell.item2.titleLab.text = menuModel.typeName;
            itemCell.item2.contentLab.text = menuModel.typeInfo;
            if ([menuModel.imgUrl hasPrefix:@"http"]) {
                [itemCell.item2.iconImageView sd_setImageWithURL:[NSURL URLWithString:menuModel.imgUrl] placeholderImage:nil];
            }else{
                [itemCell.item2.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,menuModel.imgUrl]] placeholderImage:nil];
            }
        }
        
        if (self.menuList.count >= 3) {
            InformationMenu *menuModel = self.menuList[2];
            itemCell.item3.titleLab.text = menuModel.typeName;
            itemCell.item3.contentLab.text = menuModel.typeInfo;
            [itemCell.item3.iconImageView sd_setImageWithURL:[NSURL URLWithString:menuModel.imgUrl] placeholderImage:nil];
            if ([menuModel.imgUrl hasPrefix:@"http"]) {
                [itemCell.item3.iconImageView sd_setImageWithURL:[NSURL URLWithString:menuModel.imgUrl] placeholderImage:nil];
            }else{
                [itemCell.item3.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,menuModel.imgUrl]] placeholderImage:nil];
            }
        }
        if (self.menuList.count >= 4) {
            InformationMenu *menuModel = self.menuList[3];
            itemCell.item4.titleLab.text = menuModel.typeName;
            itemCell.item4.contentLab.text = menuModel.typeInfo;
            if ([menuModel.imgUrl hasPrefix:@"http"]) {
                [itemCell.item4.iconImageView sd_setImageWithURL:[NSURL URLWithString:menuModel.imgUrl] placeholderImage:nil];
            }else{
                [itemCell.item4.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,menuModel.imgUrl]] placeholderImage:nil];
            }
        }
            
        return itemCell;
    }
        
        
        NewsMessage *newsModel = nil;
        if (self.newsList.count>indexPath.row) {
            newsModel = self.newsList[indexPath.row];
        }
        
        //文字加图片
        if ([newsModel.infoType integerValue] == 1) {
            NewsRightIConTableCell *rightIconCell = [tableView dequeueReusableCellWithIdentifier:@"rightIconCell"];
            rightIconCell.cellTitleLabel.text = newsModel.title;
            NSString *imageurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,newsModel.imgUrl];
            [rightIconCell.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
            return rightIconCell;
        }
        
        
        //文本
        if ([newsModel.infoType integerValue] == 2) {
            NewsContentViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
            contentCell.newsModel = newsModel;
            return contentCell;
        }
        

        //视频
        __weak typeof(self) weakSelf = self;
        NewsContentMaxImageViewCell *MaxImageCell = [tableView dequeueReusableCellWithIdentifier:@"MaxImageCell"];
        MaxImageCell.content = newsModel.title;
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,newsModel.imgUrl];
    
        [MaxImageCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
        return MaxImageCell;
        
    }
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.remindScrollHeader;
    }
    return [self headerViewWithIcon:nil Title:@"最新资讯"];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40.0f;
    }
    return 34.0f;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
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
        
    }

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
    
//    WZWebViewController *wzweb  = [[WZWebViewController alloc] init];
//    wzweb.titleVC               =  @"详情";
//    wzweb.webUrl = [NSString stringWithFormat:@"%@", @"http://www.baidu.com"];
//    wzweb.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:wzweb animated:YES];
    
    
    
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
    
-(void)setContentData:(id)data{
    NSMutableArray* images = [NSMutableArray array];
    for (NSInteger i = 0; i<self.bannerList.count; i++) {
        Banner *bannerModel = self.bannerList[i];
        NSString *str = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,bannerModel.imgUrl];
        //NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [images addObject:str];
    }
       _scrollView.imageURLStringsGroup = images;
}
    
#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[NewsItemsTableCell class] forCellReuseIdentifier:@"itemCell"];
        [_table registerClass:[NewsRightIConTableCell class] forCellReuseIdentifier:@"rightIconCell"];
        [_table registerClass:[NewsContentMaxImageViewCell class] forCellReuseIdentifier:@"MaxImageCell"];
        [_table registerClass:[NewsContentViewCell class] forCellReuseIdentifier:@"contentCell"];
        
    }
    return _table;
}

-(BannerScrollView *)remindScrollHeader{
    if (!_remindScrollHeader) {
        _remindScrollHeader = [[BannerScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_remindScrollHeader setContentData:nil];
    }
    return _remindScrollHeader;
}

-(SDCycleScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SDViewH) delegate:self placeholderImage:nil];
    }
    return _scrollView;
}

#pragma mark - Actions
-(UIView *)headerViewWithIcon:(NSString *)icon Title:(NSString *)title{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34.0f)];
    
    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.font = [UIFont boldSystemFontOfSize:14.0f];
    headerTitle.text = title;
    headerTitle.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    headerTitle.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:headerTitle];
    
    
    [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView.mas_centerY).offset(0);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(0);
        make.bottom.equalTo(headerView);
        make.right.equalTo(headerView);
        make.height.mas_equalTo(0.5);
    }];
    
    return headerView;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context{
    NSInteger new = [[change objectForKey:@"new"] integerValue];
    
    //数据渲染
    if (new == 4) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (hasLoadAll) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        
        [self setContentData:nil];
        [self.table reloadData];
        self.remindScrollHeader.contentStr = self.remindModel.positionName.length?self.remindModel.positionName:@"河南县党建项目已成功上线，请大家踊跃学习";
    }
    
}

#pragma mark - 通知
-(void)itemsSelectAction:(NSNotification *)noti{
    NSDictionary *notiDic = noti.userInfo;
    NSInteger index = [[notiDic objectForKey:@"index"] integerValue];
    if (index == 1) {
        if (!self.menuList.count) {
            return;
        }
        NewsdeliveryViewController *deliveryVC = [[NewsdeliveryViewController alloc]init];
        InformationMenu *menmodel = self.menuList[0];
        deliveryVC.menuModel = menmodel;
        deliveryVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:deliveryVC animated:YES];
    }else if (index == 2){
        if (self.menuList.count >1) {
            NewsPolicyViewController *policyVC = [[NewsPolicyViewController alloc]init];
            policyVC.hidesBottomBarWhenPushed = YES;
            InformationMenu *menmodel = self.menuList[1];
            policyVC.menuModel = menmodel;
            [self.navigationController pushViewController:policyVC animated:YES];
        }
    }else if (index == 4){
        if (self.menuList.count > 3) {
            InformationMenu *menmodel = self.menuList[3];
            NewsActivityViewController *acitivityVC = [[NewsActivityViewController alloc]init];
            acitivityVC.menuModel = menmodel;
            [self.navigationController pushViewController:acitivityVC animated:YES];
        }

    }else if (index == 3){
        if (self.menuList.count > 2) {
            InformationMenu *menmodel = self.menuList[2];
            NewsNoticeViewController *noticeVC = [[NewsNoticeViewController alloc]init];
            noticeVC.menuModel = menmodel;
            [self.navigationController pushViewController:noticeVC animated:YES];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"serverCount"];
}


@end
