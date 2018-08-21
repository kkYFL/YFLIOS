//
//  EWTLoginView.h
//  AFNetworking
//
//  Created by 李天露 on 2018/4/4.
//

#import <UIKit/UIKit.h>


@interface EWTLoginView : UIView

@property (nonatomic, assign)NSInteger errorCount;//密码错误次数

@property (strong, nonatomic) UITextField *phoneAndIDField;//用户名
@property (strong, nonatomic) UITextField *passwordField;//密码
@property (strong, nonatomic) UIButton *nextVCButton;

@property (copy, nonatomic) void (^loginBtnBlock)(UIButton* btn);

@end
