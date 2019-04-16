//
//  AppDelegate.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/5/27.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "EducationViewController.h"
#import "FabuHomeViewController.h"
#import "ExamnationViewController.h"
#import "PersonalViewController.h"
#import "EWTLoginAndRegisterViewController.h"
#import "ICarouselViewController.h"
#import "TestInterface.h"
#import "GuideViewController.h"
#import "GuidenModel.h"
#import "LLTabBar.h"
#import "UpdateView.h"
#import "UpdateModel.h"
#import "AvoidCrash.h"


@interface AppDelegate ()<UITabBarControllerDelegate,SubjectViewDelegate>
@property (nonatomic, strong) NSMutableArray *guidenViewArr;
@property (nonatomic, strong) UIImageView *storyBoardView;
@property (nonatomic, strong) UpdateView *updateView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//配置域名
#ifdef DEBUG
    self.host = @"http://47.100.247.71/protal";
    self.sourceHost = @"http://47.100.247.71/img";
#else
    self.host = @"http://hnxzzb.imwork.net/protal";
    self.sourceHost = @"http://hnxzzb.imwork.net/img";
#endif
    
//    [self avoidCrash];
    
    //http://hnxzzb.qicp.vip
    
    self.host = @"http://hnxzzb.qicp.vip/protal";
    self.sourceHost = @"http://hnxzzb.qicp.vip/img";

    self.hasShowUpdate = NO;
    //
    [self initScreenView];
    
    
    
    
//     self.userToken = @"1";
//     self.userId = @"69b9aa05fbfb4cd1b6c8e9ee74397101";
//     self.host = @"http://47.100.247.71/protal";
//     self.sourceHost = @"http://47.100.247.71/img";
//     self.userName = @"15606811521";
//     self.password = @"123456";

    //[self tabBarViewInit];
    
    
//    UpdateView *updateView = [[UpdateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    updateView.delegate = self;
//    self.updateView = updateView;
    

    //语言配置
    //从缓存中读取
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *type = [defaults objectForKey:@"MYLaunuage"];
    if (type) {
        if ([type integerValue] == 1) {
            APP_DELEGATE.isHan = NO;
        }else{
            APP_DELEGATE.isHan = YES;
        }
    }
    
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAccessHomeWindow:) name:KNotificationAccessHomeWindow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appSignOut:) name:KNotificationUserSignOut object:nil];
    

    //读取信息
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginSource = [userdefaults objectForKey:@"myLoginSource"];
    //信息存在且没有退出操作，进入主页面
    if (loginSource) {
        UserMessage *userModel = [[UserMessage alloc]initWithDic:loginSource];
        APP_DELEGATE.userModel = userModel;
        APP_DELEGATE.userToken = APP_DELEGATE.userModel.userToken;
        APP_DELEGATE.userId = APP_DELEGATE.userModel.userId;
        APP_DELEGATE.userName = APP_DELEGATE.userModel.userName;
     
    //window
    [self tabBarViewInit];
     //启动图
    [self screenViewShow];

    //已经退出重新登录
    }else{
        [self guidenView];
        //启动图
        [self screenViewShow];
    }

    return YES;
}


