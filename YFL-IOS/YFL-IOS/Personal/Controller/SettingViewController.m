//
//  SettingViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/14.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "SettingViewController.h"
#import "PersonSettingCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    float cacheSize;//缓存大小
    NSString *cachePath;//缓存路径
}

@property (nonatomic, strong) UITableView *table;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    //[self loadData];
}

-(void)initView{
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 42, 15, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    
    //无网络页面
    //DisnetViewDelegate
//    disView = [[DisnetView alloc] initWithFrame:self.view.bounds];
//    disView.delegate = self;
//    disView.hidden = YES;
//    [self.view addSubview:disView];
}

//-(void)loadData{
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
//}


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
    return [PersonSettingCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonSettingCell *settingCell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (indexPath.row == 0) {
        settingCell.cellTitleLabel.text = @"语言";
        settingCell.cellContentLabel.text = @"切换";
    }else if (indexPath.row == 1){
        settingCell.cellTitleLabel.text = @"缓存清理";
        
        //缓存
        cachePath = [self getCachePath];
        cacheSize = [PublicMethod folderSizeAtPath:cachePath];
        NSString *cacheString = [NSString stringWithFormat:@"%.2lfM",cacheSize/1000.];
        settingCell.cellContentLabel.text = cacheString;
    }
    return settingCell;
//
//    [_table registerClass:[PersonSettingCell class] forCellReuseIdentifier:@"settingCell"];
//
//
//
//
//    static NSString *identify = @"cellIdentify";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
//    }
//    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [self clearTheCacheMethod];
    }
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
        
        [_table registerClass:[PersonSettingCell class] forCellReuseIdentifier:@"settingCell"];
    }
    return _table;
}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    //[self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

#pragma mark - 清除缓存 方法
//获取cache文件夹路径
- (NSString *)getCachePath {
    NSString *cachePathP = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return cachePathP;
}

//清除文件夹缓存
- (void)clearCache:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 遍历文件夹下的文件或文件夹
    if ([fileManager fileExistsAtPath:folderPath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:folderPath];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [folderPath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark 清空缓存
- (void)clearTheCacheMethod {
    NSString *string = [NSString stringWithFormat:@"共需清理缓存%.2lfM",cacheSize/1000.];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清理完成" message:string delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

//UIAlertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //是否开启推送
    } else {
        //清空缓存
        [self clearCache:cachePath];
        
        [self.table reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
