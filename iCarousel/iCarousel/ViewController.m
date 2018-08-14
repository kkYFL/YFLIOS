//
//  ViewController.m
//  iCarousel
//
//  Created by 杨丰林 on 2018/7/25.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ViewController.h"
#import "iCarousel.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define carouselH  120.0

@interface ViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (nonatomic, strong) iCarousel *carousel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self iCarouselInit];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


-(void)iCarouselInit{
    /**
     
     @property (nonatomic, strong)  iCarousel *carousel;
     */
    self.carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, carouselH)];
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.backgroundColor = [UIColor blueColor];
    self.carousel.pagingEnabled = YES;
    self.carousel.scrollEnabled = YES;
    self.carousel.bounces = NO;//边界弹簧效果
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.contentOffset = CGSizeMake(-14, 0);//中心偏移
    [self.view addSubview:self.carousel];
}

#pragma mark - iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel {
    return 10;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    UIView *tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 100)];
    tmpView.backgroundColor = [UIColor grayColor];
    return tmpView;
}
- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}
- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            //return self.wrap;
            //是否可以轮播效果
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.15;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}
#pragma mark iCarousel taps
- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {
//    if (self.scrollCurrentIndexBlock) {
//        self.scrollCurrentIndexBlock(carousel.currentItemIndex);
//    }
}


@end
