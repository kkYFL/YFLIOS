//
//  ExamConentViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/12.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamConentViewController.h"
#import "ExamTopTitleTableViewCell.h"
#import "ExamChooseCell.h"
#import "ExamTextViewPutINCell.h"
#import "ExamTextInViewCell.h"

typedef NS_ENUM(NSInteger,ExamContentViewType) {
    ExamContentViewTypeDefault,
    ExamContentViewTypeTextIn
};

@interface ExamConentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) ExamContentViewType viewType;

@end

@implementation ExamConentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"考试答题";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    

}


#pragma mark - UITableView Delegate And Datasource
//UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_viewType == ExamContentViewTypeDefault) {
            return [ExamTopTitleTableViewCell CellH];
        }
        
        return [ExamTextInViewCell CellH];
        
    }else if (indexPath.row == 1){
        if (_viewType == ExamContentViewTypeDefault) {
            return [ExamChooseCell CellH];
        }
        
        return [ExamTextViewPutINCell CellH];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_viewType == ExamContentViewTypeDefault) {
            ExamTopTitleTableViewCell *topTitleCell = [tableView dequeueReusableCellWithIdentifier:@"topTitleCell"];
            return topTitleCell;
        }
        
        ExamTextInViewCell *textInCell = [tableView dequeueReusableCellWithIdentifier:@"textInCell"];
        return textInCell;
        
    }else if (indexPath.row == 1){
        if (_viewType == ExamContentViewTypeDefault) {
            ExamChooseCell *chooseCell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
            return chooseCell;
        }
        
        ExamTextViewPutINCell *putInCell = [tableView dequeueReusableCellWithIdentifier:@"putInCell"];
        return putInCell;
    }
    
    static NSString *identify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    return cell;
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
        _table.tableFooterView = self.footerView;
        
        [_table registerClass:[ExamTopTitleTableViewCell class] forCellReuseIdentifier:@"topTitleCell"];
        [_table registerClass:[ExamChooseCell class] forCellReuseIdentifier:@"chooseCell"];

        //
        [_table registerClass:[ExamTextInViewCell class] forCellReuseIdentifier:@"textInCell"];
        [_table registerClass:[ExamTextViewPutINCell class] forCellReuseIdentifier:@"putInCell"];
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

-(UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]init];
        [footerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [footerView setBackgroundColor:[UIColor whiteColor]];
        _footerView = footerView;
        
        UIButton *button1 = [[UIButton alloc]init];
        [button1 setBackgroundColor:[UIColor colorWithHexString:@"#BBBBBB"]];
        [button1 addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 101;
        button1.layer.masksToBounds = YES;
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button1 setTitle:@"上一题" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button1.layer.cornerRadius = 10.0f;
        [_footerView addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(0);
            make.right.equalTo(_footerView.mas_centerX).offset(-30);
            make.bottom.equalTo(_footerView.mas_bottom).offset(0);
            make.width.mas_equalTo(WIDTH_SCALE*120);
        }];
        
        
        
        UIButton *button2 = [[UIButton alloc]init];
        [button2 setBackgroundColor:[UIColor colorWithHexString:@"#E51C23"]];
        [button2 addTarget:self action:@selector(selectSource:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 102;
        button2.layer.masksToBounds = YES;
        [button2.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button2 setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        button2.layer.cornerRadius = 10.0f;
        [button2 setTitle:@"下一题" forState:UIControlStateNormal];
        [_footerView addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(0);
            make.left.equalTo(_footerView.mas_centerX).offset(30);
            make.bottom.equalTo(_footerView.mas_bottom).offset(0);
            make.width.mas_equalTo(WIDTH_SCALE*120);
        }];
        
    }
    return _footerView;
}

-(void)selectSource:(UIButton *)sender{
    NSInteger viewTag = sender.tag;
    if (viewTag == 101) {
        _viewType = ExamContentViewTypeDefault;
    }else if (viewTag == 102){
        _viewType = ExamContentViewTypeTextIn;
    }
    
    [self.table reloadData];
}


#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
