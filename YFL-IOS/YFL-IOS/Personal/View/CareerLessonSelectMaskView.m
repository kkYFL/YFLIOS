//
//  CareerLessonSelectMaskView.m
//  EWTCareerModule
//
//  Created by 杨丰林 on 2018/7/12.
//

#import "CareerLessonSelectMaskView.h"
//#import "CareerCourseSortModel.h"


#define contentViewW SCREEN_WIDTH-WIDTH_SCALE*80

@interface CareerLessonSelectMaskView (){
    //CareerCourseMuluModel *_selectModel;
}
@property (nonatomic, strong) UIView *backGroundView;

@end

@implementation CareerLessonSelectMaskView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor colorWithRed:0/250.0 green:0/250.0 blue:0/250.0 alpha:0.5];

    self.backGroundView = [[UIView alloc]init];
    [self.backGroundView setFrame:CGRectMake(-contentViewW, 0, contentViewW, SCREEN_HEIGHT)];
    [self addSubview:self.backGroundView];
    
    
}



#pragma mark - actions
-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backGroundView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backGroundView.x = 0;
    }];
    
}

-(void)hiden{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backGroundView.x = -contentViewW;
    } completion:^(BOOL finished) {
        self.backGroundView.hidden = YES;
        [self removeFromSuperview];
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiden];
    
    if (self.sourceSelectBlock) {
        self.sourceSelectBlock(@"");
    }
    
}



//-(void)setSortModel:(CareerCourseSortModel *)sortModel{
//    _sortModel = sortModel;
//    if (_sortModel) {
//        [self.table reloadData];
//    }
//}


@end
