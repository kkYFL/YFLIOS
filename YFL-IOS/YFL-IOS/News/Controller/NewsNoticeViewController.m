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
>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *newsList;


@end

@implementation NewsNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"通知公告";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    
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
        
        [self.table reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        //self.serverCount ++;
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
