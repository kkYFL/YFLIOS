//
//  EWTLoginView.m
//  AFNetworking
//
//  Created by 李天露 on 2018/4/4.
//

#import "EWTLoginView.h"
//#import "UserCenterHTTPEngineGuide.h"
#import "EWTBase.h"


#define kTextFieldHeight (60*HEIGHT_SCALE)

@interface EWTLoginView ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *phoneImageIcon;
@property (nonatomic, strong) UIImageView *passwordImageIcon;

@end

@implementation EWTLoginView

- (id)init
{
    self = [super init];
    if (self) {
        self.errorCount = 0;
        [self configUI];
        [self addNotifi];
    }
    return self;
}

- (void)dealloc {
    [self removeNotifi];
}

- (void)addNotifi {
    //建立通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange)name:UITextFieldTextDidChangeNotification object:_passwordField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange)name:UITextFieldTextDidChangeNotification object:_phoneAndIDField];
}

- (void)removeNotifi {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_phoneAndIDField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_passwordField];
}

-(void)textChange
{
    _nextVCButton.enabled = ((_passwordField.text.length>5) && (_phoneAndIDField.text.length>0));
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    
    //
    UIImageView *phoneImageIcon = [[UIImageView alloc]init];
    [self addSubview:phoneImageIcon];
    self.phoneImageIcon = phoneImageIcon;
    [phoneImageIcon setContentMode:UIViewContentModeCenter];
    [phoneImageIcon setImage:[UIImage imageNamed:@"change_phone_num__second_phone"]];
    [phoneImageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(0);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    

    //账号/手机号
    _phoneAndIDField = [[UITextField alloc] init];
    _phoneAndIDField.placeholder = @"账号/手机号";
    _phoneAndIDField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    _phoneAndIDField.borderStyle = UITextBorderStyleNone;
    _phoneAndIDField.textAlignment = NSTextAlignmentLeft;
    _phoneAndIDField.font = [UIFont systemFontOfSize:16];
    _phoneAndIDField.clearButtonMode = UITextFieldViewModeAlways;
    [self addSubview:_phoneAndIDField];
    [_phoneAndIDField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.equalTo(self.phoneImageIcon.mas_right).offset(5);
        make.right.equalTo(self).offset(-20);
    }];
    
    UIView* line1 = [[UIView alloc] init];
    line1.backgroundColor = HEXACOLOR(0xEEEFF3, 1.0);
    [_phoneAndIDField addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.phoneAndIDField);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.phoneImageIcon);
        make.right.equalTo(self.phoneAndIDField);

    }];
    
    UIImageView *passwordImageIcon = [[UIImageView alloc]init];
    [self addSubview:passwordImageIcon];
    self.passwordImageIcon = passwordImageIcon;
    [passwordImageIcon setContentMode:UIViewContentModeCenter];
    [passwordImageIcon setImage:[UIImage imageNamed:@"change_phone_num__second_verification_code"]];
    [passwordImageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.phoneAndIDField.mas_bottom);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    
    
    //密码
    _passwordField = [[UITextField alloc] init];
    _passwordField.placeholder = @"密码";
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.textAlignment = NSTextAlignmentLeft;
    _passwordField.font = [UIFont systemFontOfSize:16];
    _passwordField.clearButtonMode = UITextFieldViewModeAlways;
    _passwordField.secureTextEntry = YES;
    [self addSubview:_passwordField];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneAndIDField.mas_bottom);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.equalTo(self.passwordImageIcon.mas_right).offset(5);
        make.right.equalTo(self).offset(-20);
    }];
    UIView* line2 = [[UIView alloc] init];
    line2.backgroundColor = HEXACOLOR(0xEEEFF3, 1.0);
    [_passwordField addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.passwordField);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.passwordImageIcon);
        make.right.equalTo(self.passwordField);
    }];
    
    
    //下一步
    _nextVCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextVCButton.frame = CGRectMake(20, kTextFieldHeight*2+36, SCREEN_WIDTH - 20*2, 45);
    _nextVCButton.layer.cornerRadius = 4.0;
    _nextVCButton.layer.masksToBounds = YES;

    
    if (_passwordField.text.length != 0) {
        _nextVCButton.enabled = YES;
    } else {
        _nextVCButton.enabled = NO;
    }
    [_nextVCButton setTitle:@"登录" forState:UIControlStateNormal];
    [_nextVCButton addTarget:self action:@selector(dologin:) forControlEvents:UIControlEventTouchUpInside];
    [_nextVCButton setBackgroundColor:[UIColor colorWithHexString:@"#0096F6"]];
//    [_nextVCButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextVCButton setBackgroundColor:[UIColor redColor]];
    [_nextVCButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    _nextVCButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:_nextVCButton];

    //密码找回
    UIButton *findButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [findButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    findButton.titleLabel.textAlignment = NSTextAlignmentRight;
    findButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [findButton addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
//    [findButton setTitleColor:HEXACOLOR(0xA7ACB9, 1.0) forState:UIControlStateNormal];
    [findButton setTitleColor:[UIColor colorWithHexString:@"#0096F6"] forState:UIControlStateNormal];

    [self addSubview:findButton];
    [findButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nextVCButton.mas_bottom).offset(12);
        make.height.mas_equalTo(18);
        make.width.lessThanOrEqualTo(@100);
        //make.right.equalTo(self).offset(-22);
        make.centerX.equalTo(self.nextVCButton);
    }];
    
    

}




#pragma mark 忘记密码
- (void)findPassword {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"忘记密码" message:@"请拨打 13634174103进行充值！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

-(void)layoutSubviews {
    
}

#pragma mar 登录
-(void)dologin:(UIButton*)btn {
    [self endEditing:YES];
    if (self.loginBtnBlock) {
        self.loginBtnBlock(btn);
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"13634174103"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


@end
