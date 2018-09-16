//
//  ExamhomeViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamhomeViewController.h"
#import "ExamConentViewController.h"

@interface ExamhomeViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rouleLabel;
@property (nonatomic, strong) UIImageView *examImageView;


@end

@implementation ExamhomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"考试规则";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 42, 15, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    //[self.view addSubview:self.table];
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.text = @"《党的目标》知识答题 第562期";
        titleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(15.0f);
            make.centerX.equalTo(self.view);
        }];
    }
    
    
    {
        UILabel *rouleLabel = [[UILabel alloc] init];
        rouleLabel.font = [UIFont systemFontOfSize:17.0f];
        rouleLabel.text = @"考试规则";
        rouleLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        rouleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:rouleLabel];
        self.rouleLabel = rouleLabel;
        [rouleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(11.0f);
            make.centerX.equalTo(self.view);
        }];
    }
    
    
    {
        UIImageView *ImageView1 = [[UIImageView alloc]init];
        [ImageView1 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:ImageView1];
        [ImageView1 setContentMode:UIViewContentModeCenter];
        [ImageView1 setImage:[UIImage imageNamed:@"fist_image"]];
        [ImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.rouleLabel.mas_bottom).offset(28);
            make.height.width.mas_equalTo(20);
        }];
        
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = [UIFont systemFontOfSize:14.0f];
        label1.numberOfLines = 0;
        label1.text = @"考试时间一共120分钟，到时间自动提交试卷；";
        label1.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        label1.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ImageView1.mas_right).offset(11);
            make.centerY.equalTo(ImageView1.mas_centerY).offset(0);
            make.right.equalTo(self.view.mas_right).offset(-15.0);
        }];
        
        
        
        UIImageView *ImageView2 = [[UIImageView alloc]init];
        [ImageView2 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:ImageView2];
        [ImageView2 setContentMode:UIViewContentModeCenter];
        [ImageView2 setImage:[UIImage imageNamed:@"fist_image"]];
        [ImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(label1.mas_bottom).offset(22);
            make.height.width.mas_equalTo(20);
        }];
        
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.font = [UIFont systemFontOfSize:14.0f];
        label2.numberOfLines = 0;
        label2.text = @"本次考试20道选择题，每题3分；10道判断题，每题1分，6道简答题，每题5分；一共100分。";
        label2.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        label2.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ImageView2.mas_right).offset(11);
            make.centerY.equalTo(ImageView2.mas_centerY).offset(0);
            make.right.equalTo(self.view.mas_right).offset(-15.0);
        }];
        
        
        //3
        UIImageView *ImageView3 = [[UIImageView alloc]init];
        [ImageView3 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:ImageView3];
        [ImageView3 setContentMode:UIViewContentModeCenter];
        [ImageView3 setImage:[UIImage imageNamed:@"fist_image"]];
        [ImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(label2.mas_bottom).offset(22);
            make.height.width.mas_equalTo(20);
        }];
        
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.font = [UIFont systemFontOfSize:14.0f];
        label3.numberOfLines = 0;
        label3.text = @"考试最迟时间为2018-07-20，越期为0分；";
        label3.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        label3.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ImageView3.mas_right).offset(11);
            make.centerY.equalTo(ImageView3.mas_centerY).offset(0);
            make.right.equalTo(self.view.mas_right).offset(-15.0);
        }];
        
        
        //4
        UIImageView *ImageView4 = [[UIImageView alloc]init];
        [ImageView4 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:ImageView4];
        [ImageView4 setContentMode:UIViewContentModeCenter];
        [ImageView4 setImage:[UIImage imageNamed:@"fist_image"]];
        [ImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(label3.mas_bottom).offset(22);
            make.height.width.mas_equalTo(20);
        }];
        
        
        UILabel *label4 = [[UILabel alloc] init];
        label4.font = [UIFont systemFontOfSize:14.0f];
        label4.numberOfLines = 0;
        label4.text = @"考试最多有2次机会，如果全部放弃则视为0分处理；";
        label4.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
        label4.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ImageView4.mas_right).offset(11);
            make.centerY.equalTo(ImageView4.mas_centerY).offset(0);
            make.right.equalTo(self.view.mas_right).offset(-15.0);
        }];
        
        
        
    }
    
    
    UIImageView *examImageView = [[UIImageView alloc]init];
    [examImageView setBackgroundColor:[UIColor colorWithHexString:@"#E51C23"]];
    [self.view addSubview:examImageView];
    self.examImageView = examImageView;
    examImageView.layer.masksToBounds = YES;
    examImageView.layer.cornerRadius = 120/2.0f;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(examAction:)];
    examImageView.userInteractionEnabled = YES;
    [examImageView addGestureRecognizer:tap1];
    [self.examImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.height.width.mas_equalTo(120);
    }];

    
    UILabel *examTileLab = [[UILabel alloc] init];
    examTileLab.font = [UIFont boldSystemFontOfSize:17.0f];
    examTileLab.text = @"开始考试";
    examTileLab.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    examTileLab.textAlignment = NSTextAlignmentCenter;
    [self.examImageView addSubview:examTileLab];
    [examTileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.examImageView);
    }];
    
    
    

    

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

-(void)examAction:(UITapGestureRecognizer *)tap{
    ExamConentViewController *examVC = [[ExamConentViewController alloc]init];
    [self.navigationController pushViewController:examVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
