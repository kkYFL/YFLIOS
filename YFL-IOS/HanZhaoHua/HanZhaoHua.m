//
//  HanZhaoHua.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "HanZhaoHua.h"
#import "AppDelegate.h"


@implementation HanZhaoHua

+(void)loginWithUsername: (NSString *)username
                password: (NSString *)password
                 success: (void (^)(UserMessage *user))success
                 failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", APP_DELEGATE.host, @"/userCtrl/doLogin"];
    
    
    //外部传入数据
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setValue:username forKey:@"username"];
    [paraDic setValue:password forKey:@"password"];

    
    
    NSString *timeStamp = [PublicMethod currentTimeInterval];
    NSString *keyss = [self getCurrentYearMonthDay];
    NSString *randomNum = [self getRandomNum];
    NSString *sign = [PublicMethod MD5Encrypt:randomNum];
    NSString *originTakes = [PublicMethod MD5Encrypt:keyss];
    
    
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    [tmpDic setValue:timeStamp forKey:@"times"];
    [tmpDic setValue:originTakes forKey:@"takes"];
    [tmpDic setValue:username forKey:@"username"];
    [tmpDic setValue:password forKey:@"password"];
    
    
    
    NSArray *keys = tmpDic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    
    NSMutableString *valuesStr = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i<keys.count; i++) {
        NSString *objKey = keys[i];
        NSString *objValue = [tmpDic objectForKey:objKey];
        if (i == (keys.count -1)) {
            [valuesStr appendString:[NSString stringWithFormat:@"%@=%@",objKey,objValue]];
        }else{
            [valuesStr appendString:[NSString stringWithFormat:@"%@=%@|",objKey,objValue]];
        }
    }
    
    [paraDic setValue:timeStamp forKey:@"times"];
    [paraDic setValue:sign forKey:@"sign"];
    [paraDic setValue:[PublicMethod MD5Encrypt:valuesStr] forKey:@"takes"];

    
    
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            UserMessage *user = [[UserMessage alloc] initWithDic:dic];
            success(user);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(NSMutableDictionary *)encryptionWithPara:(NSMutableDictionary *)para{
    NSString *timeStamp = [PublicMethod currentTimeInterval];
    NSString *keyss = [self getCurrentYearMonthDay];
    NSString *randomNum = [self getRandomNum];
    NSString *sign = [PublicMethod MD5Encrypt:randomNum];
    NSString *originTakes = [PublicMethod MD5Encrypt:keyss];
    
    
    //加密前临时数据
    NSMutableDictionary *tmpDic = [para copy];
    [tmpDic setValue:timeStamp forKey:@"times"];
    [tmpDic setValue:originTakes forKey:@"takes"];
    
    
    NSArray *keys = tmpDic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    
    NSMutableString *valuesStr = [[NSMutableString alloc]init];
    for (NSInteger i = 0; i<keys.count; i++) {
        NSString *objKey = keys[i];
        NSString *objValue = [tmpDic objectForKey:objKey];
        if (i == (keys.count -1)) {
            [valuesStr appendString:[NSString stringWithFormat:@"%@=%@",objKey,objValue]];
        }else{
            [valuesStr appendString:[NSString stringWithFormat:@"%@=%@|",objKey,objValue]];
        }
    }
    
    
    //加密后数据包装
    [para setValue:timeStamp forKey:@"times"];
    [para setValue:sign forKey:@"sign"];
    [para setValue:[PublicMethod MD5Encrypt:valuesStr] forKey:@"takes"];

    return para;

}

+(void)changePasswordWithUserId: (NSString *)userId
                         oldPwd: (NSString *)oldPwd
                       password: (NSString *)password
                        success: (void (^)(NSDictionary *responseObject))success
                        failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", APP_DELEGATE.host, @"/userCtrl/resetPwd"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"oldPwd":oldPwd,
                              @"password":password
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

//获取当前的年月日  20181109
+(NSString *)getCurrentYearMonthDay{
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];

    if (currentDay < 10) {
        return [NSString stringWithFormat:@"%ld%ld%@%ld",currentYear,currentMonth,@"0",currentDay];
    }
    
    return [NSString stringWithFormat:@"%ld%ld%ld",currentYear,currentMonth,currentDay];
}


+(NSString *)getRandomNum{
    int randomNum = (arc4random() % 10000)+1;
    return [NSString stringWithFormat:@"%d",randomNum];
}


