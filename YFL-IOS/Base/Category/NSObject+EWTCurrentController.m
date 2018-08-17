//
//  NSObject+EWTCurrentController.m
//  EWTBase
//
//  Created by Tony on 2017/9/22.
//  Copyright © 2017年 Huangbaoyang. All rights reserved.
//

#import "NSObject+EWTCurrentController.h"

@implementation NSObject (EWTCurrentController)

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
