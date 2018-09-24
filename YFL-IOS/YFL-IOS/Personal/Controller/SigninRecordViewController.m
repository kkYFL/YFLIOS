//
//  SigninRecordViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/7.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "SigninRecordViewController.h"
#import "DIYCalendarCell.h"

#define kViolet [UIColor colorWithRed:170/255.0 green:114/255.0 blue:219/255.0 alpha:1.0]
//NS_ASSUME_NONNULL_BEGIN

#define headerViewH 273*HEIGHT_SCALE

@interface SigninRecordViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *signNumLabel;
@property (nonatomic, strong) UILabel *hasOnDay;
@property (nonatomic, strong) UILabel *hasOnDayRight;

@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@property (strong, nonatomic) NSDictionary *fillSelectionColors;
@property (strong, nonatomic) NSDictionary *fillDefaultColors;
@property (strong, nonatomic) NSDictionary *borderDefaultColors;
@property (strong, nonatomic) NSDictionary *borderSelectionColors;

@property (strong, nonatomic) NSArray *datesWithEvent;
@property (strong, nonatomic) NSArray *datesWithMultipleEvents;


@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@end

@implementation SigninRecordViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
        
        self.fillDefaultColors = @{@"2015/10/08":[UIColor purpleColor],
                                   @"2015/10/06":[UIColor greenColor],
                                   @"2015/10/18":[UIColor cyanColor],
                                   @"2015/10/22":[UIColor yellowColor],
                                   @"2015/11/08":[UIColor purpleColor],
                                   @"2015/11/06":[UIColor greenColor],
                                   @"2015/11/18":[UIColor cyanColor],
                                   @"2015/11/22":[UIColor yellowColor],
                                   @"2015/12/08":[UIColor purpleColor],
                                   @"2015/12/06":[UIColor greenColor],
                                   @"2015/12/18":[UIColor cyanColor],
                                   @"2015/12/22":[UIColor magentaColor]};
        
        self.fillSelectionColors = @{@"2015/10/08":[UIColor greenColor],
                                     @"2015/10/06":[UIColor purpleColor],
                                     @"2015/10/17":[UIColor grayColor],
                                     @"2015/10/21":[UIColor cyanColor],
                                     @"2015/11/08":[UIColor greenColor],
                                     @"2015/11/06":[UIColor purpleColor],
                                     @"2015/11/17":[UIColor grayColor],
                                     @"2015/11/21":[UIColor cyanColor],
                                     @"2015/12/08":[UIColor greenColor],
                                     @"2015/12/06":[UIColor purpleColor],
                                     @"2015/12/17":[UIColor grayColor],
                                     @"2015/12/21":[UIColor cyanColor]};
        
        self.borderDefaultColors = @{@"2015/10/08":[UIColor brownColor],
                                     @"2015/10/17":[UIColor magentaColor],
                                     @"2015/10/21":FSCalendarStandardSelectionColor,
                                     @"2015/10/25":[UIColor blackColor],
                                     @"2015/11/08":[UIColor brownColor],
                                     @"2015/11/17":[UIColor magentaColor],
                                     @"2015/11/21":FSCalendarStandardSelectionColor,
                                     @"2015/11/25":[UIColor blackColor],
                                     @"2015/12/08":[UIColor brownColor],
                                     @"2015/12/17":[UIColor magentaColor],
                                     @"2015/12/21":FSCalendarStandardSelectionColor,
                                     @"2015/12/25":[UIColor blackColor]};
        
        self.borderSelectionColors = @{@"2015/10/08":[UIColor redColor],
                                       @"2015/10/17":[UIColor purpleColor],
                                       @"2015/10/21":FSCalendarStandardSelectionColor,
                                       @"2015/10/25":FSCalendarStandardTodayColor,
                                       @"2015/11/08":[UIColor redColor],
                                       @"2015/11/17":[UIColor purpleColor],
                                       @"2015/11/21":FSCalendarStandardSelectionColor,
                                       @"2015/11/25":FSCalendarStandardTodayColor,
                                       @"2015/12/08":[UIColor redColor],
                                       @"2015/12/17":[UIColor purpleColor],
                                       @"2015/12/21":FSCalendarStandardSelectionColor,
                                       @"2015/12/25":FSCalendarStandardTodayColor};
        
        
        self.datesWithEvent = @[@"2015-10-03",
                                @"2015-10-06",
                                @"2015-10-12",
                                @"2015-10-25"];
        
        self.datesWithMultipleEvents = @[@"2015-10-08",
                                         @"2015-10-16",
                                         @"2015-10-20",
                                         @"2015-10-28"];
        
        
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        self.dateFormatter1 = [[NSDateFormatter alloc] init];
        self.dateFormatter1.dateFormat = @"yyyy/MM/dd";
        
        self.dateFormatter2 = [[NSDateFormatter alloc] init];
        self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.view = view;
    
    [self.view addSubview:self.headerView];
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(15.0f, self.headerView.bottom+15.0f, self.view.bounds.size.width-30.0f, height)];
    calendar.layer.masksToBounds = YES;
    calendar.layer.cornerRadius = 10.0f;
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.allowsMultipleSelection = YES;
    calendar.swipeToChooseGesture.enabled = NO;
    calendar.scrollEnabled = NO;
    calendar.backgroundColor = [UIColor whiteColor];
    
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    //calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    [calendar registerClass:[DIYCalendarCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    //[calendar setCurrentPage:[self.dateFormatter1 dateFromString:@"2018/8/01"] animated:NO];
    [calendar setCurrentPage:[NSDate date] animated:NO];
    
    
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(15, self.headerView.bottom+15.0f+5, 95, 34);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[UIImage imageNamed:@"sign_form"] forState:UIControlStateNormal];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-95-15.0, self.headerView.bottom+15.0f+5, 95, 34);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[UIImage imageNamed:@"sign_next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    
    
    
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"TODAY" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
    self.navigationItem.rightBarButtonItem = todayItem;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"签到记录";
    //self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    NAVIGATION_BAR_RIGHT_BUTTON(0, 0, 21, 21, @"recommend_search_normal", @"recommend_search_selected", rightButtonAction)
    
    
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


#pragma mark - 懒加载
-(UIView *)headerView{
    if (!_headerView) {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:headerView];
        [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerViewH)];
        _headerView = headerView;
        
        
        UIImageView *backView = [[UIImageView alloc]init];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [_headerView addSubview:backView];
        [backView setContentMode:UIViewContentModeScaleToFill];
        [backView setImage:[UIImage imageNamed:@"login-bg"]];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(headerView);
        }];
        
        
        UIImageView *signView = [[UIImageView alloc]init];
        [signView setBackgroundColor:[UIColor redColor]];
        [backView addSubview:signView];
        signView.layer.masksToBounds = YES;
        signView.layer.cornerRadius = 50.0f;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        signView.userInteractionEnabled = YES;
        [signView addGestureRecognizer:tap1];
        [signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backView.mas_centerY).offset(-10);
            make.height.width.mas_equalTo(100);
            make.centerX.equalTo(backView);
        }];
        
        
        
        UILabel *signTitleLabel = [[UILabel alloc] init];
        signTitleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
        signTitleLabel.text = @"签到";
        signTitleLabel.textColor = [UIColor whiteColor];
        signTitleLabel.textAlignment = NSTextAlignmentLeft;
        [signView addSubview:signTitleLabel];
        [signTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(signView);
        }];

        
        
        UILabel *signNumLabel = [[UILabel alloc] init];
        signNumLabel.backgroundColor = [UIColor whiteColor];
        signNumLabel.font = [UIFont systemFontOfSize:14.0f];
        signNumLabel.text = @"今日签到人数：200";
        signNumLabel.textColor = [UIColor colorWithHexString:@"#E51C23"];
        signNumLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:signNumLabel];
        self.signNumLabel = signNumLabel;
        signNumLabel.layer.masksToBounds = YES;
        signNumLabel.layer.cornerRadius = 12.0f;
        CGFloat numW = [PublicMethod getTheWidthOfTheLabelWithContent:signNumLabel.text font:14.0]+20.0;
        [_signNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(signView.mas_bottom).offset(15.0);
            make.centerX.equalTo(backView);
            make.height.mas_equalTo(24.0f);
            make.width.mas_equalTo(numW);
        }];
        
        
        UILabel *hasOnTitle = [[UILabel alloc] init];
        hasOnTitle.font = [UIFont boldSystemFontOfSize:17.0f];
        hasOnTitle.text = @"已坚持天数";
        hasOnTitle.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        hasOnTitle.textAlignment = NSTextAlignmentLeft;
        [backView addSubview:hasOnTitle];
        [hasOnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(30);
            make.bottom.equalTo(backView).offset(-45);
        }];
        
        
        UILabel *hasOnDay = [[UILabel alloc] init];
        hasOnDay.font = [UIFont boldSystemFontOfSize:17.0f];
        hasOnDay.text = @"117";
        hasOnDay.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        hasOnDay.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:hasOnDay];
        self.hasOnDay = hasOnDay;
        [hasOnDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hasOnTitle.mas_bottom).offset(15.0f);
            make.centerX.equalTo(hasOnTitle);
        }];
        
        

        UILabel *hasOnDayTitle = [[UILabel alloc] init];
        hasOnDayTitle.font = [UIFont boldSystemFontOfSize:17.0f];
        hasOnDayTitle.text = @"已连续打卡天数";
        hasOnDayTitle.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        hasOnDayTitle.textAlignment = NSTextAlignmentRight;
        [backView addSubview:hasOnDayTitle];
        [hasOnDayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView).offset(-30);
            make.bottom.equalTo(backView).offset(-45);
        }];
        
        
        UILabel *hasOnDayRight = [[UILabel alloc] init];
        hasOnDayRight.font = [UIFont boldSystemFontOfSize:17.0f];
        hasOnDayRight.text = @"117";
        hasOnDayRight.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        hasOnDayRight.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:hasOnDayRight];
        self.hasOnDayRight = hasOnDayRight;
        [hasOnDayRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(hasOnDayTitle.mas_bottom).offset(15.0f);
            make.centerX.equalTo(hasOnDayTitle);
        }];
        
        
    }
    return _headerView;
}



