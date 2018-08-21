//
//  EWTNotification.h
//  Ewt360
//
//  Created by 杨丰林 on 2017/10/26.
//  Copyright © 2017年 铭师堂. All rights reserved.
//  EWT 通知统一管理文件
//  命名规则：
//          KNotification + 通知发起者 = KNotificationUserSignOut
//  使用规则：
//          1.接收者在响应前注册成为事件的监听者
//          2.接收者在自己销毁前移除事件监听

#import <Foundation/Foundation.h>
@interface EWTNotification : NSObject

#pragma mark - 系统
FOUNDATION_EXPORT NSString * const KNotificationUserSignOut;                         //退出登陆
FOUNDATION_EXPORT NSString * const KNotificationAccessHomeWindow;                    //进入主窗口


@end

