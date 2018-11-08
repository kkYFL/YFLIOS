//
//  UpdateView.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/31.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubjectViewDelegate <NSObject>
- (void)updateDelegate;
@end

@interface UpdateView : UIView
@property (nonatomic, weak) id<SubjectViewDelegate> delegate;
@end