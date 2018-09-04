//
//  EWTiCarouselPageControl.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/4.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EWTiCarouselPageControl.h"
#define kDotW 6
#define kDotH 12
#define currentDotW 12
#define dotSpace 8

@interface EWTiCarouselPageControl (){
    BOOL _diyPage;
}

@end

@implementation EWTiCarouselPageControl


-(void)setDiyPointImage:(BOOL)diyPointImage{
    _diyPage = YES;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    //自定义图片
    if (_diyPage) {
        //计算圆点尺寸和间距的长度
        CGFloat marginX = kDotW + dotSpace;
        
        //计算整个pageControll的宽度
        CGFloat newW = self.frame.size.width;
        
        //计算左边距
        CGFloat leftRight = (newW - ((self.subviews.count - 1 ) * dotSpace + self.subviews.count * kDotW)) / 2;
        
        //设置新frame
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
        
        //遍历subview,设置圆点frame
        for (int i=0; i<[self.subviews count]; i++) {
            if ([[self.subviews objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
                UIImageView* dot = [self.subviews objectAtIndex:i];
                [dot setContentMode:UIViewContentModeCenter];
                if (i == self.currentPage){
                    [dot setFrame:CGRectMake(i * marginX + leftRight, dot.frame.origin.y, currentDotW, kDotH)];

                }else{
                    if (i < self.currentPage) {
                        [dot setFrame:CGRectMake(i * marginX + leftRight, dot.frame.origin.y, kDotW, kDotH)];
                    }else{
                        [dot setFrame:CGRectMake(i * marginX + leftRight+(currentDotW-kDotW), dot.frame.origin.y, kDotW, kDotH)];
                    }

                }
            }
        }
    
        
    }
          

}


@end
