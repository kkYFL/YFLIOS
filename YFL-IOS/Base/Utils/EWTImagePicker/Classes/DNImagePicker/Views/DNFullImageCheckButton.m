//
//  DNFullImageCheckButton.m
//  EWTImagePicker
//
//  Created by 李天露 on 2018/5/22.
//

#import "DNFullImageCheckButton.h"

@implementation DNFullImageCheckButton

-(id)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if(self)
    {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font = kDNFullImageButtonFont;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{};

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = 0;
    CGFloat imageY = (contentRect.size.height - buttonImageWidth )/2;
    CGFloat imageWidth = buttonImageWidth;
    CGFloat imageHeight = buttonImageWidth;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = buttonImageWidth + buttonPadding;
    CGFloat titleHeight = 16;
    CGFloat titleY = (contentRect.size.height - buttonImageWidth )/2;
    CGFloat titleWidth = contentRect.size.width - buttonImageWidth - buttonPadding;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}


@end
