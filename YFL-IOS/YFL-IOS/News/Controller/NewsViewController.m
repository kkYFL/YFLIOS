//
//  NewsViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/19.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsViewController.h"
#import "SDCycleScrollView.h"
#import "BannerScrollView.h"
#import "NewsItemsTableCell.h"
#import "NewsRightIConTableCell.h"
#define SDViewH 150

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) BannerScrollView *remindScrollHeader;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    [self loadData];
}
    
-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"党员资讯";
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.scrollView;
    
    
}
    
-(void)loadData{
    [self setContentData:nil];
}

#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    {
        return 2;
    }
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        if (section == 0) return 1;
        return 10;
    }
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if (indexPath.section ==0) {
            return [NewsItemsTableCell CellH];
        }
        return [NewsRightIConTableCell CellH];
    }
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if (indexPath.section == 0) {
            NewsItemsTableCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
            return itemCell;
        }
        
        //[_table registerClass:[NewsRightIConTableCell class] forCellReuseIdentifier:@"rightIconCell"];
        NewsRightIConTableCell *rightIconCell = [tableView dequeueReusableCellWithIdentifier:@"rightIconCell"];
        return rightIconCell;
        
        
        static NSString *identify = @"cellIdentify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        return cell;
    }
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.remindScrollHeader;
    }
    return [self headerViewWithIcon:nil Title:@"最新资讯"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        
}
    

    
    
#pragma mark - SDCycleScrollViewDelegate
    
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
//    EWTBannerItem* item = _model.bannerArray[index];
//
//    NSDictionary* dict = nil;
//
//    if (item.oldItem) {
//
//        dict = @{@"PicUrl":item.oldItem.imageUrl,@"RedirectType":item.oldItem.redirectType,@"LinkUrl":item.oldItem.linkUrl,@"Title":item.oldItem.title,@"index":@(index)};
//    }
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(moduleCell:routerInfo:userInfo:)]) {
//
//        [self.delegate moduleCell:self routerInfo:item.router userInfo:dict];
//    }
}
    
-(void)setContentData:(id)data{
    
//    if ([data isKindOfClass:[EWTBannerModule class]]) {
//
        NSMutableArray* images = [NSMutableArray array];
    for (NSInteger i = 0; i<5; i++) {
        [images addObject:[NSString stringWithFormat:@"Pfofession_card-bg-%d",i+1]];
    }
//
//        _model = [(EWTBannerModule*)data copy];
//
//        for (EWTBannerItem* item in _model.bannerArray) {
//
//            [images addObject:item.imageUrl];
//        }
        _scrollView.imageURLStringsGroup = images;
//    }
}
    
#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[NewsItemsTableCell class] forCellReuseIdentifier:@"itemCell"];
        [_table registerClass:[NewsRightIConTableCell class] forCellReuseIdentifier:@"rightIconCell"];
        //
        
    }
    return _table;
}

-(BannerScrollView *)remindScrollHeader{
    if (!_remindScrollHeader) {
        _remindScrollHeader = [[BannerScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [_remindScrollHeader setContentData:nil];
    }
    return _remindScrollHeader;
}

-(SDCycleScrollView *)scrollView{
    
    if (_scrollView == nil) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SDViewH) delegate:self placeholderImage:nil];
    }
    return _scrollView;
}

#pragma mark - Actions
-(UIView *)headerViewWithIcon:(NSString *)icon Title:(NSString *)title{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    headerTitle.text = title;
    headerTitle.textColor = [UIColor colorWithHexString:@"#51566D"];
    headerTitle.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:headerTitle];
    
    
    [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(12);
        make.centerY.equalTo(headerView.mas_centerY).offset(0);
    }];
    
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
