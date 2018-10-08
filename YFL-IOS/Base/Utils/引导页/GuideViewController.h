//
//  GuideViewController.h
//  Ewt360
//
//  Created by mistong on 17/1/22.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    videoTpye = 0,  //会员业务类型
    imageTpye,     //直播业务类型
} VideoOrImageTpye;

@interface GuideViewController : UIViewController

@property (nonatomic,retain) UIButton *kipBtn;
@property (nonatomic,assign) VideoOrImageTpye videoOrImageType;
@end
