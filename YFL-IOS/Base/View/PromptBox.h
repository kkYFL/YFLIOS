//
//  PromptBox.h
//  carowner
//
//  Created by ZengQingNian on 14-6-23.
//  Copyright (c) 2014年 tianxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface PromptBox : NSObject
{
    MBProgressHUD *MBHUD;
}

+ (PromptBox *)sharedBox;
// 文字提示框
- (void)showTextPromptBoxWithText:(NSString *)text onView:(UIView *)view;
// 文字提示框 + 时间
- (void)showTextPromptBoxWithText:(NSString *)text onView:(UIView *)view withTime:(int)second;
// 文字提示框（可自动换行）y:取值0屏幕中心显示、取值0~0.5以屏幕中心向下偏移、取值0~负0.5以屏幕中心向上偏移
- (void)showPromptBoxWithText:(NSString *)text onView:(UIView *)view hideTime:(NSTimeInterval)second y:(CGFloat)y;

// 视频专用横屏
- (void)showPromptBoxVideoWithText:(NSString *)text onView:(UIView *)view hideTime:(NSTimeInterval)second y:(CGFloat)y;

// 网络Loading提示框
- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view;

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view y:(CGFloat)y;

// 网络Loading提示框（enabled=NO 可以触控界面，此时view的值赋值self.view。enabled=YES 不可以触控界面）
- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view interactionEnabled:(BOOL)enabled;
// 移除网络提示框
- (void)removeLoadingView;

// 变更加载文字
-(void)changeLoadingWithText:(NSString *)text onView:(UIView *)view;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showTextBoxWithText:(NSString *)text yOffset:(float)yOffset;

- (void)showTextBoxWithText:(NSString *)text yOffset:(float)yOffset onView:(UIView *)view;

//从默认(showHint:)显示的位置再往上(下)yOffset 时间可控
- (void)showTextBoxWithText:(NSString *)text yOffset:(float)yOffset afterDelay:(NSInteger)afterDelay;

@end
