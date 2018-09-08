//
//  DIYCalendarCell.h
//  FSCalendar
//
//  Created by dingwenchao on 02/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <FSCalendar/FSCalendar.h>

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};


typedef NS_ENUM(NSInteger,DIYDataType) {
    DIYDataTypeDefault,        //默认
    DIYDataTypeNoSign,         //未签到
    DIYDataTypeSigned,         //已签到
    DIYDataTypeTodayNoSign     //今天待签到
};


@interface DIYCalendarCell : FSCalendarCell

@property (nonatomic, assign) DIYDataType signType;

//@property (weak, nonatomic) UIImageView *circleImageView;

//@property (weak, nonatomic) CAShapeLayer *selectionLayer;

//@property (assign, nonatomic) SelectionType selectionType;

@end
