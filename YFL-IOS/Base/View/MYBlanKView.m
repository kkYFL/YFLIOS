//
//  MYBlanKView.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/11/10.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "MYBlanKView.h"

@interface MYBlanKView ()
@property (nonatomic, strong) UIImageView *blankView;
@end

@implementation MYBlanKView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *blankView = [[UIImageView alloc]init];
    [blankView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:blankView];
    self.blankView = blankView;
    [blankView setContentMode:UIViewContentModeScaleToFill];
    [blankView setImage:[UIImage imageNamed:@"empty_follow"]];
    
    

    CGFloat W = SCREEN_WIDTH -60;
    CGFloat H = W*10.0/13;
    CGFloat X = 30;
    CGFloat Y = (self.bounds.size.height-H)/2.0f-50;
    
    [blankView setFrame:CGRectMake(X, Y, W, H)];

}




@end
