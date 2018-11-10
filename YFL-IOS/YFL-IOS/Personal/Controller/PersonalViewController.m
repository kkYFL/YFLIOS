//
//  PersonalViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/19.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonMidTableViewCell.h"
#import "PersonRowTableViewCell.h"
#import "SigninRecordViewController.h"
#import "PersonJIfenViewController.h"
#import "PersonXinxiViewController.h"
#import "PersonPassWordController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "MBProgressHUD+Toast.h"
#import "SignMoel.h"
#import "PersonJifenListController.h"
#import "MBProgressHUD+Toast.h"
#import "SettingViewController.h"
#import "AboutViewController.h"
#import "PersonRowWithIconCell.h"
#import "UpdateView.h"
#import "UpdateModel.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Toast.h"
#import "EWTMediator+EWTImagePicker.h"

#define kMaxCount 1


@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource,SubjectViewDelegate,UIActionSheetDelegate>{
    NSString *_filePath;//地址
    NSString *_info;    //更新说明
    
    NSInteger _score;
    
    NSString *headerImageUrl;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UILabel *descibeLabel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) NSInteger serverCount;
@property (nonatomic, strong) UserMessage *userModel;
@property (nonatomic, strong) SignMoel *signModel;
@property (nonatomic, strong) UIButton *signButton;

@property (nonatomic, strong) UpdateView *updateView;


/** 获取图片方式选择器 */
@property (nonatomic, strong) UIActionSheet *getPhotosSheet;
/** 已选图片集合 */
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation PersonalViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLuanguageAction:) name:KNotificationChangeLaunuageNoti object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.headerView;
    
    [self initRefresh];
    
    [self addObserver:self forKeyPath:@"serverCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshPersonViewSource:) name:@"RefreshPersonViewSourceNoti" object:nil];
}

-(void)initData{
    self.serverCount = 0;
    _score = 0;
}


#pragma mark 上下拉刷新
- (void)initRefresh{
    MJRefershHeader *header = [MJRefershHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershHeader)];
    self.table.mj_header = header;
    //self.table.mj_footer.automaticallyChangeAlpha = YES;
}


-(void)refershHeader{
    [self initData];
    [self loadData];
}


-(void)loadData{
    
    [[PromptBox sharedBox] showLoadingWithText:[NSString stringWithFormat:@"%@...",[AppDelegate getURLWithKey:@"jiazaizhong"]] onView:self.view];

    /**
     个人中心—用户信息查询接口
     */
    NSMutableDictionary  *para = [NSMutableDictionary dictionary];
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKey:@"userId"];
    [HanZhaoHua GetPersonInfoSourceWithParaDic:para success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            self.userModel = [[UserMessage alloc]initWithDic:dataDic];
            //同步个人信息
            APP_DELEGATE.userModel = [[UserMessage alloc]initWithDic:dataDic];
        }
        NSLog(@"");
        self.serverCount ++;
    } failure:^(NSError * _Nonnull error) {
        self.serverCount ++;
    }];
    
    
    
    // 用户当前积分
    // 测试结果: 通过
        [HanZhaoHua getUserCurrentScoreWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId success:^(NSNumber * _Nonnull score) {
            NSLog(@"%@", score);
            _score = [score integerValue];
            self.serverCount ++;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            self.serverCount ++;
        }];
    
    
    // 用户签到日历
    // 测试结果: 接口通过, 但是无有效数据返回
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    [HanZhaoHua getUserSignInRecordWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId year:year month:month success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        self.signModel = [[SignMoel alloc]initWithDic:dataDic];

        self.serverCount ++;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        self.serverCount ++;
    }];
    
    
    [self appVersionCheck];
    
}


/*
 "appType": 1,
 "version:"1.0.1",
 "isForceUpdate": 1,
 "filePath": "file/update/version/android_1.0.1.apk",
 "info":"更新说明"
 */

