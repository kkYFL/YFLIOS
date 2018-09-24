//
//  NewsdeliveryViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsdeliveryViewController.h"
#import "NewsRightIConTableCell.h"
#import "NewsContentMaxImageViewCell.h"
#import "NewsVideoDetailViewController.h"


@interface NewsdeliveryViewController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *cellTextfield;
@end

@implementation NewsdeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    self.navigationItem.titleView = self.searchView;
    
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
    if (indexPath.row < 3) {
        return [NewsRightIConTableCell CellH];
    }
    return [NewsContentMaxImageViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<3) {
        NewsRightIConTableCell *rightIconCell = [tableView dequeueReusableCellWithIdentifier:@"rightIconCell"];
        return rightIconCell;
    }
    
    
    __weak typeof(self) weakSelf = self;
    NewsContentMaxImageViewCell *MaxImageCell = [tableView dequeueReusableCellWithIdentifier:@"MaxImageCell"];
    MaxImageCell.selectBlock = ^(NSString *content) {
        NewsVideoDetailViewController *videoVC = [[NewsVideoDetailViewController alloc]init];
        videoVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:videoVC animated:YES];
    };
    return MaxImageCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = [UIColor whiteColor];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[NewsRightIConTableCell class] forCellReuseIdentifier:@"rightIconCell"];
        [_table registerClass:[NewsContentMaxImageViewCell class] forCellReuseIdentifier:@"MaxImageCell"];
        
    }
    return _table;
}

-(UIView *)searchView{
    if (!_searchView) {
        UIView *searchView = [[UIView alloc]init];
        searchView.backgroundColor = [UIColor whiteColor];
        searchView.layer.masksToBounds = YES;
        searchView.layer.cornerRadius = 4.0f;
        [searchView setFrame:CGRectMake(0, 0,230*WIDTH_SCALE, 33)];
        _searchView = searchView;
        
        
        UIImageView *searchImage = [[UIImageView alloc]init];
        [searchImage setBackgroundColor:[UIColor clearColor]];
        [searchView addSubview:searchImage];
        [searchImage setContentMode:UIViewContentModeCenter];
        [searchImage setImage:[UIImage imageNamed:@"search_icon"]];
//        [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(searchView).offset(10);
//            make.centerX.equalTo(searchView);
//            make.width.height.mas_equalTo(12);
//        }];
        [searchImage setFrame:CGRectMake(10, (33-10)/2.0, 12, 12)];


        UIImageView *deleteImage = [[UIImageView alloc]init];
        [deleteImage setBackgroundColor:[UIColor clearColor]];
        [searchView addSubview:deleteImage];
        [deleteImage setContentMode:UIViewContentModeCenter];
        [deleteImage setImage:[UIImage imageNamed:@"search_delete"]];
//        [deleteImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(searchView.mas_right).offset(-15);
//            make.centerX.equalTo(searchView);
//            make.width.height.mas_equalTo(12);
//        }];
        [deleteImage setFrame:CGRectMake(230*WIDTH_SCALE-15-12, (33-12)/2.0, 12, 12)];


        UITextField *cellTextfield = [[UITextField alloc]init];
        //设置边框样式，只有设置了才会显示边框样式
        cellTextfield.borderStyle = UITextBorderStyleNone;
        //设置输入框内容的字体样式和大小
        cellTextfield.font = [UIFont systemFontOfSize:14.0f];
        //设置字体颜色
        cellTextfield.textColor = [UIColor colorWithHexString:@"#8E8E93"];
        //当输入框没有内容时，水印提示 提示内容为password
        cellTextfield.placeholder = @"要闻速递";
        //内容对齐方式
        cellTextfield.textAlignment = NSTextAlignmentLeft;
        //return键变成什么键
        cellTextfield.returnKeyType =UIReturnKeyDone;
        self.cellTextfield = cellTextfield;
        [searchView addSubview:self.cellTextfield];
        [self.cellTextfield setFrame:CGRectMake(10+12+10, (33-20)/2.0, 230*WIDTH_SCALE-10-15-12*2-10-3, 20)];
//        [self.cellTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(searchImage.mas_right).offset(10);
//            make.centerX.equalTo(searchView);
//            make.right.equalTo(deleteImage.mas_left).offset(-3);
//            make.height.mas_equalTo(20);
//        }];
        
    }
    return _searchView;
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
