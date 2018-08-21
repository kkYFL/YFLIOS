//
//  NewsViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/19.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsViewController.h"
#import "SDCycleScrollView.h"
#define SDViewH 150

@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
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
        return 1;
    }
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return 10;
    }
    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        return 44;
    }
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
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
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        //[_table registerClass:[CareerProfessionjingduCell class] forCellReuseIdentifier:@"CareerjindguCell"];
    }
    return _table;
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
        [images addObject:[NSString stringWithFormat:@"Pfofession_card-bg-%ld",i]];
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
    
#pragma mark - getter
-(SDCycleScrollView *)scrollView{
    
    if (_scrollView == nil) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SDViewH) delegate:self placeholderImage:nil];
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