-(void)appVersionCheck{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:@"2" forKey:@"appType"];
    
    [HanZhaoHua GetAPPVersionSourceWithParaDic:para success:^(NSDictionary * _Nonnull responseObject) {
        NSDictionary *dataDic = [responseObject objectForKey:@"data"];
        
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            
            APP_DELEGATE.updateModel = [[UpdateModel alloc]initWithDic:dataDic];
        }

        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


-(void)gotoUPdateViersion{
    //测试使用
    UpdateView *updateView = [[UpdateView alloc]initWithUpdateViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ContentInfo:APP_DELEGATE.updateModel];
    updateView.delegate = self;
    self.updateView = updateView;
}

#pragma mark - SubjectViewDelegate
- (void)updateDelegate{
    self.updateView.hidden = YES;
    
#ifdef DEBUG
    NSString *tmpstr = @"https://itunes.apple.com/us/app/%E5%8D%96%E5%A5%BD%E8%BD%A6%E7%89%A9%E6%B5%81/id1212731400?ls=1&mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tmpstr]];
#else
#endif
    
    
    if (!_filePath.length) {
        [MBProgressHUD toastMessage:@"暂无更新信息" ToView:self.view];
        return;
    }
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_filePath]];
}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self initData];
    [self loadData];
}



#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}



#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    if (section == 1) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        if (indexPath.row == 0) {
            return [PersonMidTableViewCell CellH];
        }
        return [PersonRowWithIconCell CellH];
    }

    return [PersonRowTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0){
        PersonMidTableViewCell *midCell = [tableView dequeueReusableCellWithIdentifier:@"midCell"];
        midCell.score = _score;
        __weak typeof(self) weakSelf = self;
        midCell.selectViewBlock = ^(NSInteger viewIndex) {
            if (viewIndex == 1) {
                PersonJIfenViewController *jifenVC = [[PersonJIfenViewController alloc]init];
                jifenVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:jifenVC animated:YES];
                
            }else if (viewIndex == 2){
                PersonJifenListController *jifenListVC = [[PersonJifenListController alloc] init];
                jifenListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:jifenListVC animated:YES];
            }
        };
        return midCell;
    }
    
    

    if (indexPath.section == 0) {
        PersonRowWithIconCell *rowIconCell = [tableView dequeueReusableCellWithIdentifier:@"rowIconCell"];
        if(indexPath.row == 1){
            rowIconCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"GerenXinxi"];
            rowIconCell.cellContentLabel.text = [AppDelegate getURLWithKey:@"wanshangerenxingxi"];
            rowIconCell.cellNewImageView.hidden = YES;
            [rowIconCell.cellIcon setImage:[UIImage imageNamed:@"person_userHaerd"]];
        }else if (indexPath.row == 2){
            rowIconCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"mimaguanli"];
            rowIconCell.cellContentLabel.text = [AppDelegate getURLWithKey:@"weixinduanxinfangshi"];
            rowIconCell.cellNewImageView.hidden = YES;
            [rowIconCell.cellIcon setImage:[UIImage imageNamed:@"person_suo"]];
        }else if (indexPath.row == 3){
            rowIconCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"banbengengxin"];
            rowIconCell.cellContentLabel.text = [AppDelegate getURLWithKey:@"youxingbanbenxuyaogengxin"];
            if (![NSString isBlankString:_filePath]) {
                rowIconCell.cellNewImageView.hidden = NO;
            }else{
                rowIconCell.cellNewImageView.hidden = YES;
            }
            [rowIconCell.cellIcon setImage:[UIImage imageNamed:@"person_update"]];
        }
        
        return rowIconCell;
    }

    
    PersonRowTableViewCell *rowCell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            rowCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"Setting"];
            rowCell.cellContentLabel.text = @"";
            rowCell.cellNewImageView.hidden = YES;
        }else if (indexPath.row == 1){
            //rowCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@""]@"Guanyu", nil);
            rowCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"yuyanqiehuan"];
            rowCell.cellContentLabel.text =  [AppDelegate getURLWithKey:@"qiehuan"];
            rowCell.cellNewImageView.hidden = YES;
        }
    }
    return rowCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0f;
    }
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *tmpView = [[UIView alloc]init];
        tmpView.backgroundColor = [UIColor clearColor];
        [tmpView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15.0f)];
        return tmpView;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        //信息
        if (indexPath.row == 1) {
            PersonXinxiViewController *xinxiVC = [[PersonXinxiViewController alloc]init];
            xinxiVC.hidesBottomBarWhenPushed = YES;
            xinxiVC.userModel = self.userModel;
            [self.navigationController pushViewController:xinxiVC animated:YES];
        }else if (indexPath.row == 2){
            PersonPassWordController *passVC = [[PersonPassWordController alloc]init];
            passVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:passVC animated:YES];
        }else if (indexPath.row == 3){
            [self gotoUPdateViersion];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
            
        //语言切换
        }else if (indexPath.row == 1){
            [self showSexActionSheet];
        }
    }
}


