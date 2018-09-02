//
//  ICarouselViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/2.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ICarouselViewController.h"
#import "EWTICarousel.h"

@interface ICarouselViewController ()
@property (nonatomic, strong) EWTICarousel *icarousel1;
@property (nonatomic, strong) EWTICarousel *icarousel2;
@end

@implementation ICarouselViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"iCarousel";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 42, 15, @"navigaitionBar_back_normal", @"navigationBar_back_select", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    self.icarousel1 = [[EWTICarousel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 80) withEWTICarouselType:EWTiCarouselTypeLinear contetnViewW:200 viewSpace:10.0];
    [self.view addSubview:self.icarousel1];
    
    
    self.icarousel2 = [[EWTICarousel alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 80) withEWTICarouselType:EWTiCarouselTypeCustom contetnViewW:200 viewSpace:20];
    [self.view addSubview:self.icarousel2];
}



-(void)loadData{

}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
