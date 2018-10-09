//
//  EducationLearnDetailController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationLearnDetailController.h"
#import "EducationLearnDetailCell.h"
#import "StudyNotes.h"
#import "HanZhaoHua.h"

@interface EducationLearnDetailController ()<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *commentListArr;
@end

@implementation EducationLearnDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"心得详情";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addZanAction:) name:@"xindeAddZanActionNoti" object:nil];
    
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
    
    // 获取心得评论列表
    // 测试结果: 通过
        [HanZhaoHua getNotesCommentListWithNotesId:self.model.notesId page:1 pageNum:10 success:^(NSArray * _Nonnull list) {
            for (PartyMemberThinking *model in list) {
                NSLog(@"%@", model.pmName);
                NSLog(@"%@", model.headImg);
                NSLog(@"%@", model.ssDepartment);
                NSLog(@"%@", model.commentInfo);
                NSLog(@"%@", model.createTime);
            }
            
            self.commentListArr = [NSMutableArray arrayWithArray:list];
            
            [self.table reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}


#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.commentListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [EducationLearnDetailCell CellHWithContent:self.model.learnContent Type:LearnDetailTypeDefault];
    }
    
    return [EducationLearnDetailCell CellHWithContent:@"适应新时代，新任务，新要求，扎扎实实干好本职工作，解决实际问题。" Type:LearnDetailTypeResponse];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EducationLearnDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        [detailCell setType:LearnDetailTypeDefault Model:self.model];
        return detailCell;
    }
    
//    for (PartyMemberThinking *model in list) {
//        NSLog(@"%@", model.pmName);
//        NSLog(@"%@", model.headImg);
//        NSLog(@"%@", model.ssDepartment);
//        NSLog(@"%@", model.commentInfo);
//        NSLog(@"%@", model.createTime);
//    }

    EducationLearnDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (self.commentListArr.count > indexPath.row) {
        PartyMemberThinking *model = self.commentListArr[indexPath.row];
        [detailCell setType2:LearnDetailTypeResponse Model:model];
    }
    return detailCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc]init];
    }
    
    NSString *title = [NSString stringWithFormat:@"评论(%lu)",(unsigned long)self.commentListArr.count];
    return [self headerViewWithIcon:@"red_line" Title:title];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }
    
    return 35.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *footer = [[UIView alloc]init];
        footer.backgroundColor = [UIColor colorWithHexString:@"#E2E2E2"];
        [footer setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0f)];
        return footer;
    }
    
    return [[UIView alloc]initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 20.0f;
    }
    
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView *)headerViewWithIcon:(NSString *)icon Title:(NSString *)title{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    
    UIImageView *headerImageV = [[UIImageView alloc]init];
    [headerView addSubview:headerImageV];
    [headerImageV setContentMode:UIViewContentModeCenter];
    [headerImageV setImage:[UIImage imageNamed:icon]];
    
    UILabel *headerTitle = [[UILabel alloc] init];
    headerTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    headerTitle.text = title;
    headerTitle.textColor = [UIColor colorWithHexString:@"#51566D"];
    headerTitle.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:headerTitle];
    
    [headerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15.0);
        make.centerY.equalTo(headerView.mas_centerY).offset(0);
    }];
    
    [headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageV.mas_right).offset(11);
        make.centerY.equalTo(headerView.mas_centerY).offset(0);
    }];
    
    return headerView;
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
        
        [_table registerClass:[EducationLearnDetailCell class] forCellReuseIdentifier:@"detailCell"];
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
    
}


-(void)addZanAction:(NSNotification *)noti{
    NSDictionary *userinof = noti.userInfo;
    NSString *notesId = [userinof objectForKey:@"notesId"];
    [self addZanActionWithId:notesId];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addZanActionWithId:(NSString *)notiId{
    // 心得点赞
    // 测试结果: 通过
    [HanZhaoHua likeStudyNotesWithNotesId:notiId success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        if ([[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]] integerValue] == 2000) {
            [[PromptBox sharedBox] showPromptBoxWithText:@"点赞成功" onView:self.view hideTime:2 y:0];
        }

        [self loadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
