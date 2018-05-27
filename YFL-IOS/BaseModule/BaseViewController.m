//
//  BaseViewController.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/5/27.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"VC_APPEAR : %@\n", NSStringFromClass(self.class));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
