//
//  RYPageControl.h
//  pageControl
//
//  Created by ruany on 2016/11/28.
//  Copyright © 2016年 ruany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RYPageControl : UIPageControl

@property(nonatomic,strong)UIColor *currentColor;
@property(nonatomic,strong)UIColor *nextColor;
@property(nonatomic,assign)float rSize;

- (id)initWithFrame:(CGRect)frame currentColor:(UIColor*)currentColor nextColor:(UIColor*)nextColor rsize:(CGFloat)rsize;
-(void)setCurrentPage:(NSInteger)page;

@end
