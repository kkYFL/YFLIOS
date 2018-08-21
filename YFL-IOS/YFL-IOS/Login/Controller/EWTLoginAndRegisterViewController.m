//
//  EWTLoginAndRegisterViewController.m
//  AFNetworking
//
//  Created by 李天露 on 2018/4/4.
//

#import "EWTLoginAndRegisterViewController.h"
#import "EWTBase.h"
#import "EWTLoginView.h"
//#import "UserCenterHTTPEngineGuide.h"
#import "PublicMethod.h"



@interface EWTLoginAndRegisterViewController ()<UIAlertViewDelegate>

@property(nonatomic ,strong) UIView* headerViewBg;
@property(nonatomic ,strong) UIImageView *headerImage;
@property(nonatomic ,strong) UIButton* loginBtn;
@property(nonatomic ,strong) UIButton* selectedBtn;
@property(nonatomic ,strong) UIImageView* triangleView;
@property(nonatomic ,strong) EWTLoginView* loginView;


@end

@implementation EWTLoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _configHeaderView];
    
    [self _configLoginView];
    
    [self _configRegisterView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:6 animations:^{
        self.headerImage.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
}

- (void)_configHeaderView {
    UIView* headerViewBg = [[UIView alloc] init];
    headerViewBg.layer.masksToBounds = YES;
    self.headerViewBg = headerViewBg;
    [self.view addSubview:headerViewBg];
    [headerViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(@(StandardBy6(160)));
    }];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    self.headerImage = headerImage;
    headerImage.image = [UIImage imageNamed:@"login-bg"];
    [headerViewBg addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(headerViewBg);
    }];
    
    UILabel* titleLab = [[UILabel alloc] init];
    titleLab.text = @"登陆页面";
    titleLab.textColor = HEXACOLOR(0xFFFFFF, 1.0);
    titleLab.font = [UIFont boldSystemFontOfSize:23];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [headerViewBg addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerViewBg).offset(57);
        make.height.mas_equalTo(@24);
        make.width.lessThanOrEqualTo(@200);
        make.centerX.equalTo(headerViewBg);
    }];
    
    UIButton* loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn = loginBtn;
    loginBtn.titleLabel.font = KFont(16);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:HEXACOLOR(0xFFFFFF, 1.0) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 100;
    [headerViewBg addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerViewBg.mas_bottom).offset(-20);
        make.height.mas_equalTo(@16);
        make.width.lessThanOrEqualTo(@50);
        make.centerX.equalTo(headerViewBg.mas_centerX).multipliedBy(0.5);
    }];
    self.selectedBtn = loginBtn;
    
    UIButton* registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.titleLabel.font = KFont(16);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:HEXACOLOR(0xFFFFFF, 1.0) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.tag = 101;
    [headerViewBg addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerViewBg.mas_bottom).offset(-20);
        make.height.mas_equalTo(@16);
        make.width.lessThanOrEqualTo(@50);
        make.centerX.equalTo(headerViewBg.mas_centerX).multipliedBy(1.5);
    }];
    
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXACOLOR(0xFFFFFF, 1.0);
    [headerViewBg addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headerViewBg.mas_bottom).offset(-20);
        make.height.mas_equalTo(@16);
        make.width.mas_equalTo(@1);
        make.centerX.equalTo(headerViewBg);
    }];
    
    UIImageView* triangleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-choose"]];
    self.triangleView = triangleView;
    [headerViewBg addSubview:triangleView];
}

- (void)_configLoginView {
    EWTLoginView* loginView = [[EWTLoginView alloc] init];
    loginView.backgroundColor = [UIColor whiteColor];
    loginView.hidden = NO;
    self.loginView = loginView;
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerViewBg.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    @weakify(self)
    [loginView setLoginBtnBlock:^(UIButton *btn) {
        [weak_self doLogin];
    }];
}

- (void)_configRegisterView {

    
}

- (void)viewDidLayoutSubviews {
    self.triangleView.frame = CGRectMake(0, CGRectGetMaxY(self.headerViewBg.frame) - 7, 14, 7);
    self.triangleView.centerX = self.selectedBtn.centerX;
}

