//
//  UIView+EWT.m
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import "UIView+EWT.h"

#pragma mark - UIView (EWT)

@implementation UIView (EWT)


- (void)setCornerOnTop {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}
- (void)setCornerOnBottom {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}
- (void)setAllCornerwithCornerRadius:(CGFloat)cornerRadius{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}
- (void)setNoneCorner{
    self.layer.mask = nil;
}


+ (UIView *)viewWithFrame:(CGRect)frame andColor:(UIColor *)color{
    
    UIView * v = [[UIView alloc] initWithFrame:frame];
    v.backgroundColor = color;
    return v;
}

-(UIView *)customWithFrame:(CGRect)frame backColor:(UIColor *)backColor lineColor:(UIColor *)lineColor lineHight:(CGFloat)lineHight hideTopLine:(BOOL)hideTop hideBottomLine:(BOOL)hideBottom{
    
    
    UIView * v = [[UIView alloc] initWithFrame:frame];
    v.backgroundColor = backColor;
    
    if (!hideTop) [v addSubview:[self lineFrame:CGRectMake(0, 0, SCREEN_WIDTH, lineHight) backColor:lineColor]];
    
    if(!hideBottom) [v addSubview:[self lineFrame:CGRectMake(0, frame.size.height-lineHight, SCREEN_WIDTH, lineHight) backColor:lineColor]];
    return v;
    
}

-(UIView *)lineFrame:(CGRect)frame backColor:(UIColor *)backColor{
    
    UIView * lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = backColor;
    return lineView;
}

@end

#pragma mark - UIView (TS)
@implementation UIView (TS)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
- (CGFloat)bottom {
    return self.top + self.height;
}
- (void)setBottom:(CGFloat)bottom {
    self.top = bottom - self.height;
}
- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (CGFloat)right {
    return self.left + self.width;
}
- (void)setRight:(CGFloat)right {
    self.left = right - self.width;
}
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.centerY);
}
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.centerX, centerY);
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end

#pragma mark - UIView (EWTLayoutConstraint)
@implementation UIView (UIViewExt)

- (void)ewt_removeConstraintsWithFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute)firstAttribute {//移除某一些约束
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == firstItem && constraint.firstAttribute == firstAttribute) {
            if ([constraint respondsToSelector:@selector(active)]) {
                constraint.active = NO;
            } else {
                [self removeConstraint:constraint];
            }
        }
    }
}

@end


//
@implementation UIView (FindFirstResponder)
- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}
@end
