//
//  MJRefershHeader.m
//  MJRefreshExample
//
//  Created by mingshitang on 15/8/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJRefershHeader.h"
@interface MJRefershHeader ()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *logo;

@end
@implementation MJRefershHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.label = label;
    
    // logo
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullrefresh_default_ptr_flip"]];
    [self addSubview:logo];
    self.logo = logo;
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.label.frame = self.bounds;
    self.logo.frame = CGRectMake(self.mj_w * 0.5 - 70, self.mj_h * .5 - 10, 20, 20);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.label.text = @"下拉刷新数据";
            [self.logo.layer removeAnimationForKey:@"keyFrameAnimation"];
            self.logo.image = [UIImage imageNamed:@"pullrefresh_default_ptr_up"];
            [UIView animateWithDuration:.1f animations:^{
                self.logo.transform = CGAffineTransformRotate(self.logo.transform, M_PI);
            }];
        }
            break;
        case MJRefreshStatePulling:
        {
            self.label.text = @"松开立即刷新";
            [UIView animateWithDuration:.1f animations:^{
                self.logo.transform = CGAffineTransformRotate(self.logo.transform, M_PI);
            }];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.label.text = @"数据加载中";
            self.logo.image = [UIImage imageNamed:@"common_refresh_icon_r"];
            [self startRotateAnimation:self.logo];
        }
            break;
        default:
            break;
    }
}

#pragma mark-旋转
- (void)startRotateAnimation:(UIImageView *)theimg
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = @(2 * M_PI);
    animation.duration = .5f;
    animation.repeatCount = INT_MAX;
    [theimg.layer addAnimation:animation forKey:@"keyFrameAnimation"];
}
#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


@end
