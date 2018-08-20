//
//  EWTBaseNavigationController.m
//  Ewt360
//
//  Created by 杨丰林 on 2017/11/23.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import "EWTBaseNavigationController.h"

@interface EWTBaseNavigationController ()

@end

@implementation EWTBaseNavigationController

//重写PUSH方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //解决同一控制器多次push（PsychologyFMDetailViewController bug）
//    if (self.viewControllers.count > 1) {
//        for (UIViewController *VC in self.viewControllers) {
//            if (VC == viewController) {
//                return;
//            }
//        }
//    }

    [super pushViewController:viewController animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
