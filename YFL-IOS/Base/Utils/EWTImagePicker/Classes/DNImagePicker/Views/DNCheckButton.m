//
//  DNCheckButton.m
//  EWTImagePicker
//
//  Created by 李天露 on 2018/5/21.
//

#import "DNCheckButton.h"

@implementation DNCheckButton

-(id)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if(self)
    {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{};

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageX = (contentRect.size.width - 22 )/2;
    CGFloat imageY = (contentRect.size.height - 22 )/2;
    CGFloat imageWidth = 22;
    CGFloat imageHeight = 22;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

@end
