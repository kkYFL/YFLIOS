//
//  RYPageControl.m
//  pageControl
//
//  Created by ruany on 2016/11/28.
//  Copyright © 2016年 ruany. All rights reserved.
//

#import "RYPageControl.h"

@implementation RYPageControl

- (id)initWithFrame:(CGRect)frame currentColor:(UIColor*)currentColor nextColor:(UIColor*)nextColor rsize:(CGFloat)rsize{
    self=[super initWithFrame:frame];
    if (self) {
        _currentColor=currentColor;
        _nextColor=nextColor;
        _rSize=rsize;
    }
    return self;
}
- (void) setCurrentPage:(NSInteger)page{
    [super setCurrentPage:page];
    if (_rSize) {
        for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
            UIView* subview = [self.subviews objectAtIndex:subviewIndex];
//            CGSize size;
//            size.height = _rSize;
//            size.width = _rSize;
//            [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
//                                         size.width,size.height)];
            if (subviewIndex == page){
                [subview setBackgroundColor:_currentColor];
            }else{
                [subview setBackgroundColor:_nextColor];
                subview.layer.borderColor = [UIColor blackColor].CGColor;
                subview.layer.borderWidth = 1.0f;
            }
        }
    }
}

@end
