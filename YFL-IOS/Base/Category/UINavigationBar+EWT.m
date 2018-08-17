//
//  UINavigationBar+EWT.m
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import "UINavigationBar+EWT.h"
#import <objc/runtime.h>
#import "BarAnimationView.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
static char righticonlayerkey;
static char rightbtnkey;


#pragma mark - UINavigationBar (EWT)
@implementation UINavigationBar (EWT)

@end


#pragma mark - UINavigationBar (RightButtonAnimation)
@implementation UINavigationBar (RightButtonAnimation)

- (BarAnimationView *)righticonlayer
{
    return objc_getAssociatedObject(self, &righticonlayerkey);
}

- (void)setRighticonlayer:(UIView *)righticonlayer
{
    objc_setAssociatedObject(self, &righticonlayerkey, righticonlayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIButton *)rightBtn
{
    return objc_getAssociatedObject(self, &rightbtnkey);
}

- (void)setRightBtn:(UIButton *)rightBtn
{
    objc_setAssociatedObject(self, &rightbtnkey, rightBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}





- (void)yf_setRightAnimitionIcon
{
    if (!self.righticonlayer) {
        
        self.righticonlayer = [[BarAnimationView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-50, 10, 30, 30)];
        [self addSubview:self.righticonlayer];
        
    }
    
    if (!self.rightBtn) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-50, 10, 30, 30);
        [self addSubview:self.rightBtn];
        
    }
    
}

- (void)hiddenPlayIcon
{
    if (self.righticonlayer) {
        self.righticonlayer.hidden = YES;
        self.rightBtn.hidden = YES;
    }
    
}

- (void)displayPlayIcon
{
    if (self.righticonlayer) {
        self.righticonlayer.hidden = NO;
        self.rightBtn.hidden = NO;
    }
}



- (void)stopPlayIconAnimation
{
    
    if (self.righticonlayer) {
        
        [self.righticonlayer stopAnimation];
    }
    
}


- (void)startPlayIconAnimation
{
    if (self.righticonlayer) {
        
        [self.righticonlayer startAnimation];
    }
}


@end


#pragma mark - UINavigationBar (Awesome)
@implementation UINavigationBar (Awesome)
static char overlayKey;

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), NAVIGATION_BAR_HEIGHT)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

//- (void)lt_setElementsAlpha:(CGFloat)alpha
//{
//    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
//        view.alpha = alpha;
//    }];
//
//    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
//        view.alpha = alpha;
//    }];
//
//    UIView *titleView = [self valueForKey:@"_titleView"];
//    titleView.alpha = alpha;
////    when viewController first load, the titleView maybe nil
//    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
//            obj.alpha = alpha;
//            *stop = YES;
//        }
//    }];
//}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    
}

- (void)navigationBarBackgroundImageReduction
{
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    //    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
    //        view.alpha = alpha;
    //    }];
    //
    //    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
    //        view.alpha = alpha;
    //    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    //    when viewController first load, the titleView maybe nil
    //    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
    //        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
    //            obj.alpha = alpha;
    //            *stop = YES;
    //        }
    //    }];
}
@end


