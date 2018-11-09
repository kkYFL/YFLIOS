//
//  UpdateModel.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/11/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateModel : NSObject
@property (nonatomic, copy) NSString *appType;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *isForceUpdate;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *info;
-(id)initWithDic:(NSDictionary *)dic;
@end












/*
 "": 1,
 ":"1.0.1",
 "": 1,
 "": "file/update/version/android_1.0.1.apk",
 "":"更新说明"
 */