- (void)showSexActionSheet {
    //[self resignKeyboard];
    UIActionSheet *sexActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:[AppDelegate getURLWithKey:@"quxiao"]
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:[AppDelegate getURLWithKey:@"hanyu"], [AppDelegate getURLWithKey:@"zangyu"], nil];
    sexActionSheet.tag = 101;
    sexActionSheet.delegate = self;
    [sexActionSheet showInView:self.view];
}


#pragma mark - Photo/Library
- (void)showActionSheet {
    //[self resignKeyboard];
    self.getPhotosSheet = [[UIActionSheet alloc] initWithTitle:[AppDelegate getURLWithKey:@"xiugaitouxiang"]
                                                      delegate:self
                                             cancelButtonTitle:[AppDelegate getURLWithKey:@"quxiao"]
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:[AppDelegate getURLWithKey:@"dakaixiangji"], [AppDelegate getURLWithKey:@"dakixiangce"], nil];
    self.getPhotosSheet.tag = 100;
    self.getPhotosSheet.delegate = self;
    [self.getPhotosSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 101) {
        switch (buttonIndex)
        {
            case 0:
                //sexInputStr = [AppDelegate getURLWithKey:@"nan"];
                if (!APP_DELEGATE.isHan) {
                    return;
                }
                
                [self getServerLaunuage];

                break;
            case 1:
                //sexInputStr = [AppDelegate getURLWithKey:@"nv"];
                if (APP_DELEGATE.isHan) {
                    return;
                }
                
                [self getServerLaunuage];

                break;
        }
        
    }else{
        switch (buttonIndex)
        {
            case 0:  //打开照相机拍照
                [self takePhotos];
                break;
            case 1:  //打开本地相册
                [self getLocalPhotos];
                break;
        }
    }
}



-(void)getServerLaunuage{
    NSInteger serverType = 1;
    if (APP_DELEGATE.isHan) {
        serverType = 1;
    }else{
        serverType = 2;
    }
    
    
    [[PromptBox sharedBox] showLoadingWithText:[NSString stringWithFormat:@"%@...",[AppDelegate getURLWithKey:@"qiehuanzhong"]] onView:self.view];
    [HanZhaoHua MYGetLaungeWithType:serverType Success:^(NSDictionary * _Nonnull responseObject) {
        
        [[PromptBox sharedBox] removeLoadingView];

        
        NSString *type = @"";
        if (APP_DELEGATE.isHan) {
            APP_DELEGATE.isHan = NO;
            type = @"1";
        }else{
            APP_DELEGATE.isHan = YES;
            type = @"2";
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:type forKey:@"MYLaunuage"];
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationChangeLaunuageNoti object:nil];
        
    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"qiehuanshibai"] ToView:self.view];
    }];
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TAB_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        //_table.tableFooterView = self.footerView;
        
        [_table registerClass:[PersonMidTableViewCell class] forCellReuseIdentifier:@"midCell"];
        [_table registerClass:[PersonRowTableViewCell class] forCellReuseIdentifier:@"rowCell"];
        [_table registerClass:[PersonRowWithIconCell class] forCellReuseIdentifier:@"rowIconCell"];

        //
    }
    return _table;
}

