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
    

    

    {
        NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg", nil];
        self.icarousel1 = [[EWTICarousel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 150) withEWTICarouselType:EWTiCarouselTypeLinear contetnViewW:280 viewSpace:10.0];
        [self.icarousel1 setContentSource:dataArr];
        self.icarousel1.ewtIcarouselSelectBlock = ^(NSInteger selectIndex) {
            
        };
        self.icarousel1.autoPlay = YES;
        [self.icarousel1 showPageControl:YES PositionType:EWTiCarouselPageRight CurentPageImage:@"shengya-banner-lunbo-press" PageImage:@"shengya-banner-lunbo-nor"];

        [self.view addSubview:self.icarousel1];
    }
    
    
    
    
    
    {
        NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg", nil];
        self.icarousel2 = [[EWTICarousel alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 150) withEWTICarouselType:EWTiCarouselTypeCustom contetnViewW:280 viewSpace:20];
        [self.icarousel2 setContentSource:dataArr];
        self.icarousel2.ewtIcarouselSelectBlock = ^(NSInteger selectIndex) {
            
        };
        
        [self.icarousel2 showPageControl:YES PositionType:EWTiCarouselPageCenter CurentPageImage:@"shengya-banner-lunbo-press" PageImage:@"shengya-banner-lunbo-nor"];

        [self.view addSubview:self.icarousel2];
    }
    
    
    {
        NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg",@"http://bangimg1.dahe.cn/forum/201511/06/221846mfq6haf2mxllaqhz.jpg", nil];
        EWTICarousel *tmpCarousel = [[EWTICarousel alloc] initWithFrame:CGRectMake(0, 350, SCREEN_WIDTH, 150) withEWTICarouselType:EWTiCarouselTypeCustom contetnViewW:280 viewSpace:20];
        [tmpCarousel setContentSource:dataArr];
        tmpCarousel.ewtIcarouselSelectBlock = ^(NSInteger selectIndex) {
            
        };
        
        [tmpCarousel showPageControl:YES PositionType:EWTiCarouselPageRight CurentPageImage:nil PageImage:nil];
        [tmpCarousel setPageControlCurrentPointColor:[UIColor blackColor] pointColor:[UIColor blueColor]];
        //[tmpCarousel setPageControlCurentPageImage:@"shengya-banner-lunbo-press" PageImage:@"shengya-banner-lunbo-nor"];

        [self.view addSubview:tmpCarousel];
    }
    
    

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