#pragma mark 登录/注册切换
- (void)switchBtnClick:(UIButton*)btn {
    self.selectedBtn = btn;
    if (btn.tag == 100) {
        self.loginView.hidden = NO;
    }else {
        self.loginView.hidden = YES;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.triangleView.centerX = self.selectedBtn.centerX;
    }];
}


#pragma mark 注册
- (void)doRegister {
//    [MobClick event:@"user_register_next"];
//
//    // 不要删除一下内容
//    if (!(self.registerView.passwordField.text.length >= 6 && self.registerView.passwordField.text.length <= 16) ) {
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入范围内的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alter show];
//    } else if (self.registerView.phoneAndIDField.text.length == 0){
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alter show];
//    } else {
//        [[NSUserDefaults standardUserDefaults] setObject:self.registerView.phoneAndIDField.text forKey:@"user_name"];
//
//        [[PromptBox sharedBox] showLoadingWithText:@"请稍等..." onView:self.view];
//        [UserCenterHTTPEngineGuide getServerDateWithSuccess:^( NSDictionary *responseObject) {
//            NSString *code = [[responseObject objectForKey:@"Code"] stringValue];
//            if ([code isEqualToString:@"200"]) {
//                NSString *date = [PublicMethod serverDateformatWithSecond:[[responseObject objectForKey:@"Timestamp"] stringValue]];
//                [UserCenterHTTPEngineGuide userRegisterWithPhoneNumber:self.registerView.phoneAndIDField.text
//                                                              password:self.registerView.passwordField.text
//                                                          securityCode:self.registerView.securityField.text
//                                                                  date:date
//                                                               success:^( NSDictionary *responseObject) {
//                                                                   [self registerSuccessWithData:responseObject];
//                                                               } failure:^( NSError *error) {
//                                                                   [[PromptBox sharedBox] removeLoadingView];
//                                                                   [[PromptBox sharedBox] showTextPromptBoxWithText:error.localizedDescription onView:self.view withTime:2];
//                                                               }];
//            } else {
//                [[PromptBox sharedBox] removeLoadingView];
//                [[PromptBox sharedBox] showTextPromptBoxWithText:[EWTUserInfo getServerCodeDescriptionWithCode:code] onView:self.view];
//            }
//        } failure:^( NSError *error) {
//            [[PromptBox sharedBox] removeLoadingView];
//            [[PromptBox sharedBox] showTextPromptBoxWithText:error.localizedDescription onView:self.view withTime:2];
//        }];
//    }
}


#pragma mark 登录
- (void)doLogin{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationAccessHomeWindow object:nil];
    

    
    // 获取服务器Date
