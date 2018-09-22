//
//  StudyNotes.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudyNotes : NSObject

//点赞数
@property(nonatomic, assign) NSNumber *clickNum;
//创建时间(时间戳)
@property(nonatomic, copy) NSString *createTime;
//心得内容
@property(nonatomic, copy) NSString *learnContent;
//心得id
@property(nonatomic, copy) NSString *notesId;
//用户名
@property(nonatomic, copy) NSString *pmName;
//任务主题
@property(nonatomic, copy) NSString *taskTitle;

@end

NS_ASSUME_NONNULL_END
