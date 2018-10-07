//
//  PersonXinxiViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonXinxiViewController.h"
#import "XinxiTableViewCell.h"
#import "EWTMediator+EWTImagePicker.h"
#import "AppDelegate.h"
#import "HanZhaoHua.h"

#define kMaxCount 4


@interface PersonXinxiViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate
>
@property (nonatomic, strong) UITableView *table;
/** 获取图片方式选择器 */
@property (nonatomic, strong) UIActionSheet *getPhotosSheet;
/** 已选图片集合 */
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation PersonXinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadData];
}

-(void)initView{
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 20, 20, @"view_back", @"view_back", leftButtonAction);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    
    [self.view addSubview:self.table];
    

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


#pragma mark - UITableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowNum = 1;
    if (section == 1) {
        rowNum = 3;
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [XinxiTableViewCell CellH];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XinxiTableViewCell *xinxiCell = [tableView dequeueReusableCellWithIdentifier:@"xinxiCell"];
    if (indexPath.section == 0) {
        xinxiCell.type = XinxiCellTypeWithIconAndRow;
        xinxiCell.cellTitleLabel.text = @"用户头像";        
        NSString *headerurl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,APP_DELEGATE.userModel.headImg];
        [xinxiCell.headerIcon sd_setImageWithURL:[NSURL URLWithString:headerurl] placeholderImage:[UIImage imageNamed:@"exam_header"]];
        //    [self.iconImageView setImage:[UIImage imageNamed:@"exam_header"]];
        
        
    }else if (indexPath.section == 1){
        NSString *titleStr = @"";
        NSString *contentStr = @"";
        if (indexPath.row ==0) {
            titleStr = @"用户名";
            contentStr = APP_DELEGATE.userName;
        }else if (indexPath.row ==1){
            titleStr = @"手机号码";
            contentStr = APP_DELEGATE.userModel.userName;
        }else if (indexPath.row ==2){
            titleStr = @"实名认证";
            contentStr = @"*架兔(**************5546)";
        }
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = titleStr;
        xinxiCell.cellContentLabel.text = contentStr;
    }else if (indexPath.section == 2){
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = @"我的座右铭";
        xinxiCell.cellContentLabel.text = APP_DELEGATE.userModel.motto;
    }else if (indexPath.section == 3){
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = @"我的地址";
        xinxiCell.cellContentLabel.text = APP_DELEGATE.userModel.pmAddress;
    }
    
    return xinxiCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    
    return [self headerViewWithIcon:nil Title:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat sectionH = 0.01f;
    if (section == 0) {
        sectionH = 0.01;
    }else{
        sectionH = 15.0f;
    }
    return sectionH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self showActionSheet];
    }
}

-(UIView *)headerViewWithIcon:(NSString *)icon Title:(NSString *)title{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
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
        
        [_table registerClass:[XinxiTableViewCell class] forCellReuseIdentifier:@"xinxiCell"];
    }
    return _table;
}


#pragma mark - UIActionSheet 代理

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhotos];
            break;
            
        case 1:  //打开本地相册
            [self getLocalPhotos];
            break;
    }
}

-(void)takePhotos {
    __weak typeof(self) weakSelf = self;
    
    [EWTMediator EWTImagePicker_getImageFromCameraWithController:self authorityType:SystemAuthorityVideo allowCrop:NO completion:^(NSArray<UIImage *> *images) {
        UIImage* originalImg = [images firstObject];
        if (originalImg) {
            // 原图压缩处理（要求最多压缩2次将图片不然延迟感太强）
            CGFloat compressionQuality = 0.05f;
            NSData *compressedImgData = UIImageJPEGRepresentation(originalImg, 1.0f);
            if ((compressedImgData.length / 1024.0f) > 200.0f) {
                compressedImgData = UIImageJPEGRepresentation(originalImg, compressionQuality);
            }
            // 将压缩后的图片重新赋值给原图片
            originalImg = [UIImage imageWithData:compressedImgData];
            // 将图片添加到数组中
            [weakSelf.images addObject:originalImg];
        }
        //[weakSelf showImagesView];
    }];
}

-(void)getLocalPhotos {
    __weak typeof(self) weakSelf = self;
    [EWTMediator EWTImagePicker_getImageFromLibraryWithController:self maxNum:kMaxCount allowCrop:YES completion:^(NSArray<UIImage *> *images) {
        if (images && images.count > 0) {
            [weakSelf.images addObjectsFromArray:images];
            if (weakSelf.images.count > kMaxCount) {
                NSString* msg = [NSString stringWithFormat:@"最多添加%zd张照片",kMaxCount];
                [[PromptBox sharedBox] showTextPromptBoxWithText:msg onView:weakSelf.view];
                [weakSelf.images removeObjectsInRange:NSMakeRange(kMaxCount, (weakSelf.images.count - kMaxCount))];
            }
            //[weakSelf showImagesView];
        }
    }];
}


#pragma mark - Photo/Library
- (void)showActionSheet {
    //[self resignKeyboard];
    self.getPhotosSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"打开照相机", @"从手机相册获取", nil];
    self.getPhotosSheet.delegate = self;
    [self.getPhotosSheet showInView:self.view];
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
    // 个人信息
    // 测试结果: 通过
        [HanZhaoHua changePersonalInformationWithUserId:APP_DELEGATE.userId headImg:@"" motto:@"hijjokplpoppkookokokehe" success:^(NSDictionary * _Nonnull responseObject) {
            NSLog(@"%@", responseObject);
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];

}


- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        return _images;
    }
    return _images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
