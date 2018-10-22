//
//  VersionUpdateView.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/20.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionUpdateView : UIView
@property (nonatomic, copy) void (^updateBlock) (NSString *muluModel);

-(void)show;
-(void)hiden;
@end
