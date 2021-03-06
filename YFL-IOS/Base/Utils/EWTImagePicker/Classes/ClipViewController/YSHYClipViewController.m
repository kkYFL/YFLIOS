//
//  CircularClipView.m
//  MasonryDemo
//
//  Created by 杨淑园 on 15/11/17.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import "YSHYClipViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "EWTBase.h"

@interface YSHYClipViewController ()

@end

@implementation YSHYClipViewController
{
    UIView *_toolBar;
    UILabel* _titleLab;
    UIButton *_doneButton;
    UIButton *_cancelButton;
}
-(instancetype)initWithImage:(UIImage *)image
{
    if(self = [super init])
    {
        _image = [self fixOrientation:image];
        self.clipType = CIRCULARCLIP;
        self.radius = 120;
        self.scaleRation =  10;
        lastScale = 1.0;
    }
    return  self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self CreatUI];
    [self configCustomNaviBar];
//    [self configTitleView];
    [self configBottomToolBar];
    [self addAllGesture];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)CreatUI
{
    //验证 裁剪半径是否有效
    self.radius= self.radius > (self.view.frame.size.width/2 - 10) ? (self.view.frame.size.width/2 - 10) : self.radius;
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = (_image.size.height / _image.size.width) * self.view.frame.size.width;
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _imageView = [[UIImageView alloc]init];
    [_imageView setImage:_image];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_imageView setFrame:CGRectMake(0, 0, width, height)];
    [_imageView setCenter:self.view.center];
    self.OriginalFrame = _imageView.frame;
    [self.view addSubview:_imageView];
    
    _imageViewScale = _imageView;
    
    //覆盖层
    _overView = [[UIView alloc]init];
    [_overView setBackgroundColor:[UIColor clearColor]];
    _overView.opaque = NO;
    [_overView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:_overView];
    
    [self drawClipPath:self.clipType];
    [self MakeImageViewFrameAdaptClipFrame];
}

