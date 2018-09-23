//
//  PersonPassWordController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonPassWordController.h"
#import "PersonPasswordInCell.h"

@interface PersonPassWordController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation PersonPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 42, 15, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction);
                                
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    if (section == 0) {
        rowCount = 1;
    }else{
        rowCount = 2;
    }
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PersonPasswordInCell CellH];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headerViewWithIcon:nil Title:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonPasswordInCell *passwordCell = [tableView dequeueReusableCellWithIdentifier:@"passwordCell"];
    NSString *placholder = @"";
    if (indexPath.section == 0) {
        placholder = @"请输入当前密码";
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            placholder = @"请输入新密码";
        }else if (indexPath.row == 1){
            placholder = @"请确认新密码";
        }
    }
    passwordCell.textfield.placeholder = placholder;
   return passwordCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)headerViewWithIcon:(NSString *)icon Title:(NSString *)title{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
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
        _table.tableFooterView = self.footerView;
        
        [_table registerClass:[PersonPasswordInCell class] forCellReuseIdentifier:@"passwordCell"];
    }
    return _table;
}

-(UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [footerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90.0f)];
        _footerView = footerView;
        
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
        [button addTarget:self action:@selector(submitPassword:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [button setTitle:@"修改密码" forState:UIControlStateNormal];
        button.layer.cornerRadius = 4.0f;
        [_footerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView).offset(15.0f);
            make.top.equalTo(_footerView).offset(50.0f);
            make.right.equalTo(_footerView.mas_right).offset(-15.0f);
            make.height.mas_equalTo(40.0f);
        }];

    }
    return _footerView;
}

#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitPassword:(UIButton *)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
