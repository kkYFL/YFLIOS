//
//  EducationLearnController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationLearnController.h"
#import "EducationLearnCell.h"
#import "EducationLearnDetailController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"
#import "CLInputToolbar.h"
#import "MBProgressHUD+Toast.h"

#define pageMenueH 44.0

@interface EducationLearnController ()<UITableViewDelegate,UITableViewDataSource
>{
    NSInteger selectIndex;
    NSInteger _pageIndex;
    BOOL hasloadAll;
}
@property (nonatomic, strong) UITableView *table;


@property (nonatomic, strong) UIView *itemsView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIView *tracker;

@property (nonatomic, strong) NSMutableArray *studyNotesArr;

@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation EducationLearnController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
}

-(void)initData{
    selectIndex = 1;
    _pageIndex = 1;
    hasloadAll = NO;
    self.studyNotesArr = [NSMutableArray array];
}

-(void)initView{
    self.title = @"学习心得";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction);
                                
    [self.view addSubview:self.itemsView];
    
    [self.view addSubview:self.table];
    [self.view addSubview:self.footerView];
    [self setTextViewToolbar];
    
    [self initRefresh];
}

-(void)loadData{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    
    // 获取学习心得列表
    // 测试结果: 接口通过, 但相比于接口文档, 缺少两个字段: headImg, ssDepartment
    NSString *type = (selectIndex == 1)?@"1":@"2";
    [HanZhaoHua getStudyNotesWithUserId:APP_DELEGATE.userId taskId:nil queryType:type page:1 pageNum:10 success:^(NSArray * _Nonnull list) {
        for (StudyNotes *model in list) {
            NSLog(@"%@", model.clickNum);
            NSLog(@"%@", model.notesId);
            NSLog(@"%@", model.taskTitle);
            NSLog(@"%@", model.pmName);
            NSLog(@"%@", model.createTime);
            NSLog(@"%@", model.learnContent);
        }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (list.count<10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.table.mj_footer endRefreshing];
        }

        self.studyNotesArr = [NSMutableArray arrayWithArray:list];
        
        [self.table reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_footer endRefreshing];
        [self.table.mj_header endRefreshing];
    }];
}

-(void)loadMore{
    [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];
    // 获取学习心得列表
    // 测试结果: 接口通过, 但相比于接口文档, 缺少两个字段: headImg, ssDepartment
    NSString *type = (selectIndex == 1)?@"1":@"2";
    [HanZhaoHua getStudyNotesWithUserId:APP_DELEGATE.userId taskId:nil queryType:type page:_pageIndex pageNum:10 success:^(NSArray * _Nonnull list) {
        for (StudyNotes *model in list) {
            NSLog(@"%@", model.clickNum);
            NSLog(@"%@", model.notesId);
            NSLog(@"%@", model.taskTitle);
            NSLog(@"%@", model.pmName);
            NSLog(@"%@", model.createTime);
            NSLog(@"%@", model.learnContent);
        }
        
        [[PromptBox sharedBox] removeLoadingView];
        [self.table.mj_header endRefreshing];
        if (list.count < 10) {
            [self.table.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.table.mj_footer endRefreshing];
        }
        
        [self.studyNotesArr addObjectsFromArray:list];
        
        [self.table reloadData];
        
    } failure:^(NSError * _Nonnull error) {
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
    [self loadMore];
}

-(void)refershHeader{
    [self initData];
    [self loadData];
}


-(void)addCommentxinDeSourceWithContent:(NSString *)content{
    // 学习心得
    // 测试结果: 通过
        [HanZhaoHua submitStudyNotesWithUserId:APP_DELEGATE.userId taskId:nil learnContent:content success:^(NSDictionary * _Nonnull responseObject) {
            [MBProgressHUD toastMessage:@"发表心得成功" ToView:self.view];

            NSLog(@"%@", responseObject);
        
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            [MBProgressHUD toastMessage:@"发表心得失败" ToView:self.view];

        }];
}



#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.studyNotesArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.studyNotesArr.count > indexPath.row) {
        StudyNotes *model = self.studyNotesArr[indexPath.row];
        return [EducationLearnCell CellHWithContent:model.learnContent];
    }

    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EducationLearnCell *learnCell = [tableView dequeueReusableCellWithIdentifier:@"learnCell"];
    if (self.studyNotesArr.count > indexPath.row) {
        StudyNotes *model = self.studyNotesArr[indexPath.row];
        learnCell.model = model;
    }
    return learnCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.studyNotesArr.count > indexPath.row) {
        StudyNotes *model = self.studyNotesArr[indexPath.row];
        EducationLearnDetailController *detailVC = [[EducationLearnDetailController alloc]init];
        detailVC.model = model;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, pageMenueH, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-pageMenueH-50)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[EducationLearnCell class] forCellReuseIdentifier:@"learnCell"];
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



