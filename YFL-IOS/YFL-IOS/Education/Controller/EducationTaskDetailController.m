//
//  EducationTaskDetailController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/16.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationTaskDetailController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFIJKPlayerManager.h>
//#import <ZFPlayer/KSMediaPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "LearningTaskModel.h"
#import "EducationJianjieCell.h"


static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";


@interface EducationTaskDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger selectIndex;
}
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property (nonatomic, strong) UIView *itemsView;


@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) NSMutableArray *PartyMemberThinkingArr;

@end

@implementation EducationTaskDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
    
    [self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(pushNewVC)];
    [self.view addSubview:self.containerView];
    
    [self.containerView addSubview:self.playBtn];

    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
    /// 播放完自动播放下一个
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
        //        [self.player playTheNext];
        //        if (!self.player.isLastAssetURL) {
        //            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
        //            [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
        //        } else {
        //            [self.player stop];
        //        }
    };
    
    self.assetURLs = @[[NSURL URLWithString:@"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"],
                       [NSURL URLWithString:@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"],
                       [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/peter/mac-peter-tpl-cc-us-2018_1280x720h.mp4"],
                       [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/grimes/mac-grimes-tpl-cc-us-2018_1280x720h.mp4"],
                       [NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"],
                       [NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/9/R/EDJTRAD9R/SD/EDJTRAD9R-mobile.mp4"],
                       [NSURL URLWithString:@"http://dlhls.cdn.zhanqi.tv/zqlive/34338_PVMT5.m3u8"],
                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-video/7_517c8948b166655ad5cfb563cc7fbd8e.mp4"],
                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/68_20df3a646ab5357464cd819ea987763a.mp4"],
                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/118_570ed13707b2ccee1057099185b115bf.mp4"],
                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/15_ad895ac5fb21e5e7655556abee3775f8.mp4"],
                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/12_cc75b3fb04b8a23546d62e3f56619e85.mp4"],
                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/5_6d3243c354755b781f6cc80f60756ee5.mp4"],
                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-movideo/11233547_ac127ce9e993877dce0eebceaa04d6c2_593d93a619b0.mp4"]];
    
    self.player.assetURLs = self.assetURLs;
    
    
    //
    [self.view addSubview:self.itemsView];
    
    
}


-(void)initData{
    selectIndex = 1;
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
    
    
    
    // 获取党员心声
    // 测试结果: 通过
        [HanZhaoHua getPartyMemberThinkingWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId taskId:APP_DELEGATE.taskId page:1 pageNum:10 success:^(NSArray * _Nonnull listArray) {
            for (PartyMemberThinking *model in listArray) {
                NSLog(@"%@", model.pmName);
                NSLog(@"%@", model.headImg);
                NSLog(@"%@", model.ssDepartment);
                NSLog(@"%@", model.commentInfo);
                NSLog(@"%@", model.createTime);
            }
            
            self.PartyMemberThinkingArr = [NSMutableArray arrayWithArray:listArray];
            [self.table reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}


#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectIndex == 1) {
        return 1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == 1) {
        return [EducationJianjieCell CellH];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == 1) {
        EducationJianjieCell *JianjieCell = [tableView dequeueReusableCellWithIdentifier:@"JianjieCell"];
        return JianjieCell;
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
        CGFloat h = SCREEN_WIDTH*9/16.0;
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, h+56, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-h-56)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[EducationJianjieCell class] forCellReuseIdentifier:@"JianjieCell"];
    }
    return _table;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.player.viewControllerDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.player.viewControllerDisappear = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
    

}

- (void)changeVideo:(UIButton *)sender {
    /// 切换playerManager
    //    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    self.player.currentPlayerManager = playerManager;
    //    [self.player replaceCurrentPlayerManager:playerManager];
    
    NSString *URLString = @"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4";
    self.player.assetURL = [NSURL URLWithString:URLString];
    [self.controlView showTitle:@"Apple" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModePortrait];
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"视频标题" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
}

- (void)nextClick:(UIButton *)sender {
    [self.player playTheNext];
    if (!self.player.isLastAssetURL) {
        NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
        [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
    } else {
        NSLog(@"最后一个视频了");
    }
}

- (void)pushNewVC {
    //ZFSmallPlayViewController *vc = [[ZFSmallPlayViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    self.player.currentPlayerManager.muted = !self.player.currentPlayerManager.muted;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        //_controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor purpleColor];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}


//自定义Items切换固定items
-(UIView *)itemsView{
    if (!_itemsView) {
        _itemsView = [[UIView alloc]init];
        [_itemsView setBackgroundColor:[UIColor whiteColor]];
        CGFloat w = CGRectGetWidth(self.view.frame);
        CGFloat h = w*9/16;
        [self.view addSubview:_itemsView];
        [_itemsView setFrame:CGRectMake(0, h, SCREEN_WIDTH, 56)];
        
        
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button setTitleColor:[UIColor colorWithHexString:@"#0C0C0C"] forState:UIControlStateNormal];
        [button setTitle:@"任务简介" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#E51C23"] forState:UIControlStateSelected];
        [_itemsView addSubview:button];
        button.tag = 101;
        button.selected = YES;
        [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0, 56)];
        self.button = button;
        
        
        UIButton *button1 = [[UIButton alloc]init];
        [button1 addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#0C0C0C"] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#E51C23"] forState:UIControlStateSelected];
        [button1 setTitle:@"党员心声" forState:UIControlStateNormal];
        [_itemsView addSubview:button1];
        button1.tag = 102;
        [button1 setFrame:CGRectMake(SCREEN_WIDTH/2.0, 0, SCREEN_WIDTH/2.0, 56)];
        self.button1 = button1;
        
        
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


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)itemSelect:(UIButton *)sender{
    if (sender.tag == 101) {
        self.button.selected = YES;
        self.button1.selected = NO;
    }else if (sender.tag == 102){
        self.button.selected = NO;
        self.button1.selected = YES;
    }
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
