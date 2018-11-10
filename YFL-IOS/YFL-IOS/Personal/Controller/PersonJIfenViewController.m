//
//  PersonJIfenViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonJIfenViewController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "EWTWebView.h"


@interface PersonJIfenViewController ()<EWTWebViewDelegate>
@property (nonatomic, strong) UIImageView *icon1;
@property (nonatomic, strong) UILabel *describe;

@property (nonatomic, strong) UIImageView *icon2;
@property (nonatomic, strong) UILabel *describe2;

@property (nonatomic, strong) EWTWebView *webView;
@end

@implementation PersonJIfenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    NSString *htmlUrl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,@"/toolsCtrl/getIntegralHtml.html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlUrl]]];
    
    //
//    UIImageView *icon1 = [[UIImageView alloc]init];
//    [self.view addSubview:icon1];
//    self.icon1 = icon1;
//    [icon1 setContentMode:UIViewContentModeCenter];
//    [icon1 setImage:[UIImage imageNamed:@"jifen_describe"]];
//    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(15.0f);
//        make.top.equalTo(self.view).offset(15.0f);
//    }];
//
//
//    //
//    UILabel *describe = [[UILabel alloc] init];
//    describe.font = [UIFont systemFontOfSize:17.0f];
//    describe.text = @"积分说明";
//    describe.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
//    describe.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:describe];
//    self.describe = describe;
//    [describe mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(icon1.mas_right).offset(11.0f);
//        make.centerY.equalTo(icon1);
//    }];
//
//
//    //
//    UIImageView *icon2 = [[UIImageView alloc]init];
//    [self.view addSubview:icon2];
//    self.icon2 = icon2;
//    [icon2 setContentMode:UIViewContentModeCenter];
//    [icon2 setImage:[UIImage imageNamed:@"jifen_descirbe2"]];
//    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(15.0f);
//        make.top.equalTo(self.view).offset(100.0f);
//    }];
//
//
//    //
//    UILabel *describe2 = [[UILabel alloc] init];
//    describe2.font = [UIFont systemFontOfSize:17.0f];
//    describe2.text = @"积分获得";
//    describe2.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
//    describe2.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:describe2];
//    self.describe2 = describe2;
//    [self.describe2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(icon2.mas_right).offset(11.0f);
//        make.centerY.equalTo(icon2);
//    }];
    
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

-(EWTWebView *)webView{
    if (!_webView) {
        EWTWebView *webView = [[EWTWebView alloc]initWithFrame:self.view.bounds];
        webView.delegate = self;
        _webView = webView;
        [self.view addSubview:webView];
    }
    return _webView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = [AppDelegate getURLWithKey:@"HuoquJIfen"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
