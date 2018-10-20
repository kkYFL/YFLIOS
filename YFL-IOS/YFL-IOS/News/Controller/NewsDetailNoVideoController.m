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
#import "NewsMessage.h"

@interface NewsDetailNoVideoController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NewsDetail *newsDetail;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UILabel *videoTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation NewsDetailNoVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = NSLocalizedString(@"ZixunXiangQing", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
}

-(void)loadData{
 
    // 新闻详情接口
    // 测试结果: 未通过, 未提供测试数据, 无法测试
    [HanZhaoHua getNewsDetailWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId infoId:@"" informationId:self.newsModel.ID success:^(NewsDetail * _Nonnull newsDetail) {
        self.newsDetail = newsDetail;
        
        NSLog(@"%@", newsDetail.userId);
        NSLog(@"%@", newsDetail.userToken);
        NSLog(@"%@", newsDetail.imgUrl);
        NSLog(@"%@", newsDetail.summary);
        NSLog(@"%@", newsDetail.foreignUrl);
        NSLog(@"%@", newsDetail.foreignType);
        NSLog(@"%@", newsDetail.positionNo);
        
        
        self.videoTitleLabel.hidden = NO;
        [self.videoTitleLabel setText:[NSString stringWithFormat:@"%@",self.newsModel.title]];
        self.timeLabel.hidden = NO;
        [self.timeLabel setText:[NSString stringWithFormat:@"%@  %@",self.newsModel.createTime,self.newsModel.sourceFrom]];
        [self.videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15.0f);
            make.top.equalTo(self.view).offset(15.0f);
            make.right.equalTo(self.view.mas_right).offset(-15.0f);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15.0f);
            make.top.equalTo(self.videoTitleLabel.mas_bottom).offset(14.0f);
            make.right.equalTo(self.view.mas_right).offset(-15.0f);
        }];
        
        
        self.webView = [[UIWebView alloc] init];
        self.webView.backgroundColor = [UIColor whiteColor];
        self.webView.opaque = NO;
        self.webView.scrollView.scrollEnabled = YES;
        self.webView.delegate = self;
        self.webView.scrollView.delegate = self;
        [self.webView loadHTMLString:self.newsDetail.info baseURL:nil];
        [self.view addSubview:_webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(20);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        
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

-(UILabel *)videoTitleLabel{
    if (!_videoTitleLabel) {
        UILabel *videoTitleLabel = [[UILabel alloc] init];
        videoTitleLabel.font = [UIFont systemFontOfSize:17.0f];
        videoTitleLabel.text = @"";
        videoTitleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        videoTitleLabel.textAlignment = NSTextAlignmentLeft;
        videoTitleLabel.numberOfLines = 0;
        videoTitleLabel.hidden = YES;
        [self.view addSubview:videoTitleLabel];
        _videoTitleLabel = videoTitleLabel;
        return _videoTitleLabel;
    }
    return _videoTitleLabel;
}


-(UILabel *)timeLabel{
    if (!_timeLabel) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont systemFontOfSize:14.0f];
        timeLabel.text = @"";
        timeLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.hidden = YES;
        [self.view addSubview:timeLabel];
        _timeLabel = timeLabel;
        return _timeLabel;
    }
    return _timeLabel;
}



#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 让webview的内容一直居中显示
    //禁止左右滑动左右
    scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
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
