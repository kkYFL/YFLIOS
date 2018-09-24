//
//  PersonXinxiViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonXinxiViewController.h"
#import "XinxiTableViewCell.h"

@interface PersonXinxiViewController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic, strong) UITableView *table;

@end

@implementation PersonXinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 42, 15, @"view_back", @"view_back", leftButtonAction);
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
}


#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 1;
    if (section == 1) {
        rowNum = 3;
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XinxiTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XinxiTableViewCell *xinxiCell = [tableView dequeueReusableCellWithIdentifier:@"xinxiCell"];
    if (indexPath.section == 0) {
        xinxiCell.type = XinxiCellTypeWithIconAndRow;
        xinxiCell.cellTitleLabel.text = @"安全头像";
    }else if (indexPath.section == 1){
        NSString *titleStr = @"";
        NSString *contentStr = @"";
        if (indexPath.row ==0) {
            titleStr = @"用户名";
            contentStr = @"tuzi123";
        }else if (indexPath.row ==1){
            titleStr = @"手机号码";
            contentStr = @"182****1963";
        }else if (indexPath.row ==2){
            titleStr = @"实名认证";
            contentStr = @"*架兔(**************5546)";
        }
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = titleStr;
        xinxiCell.cellContentLabel.text = contentStr;
    }else if (indexPath.section == 2){
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = @"我的座右铭";
        xinxiCell.cellContentLabel.text = @"谁说蓝色代表悲伤，你看看天空和海洋";
    }else if (indexPath.section == 3){
        xinxiCell.type = XinxiCellTypeWithJustRow;
        xinxiCell.cellTitleLabel.text = @"我的地址";
    }
    
    return xinxiCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    
    return [self headerViewWithIcon:nil Title:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat sectionH = 0.01f;
    if (section == 0) {
        sectionH = 0.01;
    }else{
        sectionH = 15.0f;
    }
    return sectionH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)headerViewWithIcon:(NSString *)icon Title:(NSString *)title{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    return headerView;
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
        
        [_table registerClass:[XinxiTableViewCell class] forCellReuseIdentifier:@"xinxiCell"];
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
