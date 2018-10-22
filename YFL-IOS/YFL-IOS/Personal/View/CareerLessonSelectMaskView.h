//
//  CareerLessonSelectMaskView.h
//  EWTCareerModule
//
//  Created by 杨丰林 on 2018/7/12.
//

#import <UIKit/UIKit.h>

@interface CareerLessonSelectMaskView : UIView
//@property (nonatomic, strong) CareerCourseSortModel *sortModel;
@property (nonatomic, copy) void (^sourceSelectBlock) (NSString *muluModel);

-(void)show;
-(void)hiden;
@end
