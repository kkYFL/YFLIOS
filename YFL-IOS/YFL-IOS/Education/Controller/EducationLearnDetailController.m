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
#import "CLInputToolbar.h"
#import "AppDelegate.h"

@interface EducationLearnDetailController ()<UITableViewDelegate,UITableViewDataSource
>{
    NSInteger _pageIndex;
    BOOL hasloadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *commentListArr;

@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *footerView;
@end

@implementation EducationLearnDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initView{
    self.title = [AppDelegate getURLWithKey:@""]@"XindeXiangqing", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
    [self.view addSubview:self.table];
    [self initRefresh];
    [self.view addSubview:self.footerView];
    [self setTextViewToolbar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addZanAction:) name:@"xindeAddZanActionNoti" object:nil];
    
}

-(void)initData{
    _pageIndex = 1;
    self.commentListArr = [NSMutableArray array];
    hasloadAll = NO;
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:[NSString stringWithFormat:@"%@...",[AppDelegate getURLWithKey:@""]@"jiazaizhong", nil)] onView:self.view];

    // 获取心得评论列表
    // 测试结果: 通过
        [HanZhaoHua getNotesCommentListWithNotesId:self.model.notesId page:_pageIndex pageNum:10 success:^(NSArray * _Nonnull list) {
            for (PartyMemberThinking *model in list) {
                NSLog(@"%@", model.pmName);
                NSLog(@"%@", model.headImg);
                NSLog(@"%@", model.ssDepartment);
                NSLog(@"%@", model.commentInfo);
                NSLog(@"%@", model.createTime);
            }
            
            [[PromptBox sharedBox] removeLoadingView];
            [self.table.mj_header endRefreshing];
            if (list.count <10) {
                [self.table.mj_footer endRefreshingWithNoMoreData];
                hasloadAll = YES;
            }else{
                [self.table.mj_footer endRefreshing];
            }
            
            if (_pageIndex == 1) {
                self.commentListArr = [NSMutableArray arrayWithArray:list];
            }else{
                [self.commentListArr addObjectsFromArray:list];
            }
            
            
            [self.table reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            [[PromptBox sharedBox] removeLoadingView];
            [self.table.mj_footer endRefreshing];
            [self.table.mj_header endRefreshing];
        }];
}



#pragma mark 上下拉刷新
- (void)initRefresh{
    MJRefershHeader *header = [MJRefershHeader headerWithRefreshingTarget:self refreshingAction:@selector(refershHeader)];
    self.table.mj_header = header;
    MJBachFooter *footer = [MJBachFooter footerWithRefreshingTarget:self refreshingAction:@selector(refershFooter)];
    self.table.mj_footer = footer;
    self.table.mj_footer.automaticallyChangeAlpha = YES;
}

-(void)refershFooter{
    if (hasloadAll) {
        [self.table.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    _pageIndex++;
    [self loadData];
}

-(void)refershHeader{
    [self initData];
    
    [self loadData];
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
    
    NSString *title = [NSString stringWithFormat:@"%@(%lu)",[AppDelegate getURLWithKey:@""]@"pinglun", nil),(unsigned long)self.commentListArr.count];
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

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-50)];
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
            [[PromptBox sharedBox] showPromptBoxWithText:[AppDelegate getURLWithKey:@""]@"dianzanchenggong", nil) onView:self.view hideTime:2 y:0];
        }

        [self loadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#B2B2B2"];
        [footerView setFrame:CGRectMake(0, self.view.bounds.size.height-EWTTabbar_SafeBottomMargin-50, SCREEN_WIDTH, 50)];
        [self.view addSubview:footerView];
        _footerView = footerView;
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-EWTTabbar_SafeBottomMargin);
            make.height.mas_equalTo(50.0f);
        }];
        
        
        UIImageView *footerTouch = [[UIImageView alloc]init];
        [footerTouch setBackgroundColor:[UIColor whiteColor]];
        [_footerView addSubview:footerTouch];
        footerTouch.layer.masksToBounds = YES;
        footerTouch.layer.cornerRadius = 15.0f;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textInputAction:)];
        footerTouch.userInteractionEnabled = YES;
        [footerTouch addGestureRecognizer:tap1];
        [footerTouch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footerView).offset(15.0f);
            make.top.equalTo(_footerView).offset(8.0f);
            make.right.equalTo(_footerView.mas_right).offset(-8.0f);
            make.bottom.equalTo(_footerView.mas_bottom).offset(-8.0f);
        }];
        
        UILabel *remindLabel = [[UILabel alloc] init];
        remindLabel.font = [UIFont systemFontOfSize:14.0f];
        remindLabel.text = [AppDelegate getURLWithKey:@""]@"wodexiangfa", nil);
        remindLabel.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
        remindLabel.textAlignment = NSTextAlignmentLeft;
        [footerTouch addSubview:remindLabel];
        [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(footerTouch).offset(18.0f);
            make.centerY.equalTo(footerTouch);
        }];
    }
    return _footerView;
}


-(void)setTextViewToolbar {
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BlankTextViewtapActions:)];
    [self.maskView addGestureRecognizer:tap];
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    self.inputToolbar = [[CLInputToolbar alloc] initWithFrame:self.view.bounds];
    self.inputToolbar.textViewMaxLine = 1;
    self.inputToolbar.fontSize = 13;
    self.inputToolbar.placeholder = [AppDelegate getURLWithKey:@""]@"qingshuru", nil);
    __weak __typeof(self) weakSelf = self;
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        //[strongSelf.btn setTitle:text forState:UIControlStateNormal];
        // 清空输入框文字
        [strongSelf.inputToolbar bounceToolbar];
        strongSelf.maskView.hidden = YES;
        
        [strongSelf addNotesCommentWithNotesID:self.model.notesId Comment:text];
    }];
    [self.maskView addSubview:self.inputToolbar];
}


-(void)textInputAction:(UITapGestureRecognizer *)tap{
    self.maskView.hidden = NO;
    [self.inputToolbar popToolbar];
}

-(void)BlankTextViewtapActions:(UITapGestureRecognizer *)tap {
    [self.inputToolbar bounceToolbar];
    self.maskView.hidden = YES;
}


-(void)addNotesCommentWithNotesID:(NSString *)notesId Comment:(NSString *)content{
    // 心得评论
    // 测试结果: 通过
    [HanZhaoHua commentStudyNotesWithUserId:APP_DELEGATE.userId notesId:notesId commentInfo:content success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"2000"]) {
            [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@""]@"pinglunchengong", nil) ToView:self.view];
            
            [self refershHeader];
        }else{
            [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@""]@"pinglunshibai", nil) ToView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@""]@"pinglunshibai", nil) ToView:self.view];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