//    [[PromptBox sharedBox] showLoadingWithText:@"请稍等..." onView:self.view];
//    @weakify(self);
//    [UserCenterHTTPEngineGuide getServerTimestampBack:^(NSString *serverTimeStamp) {
//
//        /****记录第一次登录时间*****/
//        NSUserDefaults *loginFirstTime = [NSUserDefaults standardUserDefaults];
//        [loginFirstTime setObject:serverTimeStamp forKey:@"loginTime"];
//        [loginFirstTime synchronize];
//        [UserCenterHTTPEngineGuide loginAndGetUserInfoWithTimestamp:serverTimeStamp
//                                                           username:weak_self.loginView.phoneAndIDField.text
//                                                           password:weak_self.loginView.passwordField.text
//                                                            Success:^(NSDictionary *responseObject) {
//
//                                                                NSInteger code = [[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]] integerValue];
//
//                                                                if (code == 200) {
//                                                                    self.loginView.errorCount = 0;
//                                                                    if ([[[responseObject objectForKey:@"data"] objectForKey:@"member"] isKindOfClass:[NSDictionary class]]) {
//                                                                        [EWTUserInfo shareInstance].touristsMode = NO;
//                                                                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[responseObject objectForKey:@"data"] objectForKey:@"member"]];
//
//
//                                                                        PersonalInfoModel *per = [[PersonalInfoModel alloc] initWithDic:dic];
//                                                                        [EWTUserInfo shareInstance].personalInfo = per;
//                                                                        [EWTUserInfo shareInstance].qqIsLogin = NO;
//
//                                                                        //对个人信息进行保存
//                                                                        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//                                                                        NSString *nst = [dic objectForKey:@"photourl"];
//
//                                                                        if ([nst isEqual:[NSNull null]]) {
//                                                                            [dic setObject:@"" forKey:@"photourl"];
//                                                                        }
//                                                                        NSString *nstqq = [dic objectForKey:@"qq"];
//                                                                        if([nstqq isEqual:[NSNull null]]) {
//                                                                            [dic setObject:@"" forKey:@"qq"];
//                                                                        }
//
//                                                                        NSString *nsttel = [dic objectForKey:@"tel"];
//                                                                        if([nsttel isEqual:[NSNull null]]) {
//                                                                            [dic setObject:@"" forKey:@"tel"];
//                                                                        }
//
//
//                                                                        [userDef setObject:dic forKey:@"user"];
//
//                                                                        [userDef setObject:@"2" forKey:@"changeNetwork"];//关闭
//                                                                        [userDef setObject:@"2" forKey:@"downloadNetWork"];//关闭
//                                                                        NSString *showSignDis = [NSString stringWithFormat:@"showSign_%@",[EWTUserInfo shareInstance].personalInfo.userid];
//                                                                        [userDef setObject:@"2" forKey:showSignDis];//打开
//                                                                        [userDef setObject:@"YES" forKey:@"touristsBuySuccessButNoPhone"];//游客购买成功且绑定手机号||正常登陆也为YES
//                                                                        [userDef synchronize];
//
//
//                                                                        NSUserDefaults *userIDAndToken = [NSUserDefaults standardUserDefaults];
//                                                                        //记录用户名
//                                                                        [userIDAndToken setObject:weak_self.loginView.phoneAndIDField.text forKey:@"user_name"];
//                                                                        //记录密码
//                                                                        [userIDAndToken setObject:weak_self.loginView.passwordField.text forKey:@"user_password"];
//
//
//                                                                        //通过historicaltype字段 1:过期  0:未过期
//                                                                        NSString *str = [NSString stringWithFormat:@"%d", per.historicaltype];
//                                                                        //通过返回值cardType判断账号是否激活, 否,跳到激活界面
//                                                                        NSString *userCardType = [NSString stringWithFormat:@"user_card_type_%@", per.userid];
//                                                                        [userIDAndToken setObject:str forKey:userCardType];
//
//                                                                        [userIDAndToken synchronize];
//
//
//                                                                        // 初始化大数据SDK
//                                                                        [EWTUserInfo initDataStatistics];
//
//                                                                        // 大数据User ID埋点
//                                                                        [BigDataEngineService setMemberId:[EWTUserInfo shareInstance].personalInfo.userid];
//
//
//                                                                        //大数据上传所有信息
//                                                                        [[DataStatisticsEngine sharedEngine] reportServerAllEventSource];
//
//
//                                                                        //先判断是否过期
//                                                                        if ([str isEqualToString:@"1"]) {
//                                                                            [EWTUserCenterUserDefaultObject mistong_setRegisteredUsersWithWhether:NO];
//                                                                            [EWTUserCenterUserDefaultObject mistong_setOverdueWithWhether:YES];
//                                                                        } else {
//                                                                            //再判断是否为注册用户
//                                                                            if ([per.accessType isEqualToString:@"0"]) {
//
//                                                                                [EWTUserCenterUserDefaultObject mistong_setRegisteredUsersWithWhether:YES];
//                                                                                [EWTUserCenterUserDefaultObject mistong_setOverdueWithWhether:NO];
//                                                                            } else {
//                                                                                [EWTUserCenterUserDefaultObject mistong_setRegisteredUsersWithWhether:NO];
//                                                                                [EWTUserCenterUserDefaultObject mistong_setOverdueWithWhether:NO];
//                                                                            }
//
//                                                                        }
//
//                                                                        [EWTUserInfo requestPersonalInfo];
//
//                                                                        //判断为登陆成功后进入首页，无需数据验证，进行个推数据的绑定
//                                                                        if ([EWTUserInfo shareInstance].personalInfo.issecure == 1) {
//                                                                            //个推上传CID
//                                                                            if ([EWTUserInfo shareInstance].getuiCid.length) {
//                                                                                [UserCenterHTTPEngineGuide GeTuiReportCidToServerWithCid:[EWTUserInfo shareInstance].getuiCid];
//                                                                            }
//
//                                                                            //登陆后个推绑定别名
//                                                                            NSString *alias = [NSString stringWithFormat:@"%zd",[[EWTUserInfo shareInstance].personalInfo.userid integerValue]^signKey3];
//                                                                            NSString *sequenceNum = [alias stringByAppendingString:@"-sign"];
//
//                                                                            [EWTMediator NewsPush_GetTuiBindAlias:alias ASn:sequenceNum];
//
//                                                                        }
//
//                                                                        //新需求, (淘宝合买) 判断账号或者密码的状态
//                                                                        [self judgeAccountNumberStaus];
//
//
//
//                                                                    }
//                                                                } else {
//                                                                    self.loginView.errorCount++;
//                                                                    if (self.loginView.errorCount >= 3) {
//                                                                        UIAlertView* alt = [[UIAlertView alloc] initWithTitle:nil message:@"不记得账号密码了？\n快速找回密码，去吧！皮卡丘~" delegate:self cancelButtonTitle:@"我再想想" otherButtonTitles:@"去找回", nil];
//                                                                        alt.tag = 1001;
//                                                                        [alt show];
//
//                                                                    }else {
//                                                                        [[PromptBox sharedBox] showTextPromptBoxWithText:[responseObject objectForKey:@"msg"] onView:self.view];
//                                                                    }
//                                                                }
//                                                                [[PromptBox sharedBox] removeLoadingView];
//
//                                                            } failure:^(NSError *error) {
//
//                                                                [[PromptBox sharedBox] removeLoadingView];
//                                                                [[PromptBox sharedBox] showTextPromptBoxWithText:error.localizedDescription onView:self.view withTime:2];
//                                                            }];
//    }];
    
}

