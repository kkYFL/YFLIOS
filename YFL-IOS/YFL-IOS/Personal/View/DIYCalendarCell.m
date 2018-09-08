//
//  DIYCalendarCell.m
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "DIYCalendarCell.h"
#import "FSCalendarExtensions.h"

@interface DIYCalendarCell ()
@property (nonatomic, strong) UIColor *dateColorNeed;
@end

@implementation DIYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateColorNeed = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:1.0];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textColor = self.dateColorNeed;
}


/*
 typedef NS_ENUM(NSInteger,DIYDataType) {
 DIYDataTypeDefault,        //默认
 DIYDataTypeNoSign,         //未签到
 DIYDataTypeSigned,         //已签到
 DIYDataTypeTodayNoSign     //今天待签到
 };
 */

-(void)setSignType:(DIYDataType)signType{
    _signType = signType;
    if (_signType == DIYDataTypeDefault) {
        self.dateColorNeed = [UIColor colorWithRed:12/255.0 green:12/255.0 blue:12/255.0 alpha:1.0];
    }else if (_signType == DIYDataTypeNoSign){
        self.dateColorNeed = [UIColor whiteColor];
    }else if (_signType == DIYDataTypeSigned){
        self.dateColorNeed = [UIColor whiteColor];
    }else if (_signType == DIYDataTypeTodayNoSign){
        self.dateColorNeed = [UIColor whiteColor];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)configureAppearance
{
    [super configureAppearance];

}


@end
