//
//  BannerScrollView.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerScrollView : UIView
-(void)setContentData:(id)data;
@property (nonatomic, strong) NSString *contentStr;
@end