-(void)refreshViewWithData{
    NSString *headerurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.userModel.headImg];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headerurl] placeholderImage:[UIImage imageNamed:@"exam_header"]];
    [self.nameLabel setText:self.userModel.pmName];
    [self.descibeLabel setText:self.userModel.motto];
    [self.signButton setTitle:[AppDelegate getURLWithKey:@"qiandao"] forState:UIControlStateNormal];

    if (self.signModel) {        
        self.signLabel.text = [NSString stringWithFormat:@"%@%@%@，%@",[AppDelegate getURLWithKey:@"yiqiandao"],self.signModel.totalSignIn,[AppDelegate getURLWithKey:@"tian"],[AppDelegate getURLWithKey:@"qingjixubaochi"]];
    }
}


-(UIView *)headerView{
    if(!_headerView){
        CGFloat topSpace = 25.0f;
        CGFloat iconWH = 60.0f;
        CGFloat cameraWH = 30.0f;
        CGFloat describeLabelH = 16.0f;
        CGFloat bottonViewH = 40.0f;
        
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor redColor];
        _headerView = headerView;
        [_headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, topSpace+iconWH+cameraWH+describeLabelH+25+bottonViewH)];
        
        
//        UIImageView *settingImageView = [[UIImageView alloc]init];
//        [_headerView addSubview:settingImageView];
//        [settingImageView setContentMode:UIViewContentModeCenter];
//        [settingImageView setImage:[UIImage imageNamed:@"setting"]];
//        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
//        settingImageView.userInteractionEnabled = YES;
//        [settingImageView addGestureRecognizer:tap1];
//        [settingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_headerView).offset(topSpace);
//            make.right.equalTo(_headerView.mas_right).offset(-25);
//            make.height.with.mas_equalTo(settingWH);
//        }];
        
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        [iconImageView setBackgroundColor:[UIColor whiteColor]];
        [_headerView addSubview:iconImageView];
        [iconImageView setContentMode:UIViewContentModeScaleToFill];
        [iconImageView setImage:[UIImage imageNamed:@"exam_header"]];
        iconImageView.layer.masksToBounds = YES;
        iconImageView.layer.cornerRadius = iconWH/2.0;
        self.iconImageView = iconImageView;
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(topSpace);
            make.centerX.equalTo(_headerView);
            make.height.width.mas_equalTo(iconWH);
        }];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        iconImageView.userInteractionEnabled = YES;
        [iconImageView addGestureRecognizer:tap2];
        
        
        UIImageView *cameraImageView = [[UIImageView alloc]init];
        [_headerView addSubview:cameraImageView];
        [cameraImageView setContentMode:UIViewContentModeCenter];
        [cameraImageView setImage:[UIImage imageNamed:@"camara"]];
        [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(0);
            make.right.equalTo(iconImageView.mas_centerX).offset(-6);
            make.height.width.mas_equalTo(cameraWH);
        }];

        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.text = @"张三";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [_headerView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_centerX).offset(6);
            make.centerY.equalTo(cameraImageView);
        }];

        
        UILabel *descibeLabel = [[UILabel alloc] init];
        descibeLabel.font = [UIFont systemFontOfSize:14.0f];
        descibeLabel.numberOfLines = 0;
        descibeLabel.text = @"谁说蓝色代表悲伤，你看看天空和海洋";
        descibeLabel.textColor = [UIColor whiteColor];
        descibeLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:descibeLabel];
        self.descibeLabel = descibeLabel;
        [descibeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cameraImageView.mas_bottom);
            make.centerX.equalTo(_headerView);
            make.width.mas_equalTo(SCREEN_WIDTH-30.0);
            make.height.mas_equalTo(describeLabelH);
        }];
        
        
        UIView *bottonView = [[UIView alloc]init];
        bottonView.backgroundColor = [UIColor colorWithRed:226/255.0 green:53/255.0 blue:66/255.0 alpha:1];
        [_headerView addSubview:bottonView];
        [bottonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(0);
            make.top.equalTo(descibeLabel.mas_bottom).offset(25.0f);
            make.right.equalTo(_headerView).offset(0);
            make.height.mas_equalTo(bottonViewH);
        }];
        
        
        UIButton *signButton = [[UIButton alloc]init];
        signButton.backgroundColor = [UIColor colorWithRed:226/255.0 green:53/255.0 blue:66/255.0 alpha:1];
        [signButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
        signButton.layer.masksToBounds = YES;
        signButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        signButton.layer.borderWidth = 0.5f;
        signButton.layer.cornerRadius = 4.0f;
        [signButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [signButton setTitle:[AppDelegate getURLWithKey:@"qiandao"] forState:UIControlStateNormal];
        self.signButton = signButton;
        CGFloat contentW = [PublicMethod getTheWidthOfTheLabelWithContent:[AppDelegate getURLWithKey:@"qiandao"] font:14.0f]+2;
        if (contentW < 50) {
            contentW = 50;
        }
        [bottonView addSubview:signButton];
        [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottonView).offset(25.0f);
            make.centerY.equalTo(bottonView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(contentW+10);
        }];
        
        
        UILabel *signLabel = [[UILabel alloc] init];
        signLabel.font = [UIFont systemFontOfSize:12.0f];
        signLabel.text = @"已签到13天，请继续保持呦！";
        signLabel.textColor = [UIColor whiteColor];
        signLabel.textAlignment = NSTextAlignmentLeft;
        [bottonView addSubview:signLabel];
        self.signLabel = signLabel;
        [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(signButton.mas_right).offset(16.0f);
            make.centerY.equalTo(signButton);
        }];
    }
    return _headerView;
}