//自定义Items切换固定items
-(UIView *)itemsView{
    if (!_itemsView) {
        _itemsView = [[UIView alloc]init];
        [_itemsView setBackgroundColor:[UIColor whiteColor]];
        CGFloat w = SCREEN_WIDTH/2.0;
        [self.view addSubview:_itemsView];
        [_itemsView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, pageMenueH)];
        
        
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button setTitleColor:[UIColor colorWithHexString:@"#0C0C0C"] forState:UIControlStateNormal];
        [button setTitle:@"全部心得" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#E51C23"] forState:UIControlStateSelected];
        [_itemsView addSubview:button];
        button.tag = 101;
        button.selected = YES;
        [button setFrame:CGRectMake(0, 0, w, pageMenueH)];
        self.button = button;
        
        
        UIButton *button1 = [[UIButton alloc]init];
        [button1 addTarget:self action:@selector(itemSelect:) forControlEvents:UIControlEventTouchUpInside];
        [button1.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#0C0C0C"] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithHexString:@"#E51C23"] forState:UIControlStateSelected];
        [button1 setTitle:@"我的心得" forState:UIControlStateNormal];
        [_itemsView addSubview:button1];
        button1.tag = 102;
        [button1 setFrame:CGRectMake(w, 0, w, pageMenueH)];
        self.button1 = button1;
        
        
        UIView *tracker = [[UIView alloc]init];
        tracker.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
        [_itemsView addSubview:tracker];
        self.tracker = tracker;
        [tracker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_itemsView.mas_bottom).offset(0);
            make.width.mas_equalTo(0.6*w);
            make.height.mas_equalTo(2);
            make.centerX.equalTo(button);
        }];

        
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
        [_itemsView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_itemsView).offset(0);
            make.bottom.equalTo(_itemsView);
            make.right.equalTo(_itemsView);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _itemsView;
}

-(void)itemSelect:(UIButton *)sender{
    NSInteger viewTag = sender.tag - 100;
    CGFloat w = SCREEN_WIDTH/2.0;

    if (viewTag == 1) {
        self.button.selected = YES;
        self.button1.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [self.tracker mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_itemsView.mas_bottom).offset(0);
                make.width.mas_equalTo(0.6*w);
                make.height.mas_equalTo(2);
                make.centerX.equalTo(self.button);
            }];
        }];

    }else if (viewTag == 2){
        
        self.button.selected = NO;
        self.button1.selected = YES;
        [self.tracker mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_itemsView.mas_bottom).offset(0);
            make.width.mas_equalTo(0.6*w);
            make.height.mas_equalTo(2);
            make.centerX.equalTo(self.button1);
        }];

    }
    
    if (selectIndex != viewTag) {
        selectIndex = viewTag;
        [self loadData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self addCommentxinDeSourceWithContent:@"自觉性是指个体自觉自愿地执行或自主自愿地追求整体长远目标任务的程度。就其产生过程来讲，个体的自觉性是在信念基础上"];
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
        remindLabel.text = @"我的想法";
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
    self.inputToolbar.placeholder = @"请输入...";
    __weak __typeof(self) weakSelf = self;
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        //[strongSelf.btn setTitle:text forState:UIControlStateNormal];
        // 清空输入框文字
        [strongSelf.inputToolbar bounceToolbar];
        strongSelf.maskView.hidden = YES;
        
        [strongSelf addCommentxinDeSourceWithContent:text];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