-(void)avoidCrash {
    /*
     *  相比于becomeEffective，增加
     *  对”unrecognized selector sent to instance”防止崩溃的处理
     *
     *  但是必须配合setupClassStringsArr:使用
     */
    [AvoidCrash makeAllEffective];
    
    //项目中所防止unrecognized selector sent to instance的类有下面几个，主要是防止后台数据格式错乱导致的崩溃。
    //若要防止后台接口数据错乱，用下面的几个类即可。
    NSArray *noneSelClassStrings = @[
                                     @"NSNull",
                                     @"NSNumber",
                                     @"NSString",
                                     @"NSDictionary",
                                     @"NSArray"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
}

//AvoidCrash异常通知监听方法，在这里我们可以调用reportException方法进行上报
- (void)dealwithCrashMessage:(NSNotification *)notification {
    NSException *exception = [NSException exceptionWithName:@"AvoidCrash" reason:[notification valueForKeyPath:@"userInfo.errorName"] userInfo:notification.userInfo];
}


- (void)updateDelegate{
    self.updateView.hidden = YES;
}

-(void)tabBarViewInit{
    NewsViewController *newVC = [[NewsViewController alloc]init];
    EWTBaseNavigationController *newsNav = [self viewControllerWithTitle:[AppDelegate getURLWithKey:@"NewsHomeTitle"] image:[UIImage imageNamed:@"news_icon_gray"] selectedImage:[UIImage imageNamed:@"news_icon_light"] VC:newVC];

    
    
    
    EducationViewController *educationVC = [[EducationViewController alloc]init];
    EWTBaseNavigationController *educationNav = [self viewControllerWithTitle:[AppDelegate getURLWithKey:@"DangYuanEducationTitle"] image:[UIImage imageNamed:@"education_icon_gray"] selectedImage:[UIImage imageNamed:@"education_icon_light"] VC:educationVC];
    
    
    FabuHomeViewController *fabuVC = [[FabuHomeViewController alloc]init];
    EWTBaseNavigationController *fabuNav = [self viewControllerWithTitle:[AppDelegate getURLWithKey:@"zhibu"] image:[UIImage imageNamed:@"education_icon_gray"] selectedImage:[UIImage imageNamed:@"education_icon_light"] VC:fabuVC];
    
    
    
    ExamnationViewController *examtionVC = [[ExamnationViewController alloc]init];
    EWTBaseNavigationController *examtionNav = [self viewControllerWithTitle:[AppDelegate getURLWithKey:@"DangyuanKaoshi"] image:[UIImage imageNamed:@"exam_icon_gray"] selectedImage:[UIImage imageNamed:@"exam_icon_light"] VC:examtionVC];
    
    
    
    PersonalViewController *personalVC = [[PersonalViewController alloc]init];
    EWTBaseNavigationController *personalNav = [self viewControllerWithTitle:[AppDelegate getURLWithKey:@"Gerenzhongxin"] image:[UIImage imageNamed:@"person_icon_gray"] selectedImage:[UIImage imageNamed:@"person_icon_light"] VC:personalVC];
    
    
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.delegate = self;
    
    //普通党员
    if ([APP_DELEGATE.userModel.pmAuthor integerValue] == 5) {
        tabBar.viewControllers = @[newsNav,educationNav,examtionNav,personalNav];
    }else{
        tabBar.viewControllers = @[newsNav,educationNav,fabuNav,examtionNav,personalNav];
    }
    tabBar.tabBar.translucent = NO;
    
//    LLTabBar *tab = [[LLTabBar alloc] initWithFrame:tabBar.tabBar.bounds];
//
//    tab.tabBarItemAttributes = @[@{kLLTabBarItemAttributeTitle : [AppDelegate getURLWithKey:@""]@"NewsHomeTitle", nil), kLLTabBarItemAttributeNormalImageName : @"news_icon_gray", kLLTabBarItemAttributeSelectedImageName : @"news_icon_light", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
//                                    @{kLLTabBarItemAttributeTitle : [AppDelegate getURLWithKey:@""]@"DangYuanEducationTitle", nil), kLLTabBarItemAttributeNormalImageName : @"education_icon_gray", kLLTabBarItemAttributeSelectedImageName : @"education_icon_gray", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
//                                    @{kLLTabBarItemAttributeTitle : @"支部", kLLTabBarItemAttributeNormalImageName : @"mycity_normal", kLLTabBarItemAttributeSelectedImageName : @"mycity_highlight", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
//                                    @{kLLTabBarItemAttributeTitle : [AppDelegate getURLWithKey:@""]@"DangyuanKaoshi", nil), kLLTabBarItemAttributeNormalImageName : @"exam_icon_gray", kLLTabBarItemAttributeSelectedImageName : @"exam_icon_light", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)},
//                                    @{kLLTabBarItemAttributeTitle : [AppDelegate getURLWithKey:@""]@"Gerenzhongxin", nil), kLLTabBarItemAttributeNormalImageName : @"person_icon_gray", kLLTabBarItemAttributeSelectedImageName : @"person_icon_light", kLLTabBarItemAttributeType : @(LLTabBarItemNormal)}];
    
    //tab.delegate = self;
    //[tabBar.tabBar addSubview:tab];
        
    
    
    
    
    
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    [self.window setRootViewController:tabBar];
    [self.window makeKeyAndVisible];
}
    
-(void)showLoginAndRegistController {
    EWTLoginAndRegisterViewController *loginVC = [[EWTLoginAndRegisterViewController alloc] init];
    loginVC.title = [AppDelegate getURLWithKey:@"loginTitle"];
    EWTBaseNavigationController* nav = [[EWTBaseNavigationController alloc] initWithRootViewController:loginVC];

    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor redColor];
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [nav.navigationBar setTitleTextAttributes:dict];

    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
//
//    ICarouselViewController *loginVC = [[ICarouselViewController alloc] init];
//    EWTBaseNavigationController* nav = [[EWTBaseNavigationController alloc] initWithRootViewController:loginVC];
//    nav.navigationBar.translucent = NO;
//    nav.navigationBar.barTintColor = [UIColor grayColor];
//    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [nav.navigationBar setTitleTextAttributes:dict];
//
//    if (!self.window) {
//        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        [self.window setBackgroundColor:[UIColor whiteColor]];
//    }
//    self.window.rootViewController = nav;
//    [self.window makeKeyAndVisible];
}


