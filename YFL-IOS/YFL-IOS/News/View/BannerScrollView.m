//
//  BannerScrollView.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "BannerScrollView.h"
#import "BannerScrollViewCell.h"
#import "SDCycleScrollView.h"


@interface BannerScrollView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView* scrollView;
@property (nonatomic, strong) UIImageView *remindView;
@property (nonatomic, strong) NSMutableArray *contentViewsArr;
@end

@implementation BannerScrollView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    
    return self;
}

-(void)initView{
    self.contentViewsArr = [NSMutableArray array];
    [self addSubview:self.scrollView];
}


#pragma mark - SDCycleScrollViewDelegate

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view{
    return [BannerScrollViewCell class];
}

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    BannerScrollViewCell *contentCell = (BannerScrollViewCell *)cell;
}

-(void)setContentData:(id)data{
    
//    if ([data isKindOfClass:[EWTBannerModule class]]) {
//
//        NSMutableArray* images = [NSMutableArray array];
//
//        _model = [(EWTBannerModule*)data copy];
//
//        for (EWTBannerItem* item in _model.bannerArray) {
//
//            [images addObject:item.imageUrl];
//        }
//        _scrollView.imageURLStringsGroup = images;
//    }
    
    
    NSMutableArray* images = [NSMutableArray array];
    for (NSInteger i = 0; i<3; i++) {
        [images addObject:@""];
    }
    _scrollView.imageURLStringsGroup = images;

    
    
}
#pragma mark - getter

-(SDCycleScrollView *)scrollView{
    
    if (_scrollView == nil) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:nil];
        _scrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _scrollView.showPageControl = NO;
        
        UIImageView *remindView = [[UIImageView alloc]init];
        [remindView setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:remindView];
        self.remindView = remindView;
        [remindView setContentMode:UIViewContentModeCenter];
        [remindView setImage:[UIImage imageNamed:@"news_laba"]];
        [remindView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scrollView).offset(12);
            make.centerY.equalTo(_scrollView);
            make.height.width.mas_equalTo(15);
        }];
    }
    return _scrollView;
}


@end