#pragma mark - 无网络加载数据
- (void)refreshNet{
    [self loadData];
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tap{
    
}

#pragma mark - 返回
- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 右侧按钮
-(void)rightButtonAction{
    
}

#pragma mark - Target actions

- (void)todayItemClicked:(id)sender
{
    [_calendar setCurrentPage:[NSDate date] animated:NO];
}

#pragma mark - <FSCalendarDataSource>

//- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
//{
//    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
//    if ([_datesWithEvent containsObject:dateString]) {
//        return 1;
//    }
//    if ([_datesWithMultipleEvents containsObject:dateString]) {
//        return 3;
//    }
//    return 0;
//}

- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    
    DIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    if ([@[@4,@5,@6,@7,@9,@10,@11,@12,@13,@14,@15,@16,@17] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]) {
        cell.signType = DIYDataTypeNoSign;
    }else{
        cell.signType = DIYDataTypeDefault;
        
    }
    return cell;
}


#pragma mark - <FSCalendarDelegateAppearance>

//- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
//{
//
//    return @[[UIColor blackColor],[UIColor blackColor],[UIColor blackColor]];
//
//    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
//    if ([_datesWithMultipleEvents containsObject:dateString]) {
//        return @[[UIColor magentaColor],appearance.eventDefaultColor,[UIColor blackColor]];
//    }
//    return nil;
//}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_fillSelectionColors.allKeys containsObject:key]) {
//        return _fillSelectionColors[key];
//    }
//    return appearance.selectionColor;
//}



- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    
    if ([@[@4,@5,@6,@7,@9,@10,@11,@12,@13,@14,@15,@16,@17] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]) {
        return [UIColor colorWithRed:250/255.0 green:125/255.0 blue:69/255.0 alpha:1.0];
    }else if([@[@17] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]){
        return [UIColor colorWithRed:249/255.0 green:205/255.0 blue:86/255.0 alpha:1.0];
    }else if([@[@1,@2,@3,@8] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]){
        return [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0];
    }
    
    return nil;
    
    //    return [UIColor redColor];
    //
    //    NSString *key = [self.dateFormatter1 stringFromDate:date];
    //    if ([_fillDefaultColors.allKeys containsObject:key]) {
    //        return _fillDefaultColors[key];
    //    }
    //    return nil;
}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderDefaultColors.allKeys containsObject:key]) {
//        return _borderDefaultColors[key];
//    }
//    return appearance.borderDefaultColor;
//}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
//{
//    NSString *key = [self.dateFormatter1 stringFromDate:date];
//    if ([_borderSelectionColors.allKeys containsObject:key]) {
//        return _borderSelectionColors[key];
//    }
//    return appearance.borderSelectionColor;
//}

- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date
{
    //    if ([@[@8,@17,@21,@25] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]) {
    //        return 0.0;
    //    }
    return 1.0;
}

#pragma mark - <FSCalendarDelegate>

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
    //self.bottomContainer.frame = kContainerFrame;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    return NO;
}

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
