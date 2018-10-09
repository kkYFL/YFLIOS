//
//  ExamnationViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/19.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamnationViewController.h"
#import "ExamWaitingViewController.h"
#import "ExamTableViewCommonCell.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"

@interface ExamnationViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger _pageIndex;
    BOOL hasloadAll;
}
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *headerBottonView;

@property (nonatomic, strong) NSMutableArray *viewsArr;
@property (nonatomic, strong) UILabel *headerNumLab;
@property (nonatomic, strong) UILabel *remindLabel1;
@property (nonatomic, strong) UILabel *remindLabel2;
@property (nonatomic, strong) UILabel *paimingLabel;

@property (nonatomic, strong) TestRanking *ownerRankeModel;
@property (nonatomic, strong) NSMutableArray *scoreList;
@end

@implementation ExamnationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self refershHeader];
    
}

-(void)initView{
    self.title = @"党员考试";
    self.view.backgroundColor = [UIColor whiteColor];
    self.viewsArr = [NSMutableArray array];
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.headerView;
    
    [self initRefresh];
}

-(void)initData{
    _pageIndex = 1;
    hasloadAll = NO;
    self.scoreList = [NSMutableArray array];
}


-(void)loadData{
     [[PromptBox sharedBox] showLoadingWithText:@"加载中..." onView:self.view];

    // 考试排名
    // 测试结果: 通过
        [HanZhaoHua testRankingWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId page:_pageIndex pageNum:10 success:^(TestRanking *owner, NSArray *scoreList) {
            NSLog(@"%@", owner.headImg);
            NSLog(@"%@", owner.name);
            NSLog(@"%@", owner.score);
            for (TestRanking *model in scoreList) {
                NSLog(@"%@", model.headImg);
                NSLog(@"%@", model.name);
                NSLog(@"%@", model.score);
            }
            
            [[PromptBox sharedBox] removeLoadingView];
            //
            if (_pageIndex == 1) {
                [self.table.mj_header endRefreshing];
                if (scoreList.count < 10) {
                    hasloadAll = YES;
                    [self.table.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.table.mj_footer endRefreshing];
                }

                self.scoreList = [NSMutableArray arrayWithArray:scoreList];
                
           //loadMore
            }else{
                [self.table.mj_header endRefreshing];
                if (scoreList.count < 10) {
                    hasloadAll = YES;
                    [self.table.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.table.mj_footer endRefreshing];
                }
                
                [self.scoreList addObjectsFromArray:scoreList];
                
            }
            
            self.ownerRankeModel = owner;
            
            [self resetViewWithData];
            
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
    [self resetView];
    [self initData];
    [self loadData];
}






#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scoreList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ExamTableViewCommonCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamTableViewCommonCell *CommonCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell"];
    if (self.scoreList.count > indexPath.row) {
        TestRanking *rankModel = self.scoreList[indexPath.row];
        CommonCell.rankModel = rankModel;
    }
    return CommonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        
        [_table registerClass:[ExamTableViewCommonCell class] forCellReuseIdentifier:@"CommonCell"];
    }
    return _table;
}

