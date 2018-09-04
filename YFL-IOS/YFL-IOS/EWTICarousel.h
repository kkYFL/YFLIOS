//
//  EWTICarousel.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/2.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

typedef NS_ENUM(NSInteger,EWTICarouselType) {
    EWTiCarouselTypeLinear,  // 线性轮播
    EWTiCarouselTypeCustom   // 放大轮播
};


typedef NS_ENUM(NSInteger,EWTICarouselPagePosition) {
    EWTiCarouselPageRight,    //右边
    EWTiCarouselPageCenter,   //中心
    EWTiCarouselPageLeft      //左边
};



@interface EWTICarousel : UIView

/**
  轮播对象
 */
@property (nonatomic, strong)  iCarousel *carousel;


/**
 @param frame            轮播控件frame（主意：控件的宽度是固定的等于屏幕宽度）
 @param icarouselType    轮播banner类型
 @param contentW         轮播子视图宽度
 @param viewSpace        轮播子视图间距离
 */
-(instancetype)initWithFrame:(CGRect)frame withEWTICarouselType:(EWTICarouselType)icarouselType contetnViewW:(CGFloat)contentW viewSpace:(CGFloat)viewSpace;



/**
 设置数据

 @param sourceArr        图片地址

 */
-(void)setContentSource:(NSMutableArray *)sourceArr;



/**
 分页控制器

 @param show               是否显示
 @param pagePosition       位置
 @param currentPageImage   选中图片
 @param pageImage          非选中图片
 */
-(void)showPageControl:(BOOL)show PositionType:(EWTICarouselPagePosition)pagePosition CurentPageImage:(NSString *)currentPageImage PageImage:(NSString *)pageImage;



/**
 系统分页控制器圆点颜色

 @param currentColor       当前选中颜色
 @param pointColor         非选中颜色
 */
-(void)setPageControlCurrentPointColor:(UIColor *)currentColor pointColor:(UIColor *)pointColor;


@property (nonatomic, copy) void (^ewtIcarouselSelectBlock) (NSInteger selectIndex);

@property (nonatomic, assign) BOOL autoPlay;


@end