+(void)changePersonalInformationWithUserId: (NSString *)userId
                                   headImg: (NSString *)headImg
                                     motto: (NSString *)motto
                                   success: (void (^)(NSDictionary *responseObject))success
                                   failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/userCtrl/saveUserInfo"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"headImg":headImg,
                              @"motto":motto
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)savePersonalSourceWithPara:(NSDictionary *)para success:(void (^)(NSDictionary *responseObject))success failure: (void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/userCtrl/saveUserInfo"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:para success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}



+(void)getUserCurrentScoreWithUserToken: (NSString *)userToken
                                  userId: (NSString *)userId
                                 success: (void (^)(NSNumber *score))success
                                 failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/integral/score.json"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSNumber *score = [dic objectForKey:@"score"];
            success(score);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)getScoreListWithUserToken:(NSString *)userToken
                           userId:(NSString *)userId
                          success:(void (^)(NSArray * _Nonnull))success
                          failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", APP_DELEGATE.host, @"/integral/logsList.json"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                ScoreRecord * model = [[ScoreRecord alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+ (void)signInWithUserToken:(NSString *)userToken
                     userId:(NSString *)userId
                    success:(void (^)(NSDictionary * _Nonnull))success
                    failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/sign/signIn.do"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getUserSignInRecordWithUserToken: (NSString *)userToken
                                 userId: (NSString *)userId
                                   year: (NSInteger)year
                                  month: (NSInteger)month
                                success: (void (^)(NSDictionary *responseObject))success
                                failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/sign/signInList.json"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"year":[[NSNumber alloc] initWithInteger:year],
                              @"month":[[NSNumber alloc] initWithInteger:month]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getInformationBannerWithUserToken: (NSString *)userToken
                            positionType:(NSString *)positionType
                                 success: (void (^)(NSArray *bannerList))success
                                 failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/positionCtrl/getData"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"positionType":positionType
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            if ([responseObject objectForKey:@"data"] && [[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *list = [responseObject objectForKey:@"data"];
                NSMutableArray * result = [[NSMutableArray alloc] init];
                for (NSDictionary * d in list) {
                    Banner * model = [[Banner alloc] initWithDic:d];
                    [result addObject:model];
                }
                success([[NSArray alloc] initWithArray:result]);
            }else{
                NSDictionary *tmpDic = [responseObject objectForKey:@"data"];
                NSMutableArray * result = [[NSMutableArray alloc] init];
                Banner * model = [[Banner alloc] initWithDic:tmpDic];
                [result addObject:model];
                success([[NSArray alloc] initWithArray:result]);
            }

        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getInformationMessageWithUserToken: (NSString *)userToken
                             positionType: (NSString *)positionType
                                  success: (void (^)(Banner *message))success
                                  failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/positionCtrl/getData"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"positionType":positionType
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            Banner * model = [[Banner alloc] initWithDic:dic];
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getInformationMenuWithUserToken: (NSString *)userToken
                               success: (void (^)(NSArray *menuList))success
                               failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/informationTypeCtrl/getData"];
    NSDictionary *paraDic = @{@"userToken":userToken};
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in list) {
                InformationMenu *menu = [[InformationMenu alloc] initWithDic:dic];
                [result addObject:menu];
            }
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getNewsListWithUserToken: (NSString *)userToken
                        typesId: (NSString *)typesId
                          Title: (NSString *)title
                           page: (NSInteger)page
                        pageNum: (NSInteger)pageNum
                        success: (void (^)(NSArray *newsList))success
                        failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/informationCtrl/getData"];
    NSDictionary *paraDic = nil;
    if (title && title.length) {
                     paraDic = @{@"userToken":userToken,
                                  @"typesId":typesId,
                                  @"title":title,
                                  @"page":[NSNumber numberWithInteger:page],
                                  @"pageSize":[NSNumber numberWithInteger:pageNum]
                                  };
    }else{
                     paraDic = @{@"userToken":userToken,
                                  @"typesId":typesId,
                                  @"page":[NSNumber numberWithInteger:page],
                                  @"pageSize":[NSNumber numberWithInteger:pageNum]
                                  };
    }

    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in list) {
                NewsMessage *menu = [[NewsMessage alloc] init];
                [menu setValuesForKeysWithDictionary:dic];
                [result addObject:menu];
            }
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getNewsDetailWithUserToken: (NSString *)userToken
                           userId: (NSString *)userId
                           infoId: (NSString *)infoId
                    informationId: (NSString *)informationId
                          success: (void (^)(NewsDetail *newsDetail))success
                          failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/informationCtrl/getInfoHtml"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"informationId":informationId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NewsDetail *news = [[NewsDetail alloc] init];
            [news setValuesForKeysWithDictionary:dic];
            success(news);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getServerTimeWithUserToken: (NSString *)userToken
                           userId: (NSString *)userId
                          success: (void (^)(NSDictionary *responseObject))success
                          failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/memberTaskCtrl/getSysDate"];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/memberTaskCtrl/getData"];
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
                LearningTaskModel * model = [[LearningTaskModel alloc] initWithDic:d];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/taskCommentCtrl/getData"];
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
                PartyMemberThinking * model = [[PartyMemberThinking alloc] initWithDic:d];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/taskCommentCtrl/addData"];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/memberTaskCtrl/addHistory"];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/memberTaskCtrl/getHistory"];
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
                LearningHistory * model = [[LearningHistory alloc] initWithDic:d];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/advise/getData"];
    NSDictionary *paraDic = @{@"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                SuggestionFeedback * model = [[SuggestionFeedback alloc] initWithDic:d];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/advise/addData"];
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
                         queryType: (NSString *)queryType
                          page: (NSInteger)page
                       pageNum: (NSInteger)pageNum
                       success: (void (^)(NSArray *list))success
                       failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", APP_DELEGATE.host, @"/taskNotes/getNotes"];
    NSDictionary *paraDic = @{@"userId":userId,
                              @"queryType":queryType,
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/taskNotes/addNotes"];
    NSDictionary *paraDic = @{@"userId":userId,
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/taskNotes/addNotesComment"];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/taskNotes/fabulous"];
    NSDictionary *paraDic = @{@"notesId":notesId,
                              @"userId":APP_DELEGATE.userId
                              };
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/taskNotes/getNotesComment"];
    NSDictionary *paraDic = @{@"notesId":notesId,
                              @"page":[NSNumber numberWithInteger:page],
                              @"limit":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            NSArray *list = [dataDic objectForKey:@"list"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                PartyMemberThinking * model = [[PartyMemberThinking alloc] initWithDic:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)testRankingWithUserToken: (NSString *)userToken
                         userId: (NSString *)userId
                           page: (NSInteger)page
                        pageNum: (NSInteger)pageNum
                        success: (void (^)(TestRanking *owner, NSArray *scoreList))success
                        failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/queryNearScore"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"page":[NSNumber numberWithInteger:page],
                              @"pageSize":[NSNumber numberWithInteger:pageNum]
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSDictionary *dic = [responseObject objectForKey:@"data"];
            NSDictionary *ownerDic = [dic objectForKey:@"owner"];
            TestRanking * owner = [[TestRanking alloc] init];
            [owner setValuesForKeysWithDictionary:ownerDic];
            NSArray *list = [dic objectForKey:@"scoreList"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                TestRanking * model = [[TestRanking alloc] init];
                [model setValuesForKeysWithDictionary:d];
                [result addObject:model];
            }
            success(owner, [[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getExamListWithUserToken: (NSString *)userToken
                         userId: (NSString *)userId
                           page: (NSInteger)page
                        pageNum: (NSInteger)pageNum
                      queryType: (NSString *)queryType
                        success: (void (^)(NSArray *list))success
                        failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/queryExamPaperList"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"page":[NSNumber numberWithInteger:page],
                              @"pageSize":[NSNumber numberWithInteger:pageNum],
                              @"queryType":queryType
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * d in list) {
                HistoryExam * model = [[HistoryExam alloc] initWithDic:d];
                [result addObject:model];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getHistoryExamDetailWithUserToken: (NSString *)userToken
                                  userId: (NSString *)userId
                                 paperId: (NSString *)paperId
                                 success: (void (^)(NSArray *list))success
                                 failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/queryExamPaperDetail"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"paperId":paperId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        //        if (success) {
        //            NSArray *list = [responseObject objectForKey:@"data"];
        //            NSMutableArray * result = [[NSMutableArray alloc] init];
        //            for (NSDictionary * d in list) {
        //                HistoryExam * model = [[HistoryExam alloc] init];
        //                [model setValuesForKeysWithDictionary:d];
        //                [result addObject:model];
        //            }
        //            success([[NSArray alloc] initWithArray:result]);
        //        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getExamRuleWithUserToken: (NSString *)userToken
                         userId: (NSString *)userId
                        paperId: (NSString *)paperId
                        success: (void (^)(NSDictionary *examRule))success
                        failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/examPaperDesc"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"paperId":paperId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSDictionary *ruledic = [responseObject objectForKey:@"data"];
            success(ruledic);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)getWaitingToStartDetailWithUserToken: (NSString *)userToken
                                     userId: (NSString *)userId
                                    paperId: (NSString *)paperId
                                    success: (void (^)(NSArray *detailList))success
                                    failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/queryExamPaperSourceList"];
    NSDictionary *paraDic = @{@"userToken":userToken,
                              @"userId":userId,
                              @"paperId":paperId
                              };
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSArray *list = [responseObject objectForKey:@"data"];
            NSMutableArray *result = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in list) {
                HistoryExamDetail *examDetail = [[HistoryExamDetail alloc] initWithDic:dic];
                [result addObject:examDetail];
            }
            success([[NSArray alloc] initWithArray:result]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)submitExamPaperWithParaDic: (NSDictionary *)paraDic
                          success: (void (^)(NSDictionary *responseObject))success
                          failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/handExamPaper"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)uploadFileWithFiles: (NSData *)files success: (void (^)(NSString *imgUrl))success
                   failure: (void (^)(NSError *error))failure
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", APP_DELEGATE.host, @"/file/upload.do"];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[PublicMethod currentTimeInterval]];
    [[HTTPEngine sharedEngine] uploadData:files url:urlStr fileName:fileName mimeType:@"image/png" success:^(NSDictionary *responseObject) {
        NSLog(@"%@", responseObject);
        if (success) {
            NSString * imgUrl = @"";
            if ([responseObject objectForKey:@"data"] && [[responseObject objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *list = [responseObject objectForKey:@"data"];
                for (NSDictionary *dic in list) {
                    imgUrl = [dic objectForKey:@"imgUrl"];
                }
            }
            success(imgUrl);
        }
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)GetPersonInfoSourceWithParaDic: (NSDictionary *)paraDic
                              success: (void (^)(NSDictionary *responseObject))success
                              failure: (void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/userCtrl/getUserInfo"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}

+(void)GetAPPVersionSourceWithParaDic: (NSDictionary *)paraDic
                              success: (void (^)(NSDictionary *responseObject))success
                              failure: (void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/version/update.do"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)GetAPPGuidenViewImageSourceWithParaDic: (NSDictionary *)paraDic
                                      success: (void (^)(NSDictionary *responseObject))success
                                      failure: (void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/positionCtrl/welcomeImgs"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


//+(void)GetSubmitExamAnswerToServerWithParaDic: (NSDictionary *)paraDic
//                                      success: (void (^)(NSDictionary *responseObject))success
//                                      failure: (void (^)(NSError *error))failure{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@", host, @"exam/handExamPaper"];
//    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
//        if (success) success(responseObject);
//    } failure:^(NSError *error) {
//        if (failure) failure(error);
//    }];
//}


+(void)MYLogOutWithParaDic: (NSDictionary *)paraDic success: (void (^)(NSDictionary *responseObject))success failure: (void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/userCtrl/logout"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)MYGetLaungeWithParaDic:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/toolsCtrl/translation"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)MYGetDangYuanListWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/userCtrl/getBranchUser"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)MYGetDangYuanJianduListWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/memberTaskCtrl/getAuthorData"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)MYGetDangYuanKaoshiJianduListWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/getAuthorData"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];

}


+(void)MYGetDangYuanRenwuDetailSourceWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/memberTaskCtrl/getAuthorMember"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}


+(void)MYGetDangYuanKaoshiDetailSourceWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/exam/getAuthorMember"];
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];

}


+(void)MYGetFanbuGetH5SouceWithPara:(NSDictionary *)paraDic Success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.host, @"/toolsCtrl/getSysInfoHtml"];
    
    [paraDic setValue:APP_DELEGATE.userToken forKey:@"userToken"];
    [paraDic setValue:APP_DELEGATE.userId forKey:@"userId"];
    
    [[HTTPEngine sharedEngine] postRequestWithBodyUrl:urlStr params:paraDic success:^(NSDictionary *responseObject) {
        if (success) success(responseObject);
    } failure:^(NSError *error) {
        if (failure) failure(error);
    }];
}



@end
