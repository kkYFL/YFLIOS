//
//  NewsDetailNoVideoController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/27.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NewsDetailNoVideoController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"


@interface NewsDetailNoVideoController ()

@end

@implementation NewsDetailNoVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    //[self.view addSubview:<#tableName#>];
    
}

-(void)loadData{
 
    // 新闻详情接口
    // 测试结果: 未通过, 未提供测试数据, 无法测试
    [HanZhaoHua getNewsDetailWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId infoId:@"" informationId:self.infoId success:^(NewsDetail * _Nonnull newsDetail) {
        NSLog(@"%@", newsDetail.userId);
        NSLog(@"%@", newsDetail.userToken);
        NSLog(@"%@", newsDetail.imgUrl);
        NSLog(@"%@", newsDetail.summary);
        NSLog(@"%@", newsDetail.foreignUrl);
        NSLog(@"%@", newsDetail.foreignType);
        NSLog(@"%@", newsDetail.positionNo);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