- (void)judgeAccountNumberStaus {
//    [[PromptBox sharedBox] removeLoadingView];
//
//
//    if ([EWTUserInfo shareInstance].personalInfo.issecure == 1) {
//        NSString *str = [NSString stringWithFormat:@"%d", [EWTUserInfo shareInstance].personalInfo.historicaltype];
//        [self judgeLoginWithCardType:str];
//    } else {
//        SecurityCenterViewController *security = [[SecurityCenterViewController alloc] init];
//        if ([EWTUserInfo shareInstance].personalInfo.jumptarget == 1) {
//            security.vcType = CheckPhoneNumber;
//        } else if ([EWTUserInfo shareInstance].personalInfo.jumptarget == 2) {
//            security.vcType = ChangePassword;
//        } else if ([EWTUserInfo shareInstance].personalInfo.jumptarget == 3) {
//            security.vcType = BindPhoneNumber;
//        } else {
//
//        }
//        self.loginView.passwordField.text = @"";
//        [self.navigationController pushViewController:security animated:YES];
//    }
}

- (void)judgeLoginWithCardType:(NSString *)cardType{
    
    // 进入主界面
//    [EWTMediator AppContext_showTabBarController];
}

#pragma mark 注册成功界面
- (void)registerSuccessWithData:(NSDictionary *)responseObject {
//    NSString *string = [[responseObject objectForKey:@"Code"] stringValue];
//    //成功跳入下一页面
//    if ([string isEqualToString:@"200"]) {
//        [[PromptBox sharedBox] removeLoadingView];
//
//        [EWTUserInfo shareInstance].touristsMode = NO;
//        //对token和userid进行保存
//        NSString *string = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"Token"]];
//        [EWTUserInfo shareInstance].personalInfo.userid = [[responseObject objectForKey:@"UserId"] stringValue];
//        [EWTUserInfo shareInstance].personalInfo.token = string;
//
//        NSUserDefaults *userIDAndToken = [NSUserDefaults standardUserDefaults];
//        //注册用户
//        [EWTUserCenterUserDefaultObject mistong_setRegisteredUsersWithWhether:YES];
//        [EWTUserCenterUserDefaultObject mistong_setOverdueWithWhether:NO];
//        [[NSUserDefaults standardUserDefaults] setObject:self.registerView.phoneAndIDField.text forKey:@"user_name"];
//        [userIDAndToken synchronize];
//
//        // 初始化大数据SDK
//        [EWTUserInfo initDataStatistics];
//        // 大数据User ID埋点
//        [BigDataEngineService setMemberId:[EWTUserInfo shareInstance].personalInfo.userid];
//
//        //大数据上传所有信息
//        [[DataStatisticsEngine  sharedEngine] reportServerAllEventSource];
//
//
//        //个推上传CID
//        if ([EWTUserInfo shareInstance].getuiCid.length) {
//            [UserCenterHTTPEngineGuide GeTuiReportCidToServerWithCid:[EWTUserInfo shareInstance].getuiCid];
//        }
//
//        //登陆后个推绑定别名
//        NSString *alias = [NSString stringWithFormat:@"%zd",[[EWTUserInfo shareInstance].personalInfo.userid integerValue]^signKey3];
//        NSString *sequenceNum = [alias stringByAppendingString:@"-sign"];
//
//        [EWTMediator NewsPush_GetTuiBindAlias:alias ASn:sequenceNum];
//
//        //[self gotoJoinClassVC];
//        [self nextVCToB];
//
//    } else{
//        [[PromptBox sharedBox] removeLoadingView];
//        [[PromptBox sharedBox] showTextPromptBoxWithText:[EWTUserInfo getServerCodeDescriptionWithCode:string] onView:self.view];
//    }
}

