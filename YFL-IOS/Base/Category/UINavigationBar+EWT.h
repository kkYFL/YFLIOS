//
//  UINavigationBar+EWT.h
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - UINavigationBar (EWT)
@interface UINavigationBar (EWT)

@end


#pragma mark - UINavigationBar (RightButtonAnimation)
@interface UINavigationBar (RightButtonAnimation)

@property (nonatomic,strong)UIButton *rightBtn;

- (void)yf_setRightAnimitionIcon;

- (void)hiddenPlayIcon;
- (void)displayPlayIcon;

- (void)stopPlayIconAnimation;
- (void)startPlayIconAnimation;
@end

#pragma mark - UINavigationBar (Awesome)
@interface UINavigationBar (Awesome)
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setElementsAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;
- (void)navigationBarBackgroundImageReduction;
@end
