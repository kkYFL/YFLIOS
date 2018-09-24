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

@interface EducationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@end

@implementation EducationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"党员教育";
    self.view.backgroundColor = [UIColor whiteColor];    
    
    [self.view addSubview:self.table];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsSelectAction:) name:KNotificationEducationItemsSelect object:nil];;
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
        return [EducationHeadTableCell CellH];
    }
    return [EducationItemsTableCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        EducationHeadTableCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        return topCell;
    }
    
    EducationItemsTableCell *ItemsCell = [tableView dequeueReusableCellWithIdentifier:@"ItemsCell"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
