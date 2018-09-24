//
//  UIImage+Helper.m
//  OAMobile
//
//  Created by 李天露 on 2018/5/7.
//  Copyright © 2018年 李天露. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

+ (NSData *)compressImageQualityWithImage:(UIImage *)image toByte:(NSInteger)maxBytes {
    if (!image) {
        return nil;
    }
    
    CGFloat compression = 1;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    if (compressedData.length < maxBytes) {
        return compressedData;
    }
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 10; ++i) {
        compression = (max + min) / 2;
        // 压缩阈值建议 0.1 - 0.9
        if (compression >= 0.9 || compression <= 0.1) {
            break;
        }
        compressedData = UIImageJPEGRepresentation(image, compression);
        if (compressedData.length < maxBytes) {
            min = compression;
        } else if (compressedData.length > maxBytes) {
            max = compression;
        } else {
            break;
        }
    }
    
    return compressedData;
}

@end
