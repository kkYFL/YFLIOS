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
#import "ExamnationViewController.h"
#import "PersonalViewController.h"
#import "EWTLoginAndRegisterViewController.h"


@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //[self showLoginAndRegistController];
    
    [self tabBarViewInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appAccessHomeWindow:) name:KNotificationAccessHomeWindow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appSignOut:) name:KNotificationUserSignOut object:nil];
    
    return YES;
}

-(void)tabBarViewInit{
    NewsViewController *newVC = [[NewsViewController alloc]init];
    EWTBaseNavigationController *newsNav = [self viewControllerWithTitle:@"党员资讯" image:[UIImage imageNamed:@"tabbar_classroom_normal"] selectedImage:[UIImage imageNamed:@"tabbar_classroom_selected"] VC:newVC];

    
    
    
    EducationViewController *educationVC = [[EducationViewController alloc]init];
    EWTBaseNavigationController *educationNav = [self viewControllerWithTitle:@"党员教育" image:[UIImage imageNamed:@"ecourse_normal"] selectedImage:[UIImage imageNamed:@"ecourse_selected"] VC:educationVC];
    
    
    
    ExamnationViewController *examtionVC = [[ExamnationViewController alloc]init];
    EWTBaseNavigationController *examtionNav = [self viewControllerWithTitle:@"党员考试" image:[UIImage imageNamed:@"tabbar_community_normal"] selectedImage:[UIImage imageNamed:@"tabbar_community_selected"] VC:examtionVC];
    
    
    
    PersonalViewController *personalVC = [[PersonalViewController alloc]init];
    EWTBaseNavigationController *personalNav = [self viewControllerWithTitle:@"个人中心" image:[UIImage imageNamed:@"personal_center_tabbar_normal"] selectedImage:[UIImage imageNamed:@"personal_center_tabbar_selected"] VC:personalVC];
    
    
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.delegate = self;
    tabBar.viewControllers = @[newsNav,educationNav,examtionNav,personalNav];
    tabBar.tabBar.barTintColor = [UIColor redColor];
    tabBar.tabBar.translucent = NO;
    
    
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    [self.window setRootViewController:tabBar];
    [self.window makeKeyAndVisible];

    

}
    
-(void)showLoginAndRegistController {
    EWTLoginAndRegisterViewController *loginVC = [[EWTLoginAndRegisterViewController alloc] init];
    loginVC.title = @"登录";
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
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
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
    
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window setBackgroundColor:[UIColor whiteColor]];
    }
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}


@end
