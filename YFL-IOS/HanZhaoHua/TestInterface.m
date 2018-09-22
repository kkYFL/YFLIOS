//
//  TestInterface.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "TestInterface.h"

static NSString *userToken = @"1";
static NSString *userId = @"1";
static NSString *taskId = @"1";

@implementation TestInterface

+(void)test {
    
    // 获取服务器时间
    // 测试结果: 通过
    /*
    [HanZhaoHua getServerTimeWithUserToken:@"1" userId:@"1" success:^(NSDictionary * _Nonnull responseObject) {
        NSString *code = [[responseObject objectForKey:@"code"] stringValue];
        if ([code isEqualToString:@"2000"]) {
            NSNumber *time = [responseObject objectForKey:@"data"];
            NSLog(@"%@", time);
        } else {
            NSLog(@"处理错误");
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    */
    
    // 学习任务列表
    // 测试结果: 通过
//    [HanZhaoHua getLearningTaskListWithUserId:@"1" type:1 page:1 pageNum:10 success:^(NSArray * _Nonnull listArray) {
//        // 下拉刷新, 原数据源数组数据清空, 存储最新数据
//        // 上拉加载更多, 原数据源数组后拼接
//        for (LearningTaskModel *item in listArray) {
//            NSLog(@"%@", item.taskId);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 获取党员心声
    // 测试结果: 通过
//    [HanZhaoHua getPartyMemberThinkingWithUserToken:@"1" userId:@"1" taskId:@"1" page:1 pageNum:10 success:^(NSArray * _Nonnull listArray) {
//        for (PartyMemberThinking *model in listArray) {
//            NSLog(@"%@", model.pmName);
//            NSLog(@"%@", model.headImg);
//            NSLog(@"%@", model.ssDepartment);
//            NSLog(@"%@", model.commentInfo);
//            NSLog(@"%@", model.createTime);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 评论提交
    // 测试结果: 通过
//    [HanZhaoHua submitCommentsWithUserToken:@"1" userId:@"1" taskId:@"1" commentInfo:@"测试" success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 保存学习痕迹
    // 测试结果: 通过
//    NSDate * date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSString *currentTime = [formatter stringFromDate:date];
//    [HanZhaoHua saveLearningTracesWithUserToken:userToken userId:userId taskId:taskId startDate:currentTime success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 获取学习痕迹列表
    // 测试结果: 通过
//    [HanZhaoHua getLearningHistoryWithUserToken:userToken userId:userId taskId:taskId success:^(NSNumber * _Nonnull totalLearnTime, NSArray * _Nonnull list) {
//        NSLog(@"%@", totalLearnTime);
//        for (LearningHistory *model in list) {
//            NSLog(@"%@", model.learnTime);
//            NSLog(@"%@", model.startTime);
//            NSLog(@"%@", model.endTime);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 获取意见反馈列表
    // 测试结果: 通过
//    [HanZhaoHua getSuggestionFeedbackWithPage:1 pageNum:10 success:^(NSArray * _Nonnull list) {
//        for (SuggestionFeedback *model in list) {
//            NSLog(@"%@", model.answerState);
//            NSLog(@"%@", model.createTime);
//            NSLog(@"%@", model.problemInfo);
//            NSLog(@"%@", model.title);
//            NSLog(@"%@", model.answer);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 意见反馈
    // 测试结果: 通过
//    [HanZhaoHua suggestionFeedbackWithUserId:userId title:@"测试" problemInfo:@"测试" success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 获取学习心得列表
    // 测试结果: 相比于接口文档, 缺少两个字段: headImg, ssDepartment
//    [HanZhaoHua getStudyNotesWithUserId:userId taskId:taskId page:1 pageNum:10 success:^(NSArray * _Nonnull list) {
//        for (StudyNotes *model in list) {
//            NSLog(@"%@", model.clickNum);
//            NSLog(@"%@", model.notesId);
//            NSLog(@"%@", model.taskTitle);
//            NSLog(@"%@", model.pmName);
//            NSLog(@"%@", model.createTime);
//            NSLog(@"%@", model.learnContent);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 学习心得
    // 测试结果: 通过
//    [HanZhaoHua submitStudyNotesWithUserId:userId taskId:taskId learnContent:@"测试" success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 心得评论
    // 测试结果: 通过
//    [HanZhaoHua commentStudyNotesWithUserId:userId notesId:@"1" commentInfo:@"测试" success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    
    // 心得点赞
    // 测试结果: 通过
//    [HanZhaoHua likeStudyNotesWithNotesId:@"1" success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 获取心得评论列表
    // 测试结果: 通过
//    [HanZhaoHua getNotesCommentListWithNotesId:@"1" page:1 pageNum:10 success:^(NSArray * _Nonnull list) {
//        for (PartyMemberThinking *model in list) {
//            NSLog(@"%@", model.pmName);
//            NSLog(@"%@", model.headImg);
//            NSLog(@"%@", model.ssDepartment);
//            NSLog(@"%@", model.commentInfo);
//            NSLog(@"%@", model.createTime);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
}

@end
