//
//  FanbuDetailViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/24.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "FanbuDetailViewController.h"
#import "FanbudangyuanCell.h"
#import "AppDelegate.h"
#import "HanZhaoHua.h"
#import "FanbuDangyuanMode.h"


@interface FanbuDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _pageIndex;
    BOOL hasLoadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *dataArr1;
@end

@implementation FanbuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initData{
    _pageIndex = 1;
    self.dataArr1 = [NSMutableArray array];
    hasLoadAll = NO;
}

-(void)initView{
    self.title = (_type == 0)?@"任务详情":@"考试详情";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    [self.view addSubview:self.table];

    [self initRefresh];
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
    
    if (self.type == FanbuDetailTypeDefault) {
        [self getDangyunRenwuSourceList];
    }else{
        [self getDangyunKaoshiSourceList];
    }
    
}


-(void)getDangyunRenwuSourceList{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:self.ID forKeyPath:@"taskId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanRenwuDetailSourceWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {

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
        if (arr.count<10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
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


-(void)getDangyunKaoshiSourceList{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:self.ID forKeyPath:@"paperId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanKaoshiDetailSourceWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
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
            if (arr.count<10) {
                [self.table.mj_footer endRefreshingWithNoMoreData];
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
    [self LoadMore];
}

-(void)refershHeader{
    [self initData];
    [self loadData];
}

-(void)LoadMore{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    
    if (self.type == FanbuDetailTypeDefault) {
        [self getDangyunRenwuSourceListMore];
    }else{
        [self getDangyunKaoshiSourceListMore];
    }
}


-(void)getDangyunRenwuSourceListMore{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:self.ID forKeyPath:@"taskId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanRenwuDetailSourceWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
        
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
        if (arr.count<10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
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


-(void)getDangyunKaoshiSourceListMore{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:self.ID forKeyPath:@"paperId"];
    [para setValue:[NSNumber numberWithInteger:_pageIndex] forKey:@"page"];
    [para setValue:[NSNumber numberWithInteger:10] forKey:@"limit"];
    [HanZhaoHua MYGetDangYuanKaoshiDetailSourceWithPara:para Success:^(NSDictionary * _Nonnull responseObject) {
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
        if (arr.count<10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FanbudangyuanCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FanbudangyuanCell *dangyuanCell = [self.table dequeueReusableCellWithIdentifier:@"dangyuanCell"];

    
    if (self.dataArr1.count > indexPath.row) {
        FanbuDangyuanMode *model = self.dataArr1[indexPath.row];
        [dangyuanCell.cellIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,model.headImg]] placeholderImage:[UIImage imageNamed:@"exam_header"]];
        if (self.type == FanbuDetailTypeDefault) {
            NSInteger state = [model.nowState integerValue];
            NSString *titleStr = @"";
            if (state == 1) {
                titleStr = @"未学习";
                dangyuanCell.cellContent.textColor = [UIColor redColor];
            }else if (state == 2){
                titleStr = @"学习中";
                dangyuanCell.cellContent.textColor = [UIColor blueColor];
            }else if (state == 3){
                titleStr = @"已完成";
                dangyuanCell.cellContent.textColor = [UIColor greenColor];
            }
            dangyuanCell.cellContent.text = titleStr;
        }else{
            NSInteger state = [model.paperState integerValue];
            NSString *titleStr = @"";
            if (state == 1) {
                titleStr = @"已考试";
                dangyuanCell.cellContent.textColor = [UIColor orangeColor];
            }else if (state == 2){
                titleStr = @"待考试";
                dangyuanCell.cellContent.textColor = [UIColor redColor];
            }else if (state == 3){
                titleStr = @"已完成";
                dangyuanCell.cellContent.textColor = [UIColor greenColor];
            }
            dangyuanCell.cellContent.text = titleStr;
        }
    }

    return dangyuanCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-EWTTabbar_SafeBottomMargin)];
        _table = table;
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        //[_table registerClass:[CareerProfessionjingduCell class] forCellReuseIdentifier:@"CareerjindguCell"];
        [_table registerClass:[FanbudangyuanCell class] forCellReuseIdentifier:@"dangyuanCell"];

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
