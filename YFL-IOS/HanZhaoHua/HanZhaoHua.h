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
#import "TestRanking.h"
#import "HistoryExam.h"
#import "HistoryExamDetail.h"
#import "Answers.h"
#import "Banner.h"
#import "InformationMenu.h"
#import "NewsMessage.h"
#import "NewsDetail.h"
#import "UserMessage.h"
#import "ScoreRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface HanZhaoHua : NSObject

/// 用户相关

/**
 *  @method         用户登录
 *  @param          username 用户名称
 *  @param          password 用户密码
 */
+(void)loginWithUsername: (NSString *)username
                password: (NSString *)password
                 success: (void (^)(UserMessage *user))success
                 failure: (void (^)(NSError *error))failure;

/**
 *  @method         修改密码
 *  @param          userId 用户id
 *  @param          oldPwd 旧密码
 *  @param          password 新密码
 */
+(void)changePasswordWithUserId: (NSString *)userId
                         oldPwd: (NSString *)oldPwd
                       password: (NSString *)password
                        success: (void (^)(NSDictionary *responseObject))success
                        failure: (void (^)(NSError *error))failure;

/**
 *  @method         个人信息
 *  @param          userId 用户id
 *  @param          headImg 头像地址
 *  @param          motto 座右铭
 */
+(void)changePersonalInformationWithUserId: (NSString *)userId
                                   headImg: (NSString *)headImg
                                     motto: (NSString *)motto
                                   success: (void (^)(NSDictionary *responseObject))success
                                   failure: (void (^)(NSError *error))failure;

/**
 *  @method         用户当前积分
 *  @param          userToken 用户token
 *  @param          userId 用户id
 */
+(void)getUserCurrentScoreWithUserToken: (NSString *)userToken
                                  userId: (NSString *)userId
                                 success: (void (^)(NSNumber *score))success
                                 failure: (void (^)(NSError *error))failure;

/**
 *  @method         积分列表
 *  @param          userToken 用户token
 *  @param          userId 用户id
 */
+(void)getScoreListWithUserToken: (NSString *)userToken
                          userId: (NSString *)userId
                         success: (void (^)(NSArray *scoreList))success
                         failure: (void (^)(NSError *error))failure;

/**
 *  @method         签到
 *  @param          userToken 用户token
 *  @param          userId 用户id
 */
+(void)signInWithUserToken: (NSString *)userToken
                  userId: (NSString *)userId
                 success: (void (^)(NSDictionary *responseObject))success
                 failure: (void (^)(NSError *error))failure;

/**
 *  @method         用户签到日历
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          year 年份
 *  @param          month 月份
 */
+(void)getUserSignInRecordWithUserToken: (NSString *)userToken
                                 userId: (NSString *)userId
                                   year: (NSInteger)year
                                  month: (NSInteger)month
                                success: (void (^)(NSDictionary *responseObject))success
                                failure: (void (^)(NSError *error))failure;
/// 资讯相关
/**
 *  @method         banner接口/热区菜单接口
 *  @param          userToken 用户token
 *  @param          positionType positon类型: banner:MPOS_1 热区菜单:MPOS_4
 */
+(void)getInformationBannerWithUserToken: (NSString *)userToken
                            positionType:(NSString *)positionType
                                 success: (void (^)(NSArray *bannerList))success
                                 failure: (void (^)(NSError *error))failure;

/**
 *  @method         小喇叭接口/教育视频接口
 *  @param          userToken 用户token
 *  @param          positionType positon类型: 小喇叭:SPOS_2 教育视频:SPOS_3
 */
+(void)getInformationMessageWithUserToken: (NSString *)userToken
                             positionType: (NSString *)positionType
                                  success: (void (^)(Banner *message))success
                                  failure: (void (^)(NSError *error))failure;

/**
 *  @method         资讯菜单接口
 *  @param          userToken 用户token
 */
+(void)getInformationMenuWithUserToken: (NSString *)userToken
                               success: (void (^)(NSArray *menuList))success
                               failure: (void (^)(NSError *error))failure;

/**
 *  @method         新闻列表接口
 *  @param          userToken 用户token
 *  @param          typesId 资讯类型id/0表示查询全部
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 */
+(void)getNewsListWithUserToken: (NSString *)userToken
                        typesId: (NSString *)typesId
                          Title: (NSString *)title
                           page: (NSInteger)page
                        pageNum: (NSInteger)pageNum
                        success: (void (^)(NSArray *newsList))success
                        failure: (void (^)(NSError *error))failure;

/**
 *  @method         新闻详情接口
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          infoId 详情id
 *  @param          informationId 新闻id
 */
+(void)getNewsDetailWithUserToken: (NSString *)userToken
                           userId: (NSString *)userId
                           infoId: (NSString *)infoId
                    informationId: (NSString *)informationId
                          success: (void (^)(NewsDetail *newsDetail))success
                          failure: (void (^)(NSError *error))failure;

