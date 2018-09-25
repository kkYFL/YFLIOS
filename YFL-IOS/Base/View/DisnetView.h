//
//  DisnetView.h
//  Ewt360
//
//  Created by mistong on 15/9/25.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DisnetViewDelegate <NSObject>

- (void)refreshNet;

@end

@interface DisnetView : UIView

@property (nonatomic, weak) id<DisnetViewDelegate>delegate;
@end
