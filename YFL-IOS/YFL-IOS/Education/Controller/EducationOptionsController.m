//
//  EducationOptionsController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/21.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationOptionsController.h"
#import "EducationOptionsTableCell.h"
#import "EducationAddOptionController.h"
#import "EducationDetailController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"

@interface EducationOptionsController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *feedbackArr;
@end

@implementation EducationOptionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"options_right", @"options_right", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList:) name:@"feedBackViewRfershList" object:nil];;
    
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
    
    
    
    // 获取意见反馈列表
    // 测试结果: 通过
        [HanZhaoHua getSuggestionFeedbackWithPage:1 pageNum:10 success:^(NSArray * _Nonnull list) {
            for (SuggestionFeedback *model in list) {
                NSLog(@"%@", model.answerState);
                NSLog(@"%@", model.createTime);
                NSLog(@"%@", model.problemInfo);
                NSLog(@"%@", model.title);
                NSLog(@"%@", model.answer);
            }
            
            self.feedbackArr = list;
            
            [self.table reloadData];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
    

}



#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feedbackArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EducationOptionsTableCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationOptionsTableCell *optionsCell = [tableView dequeueReusableCellWithIdentifier:@"optionsCell"];
    if (self.feedbackArr.count > indexPath.row) {
        SuggestionFeedback *model = self.feedbackArr[indexPath.row];
        optionsCell.feedBackModel = model;
    }
    return optionsCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationDetailController *optionDetailVC = [[EducationDetailController alloc]init];
    [self.navigationController pushViewController:optionDetailVC animated:YES];
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[EducationOptionsTableCell class] forCellReuseIdentifier:@"optionsCell"];
    }
    return _table;
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
    EducationAddOptionController *addVC = [[EducationAddOptionController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - 通知
-(void)refreshList:(NSNotification *)noti{
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}


@end
