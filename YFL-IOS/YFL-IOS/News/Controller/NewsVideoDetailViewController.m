//
//  NewsVideoDetailViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/6.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsVideoDetailViewController.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFIJKPlayerManager.h>
//#import <ZFPlayer/KSMediaPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "NewsMessage.h"


static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface NewsVideoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;


@property (nonatomic, strong) NewsDetail *newsDetail;
@property (nonatomic, strong) NSString *corverImageUrl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *videoTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation NewsVideoDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    if ([self.newsModel.imgUrl hasPrefix:@"http"]) {
        self.corverImageUrl = self.newsModel.imgUrl;
    }else{
        self.corverImageUrl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.newsModel.imgUrl];
    }
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.corverImageUrl]];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(pushNewVC)];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.backImageView];
    [self.containerView addSubview:self.playBtn];
    [self.view addSubview:self.backBtn];

    
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
    

    
}

-(void)loadData{
    
    // 新闻详情接口
    // 测试结果: 未通过, 未提供测试数据, 无法测试
        [HanZhaoHua getNewsDetailWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId infoId:@"" informationId:self.newsModel.ID success:^(NewsDetail * _Nonnull newsDetail) {
            self.newsDetail = newsDetail;

            
            NSLog(@"%@", newsDetail.userId);
            NSLog(@"%@", newsDetail.userToken);
            NSLog(@"%@", newsDetail.imgUrl);
            NSLog(@"%@", newsDetail.summary);
            NSLog(@"%@", newsDetail.foreignUrl);
            NSLog(@"%@", newsDetail.foreignType);
            NSLog(@"%@", newsDetail.positionNo);
            
            if ([NSString isBlankString:newsDetail.vedioUrl]) {
                self.assetURLs = [NSArray arrayWithObject:[NSURL URLWithString:@"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"]];
            }else{
                if ([newsDetail.vedioUrl hasPrefix:@"http"]) {
                    self.assetURLs = [NSArray arrayWithObject:[NSURL URLWithString:newsDetail.vedioUrl]];
                }else{
                    self.assetURLs = [NSArray arrayWithObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,newsDetail.vedioUrl]]];
                }
            }
            
//            if ([newsDetail.imgUrl hasPrefix:@"http"]) {
//                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:newsDetail.imgUrl]];
//            }else{
//                [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,newsDetail.imgUrl]]];
//            }
            
            self.player.assetURLs = self.assetURLs;
            //[self.webView loadHTMLString:self.newsDetail.info baseURL:nil];
            
            self.videoTitleLabel.hidden = NO;
            [self.videoTitleLabel setText:[NSString stringWithFormat:@"%@",self.newsModel.title]];
            self.timeLabel.hidden = NO;
            [self.timeLabel setText:[NSString stringWithFormat:@"%@  %@",self.newsModel.createTime,self.newsModel.sourceFrom]];

        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.player.viewControllerDisappear = NO;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.player.viewControllerDisappear = YES;
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x1 = 0;
    CGFloat y1 = 0;
    CGFloat w1 = CGRectGetWidth(self.view.frame);
    CGFloat h1 = w1*9/16;
    self.containerView.frame = CGRectMake(x1, y1, w1, h1);
    
    self.backImageView.frame = CGRectMake(x1, y1, w1, h1);
    
    CGFloat w2 = 44;
    CGFloat h2 = 44;
    CGFloat x2 = (CGRectGetWidth(self.containerView.frame)-w2)/2;
    CGFloat y2 = (CGRectGetHeight(self.containerView.frame)-h2)/2;
    self.playBtn.frame = CGRectMake(x2, y2, w2, h2);
    
    
    CGFloat X3 = 10.0f;
    CGFloat Y3 = 35.0f;
    CGFloat H3 = 25.0f;
    CGFloat W3 = 25.0f;
    self.backBtn.frame = CGRectMake(X3, Y3, W3, H3);

    
            [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(h1);
                make.left.right.bottom.equalTo(self.view);
            }];
    
    [self.videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.containerView.mas_bottom).offset(12.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15.0f);
        make.top.equalTo(self.videoTitleLabel.mas_bottom).offset(10.0f);
        make.right.equalTo(self.view.mas_right).offset(-15.0f);
    }];
    
}



- (void)playClick:(UIButton *)sender {
    if (!self.assetURLs.count) {
        [MBProgressHUD toastMessage:@"未获取到视频" ToView:self.view];
        return;
    }
    
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"" coverURLString:self.newsModel.userPic fullScreenMode:ZFFullScreenModeLandscape];
}

- (void)nextClick:(UIButton *)sender {
    [self.player playTheNext];
    if (!self.player.isLastAssetURL) {
        NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
        [self.controlView showTitle:title coverURLString:self.corverImageUrl fullScreenMode:ZFFullScreenModeLandscape];
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
        _containerView.backgroundColor = [UIColor whiteColor];
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


-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"Video_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.opaque = NO;
        _webView.scrollView.scrollEnabled = YES;
        _webView.delegate = self;
        [self.view addSubview:_webView];

    }
    return _webView;
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        UIImageView *backImageView = [[UIImageView alloc]init];
        [backImageView setBackgroundColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:0.5]];
        _backImageView = backImageView;
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}


-(UILabel *)videoTitleLabel{
    if (!_videoTitleLabel) {
        UILabel *videoTitleLabel = [[UILabel alloc] init];
        videoTitleLabel.font = [UIFont systemFontOfSize:17.0f];
        videoTitleLabel.text = @"";
        videoTitleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        videoTitleLabel.textAlignment = NSTextAlignmentLeft;
        videoTitleLabel.numberOfLines = 0;
        videoTitleLabel.hidden = YES;
        [self.view addSubview:videoTitleLabel];
        _videoTitleLabel = videoTitleLabel;
        return _videoTitleLabel;
    }
    return _videoTitleLabel;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:14.0f];
        timeLabel.text = @"";
        timeLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.hidden = YES;
        [self.view addSubview:timeLabel];
        _timeLabel = timeLabel;
        return _timeLabel;
    }
    return _timeLabel;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
