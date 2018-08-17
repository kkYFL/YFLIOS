//
//  UIView+EWT.h
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - UIView (EWT)

@interface UIView (EWT)

- (void)setAllCornerwithCornerRadius:(CGFloat)cornerRadius;

+ (UIView *)viewWithFrame:(CGRect)frame andColor:(UIColor *)color;

-(UIView *)customWithFrame:(CGRect)frame backColor:(UIColor *)backColor lineColor:(UIColor *)lineColor lineHight:(CGFloat)lineHight hideTopLine:(BOOL)hideTop hideBottomLine:(BOOL)hideBottom;
@end

#pragma mark - UIView (TS)
@interface UIView (TS)

@property(nonatomic, assign)CGFloat top;
@property(nonatomic, assign)CGFloat bottom;
@property(nonatomic, assign)CGFloat left;
@property(nonatomic, assign)CGFloat right;
@property(nonatomic, assign)CGFloat centerX;
@property(nonatomic, assign)CGFloat centerY;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, assign)CGFloat width;
@property(nonatomic, assign)CGSize size;
@property(nonatomic, assign)CGPoint origin;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;


- (void)removeAllSubviews;
- (UIViewController *)viewController;
@end

#pragma mark - UIView (EWTLayoutConstraint)
@interface UIView (EWTLayoutConstraint)

/**移除某一些约束*/
- (void)ewt_removeConstraintsWithFirstItem:(id)firstItem firstAttribute:(NSLayoutAttribute)firstAttribute;

@end


/*!
 *  @method
 *  @discussion
 */
@interface UIView (FindFirstResponder)
- (id)findFirstResponder;
@end
