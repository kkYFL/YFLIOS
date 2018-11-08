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
#import "EducationXinshegnViewCell.h"
#import "UIView+CLSetRect.h"
#import "CLInputToolbar.h"



@interface EducationTaskDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger selectIndex;
}
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@property (nonatomic, strong) UIView *itemsView;


@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIView *footerView;


@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) UIView *maskView;

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
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.table];

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push" style:UIBarButtonItemStylePlain target:self action:@selector(pushNewVC)];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.backImageView];
    [self.containerView addSubview:self.playBtn];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.model.taskThumb]]];
    [self setTextViewToolbar];

    
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
    
    
    
    if ([self.model.vedioUrl hasPrefix:@"http"]) {
        NSURL *videoUrl = [NSURL URLWithString:self.model.vedioUrl];
        self.assetURLs = [NSArray arrayWithObjects:videoUrl, nil];
    }else{
        NSURL *videoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.model.vedioUrl]];
        self.assetURLs = [NSArray arrayWithObjects:videoUrl, nil];
    }
    self.player.assetURLs = self.assetURLs;
    
    
    //
    [self.view addSubview:self.itemsView];
}


-(void)initData{
    selectIndex = 1;
}


-(void)loadData{
    
    // 获取党员心声
    // 测试结果: 通过
        [HanZhaoHua getPartyMemberThinkingWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId taskId:self.model.taskId page:1 pageNum:10 success:^(NSArray * _Nonnull listArray) {
            for (PartyMemberThinking *model in listArray) {
                NSLog(@"%@", model.pmName);
                NSLog(@"%@", model.headImg);
                NSLog(@"%@", model.ssDepartment);
                NSLog(@"%@", model.commentInfo);
                NSLog(@"%@", model.createTime);
            }
            
            self.PartyMemberThinkingArr = [NSMutableArray arrayWithArray:listArray];
            //[self.table reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}


-(void)takeCommentToServerWithCommentStr:(NSString *)comment{
    // 评论提交
    // 测试结果: 通过
    if ([NSString isBlankString:comment]) { return;    }
    
        [HanZhaoHua submitCommentsWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId taskId:self.model.taskId commentInfo:comment success:^(NSDictionary * _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            [[PromptBox sharedBox] showPromptBoxWithText:[AppDelegate getURLWithKey:@""]@"pinglunchengong", nil) onView:self.view hideTime:2 y:0];
            
            [self loadData];

        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            [[PromptBox sharedBox] showPromptBoxWithText:[AppDelegate getURLWithKey:@""]@"pinglunshibai", nil) onView:self.view hideTime:2 y:0];

        }];
    
}

-(void)getServerTime{
    // 获取服务器时间
    // 测试结果: 通过
    [HanZhaoHua getServerTimeWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId success:^(NSDictionary * _Nonnull responseObject) {
        NSString *code = [[responseObject objectForKey:@"code"] stringValue];
        if ([code isEqualToString:@"2000"]) {
            NSNumber *time = [responseObject objectForKey:@"data"];
            NSLog(@"%@", time);
        } else {
            NSLog(@"处理错误");
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


-(void)saveLearnHistory{
    // 保存学习痕迹
    // 测试结果: 通过
        NSDate * date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *currentTime = [formatter stringFromDate:date];
        [HanZhaoHua saveLearningTracesWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId taskId:self.model.taskId startDate:currentTime success:^(NSDictionary * _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
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
    return self.PartyMemberThinkingArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == 1) {
        return [EducationJianjieCell CellHWithModel:self.model];
    }
    
    return [EducationXinshegnViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == 1) {
        EducationJianjieCell *JianjieCell = [tableView dequeueReusableCellWithIdentifier:@"JianjieCell"];
        JianjieCell.model = self.model;
        return JianjieCell;
    }
    
    
    EducationXinshegnViewCell *xishengCell = [tableView dequeueReusableCellWithIdentifier:@"xishengCell"];
    if (self.PartyMemberThinkingArr.count > indexPath.row) {
        PartyMemberThinking *thindModel = self.PartyMemberThinkingArr[indexPath.row];
        xishengCell.thindModel = thindModel;
    }
    return xishengCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        CGFloat h = SCREEN_WIDTH*9/16.0;
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, h+56, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-EWTTabbar_SafeBottomMargin-h-56-50)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[EducationJianjieCell class] forCellReuseIdentifier:@"JianjieCell"];
        //
        [_table registerClass:[EducationXinshegnViewCell class] forCellReuseIdentifier:@"xishengCell"];

    }
    return _table;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.player.viewControllerDisappear = NO;
    [self getServerTime];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //self.player.viewControllerDisappear = YES;
    [self saveLearnHistory];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    self.backImageView.frame = CGRectMake(x, y, w, h);

    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
    

}


- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
    NSString *coverImageStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.model.taskThumb];
    [self.controlView showTitle:@"" coverURLString:coverImageStr fullScreenMode:ZFFullScreenModeLandscape];
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
        [button setTitle:[AppDelegate getURLWithKey:@""]@"RenWujianjie", nil) forState:UIControlStateNormal];
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
        [button1 setTitle:[AppDelegate getURLWithKey:@""]@"DangYuanHeart", nil) forState:UIControlStateNormal];
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

