//
//  EWTBaseViewController.h
//  EWTBase
//
//  Created by Tony on 2017/9/18.
//  Copyright © 2017年 Huangbaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EWTBaseUIDelegate <NSObject>

@optional

-(UIView*)getNetErrorView;

@optional

-(UIView*)getEmptyDataView;

@end

@interface EWTBaseViewController : UIViewController<EWTBaseUIDelegate>

/**
 *  @author raojie
 *
 *  @brief go to Login Controller
 */
- (void)showLoginVC;

/**
 *  @author raojie
 *
 *  @brief go to Main Controller
 */
- (void)showMainVC;

/**
 *  @author raojie
 *
 *  @brief set Title
 *
 *  @param title title description
 
 */
- (void)setNavBarTitle:(NSString *)title;

/**
 *  @author raojie
 *
 *  @brief 返回
 */
-(void)setBackItem;

/**
 *  @author raojie
 *
 *  @brief set Right title
 *
 *  @param title <#title description#>
 */
- (void)setNavRightTitle:(NSString *)title;

@end
