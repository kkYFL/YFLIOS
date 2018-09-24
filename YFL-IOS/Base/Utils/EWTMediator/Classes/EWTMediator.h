//
//  EWTMediator.h
//  EWTMediator
//
//  Created by Tony on 2017/9/14.
//  Copyright © 2017年 Huangbaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EWTMediator : NSObject

+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

// 本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;

@end