-(UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#B2B2B2"];
        [footerView setFrame:CGRectMake(0, self.view.bounds.size.height-EWTTabbar_SafeBottomMargin-50, SCREEN_WIDTH, 50)];
        [self.view addSubview:footerView];
        _footerView = footerView;
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-EWTTabbar_SafeBottomMargin);
            make.height.mas_equalTo(50.0f);
        }];
        
        
        UIImageView *footerTouch = [[UIImageView alloc]init];
        [footerTouch setBackgroundColor:[UIColor whiteColor]];
        [_footerView addSubview:footerTouch];
        footerTouch.layer.masksToBounds = YES;
        footerTouch.layer.cornerRadius = 15.0f;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textInputAction:)];
        footerTouch.userInteractionEnabled = YES;
        [footerTouch addGestureRecognizer:tap1];
        [footerTouch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView).offset(15.0f);
            make.top.equalTo(_footerView).offset(8.0f);
            make.right.equalTo(_footerView.mas_right).offset(-8.0f);
            make.bottom.equalTo(_footerView.mas_bottom).offset(-8.0f);
        }];

        UILabel *remindLabel = [[UILabel alloc] init];
        remindLabel.font = [UIFont systemFontOfSize:14.0f];
        remindLabel.text = [AppDelegate getURLWithKey:@""]@"wodexiangfa", nil);
        remindLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
        remindLabel.textAlignment = NSTextAlignmentLeft;
        [footerTouch addSubview:remindLabel];
        [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerTouch).offset(18.0f);
            make.centerY.equalTo(footerTouch);
        }];
    }
    return _footerView;
}

-(void)setTextViewToolbar {
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BlankTextViewtapActions:)];
    [self.maskView addGestureRecognizer:tap];
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    self.inputToolbar = [[CLInputToolbar alloc] initWithFrame:self.view.bounds];
    self.inputToolbar.textViewMaxLine = 1;
    self.inputToolbar.fontSize = 13;
    self.inputToolbar.placeholder = [AppDelegate getURLWithKey:@""]@"qingshuru", nil);
    __weak __typeof(self) weakSelf = self;
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        //[strongSelf.btn setTitle:text forState:UIControlStateNormal];
        // 清空输入框文字
        [strongSelf.inputToolbar bounceToolbar];
        strongSelf.maskView.hidden = YES;
        
        [strongSelf takeCommentToServerWithCommentStr:text];
    }];
    [self.maskView addSubview:self.inputToolbar];
}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textInputAction:(UITapGestureRecognizer *)tap{
    self.maskView.hidden = NO;
    [self.inputToolbar popToolbar];
}

-(void)BlankTextViewtapActions:(UITapGestureRecognizer *)tap {
    [self.inputToolbar bounceToolbar];
    self.maskView.hidden = YES;
}

-(void)itemSelect:(UIButton *)sender{
    if (sender.tag == 101) {
        self.button.selected = YES;
        self.button1.selected = NO;
        selectIndex = 1;
    }else if (sender.tag == 102){
        self.button.selected = NO;
        self.button1.selected = YES;
        selectIndex = 2;
    }
    
    [self.table reloadData];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
