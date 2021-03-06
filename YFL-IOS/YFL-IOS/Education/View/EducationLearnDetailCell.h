//
//  EducationLearnDetailCell.h
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudyNotes;
@class PartyMemberThinking;
typedef NS_ENUM(NSInteger,LearnDetailType) {
    LearnDetailTypeDefault,
    LearnDetailTypeResponse
};

@interface EducationLearnDetailCell : UITableViewCell
+(CGFloat)CellHWithContent:(NSString *)content Type:(LearnDetailType)type;
-(void)setType:(LearnDetailType)type Model:(StudyNotes *)model;
-(void)setType2:(LearnDetailType)type Model:(PartyMemberThinking *)model;

@end
