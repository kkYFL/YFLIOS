//
//  HanZhaoHua.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPEngine.h"
#import "LearningTaskModel.h"
#import "PartyMemberThinking.h"
#import "LearningHistory.h"
#import "SuggestionFeedback.h"
#import "StudyNotes.h"

NS_ASSUME_NONNULL_BEGIN

@interface HanZhaoHua : NSObject

/**
 *  @method         获取服务器时间
 *  @param          userToken 用户token
 *  @param          userId 用户id
 */
+(void)getServerTimeWithUserToken: (NSString *)userToken
                           userId: (NSString *)userId
                          success: (void (^)(NSDictionary *responseObject))success
                          failure: (void (^)(NSError *error))failure;

/**
 *  @method         获取学习任务列表
 *  @param          userId 用户id
 *  @param          type 类型: 1: 学习任务列表, 2:学习痕迹列表
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 */
+(void)getLearningTaskListWithUserId: (NSString *)userId
                                type: (NSInteger) type
                                page: (NSInteger) page
                             pageNum: (NSInteger) pageNum
                             success: (void (^)(NSArray *listArray))success
                             failure: (void (^)(NSError *error))failure;

/**
 *  @method         获取党员心声
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          taskId 任务id
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 */
+(void)getPartyMemberThinkingWithUserToken: (NSString *)userToken
                                    userId: (NSString *)userId
                                    taskId: (NSString *)taskId
                                      page: (NSInteger)page
                                   pageNum: (NSInteger) pageNum
                                   success: (void (^)(NSArray * listArray))success
                                   failure: (void (^)(NSError *error))failure;

/**
 *  @method         提交评论
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          taskId 任务id
 *  @param          commentInfo 评论内容
 */
+(void)submitCommentsWithUserToken: (NSString *)userToken
                            userId: (NSString *)userId
                            taskId: (NSString *)taskId
                       commentInfo: (NSString *)commentInfo
                           success: (void (^)(NSDictionary *responseObject))success
                           failure: (void (^)(NSError *error))failure;

/**
 *  @method         保存学习痕迹
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          taskId 任务id
 *  @param          startDate 服务端获取系统时间
 */
+(void)saveLearningTracesWithUserToken: (NSString *)userToken
                                userId: (NSString *)userId
                                taskId: (NSString *)taskId
                             startDate: (NSString *)startDate
                               success: (void (^)(NSDictionary *responseObject))success
                               failure: (void (^)(NSError *error))failure;

/**
 *  @method         获取学习痕迹列表
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          taskId 任务id
 */
+(void)getLearningHistoryWithUserToken: (NSString *)userToken
                                userId: (NSString *)userId
                                taskId: (NSString *)taskId
                               success: (void (^)(NSNumber *totalLearnTime, NSArray *list))success
                               failure: (void (^)(NSError *error))failure;

/**
 *  @method         获取意见反馈列表
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 */
+(void)getSuggestionFeedbackWithPage: (NSInteger)page
                             pageNum: (NSInteger)pageNum
                             success: (void (^)(NSArray *list))success
                             failure: (void (^)(NSError *error))failure;

/**
 *  @method         意见反馈
 *  @param          userId 用户id
 *  @param          title 反馈主题
 *  @param          problemInfo 问题描述
 */
+(void)suggestionFeedbackWithUserId: (NSString *)userId
                              title: (NSString *)title
                        problemInfo: (NSString *)problemInfo
                            success: (void (^)(NSDictionary *responseObject))success
                            failure: (void (^)(NSError *error))failure;

/**
 *  @method         获取学习心得列表
 *  @param          userId 用户id(此参数不传为所有用户心得)
 *  @param          taskId 任务id(此参数不传为所有任务心得)
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 */
+(void)getStudyNotesWithUserId: (NSString *)userId
                        taskId: (NSString *)taskId
                          page: (NSInteger)page
                       pageNum: (NSInteger)pageNum
                       success: (void (^)(NSArray *list))success
                       failure: (void (^)(NSError *error))failure;

/**
 *  @method         学习心得
 *  @param          userId 用户id
 *  @param          taskId 任务id
 *  @param          learnContent 心得体会
 */
+(void)submitStudyNotesWithUserId: (NSString *)userId
                           taskId: (NSString *)taskId
                     learnContent: (NSString *)learnContent
                          success: (void (^)(NSDictionary *responseObject))success
                          failure: (void (^)(NSError *error))failure;

/**
 *  @method         心得评论
 *  @param          userId 用户id
 *  @param          notesId 心得id
 *  @param          commentInfo 评论内容
 */
+(void)commentStudyNotesWithUserId: (NSString *)userId
                           notesId: (NSString *)notesId
                       commentInfo: (NSString *)commentInfo
                           success: (void (^)(NSDictionary *responseObject))success
                           failure: (void (^)(NSError *error))failure;

/**
 *  @method         心得评论
 *  @param          notesId 心得id
 */
+(void)likeStudyNotesWithNotesId: (NSString *)notesId
                         success: (void (^)(NSDictionary *responseObject))success
                         failure: (void (^)(NSError *error))failure;

/**
 *  @method         获取心得评论列表
 *  @param          notesId 用户id
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 */
+(void)getNotesCommentListWithNotesId: (NSString *)notesId
                                 page: (NSInteger)page
                              pageNum: (NSInteger)pageNum
                              success: (void (^)(NSArray *list))success
                              failure: (void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
