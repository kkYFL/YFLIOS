//
//  DisnetView.m
//  Ewt360
//
//  Created by mistong on 15/9/25.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import "DisnetView.h"

@implementation DisnetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(242, 242, 242);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 160 / 2, frame.size.height / 2 - 150, 160, 110)];
        imageView.image = [UIImage imageNamed:@"common_wifi_icon_1"];
        [self addSubview:imageView];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 27, SCREEN_WIDTH - 10 * 2, 40)];
        textLabel.text = @"网络出错了! \n 请检查网络连接,或点击按钮重新加载.";
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 2;
        textLabel.textColor = RGB(136, 136, 136);
        textLabel.font = KFont(14);
        [self addSubview:textLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH / 2 - 110 / 2, CGRectGetMaxY(textLabel.frame) + 25, 110, 30);
        [btn setTitle:@"重新加载" forState:UIControlStateNormal];
        [btn setTitleColor:RGB(136, 136, 136) forState:UIControlStateNormal];
        btn.titleLabel.font = KFont(14);
        btn.layer.borderColor = RGB(136, 136, 136).CGColor;
        btn.layer.borderWidth = 0.3;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        [btn addTarget:self action:@selector(refreshNetWorking) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
    return self;
}
- (void)refreshNetWorking
{
    [self.delegate refreshNet];
}

@end