-(UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [footerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_SCALE*(50+25)+40)];
        _footerView = footerView;
        
        UIButton *outButton = [[UIButton alloc]init];
        outButton.backgroundColor = [UIColor whiteColor];
        [outButton addTarget:self action:@selector(signOutAction:) forControlEvents:UIControlEventTouchUpInside];
        outButton.layer.masksToBounds = YES;
        outButton.layer.borderColor = [UIColor colorWithHexString:@"#D64348"].CGColor;
        outButton.layer.borderWidth = 0.5f;
        [outButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [outButton setTitleColor:[UIColor colorWithHexString:@"#FF0000"] forState:UIControlStateNormal];
        [outButton setTitle:[AppDelegate getURLWithKey:@"tuichu"] forState:UIControlStateNormal];
        outButton.layer.cornerRadius = 4.0f;
        [_footerView addSubview:outButton];
        
        [outButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(HEIGHT_SCALE*50);
            make.centerX.equalTo(_footerView);
            make.width.mas_equalTo(WIDTH_SCALE*300);
            make.height.mas_equalTo(40.0f);
        }];
        
    }
    return _footerView;
}

//退出登录
-(void)signOutAction:(UIButton *)sender{
    [self MYSignOutSerVer];
}

-(void)MYSignOutSerVer{
    [[PromptBox sharedBox] showLoadingWithText:[NSString stringWithFormat:@"%@...",[AppDelegate getURLWithKey:@"jiazaizhong"]] onView:self.view];

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [HanZhaoHua MYLogOutWithParaDic:paraDic success:^(NSDictionary * _Nonnull responseObject) {
        [[PromptBox sharedBox] removeLoadingView];

        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationUserSignOut object:nil];
    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"tuichushibai"] ToView:self.view];
    }];
}

-(void)sign:(UIButton *)sender{
    SigninRecordViewController *signRecordVC = [[SigninRecordViewController alloc]init];
    signRecordVC.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:signRecordVC animated:YES];
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    [self showActionSheet];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    self.title = [AppDelegate getURLWithKey:@"Gerenzhongxin"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context{
    NSInteger new = [[change objectForKey:@"new"] integerValue];
    
    //数据渲染
    if (new == 3) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        
        [self refreshViewWithData];
        [self.table reloadData];
    }
    
}

-(void)freshPersonViewSource:(NSNotification *)noti{
    [self refershHeader];
}

-(void)showUpdateViewWindow{
    
}


