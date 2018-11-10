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
#import "UserMessage.h"

#define kMaxCount 1


@interface PersonXinxiViewController ()<UITableViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate
>{
    BOOL allowEdting;
    
    NSString *headerImageUrl;
    NSString *phoneInputStr;
    NSString *sexInputStr;
    NSString *mottoInputStr;
    NSString *addressInputStr;
}

@property (nonatomic, strong) UITableView *table;
/** 获取图片方式选择器 */
@property (nonatomic, strong) UIActionSheet *getPhotosSheet;
/** 已选图片集合 */
@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) NSString *userServerPic;

@property (nonatomic, strong) UIButton *righBtn;

@end

@implementation PersonXinxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
    
    [self loadData];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    NAVIGATION_BAR_LEFT_BUTTON(0, 0, 25, 25, @"view_back", @"view_back", leftButtonAction);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setTitle:[AppDelegate getURLWithKey:@"xiugai"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.righBtn = button;
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    
    [self.view addSubview:self.table];
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textContentDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)initData{
    allowEdting = NO;
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
    return 3;
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
    xinxiCell.cellContentLabel.delegate = self;
    
    
    if (indexPath.section == 0) {
        xinxiCell.type = XinxiCellTypeWithIconAndRow;
        xinxiCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"yonghutouxiang"];
        
        NSString *headimageUrl = @"";
        if ([self.userModel.headImg hasPrefix:@"http"]) {
            headimageUrl = self.userModel.headImg;
        }else{
            headimageUrl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.userModel.headImg];
        }
        [xinxiCell.headerIcon sd_setImageWithURL:[NSURL URLWithString:headimageUrl] placeholderImage:[UIImage imageNamed:@"exam_header"]];
        
        
    }else if (indexPath.section == 1){
        NSString *titleStr = @"";
        NSString *contentStr = @"";
        if (indexPath.row ==0) {
            titleStr = [AppDelegate getURLWithKey:@"zhengshixingming"];
            contentStr = self.userModel.pmName;
            xinxiCell.cellContentLabel.tag = 101;
        }else if (indexPath.row ==1){
            titleStr = [AppDelegate getURLWithKey:@"PhoneNum"];
            contentStr = phoneInputStr?self.userModel.userName:self.userModel.userName;
            xinxiCell.cellContentLabel.tag = 102;
        }else if (indexPath.row ==2){
            titleStr = [AppDelegate getURLWithKey:@"sex"];
            if ([self.userModel.pmSex integerValue] == 1) {
                contentStr = [AppDelegate getURLWithKey:@"nan"];
            }else if ([self.userModel.pmSex integerValue] == 2){
                contentStr = [AppDelegate getURLWithKey:@"nv"];
            }
            if (sexInputStr.length) {
                contentStr = sexInputStr;
            }
            xinxiCell.cellContentLabel.tag = 103;
        }
        
        if ([NSString isBlankString:contentStr]) {
            contentStr = @"";
        }
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = titleStr;
        xinxiCell.cellContentLabel.text = contentStr;
    }else if (indexPath.section == 2){
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"wodezuoyouming"];
        xinxiCell.cellContentLabel.tag = 104;
        xinxiCell.cellContentLabel.text = mottoInputStr.length?mottoInputStr:self.userModel.motto;
    }else if (indexPath.section == 3){
        xinxiCell.type = XinxiCellTypeWithJustContent;
        xinxiCell.cellTitleLabel.text = [AppDelegate getURLWithKey:@"wodedizhi"];
        xinxiCell.cellContentLabel.text = addressInputStr.length?addressInputStr:self.userModel.pmAddress;
        xinxiCell.cellContentLabel.tag = 105;
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
    if (allowEdting) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            [self showActionSheet];
        }
        
    }
}

-(UIView *)headerViewWithIcon:(NSString *)icon Title:(NSString *)title{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [headerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    return headerView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
    if (actionSheet.tag == 101) {
        switch (buttonIndex)
        {
            case 0:
                sexInputStr = [AppDelegate getURLWithKey:@"nan"];
                [self.table reloadData];
                break;
            case 1:
                sexInputStr = [AppDelegate getURLWithKey:@"nv"];
                [self.table reloadData];
                break;
        }
    }else{
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
}

-(void)takePhotos {
    __weak typeof(self) weakSelf = self;
    
    if (self.images.count) {
        [self.images removeAllObjects];
    }
    
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
            
            
            UIImage *imageOrigin = weakSelf.images[0];
            UIImage *imageNew = [weakSelf imageWithOriginalImage:imageOrigin andScaledSize:CGSizeMake(60, 60)];
            [self.images removeAllObjects];
            [self.images addObject:imageNew];
        }
        
        [self uploadImageToServer];
        //[weakSelf showImagesView];
    }];
}

-(void)getLocalPhotos {
    __weak typeof(self) weakSelf = self;
    
    if (self.images.count) {
        [self.images removeAllObjects];
    }
    
    [EWTMediator EWTImagePicker_getImageFromLibraryWithController:self maxNum:kMaxCount allowCrop:YES completion:^(NSArray<UIImage *> *images) {
        if (images && images.count > 0) {
            [weakSelf.images addObjectsFromArray:images];
            UIImage *imageOrigin = weakSelf.images[0];
            UIImage *imageNew = [weakSelf imageWithOriginalImage:imageOrigin andScaledSize:CGSizeMake(60, 60)];
            [self.images removeAllObjects];
            [self.images addObject:imageNew];
            [self uploadImageToServer];
            //[weakSelf showImagesView];
        }
    }];
}


