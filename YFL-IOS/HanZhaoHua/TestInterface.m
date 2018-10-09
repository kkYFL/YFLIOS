//
//  TestInterface.m
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "TestInterface.h"

static NSString *userToken = @"1";
static NSString *userId = @"a6464fe1-6d65-4088-88f2-08272e55253f";
static NSString *taskId = @"1";

@implementation TestInterface

+(void)test {
    
    // 用户登录
    // 测试结果: 通过
//    [HanZhaoHua loginWithUsername:@"15606811521" password:@"000000" success:^(UserMessage * _Nonnull user) {
//        NSLog(@"%@", user);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 修改密码
    // 测试结果: 通过
//    [HanZhaoHua changePasswordWithUserId:userId oldPwd:@"111111" password:@"000000" success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 个人信息
    // 测试结果: 通过
//    [HanZhaoHua changePersonalInformationWithUserId:userId headImg:@"" motto:@"hehe" success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 用户当前积分
    // 测试结果: 通过
//    [HanZhaoHua getUserCurrentScoreWithUserToken:userToken userId:userId success:^(NSNumber * _Nonnull score) {
//        NSLog(@"%@", score);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 积分列表
    // 测试结果: 接口通过, 但是无数据返回
//    [HanZhaoHua getScoreListWithUserToken:userToken userId:userId success:^(NSArray * _Nonnull scoreList) {
//        for (ScoreRecord *score in scoreList) {
//            NSLog(@"%@", score.expireTime);
//            NSLog(@"%@", score.getTime);
//            NSLog(@"%@", score.scoreId);
//            NSLog(@"%@", score.remark);
//            NSLog(@"%@", score.score);
//            NSLog(@"%@", score.source);
//            NSLog(@"%@", score.pmId);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 签到接口
    // 测试结果: 通过
//    [HanZhaoHua signInWithUserToken:userToken userId:userId success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 用户签到日历
    // 测试结果: 接口通过, 但是无有效数据返回
//    [HanZhaoHua getUserSignInRecordWithUserToken:userToken userId:userId year:2018 month:9 success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // banner接口   positionType:@"MPOS_1"
    // 热区菜单接口  positionType:@"MPOS_4"
    // 测试结果: 通过
//    [HanZhaoHua getInformationBannerWithUserToken:userToken positionType:@"MPOS_4" success:^(NSArray * _Nonnull bannerList) {
//        for (Banner *model in bannerList) {
//            NSLog(@"%@", model.imgUrl);
//            NSLog(@"%@", model.positionNo);
//            NSLog(@"%@", model.summary);
//            NSLog(@"%@", model.foreignUrl);
//            NSLog(@"%@", model.foreignType);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 小喇叭接口   positionType:@"SPOS_2"
    // 教育视频接口  positionType:@"SPOS_3"
    // 测试结果: 通过
//    [HanZhaoHua getInformationMessageWithUserToken:userToken positionType:@"SPOS_3" success:^(Banner * _Nonnull message) {
//        NSLog(@"%@", message.imgUrl);
//        NSLog(@"%@", message.positionNo);
//        NSLog(@"%@", message.summary);
//        NSLog(@"%@", message.foreignUrl);
//        NSLog(@"%@", message.foreignType);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 资讯菜单接口
    // 测试结果: 通过
//    [HanZhaoHua getInformationMenuWithUserToken:userToken success:^(NSArray * _Nonnull menuList) {
//        for (InformationMenu *menu in menuList) {
//            NSLog(@"%@", menu.menuId);
//            NSLog(@"%@", menu.imgUrl);
//            NSLog(@"%@", menu.appPositon);
//            NSLog(@"%@", menu.typeInfo);
//            NSLog(@"%@", menu.typeName);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 新闻列表接口
    // 测试结果: 通过
//    [HanZhaoHua getNewsListWithUserToken:userToken typesId:@"0" page:1 pageNum:10 success:^(NSArray * _Nonnull newsList) {
//        for (NewsMessage *news in newsList) {
//            NSLog(@"%@", news.browsingNum);
//            NSLog(@"%@", news.clickNum);
//            NSLog(@"%@", news.commonNum);
//            NSLog(@"%@", news.imgUrl);
//            NSLog(@"%@", news.infoId);
//            NSLog(@"%@", news.infoType);
//            NSLog(@"%@", news.shortInfo);
//            NSLog(@"%@", news.sourceFrom);
//            NSLog(@"%@", news.title);
//            NSLog(@"%@", news.types);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 新闻详情接口
    // 测试结果: 未通过, 未提供测试数据, 无法测试
//    [HanZhaoHua getNewsDetailWithUserToken:userToken userId:userId infoId:@"100" informationId:@"1" success:^(NewsDetail * _Nonnull newsDetail) {
//        NSLog(@"%@", newsDetail.userId);
//        NSLog(@"%@", newsDetail.userToken);
//        NSLog(@"%@", newsDetail.imgUrl);
//        NSLog(@"%@", newsDetail.summary);
//        NSLog(@"%@", newsDetail.foreignUrl);
//        NSLog(@"%@", newsDetail.foreignType);
//        NSLog(@"%@", newsDetail.positionNo);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 获取服务器时间
    // 测试结果: 通过
    //    [HanZhaoHua getServerTimeWithUserToken:@"1" userId:@"1" success:^(NSDictionary * _Nonnull responseObject) {
    //        NSString *code = [[responseObject objectForKey:@"code"] stringValue];
    //        if ([code isEqualToString:@"2000"]) {
    //            NSNumber *time = [responseObject objectForKey:@"data"];
    //            NSLog(@"%@", time);
    //        } else {
    //            NSLog(@"处理错误");
    //        }
    //    } failure:^(NSError * _Nonnull error) {
    //        NSLog(@"%@", error);
    //    }];
    
    


    




    
    // 考试排名
    // 测试结果: 通过
    //    [HanZhaoHua testRankingWithUserToken:userToken userId:userId page:1 pageNum:10 success:^(TestRanking *owner, NSArray *scoreList) {
    //        NSLog(@"%@", owner.headImg);
    //        NSLog(@"%@", owner.name);
    //        NSLog(@"%@", owner.score);
    //        for (TestRanking *model in scoreList) {
    //            NSLog(@"%@", model.headImg);
    //            NSLog(@"%@", model.name);
    //            NSLog(@"%@", model.score);
    //        }
    //    } failure:^(NSError * _Nonnull error) {
    //        NSLog(@"%@", error);
    //    }];
    
    // 历史考试列表/待开始列表
    // 测试结果: 通过
//    [HanZhaoHua getExamListWithUserToken:userToken userId:userId page:1 pageNum:10 queryType:@"1" success:^(NSArray * _Nonnull list) {
//        for (HistoryExam *model in list) {
//            NSLog(@"%@", model.times);
//            NSLog(@"%@", model.totalTime);
//            NSLog(@"%@", model.totalTimes);
//            NSLog(@"%@", model.paperTitle);
//            NSLog(@"%@", model.beginTime);
//            NSLog(@"%@", model.finalTime);
//            NSLog(@"%@", model.state);
//            NSLog(@"%@", model.summary);
//            NSLog(@"%@", model.examId);
//            NSLog(@"%@", model.paperId);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 历史考试详情
    // 测试结果: 接口通过, 但无有效数据返回
//        [HanZhaoHua getHistoryExamDetailWithUserToken:userToken userId:userId paperId:@"5c6672ac-22f3-40d7-a175-efeeab1247ce" success:^(NSArray * _Nonnull list) {
//
//        } failure:^(NSError * _Nonnull error) {
//            NSLog(@"%@", error);
//        }];
    
    // 待考试规则
    // 测试结果: 通过
//    [HanZhaoHua getExamRuleWithUserToken:userToken userId:userId paperId:@"5c6672ac-22f3-40d7-a175-efeeab1247ce" success:^(HistoryExam * _Nonnull examRule) {
//        NSLog(@"%@", examRule.times);
//        NSLog(@"%@", examRule.totalTime);
//        NSLog(@"%@", examRule.totalTimes);
//        NSLog(@"%@", examRule.paperTitle);
//        NSLog(@"%@", examRule.beginTime);
//        NSLog(@"%@", examRule.finalTime);
//        NSLog(@"%@", examRule.state);
//        NSLog(@"%@", examRule.summary);
//        NSLog(@"%@", examRule.examId);
//        NSLog(@"%@", examRule.paperId);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 待开始详情
    // 测试结果: 通过
//    [HanZhaoHua getWaitingToStartDetailWithUserToken:userToken userId:userId paperId:@"5c6672ac-22f3-40d7-a175-efeeab1247ce" success:^(NSArray * _Nonnull detailList) {
//
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    
    // 党员开始交卷
    // 测试结果: 通过
//    NSDictionary *paraDic = @{@"userToken":userToken,
//                              @"userId":userId,
//                              @"paperId":@"5c6672ac-22f3-40d7-a175-efeeab1247ce",
//                              @"data": @{@"userAnswer":@"",
//                                         @"examTitle":@"",
//                                         @"totalTimes": [[NSNumber alloc] initWithInteger:2],
//                                         @"paperTitle":@"",
//                                         @"examUrl":@"",
//                                         @"examId":@"",
//                                         @"examType":@"",
//                                         @"summary":@"",
//                                         @"answers":@[@{}]
//                                         }
//                              };
//    [HanZhaoHua submitExamPaperWithParaDic:paraDic success:^(NSDictionary * _Nonnull responseObject) {
//        NSLog(@"%@", responseObject);
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error);
//    }];
    


    
}

@end
