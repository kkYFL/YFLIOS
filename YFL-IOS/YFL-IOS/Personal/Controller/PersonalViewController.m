//
//  PersonalViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/19.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonMidTableViewCell.h"
#import "PersonRowTableViewCell.h"
#import "SigninRecordViewController.h"
#import "PersonJIfenViewController.h"
#import "PersonXinxiViewController.h"
#import "PersonPassWordController.h"
#import "HanZhaoHua.h"
#import "AppDelegate.h"


@interface PersonalViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descibeLabel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) NSInteger serverCount;


@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
    
    [self loadData];
}

-(void)initView{
    self.title = @"个人中心";
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self.view addSubview:self.table];
    self.table.tableHeaderView = self.headerView;
    

    [self addObserver:self forKeyPath:@"serverCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
}

-(void)initData{
    self.serverCount = 0;
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
    
    /**
     个人中心—用户信息查询接口
     
     */
//    NSMutableDictionary  *para = [NSMutableDictionary dictionary];
//    [para setValue:APP_DELEGATE.userToken forKey:@"userToken"];
//    [para setValue:APP_DELEGATE.userId forKey:@"userId"];
//    [HanZhaoHua GetPersonInfoSourceWithParaDic:para success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"");
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
    
    // 用户当前积分
    // 测试结果: 通过
        [HanZhaoHua getUserCurrentScoreWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId success:^(NSNumber * _Nonnull score) {
            NSLog(@"%@", score);
            self.serverCount ++;
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
            self.serverCount ++;
        }];
    
    
    // 用户签到日历
    // 测试结果: 接口通过, 但是无有效数据返回
    NSDate *newDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:newDate];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    [HanZhaoHua getUserSignInRecordWithUserToken:APP_DELEGATE.userToken userId:APP_DELEGATE.userId year:year month:month success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        self.serverCount ++;
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
        self.serverCount ++;
    }];
    
}


#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self initData];
    [self loadData];
}



#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}



#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return [PersonMidTableViewCell CellH];
    }
    
    return [PersonRowTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        PersonMidTableViewCell *midCell = [tableView dequeueReusableCellWithIdentifier:@"midCell"];
        __weak typeof(self) weakSelf = self;
        midCell.selectViewBlock = ^(NSInteger viewIndex) {
            if (viewIndex == 1) {
                PersonJIfenViewController *jifenVC = [[PersonJIfenViewController alloc]init];
                jifenVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:jifenVC animated:YES];
                
            }else if (viewIndex == 2){
                SigninRecordViewController *signRecordVC = [[SigninRecordViewController alloc]init];
                signRecordVC.hidesBottomBarWhenPushed  = YES;
                [weakSelf.navigationController pushViewController:signRecordVC animated:YES];
            }
        };
        return midCell;
    }
    
    PersonRowTableViewCell *rowCell = [tableView dequeueReusableCellWithIdentifier:@"rowCell"];
    if(indexPath.row == 1){
        rowCell.cellTitleLabel.text = @"个人信息";
        rowCell.cellContentLabel.text = @"请完善个人信息";
        rowCell.cellNewImageView.hidden = YES;
    }else if (indexPath.row == 2){
        rowCell.cellTitleLabel.text = @"密码管理";
        rowCell.cellContentLabel.text = @"可设置微信、短信等方式";
        rowCell.cellNewImageView.hidden = YES;
        
    }else if (indexPath.row == 3){
        rowCell.cellTitleLabel.text = @"版本更新";
        rowCell.cellContentLabel.text = @"有新版本需要更新呦";
        rowCell.cellNewImageView.hidden = NO;
    }else{
        rowCell.cellTitleLabel.text = @"关于";
        rowCell.cellContentLabel.text = @"";
        rowCell.cellNewImageView.hidden = YES;
    }
    
    return rowCell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //信息
    if (indexPath.row == 1) {
        PersonXinxiViewController *xinxiVC = [[PersonXinxiViewController alloc]init];
        xinxiVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:xinxiVC animated:YES];
    }else if (indexPath.row == 2){
        PersonPassWordController *passVC = [[PersonPassWordController alloc]init];
        passVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:passVC animated:YES];
    }
}

#pragma mark - 懒加载
-(UITableView *)table{
    if(!_table){
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TAB_BAR_HEIGHT)];
        _table = table;
        _table.backgroundColor = RGB(242, 242, 242);
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
        _table.tableFooterView = self.footerView;
        
        [_table registerClass:[PersonMidTableViewCell class] forCellReuseIdentifier:@"midCell"];
        [_table registerClass:[PersonRowTableViewCell class] forCellReuseIdentifier:@"rowCell"];
        
    }
    return _table;
}

-(void)refreshViewWithData{
    NSString *headerurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,APP_DELEGATE.userModel.headImg];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headerurl] placeholderImage:[UIImage imageNamed:@"exam_header"]];
//    [self.iconImageView setImage:[UIImage imageNamed:@"exam_header"]];
    [self.nameLabel setText:APP_DELEGATE.userModel.userName];
    [self.descibeLabel setText:APP_DELEGATE.userModel.motto];
}