/// 教育相关

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
                     queryType: (NSString *)queryType
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

/// 考试相关

/**
 *  @method         考试排名
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 */
+(void)testRankingWithUserToken: (NSString *)userToken
                         userId: (NSString *)userId
                           page: (NSInteger)page
                        pageNum: (NSInteger)pageNum
                        success: (void (^)(TestRanking *owner, NSArray *scoreList))success
                        failure: (void (^)(NSError *error))failure;

/**
 *  @method         历史考试列表/待开始列表
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          page 第几页
 *  @param          pageNum 每页条数
 *  @param          queryType 1-待考试 2-历史考试
 */
+(void)getExamListWithUserToken: (NSString *)userToken
                         userId: (NSString *)userId
                           page: (NSInteger)page
                        pageNum: (NSInteger)pageNum
                      queryType: (NSString *)queryType
                        success: (void (^)(NSArray *list))success
                        failure: (void (^)(NSError *error))failure;

/**
 *  @method         历史考试详情
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          paperId 考试试卷id
 */
+(void)getHistoryExamDetailWithUserToken: (NSString *)userToken
                                  userId: (NSString *)userId
                                 paperId: (NSString *)paperId
                                 success: (void (^)(NSArray *list))success
                                 failure: (void (^)(NSError *error))failure;

/**
 *  @method         待考试规则
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          paperId 考试试卷id
 */
+(void)getExamRuleWithUserToken: (NSString *)userToken
                         userId: (NSString *)userId
                        paperId: (NSString *)paperId
                        success: (void (^)(NSDictionary *examRule))success
                        failure: (void (^)(NSError *error))failure;

/**
 *  @method         待开始详情
 *  @param          userToken 用户token
 *  @param          userId 用户id
 *  @param          paperId 考试试卷id
 */
+(void)getWaitingToStartDetailWithUserToken: (NSString *)userToken
                                     userId: (NSString *)userId
                                    paperId: (NSString *)paperId
                                    success: (void (^)(NSArray *detailList))success
                                    failure: (void (^)(NSError *error))failure;

/**
 *  @method         党员考试交卷
 *  @param          paraDic 数据
 */
+(void)submitExamPaperWithParaDic: (NSDictionary *)paraDic
                          success: (void (^)(NSDictionary *responseObject))success
                          failure: (void (^)(NSError *error))failure;

/// 公共
/**
 *  @method         文件上传
 *  @param          files 二进制数据
 */
+(void)uploadFileWithFiles: (NSData *)files success: (void (^)(NSString *imgUrl))success
                   failure: (void (^)(NSError *error))failure;



/**
 个人中心—用户信息查询接口

 */
+(void)GetPersonInfoSourceWithParaDic: (NSDictionary *)paraDic
                              success: (void (^)(NSDictionary *responseObject))success
                              failure: (void (^)(NSError *error))failure;


+(void)savePersonalSourceWithPara:(NSDictionary *)para success:(void (^)(NSDictionary *responseObject))success failure: (void (^)(NSError *error))failure;
    

/**
 版本更新
 
 */
+(void)GetAPPVersionSourceWithParaDic: (NSDictionary *)paraDic
                              success: (void (^)(NSDictionary *responseObject))success
                              failure: (void (^)(NSError *error))failure;


/**
 欢迎页面

 */
+(void)GetAPPGuidenViewImageSourceWithParaDic: (NSDictionary *)paraDic
                              success: (void (^)(NSDictionary *responseObject))success
                              failure: (void (^)(NSError *error))failure;



/**
 欢迎页面
 
 */
+(void)MYLogOutWithParaDic: (NSDictionary *)paraDic success: (void (^)(NSDictionary *responseObject))success failure: (void (^)(NSError *error))failure;



/**
 墨云-获取学习任务列表
 
 @param queryType      类型   1：汉语 2：藏语
 */
+(void)MYGetLaungeWithParaDic:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;



/**
 墨云-支部党员接口

 */

+(void)MYGetDangYuanListWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;


/**
 墨云-支部任务监督
 
 */
+(void)MYGetDangYuanJianduListWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;


/**
 墨云-支部考试监督
 
 */
+(void)MYGetDangYuanKaoshiJianduListWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;



/**
 墨云-支部任务监督人员列表
 
 */
+(void)MYGetDangYuanRenwuDetailSourceWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;



/**
 墨云-支部考试监督人员列表
 
 */
+(void)MYGetDangYuanKaoshiDetailSourceWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;


/**
 墨云-返回h5页面接口
 */

+(void)MYGetFanbuGetH5SouceWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;


/**
 墨云-语言切换
 */
+(void)MYGetLaungeWithType:(NSInteger)type Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
