//
//  UIImage+Helper.h
//  OAMobile
//
//  Created by 李天露 on 2018/5/7.
//  Copyright © 2018年 李天露. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

+ (NSData *)compressImageQualityWithImage:(UIImage *)image toByte:(NSInteger)maxBytes;

@end
