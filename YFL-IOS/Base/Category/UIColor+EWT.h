//
//  UIColor+EWT.h
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (EWT)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
/**根据颜色生成image*/
- (UIImage *)ewt_imageWithSize:(CGSize)size;

@end
