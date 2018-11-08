//
//  DNFullImageButton.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/2.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNFullImageButton.h"
#import "UIView+DNImagePicker.h"
#import "NSBundle+EWTImagePicker.h"
#import "DNFullImageCheckButton.h"

@interface DNFullImageButton ()
@property (nonatomic, strong) DNFullImageCheckButton *fullImageButton;
@property (nonatomic, strong) UILabel *imageSizeLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation DNFullImageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.height = 28;
        self.width = CGRectGetWidth([[UIScreen mainScreen] bounds])/2 -20;
        [self fullImageButton];
        [self imageSizeLabel];
        [self indicatorView];
        self.selected = NO;
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.fullImageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (UILabel *)imageSizeLabel
{
    if (nil == _imageSizeLabel) {
        _imageSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 4, CGRectGetWidth(self.frame)- 100, 20)];
        _imageSizeLabel.backgroundColor = [UIColor clearColor];
        _imageSizeLabel.font = [UIFont systemFontOfSize:14.0f];
        _imageSizeLabel.textAlignment = NSTextAlignmentLeft;
        _imageSizeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_imageSizeLabel];
    }
    return _imageSizeLabel;
}

- (DNFullImageCheckButton *)fullImageButton
{
    if (nil == _fullImageButton) {
        _fullImageButton = [DNFullImageCheckButton buttonWithType:UIButtonTypeCustom];
        _fullImageButton.frame = CGRectMake(0, (self.height - 28 )/2, [self fullImageButtonWidth], 28);
        _fullImageButton.backgroundColor = [UIColor clearColor];
        [_fullImageButton setTitle:[AppDelegate getURLWithKey:@""]@"yuantu", nil) forState:UIControlStateNormal];
        _fullImageButton.titleLabel.font = kDNFullImageButtonFont;
        [_fullImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_fullImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fullImageButton setImage:[[UIImage imageWithContentsOfFile:[[NSBundle EWTImagePickerBundle] pathForResource:@"icon_list_checkbox_disabled" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_fullImageButton setImage:[[UIImage imageWithContentsOfFile:[[NSBundle EWTImagePickerBundle] pathForResource:@"icon_list_checkbox_abled" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
//        _fullImageButton.contentVerticalAlignment = NSTextAlignmentRight;
//        [_fullImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, buttonPadding-buttonImageWidth, 6, 0)];
//        [_fullImageButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, _fullImageButton.width - buttonImageWidth)];
        [self addSubview:_fullImageButton];
    }
    return _fullImageButton;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (nil == _indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.fullImageButton.width, 2, 26, 26)];
        _indicatorView.hidesWhenStopped = YES;
        [_indicatorView stopAnimating];
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (CGFloat)fullImageButtonWidth
{
    NSString *string = [AppDelegate getURLWithKey:@""]@"yuantu", nil);
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kDNFullImageButtonFont} context:nil];
    CGFloat width = buttonImageWidth + buttonPadding + CGRectGetWidth(rect);
    return width;
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        _selected = selected;
        self.fullImageButton.selected = _selected;
        self.fullImageButton.width = [self fullImageButtonWidth];
//        [self.fullImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, buttonPadding-buttonImageWidth, 6, 0)];
//        [self.fullImageButton setImageEdgeInsets:UIEdgeInsetsMake(6, 0, 6, self.fullImageButton.width - buttonImageWidth)];
        CGFloat labelWidth = self.width - self.fullImageButton.width;
        self.imageSizeLabel.left = self.fullImageButton.width;
        self.imageSizeLabel.width = labelWidth;
        self.imageSizeLabel.hidden = !_selected;
    }
}

- (void)setText:(NSString *)text
{
    self.imageSizeLabel.text = text;
}

- (void)shouldAnimating:(BOOL)animate
{
    if (self.selected) {
        self.imageSizeLabel.hidden = animate;
        if (animate) {
            [self.indicatorView startAnimating];
        } else {
            [self.indicatorView stopAnimating];
        }
    }
}
@end