-(UIView *)headerView{
    if(!_headerView){
        CGFloat imageViewW = SCREEN_WIDTH;
        CGFloat imageViewH = SCREEN_WIDTH*272/375.0;
        
        CGFloat selectImageViewW = (SCREEN_WIDTH-15-25*2)/2.0;

        CGFloat headerViewH = imageViewH + 16.0 + 30.0f;
        
        //
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewH)];
        _headerView = headerView;
        
        
        //
        UIImageView *headerImageView = [[UIImageView alloc]init];
        [headerImageView setBackgroundColor:[UIColor whiteColor]];
        headerImageView.userInteractionEnabled = YES;
        [_headerView addSubview:headerImageView];
        self.headerImageView = headerImageView;
        [headerImageView setContentMode:UIViewContentModeScaleToFill];
        [headerImageView setImage:[UIImage imageNamed:@"Exam_Header-1"]];
        [headerImageView setFrame:CGRectMake(0, 0, imageViewW, imageViewH)];

        
        CGFloat orginRadion = -130.0f;
        CGFloat perRadion = 13.6842f;
        
        for (NSInteger i = 0; i < 20; i++) {
            
            UIView *routeView = [[UIView alloc]init];
            [headerImageView addSubview:routeView];
            routeView.tag = 100+i;
            
            
            CGFloat routeViewW = 15.0;
            CGFloat routeViewH = 100.0;
            
            [routeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(headerImageView);
                make.bottom.equalTo(headerImageView.mas_centerY).offset(40);
                make.height.mas_equalTo(routeViewH);
                make.width.mas_equalTo(routeViewW);
            }];
            
            
            routeView.layer.anchorPoint = CGPointMake(0.5, 1);
            routeView.bounds = CGRectMake(0, 0, routeViewW, routeViewH);
            routeView.layer.position = CGPointMake(imageViewW * 0.5, imageViewH * 0.5);
            // 按钮的旋转角度
            CGFloat radion = ((perRadion*i+orginRadion) / 180.0 * M_PI);
            routeView.transform = CGAffineTransformMakeRotation(radion);
            
            
            UIButton *button = [[UIButton alloc]init];
            [button setImage:[UIImage imageNamed:@"suo_gray"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"suoViewLight"] forState:UIControlStateSelected];
            [self.viewsArr addObject:button];
            //button.enabled = NO;
            [routeView addSubview:button];
            button.selected = NO;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(routeView);
                make.centerX.equalTo(routeView);
                make.height.mas_equalTo(30);
                make.width.mas_equalTo(20);
            }];
            
        }
        
        
        //num
        UILabel *headerNumLab= [[UILabel alloc] init];
        headerNumLab.font = [UIFont boldSystemFontOfSize:60];
        headerNumLab.text = @"0";
        headerNumLab.textColor = [UIColor whiteColor];
        headerNumLab.textAlignment = NSTextAlignmentCenter;
        [headerImageView addSubview:headerNumLab];
        self.headerNumLab = headerNumLab;
        [self.headerNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerImageView);
            make.centerY.equalTo(headerImageView.mas_centerY).offset(-10.f);
        }];
        
        
        //remindLabel1
        UILabel *remindLabel1 = [[UILabel alloc] init];
        remindLabel1.font = [UIFont systemFontOfSize:16.0f];
        remindLabel1.text = @"最近成绩";
        remindLabel1.textColor = [UIColor whiteColor];
        remindLabel1.textAlignment = NSTextAlignmentCenter;
        [headerImageView addSubview:remindLabel1];
        self.remindLabel1 = remindLabel1;
        [self.remindLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerNumLab.mas_bottom).offset(0);
            make.centerX.equalTo(self.headerNumLab);
        }];
        

        //remindLabel2
        UILabel *remindLabel2 = [[UILabel alloc] init];
        remindLabel2.font = [UIFont systemFontOfSize:14.0f];
        remindLabel2.text = @"您的成绩优秀，请继续保持呦!";
        remindLabel2.textColor = [UIColor whiteColor];
        remindLabel2.textAlignment = NSTextAlignmentCenter;
        [headerImageView addSubview:remindLabel2];
        self.remindLabel2 = remindLabel2;
        [self.remindLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView.mas_centerY).offset(40.0);
            make.centerX.equalTo(self.remindLabel1);
        }];
        