#pragma mark - Photo/Library
- (void)showActionSheet {
    //[self resignKeyboard];
    self.getPhotosSheet = [[UIActionSheet alloc] initWithTitle:[AppDelegate getURLWithKey:@"xiugaitouxiang"]
                                                      delegate:self
                                             cancelButtonTitle:[AppDelegate getURLWithKey:@"quxiao"]
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:[AppDelegate getURLWithKey:@"dakaixiangji"], [AppDelegate getURLWithKey:@"dakixiangce"], nil];
    self.getPhotosSheet.tag = 100;
    self.getPhotosSheet.delegate = self;
    [self.getPhotosSheet showInView:self.view];
}

- (void)showSexActionSheet {
    //[self resignKeyboard];
    UIActionSheet *sexActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:[AppDelegate getURLWithKey:@"quxiao"]
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:[AppDelegate getURLWithKey:@"nan"], [AppDelegate getURLWithKey:@"nv"], nil];
    sexActionSheet.tag = 101;
    sexActionSheet.delegate = self;
    [sexActionSheet showInView:self.view];
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
    if (!allowEdting) {
        [self.righBtn setTitle:[AppDelegate getURLWithKey:@"baocun"] forState:UIControlStateNormal];
        allowEdting = YES;
        
        [self showActionSheet];
    }else{
        [self.righBtn setTitle:[AppDelegate getURLWithKey:@"xiugai"] forState:UIControlStateNormal];
        allowEdting = NO;
        
        [self savePersonSource];
    }

}

-(void)savePersonSource{
    
    if ([NSString isBlankString:headerImageUrl] && [NSString isBlankString:phoneInputStr] && [NSString isBlankString:sexInputStr] && [NSString isBlankString:mottoInputStr] && [NSString isBlankString:addressInputStr]) {
        
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"xuanzexiugaineirong"] ToView:self.view];
        return;
    }

    
    // 个人信息
    // 测试结果: 通过
    NSString *sexNum = @"";
    if ([sexInputStr isEqualToString:[AppDelegate getURLWithKey:@"nan"]]) {
        sexNum = @"1";
    }else if ([sexInputStr isEqualToString:[AppDelegate getURLWithKey:@"nv"]]){
        sexNum = @"2";
    }
    
    if (!sexNum.length) {
        NSString *sexStr = self.userModel.pmSex;
        if ([sexStr integerValue] == 1) {
            sexNum = @"1";
        }else if ([sexStr integerValue] == 2){
            sexNum = @"2";
        }
    }

    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setValue:APP_DELEGATE.userId forKey:@"userId"];
    [para setValue:self.userModel.headImg forKey:@"headImg"];
    [para setValue:mottoInputStr?mottoInputStr:self.userModel.motto forKey:@"motto"];
    [para setValue:addressInputStr?addressInputStr:self.userModel.pmAddress forKey:@"address"];
    [para setValue:sexNum forKey:@"sex"];

    
    [HanZhaoHua savePersonalSourceWithPara:para success:^(NSDictionary * _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"saveSuccess"] ToView:self.view];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPersonViewSourceNoti" object:nil];
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"saveError"] ToView:self.view];
    }];
    
}


-(void)uploadImageToServer{
    // 文件上传
    //测试结果:
    if (self.images.count) {
       [[PromptBox sharedBox] showLoadingWithText:[AppDelegate getURLWithKey:@"shangchuanzhong"] onView:self.view];

        UIImage *image = self.images[0];
        NSData *data = UIImagePNGRepresentation(image);
        
        [HanZhaoHua uploadFileWithFiles:data success:^(NSString * _Nonnull imgUrl) {
            [[PromptBox sharedBox] removeLoadingView];
            
            headerImageUrl = [imgUrl copy];
            self.userModel.headImg = imgUrl;
            [self.table reloadData];
            
        } failure:^(NSError * _Nonnull error) {
            [[PromptBox sharedBox] removeLoadingView];
        }];
    }

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (allowEdting) {
        if (textField.tag == 101) {
            [MBProgressHUD toastMessage:[AppDelegate getURLWithKey:@"bukexiugaixingming"] ToView:self.view];
            return NO;
        }
        
        if (textField.tag == 103) {
            [self.view endEditing:YES];
            [self showSexActionSheet];
            return NO;
        }
        
        return YES;
    }
    
    return NO;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)textContentDidChange:(NSNotification *)noti{
    UITextField *currentTextfield = (UITextField *)noti.object;
    
    if (currentTextfield.tag == 102){
        phoneInputStr = currentTextfield.text;
    }else if (currentTextfield.tag == 103){
        sexInputStr = currentTextfield.text;
    }else if (currentTextfield.tag == 104){
        mottoInputStr = currentTextfield.text;
    }else if (currentTextfield.tag == 105){
        addressInputStr = currentTextfield.text;
    }
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

-(UIImage *)imageWithOriginalImage:(UIImage *)originalImage andScaledSize:(CGSize)imageNewSize{
    UIGraphicsBeginImageContext(imageNewSize);
    [originalImage drawInRect:CGRectMake(0, 0, imageNewSize.width, imageNewSize.height)];
    UIImage *imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageNew;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title = [AppDelegate getURLWithKey:@"GerenXinxi"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
