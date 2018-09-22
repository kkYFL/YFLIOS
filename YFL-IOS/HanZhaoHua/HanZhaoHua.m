//
//  HanZhaoHua.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "HanZhaoHua.h"

@implementation HanZhaoHua

+(void)getServerTimeWithUserToken: (NSString *)userToken
                           userId: (NSString *)userId
                          success: (void (^)(NSDictionary *responseObject))success
                          failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/memberTaskCtrl/getSysDate"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId};
    [[HTTPEngine sharedEngine] getRequestWithURL:urlStr parameter:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getLearningTaskListWithUserId: (NSString *)userId
                                type: (NSInteger) type
                                page: (NSInteger) page
                             pageNum: (NSInteger) pageNum
                             success: (void (^)(NSArray * listArray))success
                             failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/memberTaskCtrl/getData"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"type":[NSNumber numberWithInteger:type],
                              @"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray * list = [dic objectForKey:@"list"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                LearningTaskModel * model = [[LearningTaskModel alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getPartyMemberThinkingWithUserToken: (NSString *)userToken
                                    userId: (NSString *)userId
                                    taskId: (NSString *)taskId
                                      page: (NSInteger)page
                                   pageNum: (NSInteger) pageNum
                                   success: (void (^)(NSArray * listArray))success
                                   failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/taskCommentCtrl/getData"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"taskId":taskId,
                              @"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                PartyMemberThinking * model = [[PartyMemberThinking alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)submitCommentsWithUserToken: (NSString *)userToken
                            userId: (NSString *)userId
                            taskId: (NSString *)taskId
                       commentInfo: (NSString *)commentInfo
                           success: (void (^)(NSDictionary *responseObject))success
                           failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/taskCommentCtrl/addData"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"taskId":taskId,
                              @"commentInfo":commentInfo
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)saveLearningTracesWithUserToken: (NSString *)userToken
                                userId: (NSString *)userId
                                taskId: (NSString *)taskId
                             startDate: (NSString *)startDate
                               success: (void (^)(NSDictionary *responseObject))success
                               failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/memberTaskCtrl/addHistory"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"taskId":taskId,
                              @"startDate":startDate
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getLearningHistoryWithUserToken: (NSString *)userToken
                                userId: (NSString *)userId
                                taskId: (NSString *)taskId
                               success: (void (^)(NSNumber *totalLearnTime, NSArray *list))success
                               failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/memberTaskCtrl/getHistory"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"taskId":taskId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSArray *list = [dic objectForKey:@"list"];
            NSNumber *totalLearnTime = [dic objectForKey:@"totalLearnTime"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                LearningHistory * model = [[LearningHistory alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success(totalLearnTime, [[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getSuggestionFeedbackWithPage: (NSInteger)page
                             pageNum: (NSInteger)pageNum
                             success: (void (^)(NSArray *list))success
                             failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/advise/getData"];
    NSDictionary *paraDic = @{@"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                SuggestionFeedback * model = [[SuggestionFeedback alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)suggestionFeedbackWithUserId: (NSString *)userId
                              title: (NSString *)title
                        problemInfo: (NSString *)problemInfo
                            success: (void (^)(NSDictionary *responseObject))success
                            failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/advise/addData"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"title":title,
                              @"problemInfo":problemInfo
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getStudyNotesWithUserId: (NSString *)userId
                          taskId: (NSString *)taskId
                            page: (NSInteger)page
                         pageNum: (NSInteger)pageNum
                         success: (void (^)(NSArray *list))success
                         failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/taskNotes/getNotes"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"taskId":taskId,
                              @"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                StudyNotes * model = [[StudyNotes alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)submitStudyNotesWithUserId: (NSString *)userId
                           taskId: (NSString *)taskId
                     learnContent: (NSString *)learnContent
                          success: (void (^)(NSDictionary *responseObject))success
                          failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/taskNotes/addNotes"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"taskId":taskId,
                              @"learnContent":learnContent
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)commentStudyNotesWithUserId: (NSString *)userId
                           notesId: (NSString *)notesId
                       commentInfo: (NSString *)commentInfo
                           success: (void (^)(NSDictionary *responseObject))success
                           failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/taskNotes/addNotesComment"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"notesId":notesId,
                              @"commentInfo":commentInfo
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)likeStudyNotesWithNotesId: (NSString *)notesId
                         success: (void (^)(NSDictionary *responseObject))success
                         failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/taskNotes/fabulous"];
    NSDictionary *paraDic = @{@"notesId":notesId};
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getNotesCommentListWithNotesId: (NSString *)notesId
                               page: (NSInteger)page
                            pageNum: (NSInteger)pageNum
                            success: (void (^)(NSArray *list))success
                            failure: (void (^)(NSError *error))failure
{
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://47.100.247.71/protal/taskNotes/getNotesComment"];
    NSDictionary *paraDic = @{@"notesId":notesId,
                              @"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                PartyMemberThinking * model = [[PartyMemberThinking alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

@end
