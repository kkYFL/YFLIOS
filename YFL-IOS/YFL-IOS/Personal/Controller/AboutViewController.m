//
//  AboutViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/14.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "AboutViewController.h"
#import "AppDelegate.h"
#import "EWTWebView.h"


@interface AboutViewController ()<EWTWebViewDelegate>
@property (nonatomic, strong) EWTWebView *webView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    //[self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    NSString *htmlUrl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,@"/toolsCtrl/getAboutHtml.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlUrl]]];
    
    //[self.view addSubview:<#tableName#>];
    
    //无网络页面
    //DisnetViewDelegate
//    disView = [[DisnetView alloc] initWithFrame:self.view.bounds];
//    disView.delegate = self;
//    disView.hidden = YES;
//    [self.view addSubview:disView];
}

//-(void)loadData{
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
//}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    //[self loadData];
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = [AppDelegate getURLWithKey:@"Guanyu"];
}

-(EWTWebView *)webView{
    if (!_webView) {
        EWTWebView *webView = [[EWTWebView alloc]initWithFrame:self.view.bounds];
        webView.delegate = self;
        webView.wkWebView.scrollView.delegate = self;
        _webView = webView;
        [self.view addSubview:webView];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