- (EWTBaseNavigationController *)viewControllerWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage VC:(UIViewController *)VC{
    VC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.title = title;
    EWTBaseNavigationController *nav = [[EWTBaseNavigationController alloc] initWithRootViewController:VC];
    nav.navigationBar.translucent = NO;
    nav.navigationBar.barTintColor = [UIColor redColor];
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [nav.navigationBar setTitleTextAttributes:dict];
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:229/255.0f green:28/255.0f blue:35/255.0f alpha:0.5f]} forState:UIControlStateNormal];
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:229/255.0f green:28/255.0f blue:35/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    return nav;
 
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
    
    
#pragma mark - 通知
-(void)appAccessHomeWindow:(NSNotification *)noti{
    [self tabBarViewInit];
}

-(void)appSignOut:(NSNotification *)noti{
    EWTLoginAndRegisterViewController *loginVC = [[EWTLoginAndRegisterViewController alloc] init];
    EWTBaseNavigationController* nav = [[EWTBaseNavigationController alloc] initWithRootViewController:loginVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"user_center_navigationBar_background"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
    nav.navigationBar.translucent = NO;
    

    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
}

-(UIWindow *)window{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window setBackgroundColor:[UIColor whiteColor]];
    }
    return _window;
}

-(void)guidenView{
    GuideViewController *vc = [[GuideViewController alloc]init];
    vc.videoOrImageType = imageTpye;
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

+ (BOOL)isHasShowGuidenVersion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"hasGuiden"]) {
        return YES;
    }
    return NO;
}

-(void)initScreenView{
    self.storyBoardView.backgroundColor = [UIColor whiteColor];
}
-(void)ScreenViewSource{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:@"HNX_SCREEN" forKey:@"config"];
    
    [HanZhaoHua GetAPPGuidenViewImageSourceWithParaDic:para success:^(NSDictionary * _Nonnull responseObject) {
        NSArray *arr = [responseObject objectForKey:@"data"];
        if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
            NSDictionary *tmpDic = arr[0];
            NSString *urlStr = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"imgUrl"]];
            
            //从缓存中读取
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *screenURL = [defaults objectForKey:myScreenImageURL];
            //第一次进入程序显示图片
            if ([NSString isBlankString:screenURL]) {
                NSURL *imageUrl = ([urlStr hasPrefix:@"http"])?[NSURL URLWithString:urlStr]:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,urlStr]];
                [self.storyBoardView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"launchDefault"]];
            }

            //存储图片
            if (![NSString isBlankString:urlStr]) {
                //从缓存中读取
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:urlStr forKey:myScreenImageURL];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.storyBoardView removeFromSuperview];
            });

        }else{
            [self.storyBoardView removeFromSuperview];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [self.storyBoardView removeFromSuperview];
    }];
}


-(void)screenViewShow{
    [self.window addSubview:self.storyBoardView];
    [self ScreenViewSource];
}


-(UIImageView *)storyBoardView{
    if (!_storyBoardView) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
        UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"LaunchScreen"];
        UIImageView *screenImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //添加默认的启动图片
        [screenImageView setImage:[UIImage imageNamed:@"launchDefault"]];
        [vc.view addSubview:screenImageView];
        _storyBoardView = screenImageView;
        
        //从缓存中读取
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *screenURL = [defaults objectForKey:myScreenImageURL];
        if (![NSString isBlankString:screenURL]) {
            NSString *urlStr = [NSString stringWithFormat:@"%@",screenURL];
            NSURL *imageUrl = ([urlStr hasPrefix:@"http"])?[NSURL URLWithString:urlStr]:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,urlStr]];
            [_storyBoardView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"launchDefault"]];
        }
    }
    return _storyBoardView;
}


+ (NSString *)getURLWithKey:(NSString *)key {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"launguage" ofType:@"plist"];
    NSString* launuage = nil;
    if (!APP_DELEGATE.isHan) {
        launuage = @"Han";
    }else{
        launuage = @"Zang";
    }
    
    NSDictionary *dic = [[NSDictionary dictionaryWithContentsOfFile:path] objectForKey:launuage];
    return [dic objectForKey:key];
}


@end