//
//        [routeView setFrame:CGRectMake((imageViewW-routeViewW)/2.0, (imageViewH-routeViewH)/2.0, routeViewW, routeViewH)];

        UIImageView *selectImageView = [[UIImageView alloc]init];
        [selectImageView setBackgroundColor:[[UIColor colorWithHexString:@"#9C9C9C"] colorWithAlphaComponent:0.70]];
        [_headerImageView addSubview:selectImageView];
        selectImageView.layer.masksToBounds = YES;
        selectImageView.layer.cornerRadius = 4.0f;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        selectImageView.userInteractionEnabled = YES;
        [selectImageView addGestureRecognizer:tap1];
        selectImageView.tag = 101;
        [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(25.0f);
            make.top.equalTo(remindLabel2.mas_bottom).offset(10.0f);
            make.bottom.equalTo(_headerImageView);
            make.width.mas_equalTo(selectImageViewW);
        }];
        UILabel *selectTitle1 = [[UILabel alloc] init];
        selectTitle1.font = [UIFont boldSystemFontOfSize:17.0f];
        selectTitle1.text = @"历史考试";
        selectTitle1.textColor = [UIColor whiteColor];
        selectTitle1.textAlignment = NSTextAlignmentCenter;
        [selectImageView addSubview:selectTitle1];
        [selectTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(selectImageView);
        }];

        
        
        UIImageView *selectImageView2 = [[UIImageView alloc]init];
        [selectImageView2 setBackgroundColor:[[UIColor colorWithHexString:@"#9C9C9C"] colorWithAlphaComponent:0.70]];
        [_headerImageView addSubview:selectImageView2];
        selectImageView2.layer.masksToBounds = YES;
        selectImageView2.layer.cornerRadius = 4.0f;
        selectImageView2.tag = 102;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        selectImageView2.userInteractionEnabled = YES;
        [selectImageView2 addGestureRecognizer:tap2];
        [selectImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(25.0f+selectImageViewW+15.0f);
            make.top.equalTo(remindLabel2.mas_bottom).offset(10.0f);
            make.bottom.equalTo(_headerImageView);
            make.width.mas_equalTo(selectImageViewW);
        }];
        UILabel *selectTitle2 = [[UILabel alloc] init];
        selectTitle2.font = [UIFont boldSystemFontOfSize:17.0f];
        selectTitle2.text = @"待考试";
        selectTitle2.textColor = [UIColor whiteColor];
        selectTitle2.textAlignment = NSTextAlignmentCenter;
        [selectImageView2 addSubview:selectTitle2];
        [selectTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(selectImageView2);
        }];
        
        
        UIImageView *headerBottonView = [[UIImageView alloc]init];
        [_headerImageView addSubview:headerBottonView];
        [headerBottonView setBackgroundColor:[UIColor clearColor]];
        headerBottonView.userInteractionEnabled = NO;
        self.headerBottonView = headerBottonView;
        [headerBottonView setContentMode:UIViewContentModeScaleToFill];
        [headerBottonView setImage:[UIImage imageNamed:@"Exam_header_botton"]];
        [headerBottonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remindLabel2.mas_bottom).offset(10.0f);
            make.left.equalTo(_headerImageView);
            make.right.equalTo(_headerImageView);
            make.bottom.equalTo(_headerImageView);
        }];

        
        
        UILabel *paimingLabel = [[UILabel alloc] init];
        paimingLabel.font = [UIFont systemFontOfSize:16.0f];
        paimingLabel.text = @"考试排名";
        paimingLabel.textColor = [UIColor colorWithHexString:@"#FF6A00"];
        paimingLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:paimingLabel];
        [paimingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerImageView.mas_bottom).offset(30.0f);
            make.centerX.equalTo(_headerView);
            make.height.mas_equalTo(15.0f);
        }];
        
        
        UIImageView *leftLineImageView = [[UIImageView alloc]init];
        [_headerView addSubview:leftLineImageView];
        [leftLineImageView setContentMode:UIViewContentModeCenter];
        [leftLineImageView setImage:[UIImage imageNamed:@"Exam_line"]];
        [leftLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(paimingLabel.mas_left).offset(-15);
            make.centerY.equalTo(paimingLabel);
        }];
        
        
        UIImageView *rightLineImageView = [[UIImageView alloc]init];
        [_headerView addSubview:rightLineImageView];
        [rightLineImageView setContentMode:UIViewContentModeCenter];
        [rightLineImageView setImage:[UIImage imageNamed:@"Exam_line"]];
        [rightLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(paimingLabel.mas_right).offset(15);
            make.centerY.equalTo(paimingLabel);
        }];

    }
    return _headerView;
}

-(void)resetView{
    for (NSInteger i = 0; i<self.viewsArr.count; i++) {
        UIButton *currentBtn = self.viewsArr[i];
        currentBtn.selected = NO;
    }
}

-(void)resetViewWithData{
    if (self.ownerRankeModel) {
        NSInteger score = [self.ownerRankeModel.score integerValue];
        if (score > 100) {
            score = 100;
        }
        score = 80;
        NSInteger num = score/5;
        
        if (num >0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (NSInteger i = 0; i<num; i++) {
                    UIButton *currentBtn = self.viewsArr[i];
                    [UIView animateWithDuration:10 animations:^{
                        currentBtn.selected = YES;
                    }];
                }
            });
        }

    }
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}



-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    UIImageView *touchView = (UIImageView *)tap.view;
    NSInteger viewTag = touchView.tag;
    if (viewTag == 101) {
        ExamWaitingViewController *waitingVC = [[ExamWaitingViewController alloc]init];
        waitingVC.hidesBottomBarWhenPushed = YES;
        waitingVC.type = ExamViewTypeDefault;
        [self.navigationController pushViewController:waitingVC animated:YES];

    }else if (viewTag == 102){
        ExamWaitingViewController *waitingVC = [[ExamWaitingViewController alloc]init];
        waitingVC.hidesBottomBarWhenPushed = YES;
        waitingVC.type = ExamViewTypeHistory;
        [self.navigationController pushViewController:waitingVC animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