- (void)configCustomNaviBar {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = [AppDelegate getURLWithKey:@"zhaoping"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton setImage:[UIImage imageNamed:@"backBtn_tiku"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)configTitleView {
    //选取照片位置：
    _titleLab = [[UILabel alloc] init];
    _titleLab.text = @"选取照片位置：";
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(33);
        make.left.equalTo(self.view).offset(12);
        make.height.mas_equalTo(22);
        make.width.lessThanOrEqualTo(@200);
    }];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] init];
    _toolBar.backgroundColor = [UIColor colorWithHexString:@"#E51C23"];
    [self.view addSubview:_toolBar];
    
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.left.right.equalTo(self.view);
    }];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(self.view.width - 75 - 12, 8, 75, 33);
    [_doneButton setTitle:[AppDelegate getURLWithKey:@"baocun"] forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(clipBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(12, 8, 75, 33);
    [_cancelButton setTitle:[AppDelegate getURLWithKey:@"quxiao"] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolBar addSubview:_doneButton];
    [_toolBar addSubview:_cancelButton];
    
}

//绘制裁剪框
-(void)drawClipPath:(ClipType )clipType
{
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGPoint center = self.view.center;
    
     self.circularFrame = CGRectMake(center.x - self.radius, center.y - self.radius, self.radius * 2, self.radius * 2);
    UIBezierPath * path= [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
     CAShapeLayer *layer = [CAShapeLayer layer];
    if(clipType == CIRCULARCLIP)
    {
        //绘制圆形裁剪区域
        [path  appendPath:[UIBezierPath bezierPathWithArcCenter:self.view.center radius:self.radius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    }
    else
    {
        [path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(center.x - self.radius, center.y - self.radius, self.radius * 2, self.radius * 2)]];
    }
    [path setUsesEvenOddFillRule:YES];
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = HEXACOLOR(0x000000,0.6).CGColor;
    layer.lineWidth = 1.0f;
    [layer setStrokeColor:[UIColor whiteColor].CGColor];
//    layer.opacity = 0.5;
    [_overView.layer addSublayer:layer];
}

//让图片自己适应裁剪框的大小
-(void)MakeImageViewFrameAdaptClipFrame
{
    CGFloat width = _imageView.frame.size.width ;
    CGFloat height = _imageView.frame.size.height;
    if(height < self.circularFrame.size.height)
    {
        width = (width / height) * self.circularFrame.size.height;
        height = self.circularFrame.size.height;
        CGRect frame = CGRectMake(0, 0, width, height);
        [_imageView setFrame:frame];
        [_imageView setCenter:self.view.center];
    }
}
-(void)addAllGesture
{
    //捏合手势
    UIPinchGestureRecognizer * pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGesture:)];
    [self.view addGestureRecognizer:pinGesture];
    //拖动手势
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

-(void)handlePinGesture:(UIPinchGestureRecognizer *)pinGesture
{
    UIView * view = _imageView;
    if(pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(_imageViewScale.transform, pinGesture.scale,pinGesture.scale);
        pinGesture.scale = 1.0;
    }
    else if(pinGesture.state == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        CGFloat ration =  view.frame.size.width /self.OriginalFrame.size.width;
        
        if(ration>_scaleRation) // 缩放倍数 > 自定义的最大倍数
        {
            CGRect newFrame =CGRectMake(0, 0, self.OriginalFrame.size.width * _scaleRation, self.OriginalFrame.size.height * _scaleRation);
            view.frame = newFrame;
        }else if (view.frame.size.width < self.circularFrame.size.width && self.OriginalFrame.size.width <= self.OriginalFrame.size.height)
        {
            view.frame = [self handelWidthLessHeight:view];
            view.frame = [self handleScale:view];
        }
        else if(view.frame.size.height< self.circularFrame.size.height && self.OriginalFrame.size.height <= self.OriginalFrame.size.width)
        {
            view.frame =[self handleHeightLessWidth:view];
            view.frame = [self handleScale:view];
        }
        else
        {
            view.frame = [self handleScale:view];
        }
        self.currentFrame = view.frame;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    UIView * view = _imageView;
    
    if(panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGesture translationInView:view.superview];
        [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
        
        [panGesture setTranslation:CGPointZero inView:view.superview];
    }
    else if ( panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGRect currentFrame = view.frame;
        //向右滑动 并且超出裁剪范围后
        if(currentFrame.origin.x >= self.circularFrame.origin.x)
        {
            currentFrame.origin.x =self.circularFrame.origin.x;
            
        }
        //向下滑动 并且超出裁剪范围后
        if(currentFrame.origin.y >= self.circularFrame.origin.y)
        {
            currentFrame.origin.y = self.circularFrame.origin.y;
        }
        //向左滑动 并且超出裁剪范围后
        if(currentFrame.size.width + currentFrame.origin.x < self.circularFrame.origin.x + self.circularFrame.size.width)
        {
            CGFloat movedLeftX =fabs(currentFrame.size.width + currentFrame.origin.x -(self.circularFrame.origin.x + self.circularFrame.size.width));
            currentFrame.origin.x += movedLeftX;
        }
        //向上滑动 并且超出裁剪范围后
        if(currentFrame.size.height+currentFrame.origin.y < self.circularFrame.origin.y + self.circularFrame.size.height)
        {
            CGFloat moveUpY =fabs(currentFrame.size.height + currentFrame.origin.y -(self.circularFrame.origin.y + self.circularFrame.size.height));
            currentFrame.origin.y += moveUpY;
        }
        [UIView animateWithDuration:0.5 animations:^{
            [view setFrame:currentFrame];
        }];
    }
}

//缩放结束后 确保图片在裁剪框内
-(CGRect )handleScale:(UIView *)view
{
    // 图片.right < 裁剪框.right
    if(view.frame.origin.x + view.frame.size.width< self.circularFrame.origin.x+self.circularFrame.size.width)
    {
        CGFloat right =view.frame.origin.x + view.frame.size.width;
        CGRect viewFrame = view.frame;
        CGFloat space = self.circularFrame.origin.x+self.circularFrame.size.width - right;
        viewFrame.origin.x+=space;
        view.frame = viewFrame;
    }
    // 图片.top < 裁剪框.top
    if(view.frame.origin.y > self.circularFrame.origin.y)
    {
        CGRect viewFrame = view.frame;
        viewFrame.origin.y=self.circularFrame.origin.y;
        view.frame = viewFrame;
    }
    // 图片.left < 裁剪框.left
    if(view.frame.origin.x > self.circularFrame.origin.x)
    {
        CGRect viewFrame = view.frame;
        viewFrame.origin.x=self.circularFrame.origin.x;
        view.frame = viewFrame;
    }
    // 图片.bottom < 裁剪框.bottom
    if((view.frame.size.height +view.frame.origin.y) < (self.circularFrame.origin.y + self.circularFrame.size.height))
    {
        CGRect viewFrame = view.frame;
        CGFloat space = self.circularFrame.origin.y + self.circularFrame.size.height - (view.frame.size.height +view.frame.origin.y);
        viewFrame.origin.y +=space;
        view.frame = viewFrame;
    }

    return view.frame;
}

// 图片的高<宽 并且缩放后的图片高小于裁剪框的高
-(CGRect )handleHeightLessWidth:(UIView *)view
{
    CGRect tempFrame = view.frame;
    CGFloat rat = self.OriginalFrame.size.width / self.OriginalFrame.size.height;
    CGFloat width = self.circularFrame.size.width * rat;
    CGFloat height = self.circularFrame.size.height ;
    CGFloat  x  = view.frame.origin.x ;
    CGFloat y = self.circularFrame.origin.y;
    
    if(view.frame.origin.x > self.circularFrame.origin.x)
    {
        x = self.circularFrame.origin.x;
    }
    else if ((view.frame.origin.x+view.frame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width)
    {
        x = self.circularFrame.origin.x + self.circularFrame.size.width - width ;
    }
    
    CGRect newFrame =CGRectMake(x, y, width,height);
    view.frame = newFrame;
    
    if((tempFrame.origin.x > self.circularFrame.origin.x &&(tempFrame.origin.x+tempFrame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width))
    {
        [view setCenter:self.view.center];
    }
    
    if((tempFrame.origin.y > self.circularFrame.origin.y &&(tempFrame.origin.y+tempFrame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height))
    {
        [view setCenter:CGPointMake(tempFrame.size.width/2 + tempFrame.origin.x, view.frame.size.height /2)];
    }
    return  view.frame;
}

//图片的宽<高 并且缩放后的图片宽小于裁剪框的宽
-(CGRect)handelWidthLessHeight:(UIView *)view
{
    CGFloat rat = self.OriginalFrame.size.height / self.OriginalFrame.size.width;
    CGRect tempFrame = view.frame;
    
    CGFloat width = self.circularFrame.size.width;
    CGFloat height = self.circularFrame.size.height * rat ;
    
    CGFloat  x  = self.circularFrame.origin.x ;
    CGFloat y = view.frame.origin.y;
    
    if(view.frame.origin.y > self.circularFrame.origin.y)
    {
        y = self.circularFrame.origin.y;
    }
    else if ((view.frame.origin.y+view.frame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height)
    {
        y = self.circularFrame.origin.y + self.circularFrame.size.height - height ;
    }
    CGRect newFrame =CGRectMake(x, y, width,height);
    view.frame = newFrame;
    
    if((tempFrame.origin.y > self.circularFrame.origin.y &&(tempFrame.origin.y+tempFrame.size.height) < self.circularFrame.origin.y + self.circularFrame.size.height))
    {
        [view setCenter:self.view.center];
        
    }
    if((tempFrame.origin.x > self.circularFrame.origin.x &&(tempFrame.origin.x+tempFrame.size.width) < self.circularFrame.origin.x + self.circularFrame.size.width))
    {
        [view setCenter:CGPointMake(view.frame.size.width/2, tempFrame.size.height /2 + tempFrame.origin.y)];
    }
    return  view.frame;
}

-(void)clipBtnSelected:(UIButton *)btn
{
    [self.delegate ClipViewController:self FinishClipImage:[self getSmallImage]];
}

-(void)cancelButtonClick {
    [self.delegate ClipViewController:self CancelClipImage:nil];
}

-(void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//修复图片显示方向问题
-(UIImage *)fixOrientation:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//方形裁剪
-(UIImage *)getSmallImage
{
    CGFloat width= _imageView.frame.size.width;
    CGFloat rationScale = (width /_image.size.width);

    CGFloat origX = (self.circularFrame.origin.x - _imageView.frame.origin.x) / rationScale;
    CGFloat origY = (self.circularFrame.origin.y - _imageView.frame.origin.y) / rationScale;
    CGFloat oriWidth = self.circularFrame.size.width / rationScale;
    CGFloat oriHeight = self.circularFrame.size.height / rationScale;
  
    CGRect myRect = CGRectMake(origX, origY, oriWidth, oriHeight);
     CGImageRef  imageRef = CGImageCreateWithImageInRect(_image.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    
    if(self.clipType == CIRCULARCLIP)
        return  [self CircularClipImage:clipImage];
    
    return clipImage;
}

//圆形图片
-(UIImage *)CircularClipImage:(UIImage *)image
{
    CGFloat arcCenterX = image.size.width/ 2;
    CGFloat arcCenterY = image.size.height / 2;
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextAddArc(context, arcCenterX , arcCenterY, image.size.width/ 2 , 0.0, 2*M_PI, NO);
    CGContextClip(context);
    CGRect myRect = CGRectMake(0 , 0, image.size.width ,  image.size.height);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}



@end