-(UIView *)headerView{
    if(!_headerView){
        CGFloat topSpace = 25.0f;
        CGFloat settingWH = 30.0f;
        CGFloat iconWH = 60.0f;
        CGFloat cameraWH = 30.0f;
        CGFloat describeLabelH = 16.0f;
        CGFloat bottonViewH = 40.0f;
        
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor redColor];
        _headerView = headerView;
        [_headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, topSpace+settingWH+iconWH+cameraWH+describeLabelH+25+bottonViewH)];
        
        
        UIImageView *settingImageView = [[UIImageView alloc]init];
        [_headerView addSubview:settingImageView];
        [settingImageView setContentMode:UIViewContentModeCenter];
        [settingImageView setImage:[UIImage imageNamed:@"setting"]];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        settingImageView.userInteractionEnabled = YES;
        [settingImageView addGestureRecognizer:tap1];
        [settingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerView).offset(topSpace);
            make.right.equalTo(_headerView.mas_right).offset(-25);
            make.height.with.mas_equalTo(settingWH);
        }];
        
        
        UIImageView *iconImageView = [[UIImageView alloc]init];
        [iconImageView setBackgroundColor:[UIColor whiteColor]];
        [_headerView addSubview:iconImageView];
        [iconImageView setContentMode:UIViewContentModeScaleToFill];
        [iconImageView setImage:[UIImage imageNamed:@"exam_header"]];
        iconImageView.layer.masksToBounds = YES;
        iconImageView.layer.cornerRadius = iconWH/2.0;
        self.iconImageView = iconImageView;
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(settingImageView.mas_bottom).offset(0);
            make.centerX.equalTo(_headerView);
            make.height.width.mas_equalTo(iconWH);
        }];
        
        
        UIImageView *cameraImageView = [[UIImageView alloc]init];
        [_headerView addSubview:cameraImageView];
        [cameraImageView setContentMode:UIViewContentModeCenter];
        [cameraImageView setImage:[UIImage imageNamed:@"camara"]];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        cameraImageView.userInteractionEnabled = YES;
        [cameraImageView addGestureRecognizer:tap2];
        [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).offset(0);
            make.right.equalTo(iconImageView.mas_centerX).offset(-6);
            make.height.width.mas_equalTo(cameraWH);
        }];

        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.text = @"张三";
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [_headerView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_centerX).offset(6);
            make.centerY.equalTo(cameraImageView);
        }];

        
        UILabel *descibeLabel = [[UILabel alloc] init];
        descibeLabel.font = [UIFont systemFontOfSize:14.0f];
        descibeLabel.numberOfLines = 0;
        descibeLabel.text = @"谁说蓝色代表悲伤，你看看天空和海洋";
        descibeLabel.textColor = [UIColor whiteColor];
        descibeLabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:descibeLabel];
        self.descibeLabel = descibeLabel;
        [descibeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cameraImageView.mas_bottom);
            make.centerX.equalTo(_headerView);
            make.width.mas_equalTo(SCREEN_WIDTH-30.0);
            make.height.mas_equalTo(describeLabelH);
        }];
        
        
        UIView *bottonView = [[UIView alloc]init];
        bottonView.backgroundColor = [UIColor colorWithRed:226/255.0 green:53/255.0 blue:66/255.0 alpha:1];
        [_headerView addSubview:bottonView];
        [bottonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(0);
            make.top.equalTo(descibeLabel.mas_bottom).offset(25.0f);
            make.right.equalTo(_headerView).offset(0);
            make.height.mas_equalTo(bottonViewH);
        }];
        
        
        UIButton *signButton = [[UIButton alloc]init];
        signButton.backgroundColor = [UIColor colorWithRed:226/255.0 green:53/255.0 blue:66/255.0 alpha:1];
        [signButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
        signButton.layer.masksToBounds = YES;
        signButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        signButton.layer.borderWidth = 0.5f;
        [signButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [signButton setTitle:@"签到" forState:UIControlStateNormal];
        [bottonView addSubview:signButton];
        [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottonView).offset(25.0f);
            make.centerY.equalTo(bottonView);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
        }];
        
        
        UILabel *signLabel = [[UILabel alloc] init];
        signLabel.font = [UIFont systemFontOfSize:12.0f];
        signLabel.text = @"已签到13天，请继续保持呦！";
        signLabel.textColor = [UIColor whiteColor];
        signLabel.textAlignment = NSTextAlignmentLeft;
        [bottonView addSubview:signLabel];
        [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(signButton.mas_right).offset(16.0f);
            make.centerY.equalTo(signButton);
        }];
    }
    return _headerView;
}

-(UIView *)footerView{
    if (!_footerView) {
        UIView *footerView = [[UIView alloc]init];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [footerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_SCALE*(50+25)+40)];
        _footerView = footerView;
        
        UIButton *outButton = [[UIButton alloc]init];
        outButton.backgroundColor = [UIColor whiteColor];
        [outButton addTarget:self action:@selector(signOutAction:) forControlEvents:UIControlEventTouchUpInside];
        outButton.layer.masksToBounds = YES;
        outButton.layer.borderColor = [UIColor colorWithHexString:@"#D64348"].CGColor;
        outButton.layer.borderWidth = 0.5f;
        [outButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [outButton setTitleColor:[UIColor colorWithHexString:@"#FF0000"] forState:UIControlStateNormal];
        [outButton setTitle:@"安全退出" forState:UIControlStateNormal];
        outButton.layer.cornerRadius = 4.0f;
        [_footerView addSubview:outButton];
        
        [outButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_footerView).offset(HEIGHT_SCALE*50);
            make.centerX.equalTo(_footerView);
            make.width.mas_equalTo(WIDTH_SCALE*300);
            make.height.mas_equalTo(40.0f);
        }];
        
    }
    return _footerView;
}

//退出登录
-(void)signOutAction:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationUserSignOut object:nil];
}

-(void)sign:(UIButton *)sender{
    
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void*)context{
    NSInteger new = [[change objectForKey:@"new"] integerValue];
    
    //数据渲染
    if (new == 2) {
        [self refreshViewWithData];
        [self.table reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"serverCount"];
}



@end
