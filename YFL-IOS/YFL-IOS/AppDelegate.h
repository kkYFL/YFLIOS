//
//  AppDelegate.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/5/27.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMessage.h"
@class UpdateModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UserMessage *userModel;


@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *sourceHost;
@property (nonatomic, strong) NSString *localType;

@property (nonatomic, assign) BOOL isHan;//默认 汉语

@property (nonatomic, strong) UpdateModel *updateModel;
@property (nonatomic, assign) BOOL hasShowUpdate;

+(NSString *)getURLWithKey:(NSString *)key;
@end



