//
//  NSObject+YFLCurrentVC.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/5/27.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "NSObject+YFLCurrentVC.h"

@implementation NSObject (YFLCurrentVC)
+ (UIViewController *)currentViewController
{
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    while (viewController) {
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tbvc = (UITabBarController*)viewController;
            viewController = tbvc.selectedViewController;
        } else if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nvc = (UINavigationController*)viewController;
            viewController = nvc.topViewController;
        } else if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        } else if ([viewController isKindOfClass:[UISplitViewController class]] &&
                   ((UISplitViewController *)viewController).viewControllers.count > 0) {
            UISplitViewController *svc = (UISplitViewController *)viewController;
            viewController = svc.viewControllers.lastObject;
        } else  {
            return viewController;
        }
    }
    return viewController;
}
@end
