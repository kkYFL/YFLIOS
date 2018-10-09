//
//  EducationViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/19.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationViewController.h"
#import "EducationHeadTableCell.h"
#import "EducationItemsTableCell.h"
#import "EducationOptionsController.h"
#import "EducationLearHeartViewController.h"
#import "EducationLearnController.h"
#import "EducationTaskDetailController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"

@interface EducationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *bannerList;
@property (nonatomic, assign) NSInteger serverCount;
@property (nonatomic, strong) Banner *videoModel;

@end

@implementation EducationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initData{
    self.serverCount = 0;
}

-(void)initView{
    self.title = @"党员教育";
    self.view.backgroundColor = [UIColor whiteColor];    
    [self.view addSubview:self.table];
    
    [self initRefresh];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSelectAction:) name:KNotificationEducationItemsSelect object:nil];
}


#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [EducationHeadTableCell CellHWithModel:self.videoModel];
    }
    return [EducationItemsTableCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EducationHeadTableCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        topCell.videoModel = self.videoModel;
        return topCell;
    }
    
    EducationItemsTableCell *ItemsCell = [tableView dequeueReusableCellWithIdentifier:@"ItemsCell"];
    ItemsCell.dataArr = self.bannerList;
    return ItemsCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[EducationHeadTableCell class] forCellReuseIdentifier:@"topCell"];
        [_table registerClass:[EducationItemsTableCell class] forCellReuseIdentifier:@"ItemsCell"];
        //EducationItemsTableCell
    }
    return _table;
}


#pragma mark 上下拉刷新
- (void)initRefresh{
    MJRefershHeader *header = [MJRefershHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershHeader)];
    self.table.mj_header = header;

}


-(void)refershHeader{
    [self initData];
    [self loadData];
}




-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];

    
    //教育视频接口
    // banner接口   positionType:@"MPOS_1"
    // 热区菜单接口  positionType:@"MPOS_4"
    // 测试结果: 通过
    [HanZhaoHua getInformationBannerWithUserToken:APP_DELEGATE.userToken positionType:@"SPOS_3" success:^(NSArray * _Nonnull bannerList) {
        if (bannerList && bannerList.count) {
            self.videoModel = self.bannerList[0];
        }
        self.serverCount ++;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        self.serverCount ++;
    }];
    
    
    // banner接口   positionType:@"MPOS_1"
    // 热区菜单接口  positionType:@"MPOS_4"
    // 测试结果: 通过
    [HanZhaoHua getInformationBannerWithUserToken:APP_DELEGATE.userToken positionType:@"MPOS_4" success:^(NSArray * _Nonnull bannerList) {
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
    
    
    
}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self initData];
    [self loadData];}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

#pragma mark - 通知
-(void)itemsSelectAction:(NSNotification *)noti{
    NSDictionary *userInfo = noti.userInfo;
    NSInteger index = [[userInfo objectForKey:@"index"] integerValue];
    if (index == 1) {

        EducationLearHeartViewController *heartVC = [[EducationLearHeartViewController alloc]init];
        heartVC.type = MYEducationViewTypeDefault;
        heartVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:heartVC animated:YES];
    }else if (index == 2){
        EducationLearHeartViewController *heartVC = [[EducationLearHeartViewController alloc]init];
        heartVC.hidesBottomBarWhenPushed = YES;
        heartVC.type = MYEducationViewTypeHistory;
        [self.navigationController pushViewController:heartVC animated:YES];
    }else if (index == 3){
        EducationOptionsController *optionsVC = [[EducationOptionsController alloc]init];
        optionsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:optionsVC animated:YES];
        
    }else if (index == 4){
        EducationLearnController *learnVC = [[EducationLearnController alloc]init];
        learnVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:learnVC animated:YES];
    }
}


-(void)setServerCount:(NSInteger)serverCount{
    _serverCount = serverCount;
    if (_serverCount == 2) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        
        [self.table reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
