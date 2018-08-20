//
//  EWTBaseViewController.m
//  EWTBase
//
//  Created by Tony on 2017/9/18.
//  Copyright © 2017年 Huangbaoyang. All rights reserved.
//

#import "EWTBaseViewController.h"

@interface EWTBaseViewController ()

@property (nonatomic, strong) UIView* emptyDataView;

@property (nonatomic, strong) UIView* netErrorView;

@end

@implementation EWTBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(242, 242, 242);

    if ([self respondsToSelector:@selector(getNetErrorView)]) {
        
        UIView* errorView = [self getNetErrorView];

        if (errorView) {
            
            [self.view addSubview:errorView];
            
        }else{
            
            [self.view addSubview:self.netErrorView];
        }
    }

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setNavBarBg];
    [self setNavBackBtn:[UIImage imageNamed:@""]];
    
    // Do any additional setup after loading the view.
}

#pragma mark - getter


-(UIView *)netErrorView{

    if (_netErrorView == nil) {

    }
    return _netErrorView;
}

-(UIView *)emptyDataView{

    return nil;

}

#pragma mark - DisnetViewDelegate

-(void)refreshNet{

    
    
}

#pragma mark - EWTBaseUIDelegate

-(UIView *)getNetErrorView{

    return self.netErrorView;
}

-(UIView *)getEmptyDataView{

    return self.emptyDataView;
}


#pragma mark ---自定义导航栏

/**
 *  @brief 设置导航栏透明度和颜色
 */
- (void)setNavBarBg
{
    self.navigationController.navigationBar.translucent = NO;

    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];//返回按钮颜色
}

#pragma mark-- navigationBar的title设置

- (void)setNavBarTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

#pragma mark -- back

-(void)setBackItem{

    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 14, 24, @"career_planning_preference_setting_back", @"career_planning_preference_setting_back", navigationBarLeftButtonAction);
}

-(void)navigationBarLeftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-- navigationBar的返回按钮设置
- (void)setNavBackBtn:(UIImage *)image
{
    UIButton*left=[UIButton buttonWithType:UIButtonTypeCustom];
    left.frame=CGRectMake(0, 0, 9, 16);
    [left setBackgroundImage:image forState:UIControlStateNormal];
    [left addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:left];
}

- (void)setNavRightTitle:(NSString *)title
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)rightBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLoginVC
{
    
}


- (void)showMainVC
{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"VC_APPEAR : %@\n", NSStringFromClass(self.class));
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