-(void)takePhotos {
    __weak typeof(self) weakSelf = self;
    
    if (self.images.count) {
        [self.images removeAllObjects];
    }
    
    [EWTMediator EWTImagePicker_getImageFromCameraWithController:self authorityType:SystemAuthorityVideo allowCrop:NO completion:^(NSArray<UIImage *> *images) {
        UIImage* originalImg = [images firstObject];
        if (originalImg) {
            // 原图压缩处理（要求最多压缩2次将图片不然延迟感太强）
            CGFloat compressionQuality = 0.05f;
            NSData *compressedImgData = UIImageJPEGRepresentation(originalImg, 1.0f);
            if ((compressedImgData.length / 1024.0f) > 200.0f) {
                compressedImgData = UIImageJPEGRepresentation(originalImg, compressionQuality);
            }
            // 将压缩后的图片重新赋值给原图片
            originalImg = [UIImage imageWithData:compressedImgData];
            // 将图片添加到数组中
            [weakSelf.images addObject:originalImg];
            
            
            UIImage *imageOrigin = weakSelf.images[0];
            UIImage *imageNew = [weakSelf imageWithOriginalImage:imageOrigin andScaledSize:CGSizeMake(60, 60)];
            [self.images removeAllObjects];
            [self.images addObject:imageNew];
        }
        
        [self uploadImageToServer];
        //[weakSelf showImagesView];
    }];
}

-(void)getLocalPhotos {
    __weak typeof(self) weakSelf = self;
    
    if (self.images.count) {
        [self.images removeAllObjects];
    }
    
    [EWTMediator EWTImagePicker_getImageFromLibraryWithController:self maxNum:kMaxCount allowCrop:YES completion:^(NSArray<UIImage *> *images) {
        if (images && images.count > 0) {
            [weakSelf.images addObjectsFromArray:images];
            UIImage *imageOrigin = weakSelf.images[0];
            UIImage *imageNew = [weakSelf imageWithOriginalImage:imageOrigin andScaledSize:CGSizeMake(60, 60)];
            [self.images removeAllObjects];
            [self.images addObject:imageNew];
            [self uploadImageToServer];
            //[weakSelf showImagesView];
        }
    }];
}



-(void)uploadImageToServer{
    // 文件上传
    //测试结果:
    if (self.images.count) {
        [[PromptBox sharedBox] showLoadingWithText:[AppDelegate getURLWithKey:@"shangchuanzhong"] onView:self.view];
        
        UIImage *image = self.images[0];
        NSData *data = UIImagePNGRepresentation(image);
        
        [HanZhaoHua uploadFileWithFiles:data success:^(NSString * _Nonnull imgUrl) {
            
            headerImageUrl = [imgUrl copy];
            
            [self savePersonSource];
            
        } failure:^(NSError * _Nonnull error) {
            [[PromptBox sharedBox] removeLoadingView];
            [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"saveError"] ToView:self.view];
        }];
    }
    
}


-(void)savePersonSource{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [para setValue:APP_DELEGATE.userId forKey:@"userId"];
    [para setValue:headerImageUrl forKey:@"headImg"];
    [para setValue:self.userModel.motto forKey:@"motto"];
    [para setValue:self.userModel.pmAddress forKey:@"address"];
    [para setValue:self.userModel.pmSex forKey:@"sex"];
    
    
    [HanZhaoHua savePersonalSourceWithPara:para success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        [[PromptBox sharedBox] removeLoadingView];
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"saveSuccess"] ToView:self.view];
        
        self.userModel.headImg = headerImageUrl;
        APP_DELEGATE.userModel.headImg = headerImageUrl;
        NSString *headerurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.userModel.headImg];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headerurl] placeholderImage:[UIImage imageNamed:@"exam_header"]];
        
    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"saveError"] ToView:self.view];
    }];
    
}



-(UIImage *)imageWithOriginalImage:(UIImage *)originalImage andScaledSize:(CGSize)imageNewSize{
    UIGraphicsBeginImageContext(imageNewSize);
    [originalImage drawInRect:CGRectMake(0, 0, imageNewSize.width, imageNewSize.height)];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}


- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        return _images;
    }
    return _images;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)changeLuanguageAction:(NSNotification *)noti{
    self.title = [AppDelegate getURLWithKey:@"Gerenzhongxin"];
    
    [self refershHeader];
}


-(void)dealloc{
    [self removeObserver:self forKeyPath:@"serverCount"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