- (void)gotoJoinClassVC {
//    EWTJoinClassViewController* joinClassVC = [[EWTJoinClassViewController alloc] init];
//    [self.navigationController pushViewController:joinClassVC animated:YES];
}

#pragma mark 请求个人信息
- (void)nextVCToB {
//
//    [UserCenterHTTPEngineGuide getPersonalInformationWithSuccess:^( NSDictionary *responseObject) {
//        [[PromptBox sharedBox] removeLoadingView];
//        NSString *code  = [[responseObject objectForKey:@"Code"] stringValue];
//        if ([code isEqualToString:@"200"]) {
//
//            PersonalInfoModel *per = [[PersonalInfoModel alloc] initWithDic:[responseObject objectForKey:@"Data"]];
//            [EWTUserInfo shareInstance].personalInfo = per;
//            [EWTUserInfo shareInstance].qqIsLogin = NO;
//            //对个人信息进行保存
//            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//            [userDef setObject:[responseObject objectForKey:@"Data"] forKey:@"user"];
//            [userDef setObject:@"YES" forKey:@"touristsBuySuccessButNoPhone"];//游客购买成功且绑定手机号||正常登陆也为YES
//            [userDef synchronize];
//
//            //进入主界面
//            [EWTMediator AppContext_showTabBarController];
//
//        } else {
//            [[PromptBox sharedBox] showTextPromptBoxWithText:@"获取个人信息失败, 请稍后重试" onView:self.view];
//        }
//    } failure:^( NSError *error) {
//        [[PromptBox sharedBox] removeLoadingView];
//        [[PromptBox sharedBox] showTextPromptBoxWithText:error.localizedDescription onView:self.view withTime:2];
//    }];
}


#pragma mark UIAlertView Delegate
//去验证激活界面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 1001) {
//        if (buttonIndex == 1) {
//            WZWebViewController *findPassword = [[WZWebViewController alloc] init];
//            NSString* url = [UserCenterHTTPEngineGuide lookForPassword];
//            findPassword.webUrl =  url;
//            if ([PublicMethod checkIsPhone:self.loginView.phoneAndIDField.text]) {
//                //回传手机号
//                findPassword.webUrl = [url stringByAppendingString:[NSString stringWithFormat:@"?phone=%@",self.loginView.phoneAndIDField.text]];
//            }
//            findPassword.title = @"密码找回";
//            findPassword.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:findPassword animated:YES];
//        }
//        self.loginView.errorCount = 0;
//    }
}

//隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

