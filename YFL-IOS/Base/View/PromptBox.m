//
//  PromptBox.m
//  carowner
//
//  Created by ZengQingNian on 14-6-23.
//  Copyright (c) 2014年 tianxu. All rights reserved.
//

#import "PromptBox.h"

@implementation PromptBox


+ (PromptBox *)sharedBox
{
    static PromptBox *box = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        box = [[PromptBox alloc] init];
        [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    });
    
    return box;
}

- (void)showTextPromptBoxWithText:(NSString *)text onView:(UIView *)view
{
    if (text.length <= 0) return;
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.textColor = [UIColor whiteColor];
    HUD.label.text = text;
    HUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 1.0);
    [HUD hideAnimated:YES afterDelay:1.5];
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    
    [MBHUD removeFromSuperview];
    if (text.length > 0) {
        MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        MBHUD.label.text = text;
        MBHUD.label.textColor = [UIColor whiteColor];
        MBHUD.mode = MBProgressHUDModeIndeterminate;
        MBHUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 1.0);
    }
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view y:(CGFloat)y {
    
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    
    [MBHUD removeFromSuperview];
    if (text.length > 0) {
        MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        MBHUD.label.text = text;
        MBHUD.label.textColor = [UIColor whiteColor];
        MBHUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 0.8);
        //MBHUD.userInteractionEnabled = NO;
    }
}

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view interactionEnabled:(BOOL)enabled
{
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    
    [MBHUD removeFromSuperview];
    if (text.length > 0) {
        MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        MBHUD.label.text = text;
        MBHUD.label.textColor = [UIColor whiteColor];
        MBHUD.userInteractionEnabled = enabled;
        MBHUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 0.8);
    }
}


-(void)changeLoadingWithText:(NSString *)text onView:(UIView *)view{
    if (MBHUD) {
        MBHUD.label.text = text;
        [MBHUD showAnimated:YES];
    } else {
        MBHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        MBHUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 1.0);
        //MBHUD.mode = MBProgressHUDModeAnnularDeterminate;
        MBHUD.userInteractionEnabled = NO;
        MBHUD.label.text = text;
        MBHUD.label.textColor = [UIColor whiteColor];
    }
}

- (void)showTextPromptBoxWithText:(NSString *)text onView:(UIView *)view withTime:(int)second
{
    if (text.length <= 0) return;
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    MBHUD.label.text = text;
    MBHUD.label.textColor = [UIColor whiteColor];
    HUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 0.8);
    [HUD hideAnimated:YES afterDelay:second];
}

- (void)showPromptBoxWithText:(NSString *)text onView:(UIView *)view hideTime:(NSTimeInterval)second y:(CGFloat)y
{
    if (text.length <= 0) return;
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 1.0);
    HUD.mode = MBProgressHUDModeText;
    HUD.margin = 8.0f;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:14];
    [HUD hideAnimated:YES afterDelay:second];
}

- (void)showPromptBoxVideoWithText:(NSString *)text onView:(UIView *)view hideTime:(NSTimeInterval)second y:(CGFloat)y {
    if (text.length <= 0) return;
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.bezelView.backgroundColor = HEXACOLOR(0x000000, 1.0);
    //    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI/2);
    
    //HUD.transform = CGAffineTransformMakeScale(.3, .3);
    [HUD setTransform:CGAffineTransformMakeRotation(-M_PI*2)];
    HUD.mode = MBProgressHUDModeText;
    HUD.margin = 8.0f;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:14];
    [HUD hideAnimated:YES afterDelay:second];
}
- (void)removeLoadingView
{
    if (MBHUD != nil) {
        [MBHUD removeFromSuperview];
    }
}
- (void)showTextBoxWithText:(NSString *)text yOffset:(float)yOffset {
    //显示提示信息
    [self showTextBoxWithText:text yOffset:yOffset afterDelay:2 onView:nil];
}

- (void)showTextBoxWithText:(NSString *)text yOffset:(float)yOffset onView:(UIView *)view{
    [self showTextBoxWithText:text yOffset:yOffset afterDelay:2 onView:view];
}

//从默认(showHint:)显示的位置再往上(下)yOffset 时间可控
- (void)showTextBoxWithText:(NSString *)text yOffset:(float)yOffset afterDelay:(NSInteger)afterDelay{
    [self showTextBoxWithText:text yOffset:yOffset afterDelay:afterDelay onView:nil];
}
//从默认(showHint:)显示的位置再往上(下)yOffset 时间可控
- (void)showTextBoxWithText:(NSString *)text yOffset:(float)yOffset afterDelay:(NSInteger)afterDelay onView:(UIView *)tipView{
    UIView *view;
    if (tipView) {
        view = tipView;
    }else{
        view = [[UIApplication sharedApplication].delegate window];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:afterDelay];
}


@end

