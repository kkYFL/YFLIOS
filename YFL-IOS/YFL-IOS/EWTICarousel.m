//
//  EWTICarousel.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/2.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EWTICarousel.h"

@interface EWTICarousel ()<iCarouselDataSource, iCarouselDelegate>{
    CGFloat _EWTICarouselW;             //W
    CGFloat _EWTICarouselH;             //H
    CGFloat _EWTICarouselSpace;         //Space
    
    EWTICarouselType _icarouselType;
    EWTICarouselSourceType _sourceType;
    EWTICarouselPagePosition _pagePosition;
    
    BOOL _hasReloadData;                //是否刷新数据（防止频繁加载数据卡顿问题）
}

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *sourceDataArr;
@property (nonatomic, assign) BOOL showPageControl;


@end


@implementation EWTICarousel
-(instancetype)initWithFrame:(CGRect)frame withEWTICarouselType:(EWTICarouselType)icarouselType contetnViewW:(CGFloat)contentW viewSpace:(CGFloat)viewSpace{
    self = [super initWithFrame:frame];
    if(self){
        _EWTICarouselW = contentW;
        _EWTICarouselH = frame.size.height;
        _EWTICarouselSpace = viewSpace;
        _icarouselType = icarouselType;
        
        [self initView];
    }
    return self;
}


-(void)initView{
    [self iCarouselInit];
}


-(void)iCarouselInit{
    self.carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _EWTICarouselH)];
    self.carousel.backgroundColor = [UIColor yellowColor];
    self.carousel.type = (_icarouselType == EWTiCarouselTypeLinear)?iCarouselTypeLinear:iCarouselTypeCustom;
    self.carousel.pagingEnabled = YES;
    self.carousel.scrollEnabled = YES;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    [self addSubview:self.carousel];
    
}

#pragma mark - iCarousel methods
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel {
    return (_sourceDataArr && _sourceDataArr.count)?_sourceDataArr.count:0;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
   
    if(!view){
        return [self createIcarouselViewWithIndex:index];
    }
    
    UIImageView *contentimageView = (UIImageView *)view;
    if(_sourceDataArr && _sourceDataArr.count > index){
        NSString *imageurl = _sourceDataArr[index];
        if(_sourceType == EWTiCarouselSourceRomote){
            [contentimageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:nil];
        }else{
            [contentimageView setImage:[UIImage imageNamed:imageurl]];
        }
    }
    
    return contentimageView;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {

    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * self.carousel.itemWidth * 1.20, 0.0, 0.0);
    
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    
    switch (option)
    {
            case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            //return self.wrap;
            //是否可以轮播效果
            return YES;
        }
            case iCarouselOptionSpacing:
        {
            //space 0
            if(_EWTICarouselSpace <= 0){
                return 1.0f;
            }
            
            return 1.0f + (_EWTICarouselSpace /(CGFloat) _EWTICarouselW);
        }
            case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 1.0;
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
    if(self.ewtIcarouselSelectBlock){
        self.ewtIcarouselSelectBlock(index);
    }
}

-(UIImageView *)createIcarouselViewWithIndex:(NSInteger)index{
    UIImageView *contentimageView = [[UIImageView alloc]init];
    [contentimageView setBackgroundColor:[UIColor whiteColor]];
    [contentimageView setFrame:CGRectMake(0, 0, _EWTICarouselW, _EWTICarouselH)];
    [contentimageView setContentMode:UIViewContentModeScaleToFill];
    if(_sourceDataArr && _sourceDataArr.count > index){
        NSString *imageurl = _sourceDataArr[index];
        if(_sourceType == EWTiCarouselSourceRomote){
            [contentimageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:nil];
        }else{
            [contentimageView setImage:[UIImage imageNamed:imageurl]];
        }
    }
    return contentimageView;
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {
    if (_showPageControl) _pageControl.currentPage = carousel.currentItemIndex;
    
}


-(void)setContentSource:(NSMutableArray *)sourceArr SourceType:(EWTICarouselSourceType)sourceType{
    _sourceDataArr = sourceArr;
    _sourceType = sourceType;
    
    //数据已经刷新返回避免频繁刷新数据
    if(_hasReloadData) return;
       
    [self.carousel reloadData];
}



-(void)showPageControl:(BOOL)show PositionType:(EWTICarouselPagePosition)pagePosition{
    _showPageControl = show;
    _pagePosition = pagePosition;
    
    
    if(_showPageControl){
        [self.carousel addSubview:self.pageControl];
        
        CGFloat marginSpace = (SCREEN_WIDTH-_EWTICarouselW)/2.0;
        CGFloat pageW = 150.0f;
        CGFloat pageH = 30.0f;
        

        
        if (_pagePosition == EWTiCarouselPageRight) {
            [_pageControl setFrame:CGRectMake(SCREEN_WIDTH-marginSpace-pageW, _EWTICarouselH-pageH, pageW, pageH)];
            CGSize pointSize = [self.pageControl sizeForNumberOfPages:self.sourceDataArr.count];
            CGFloat page_x_margin = -(self.pageControl.bounds.size.width - pointSize.width) / 2.0 ;
            [_pageControl setBounds:CGRectMake(page_x_margin, _pageControl.bounds.origin.y,_pageControl.bounds.size.width, _pageControl.bounds.size.height)];
            
        }else if (_pagePosition == EWTiCarouselPageCenter){
            [_pageControl setFrame:CGRectMake((SCREEN_WIDTH-pageW)/2.0, _EWTICarouselH-pageH, pageW, pageH)];

        }else if (_pagePosition == EWTiCarouselPageLeft){

            [_pageControl setFrame:CGRectMake(marginSpace, _EWTICarouselH-pageH, pageW, pageH)];
            CGSize pointSize = [self.pageControl sizeForNumberOfPages:self.sourceDataArr.count];
            CGFloat page_x_margin = -(self.pageControl.bounds.size.width - pointSize.width) / 2.0 ;
            [_pageControl setBounds:CGRectMake(-page_x_margin, _pageControl.bounds.origin.y,_pageControl.bounds.size.width, _pageControl.bounds.size.height)];
        }
        
        self.pageControl.numberOfPages = self.sourceDataArr.count;
        self.pageControl.hidden = NO;
    }else{
        self.pageControl.hidden = YES;
    }
}

#pragma mark - actions

//切换index时候更新PageControl图片
-(void)updateDots {
    for (int i = 0; i < [self.pageControl.subviews count]; i++)  {
        if ([[self.pageControl.subviews objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
            UIImageView* dot = [self.pageControl.subviews objectAtIndex:i];
            if (i == self.pageControl.currentPage){
                dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, 20, 6);
                dot.image = [UIImage imageNamed:@"shengya-list-lunbo-press"];
            }else{
                dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, 6, 6);
                dot.image = [UIImage imageNamed:@"shengya-list-lunbo-nor"];
            }
        }
    }
}


#pragma mark - 懒加载
-(UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.backgroundColor = [UIColor redColor];
        _pageControl.hidden = YES;
        //NSArray *itemSourceArr = (NSArray *)self.careerLessonVideosArr[0];
        //self.pageControl.numberOfPages = itemSourceArr.count;
        //self.pageControl.currentPage = pageIndex;
        //[self.pageControl setValue:[UIImage imageNamed:@"shengya-list-lunbo-nor"] forKeyPath:@"_pageImage"];
        //[self.pageControl setValue:[UIImage imageNamed:@"shengya-list-lunbo-press"] forKeyPath:@"_currentPageImage"];
        
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [UIColor greenColor];
        [self.carousel addSubview:_pageControl];
    }
    return _pageControl;
}

//  初始化pageControl

@end
