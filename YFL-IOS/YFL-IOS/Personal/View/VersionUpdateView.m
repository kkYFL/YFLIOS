//
//  VersionUpdateView.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/20.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "VersionUpdateView.h"


#define topSpace 100

@interface VersionUpdateView ()
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIImageView *topImageView;
@end

@implementation VersionUpdateView

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
    self.backGroundView.backgroundColor = [UIColor whiteColor];
    [self.backGroundView setFrame:CGRectMake(20, topSpace, SCREEN_WIDTH-40, SCREEN_HEIGHT-2*topSpace)];
    self.backGroundView.layer.masksToBounds = YES;
    self.backGroundView.layer.cornerRadius = 40.0f;
    [self addSubview:self.backGroundView];
    

    UIImageView *topImageView = [[UIImageView alloc]init];
    [topImageView setBackgroundColor:[UIColor clearColor]];
    [self.backGroundView addSubview:topImageView];
    self.topImageView = topImageView;
    [topImageView setContentMode:UIViewContentModeScaleToFill];
    [topImageView setImage:[UIImage imageNamed:@""]];
    topImageView.layer.masksToBounds = YES;
    topImageView.layer.cornerRadius = 40.0f;
    [topImageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 150)];
    
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
        //self.backGroundView.x = -contentViewW;
    } completion:^(BOOL finished) {
        self.backGroundView.hidden = YES;
        [self removeFromSuperview];
    }];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hiden];
    
    if (self.updateBlock) {
        self.updateBlock(@"");
    }
    
}

@end
