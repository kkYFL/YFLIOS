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
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "InformationMenu.h"
#import "NewsContentViewCell.h"
#import "NewsDetailNoVideoController.h"


@interface NewsdeliveryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
>{
    NSInteger pageIndex;
    BOOL hasloadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *cellTextfield;
@property (nonatomic, strong) NSMutableArray *newsList;

@end

@implementation NewsdeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];

    [self refershHeader];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    self.navigationItem.titleView = self.searchView;
    
    [self.view addSubview:self.table];
    
    [self initRefresh];
}

-(void)initData{
    pageIndex = 1;
    hasloadAll = NO;
    self.newsList = [NSMutableArray array];
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];

    // 新闻列表接口
    // 测试结果: 通过
    [HanZhaoHua getNewsListWithUserToken:APP_DELEGATE.userToken typesId:self.menuModel.menuId Title:self.cellTextfield.text.length?self.cellTextfield.text:@"" page:1 pageNum:10 success:^(NSArray * _Nonnull newsList) {
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
        
        //
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (newsList.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
            hasloadAll = YES;
        }else{
            [self.table.mj_footer endRefreshing];
        }

        //fresh
        if (pageIndex == 1) {
            self.newsList = [NSMutableArray arrayWithArray:newsList];
        //more
        }else{
            [self.newsList addObjectsFromArray:newsList];
        }
        
        [self.table reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
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
    if (hasloadAll) {
        [self.table.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    pageIndex++;
    [self loadData];
}

-(void)refershHeader{
    [self initData];
    [self loadData];
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
    
    NewsMessage *newsModel = nil;
    if (self.newsList.count>indexPath.row) {
        newsModel = self.newsList[indexPath.row];
    }
    
    //文字加图片
    if ([newsModel.infoType integerValue] == 1) {
        NewsRightIConTableCell *rightIconCell = [tableView dequeueReusableCellWithIdentifier:@"rightIconCell"];
        rightIconCell.cellTitleLabel.text = newsModel.title;
        NSString *imageurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,newsModel.imgUrl];
        [rightIconCell.cellImageView setImage:[UIImage imageNamed:imageurl]];
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
    NSString *imageurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,newsModel.imgUrl];
    [MaxImageCell.iconImageView setImage:[UIImage imageNamed:imageurl]];
    return MaxImageCell;
    
    
    
    
//    if (indexPath.row<3) {
//        NewsRightIConTableCell *rightIconCell = [tableView dequeueReusableCellWithIdentifier:@"rightIconCell"];
//        return rightIconCell;
//    }
//
//
//    __weak typeof(self) weakSelf = self;
//    NewsContentMaxImageViewCell *MaxImageCell = [tableView dequeueReusableCellWithIdentifier:@"MaxImageCell"];
//    MaxImageCell.selectBlock = ^(NSString *content) {
//        NewsVideoDetailViewController *videoVC = [[NewsVideoDetailViewController alloc]init];
//        videoVC.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:videoVC animated:YES];
//    };
//    return MaxImageCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.cellTextfield resignFirstResponder];
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
        [_table registerClass:[NewsContentViewCell class] forCellReuseIdentifier:@"contentCell"];

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
        cellTextfield.delegate = self;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //textField放弃第一响应者 （收起键盘）
    //键盘是textField的第一响应者
    [textField resignFirstResponder];
    
    if (textField.text.length) {
        [self refershHeader];
    }
    
    return YES;
}



#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
