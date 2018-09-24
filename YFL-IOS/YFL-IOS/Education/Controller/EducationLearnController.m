//
//  EducationLearnController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationLearnController.h"
#import "EducationLearnCell.h"
#import "EducationLearnDetailController.h"

#define pageMenueH 44.0

@interface EducationLearnController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic, strong) UITableView *table;


@property (nonatomic, strong) UIView *itemsView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIView *tracker;



@end

@implementation EducationLearnController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"学习心得";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction);
                                
    [self.view addSubview:self.itemsView];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EducationLearnCell CellHWithContent:@"适应新时代，新任务，新要求，扎扎实实干好本职工作，解决实际问题。"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationLearnCell *learnCell = [tableView dequeueReusableCellWithIdentifier:@"learnCell"];
    return learnCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationLearnDetailController *detailVC = [[EducationLearnDetailController alloc]init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, pageMenueH, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-pageMenueH)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[EducationLearnCell class] forCellReuseIdentifier:@"learnCell"];
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



//自定义Items切换固定items
-(UIView *)itemsView{
    if (!_itemsView) {
        _itemsView = [[UIView alloc]init];
        [_itemsView setBackgroundColor:[UIColor whiteColor]];
        CGFloat w = SCREEN_WIDTH/2.0;
        [self.view addSubview:_itemsView];
        [_itemsView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, pageMenueH)];
        
        
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button setTitleColor:[UIColor colorWithHexString:@"#0C0C0C"] forState:UIControlStateNormal];
        [button setTitle:@"全部心得" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#E51C23"] forState:UIControlStateSelected];
        [_itemsView addSubview:button];
        button.tag = 101;
        button.selected = YES;
        [button setFrame:CGRectMake(0, 0, w, pageMenueH)];
        self.button = button;
        
        
        UIButton *button1 = [[UIButton alloc]init];
        [button1 addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#0C0C0C"] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#E51C23"] forState:UIControlStateSelected];
        [button1 setTitle:@"我的心得" forState:UIControlStateNormal];
        [_itemsView addSubview:button1];
        button1.tag = 102;
        [button1 setFrame:CGRectMake(w, 0, w, pageMenueH)];
        self.button1 = button1;
        
        
        UIView *tracker = [[UIView alloc]init];
        tracker.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
        [_itemsView addSubview:tracker];
        self.tracker = tracker;
        [tracker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_itemsView.mas_bottom).offset(0);
            make.width.mas_equalTo(0.6*w);
            make.height.mas_equalTo(2);
            make.centerX.equalTo(button);
        }];

        
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
        [_itemsView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_itemsView).offset(0);
            make.bottom.equalTo(_itemsView);
            make.right.equalTo(_itemsView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _itemsView;
}

-(void)itemSelect:(UIButton *)sender{
    NSInteger viewTag = sender.tag - 100;
    CGFloat w = SCREEN_WIDTH/2.0;

    if (viewTag == 1) {
        self.button.selected = YES;
        self.button1.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [self.tracker mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_itemsView.mas_bottom).offset(0);
                make.width.mas_equalTo(0.6*w);
                make.height.mas_equalTo(2);
                make.centerX.equalTo(self.button);
            }];
        }];
    }else if (viewTag == 2){
        
        self.button.selected = NO;
        self.button1.selected = YES;
        [self.tracker mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_itemsView.mas_bottom).offset(0);
            make.width.mas_equalTo(0.6*w);
            make.height.mas_equalTo(2);
            make.centerX.equalTo(self.button1);
        }];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
