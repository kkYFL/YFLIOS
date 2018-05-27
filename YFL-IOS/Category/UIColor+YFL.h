//
//  UIColor+YFL.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/5/27.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YFL)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
