//
//  HttpConfig.h
//  EWTBase
//
//  Created by Tony on 2018/3/17.
//  Copyright © 2018年 Huangbaoyang. All rights reserved.
//

#ifndef HttpConfig_h
#define HttpConfig_h


typedef NS_ENUM(NSInteger, HTTPCode) {
    KickedofLine = 704,
    CommunityLogin = -9
};

// www.233.mistong.com  志愿填报/用户模块/心理FM评论等
// bbs.ewt360.com 社区
// tlog.data.mistong.com  统计,日志方面的
// my.233.mistong.com 用户
// kc.233.mistong.com 全部启用
// study.233.mistong.com/ 提分线E讲堂所在全部接口
// live.233.mistong.com 直播
// m.ewt360.com  学分
// plog.ewt360.com 大数据.
// xinli.233.mistong.com 信息
// messagecenter.233.mistong.com  消息中心
// teacher.233.mistong.com  教师端

#ifdef DEBUG
static NSString* main_host = @"www.233.mistong.com";
static NSString* community_host = @"test.bbs.ewt360.com";
static NSString* statistics_host = @"tlog.data.mistong.com";
static NSString* user_host = @"my.233.mistong.com";
static NSString* all_host = @"kc.233.mistong.com";
static NSString* study_host = @"study.233.mistong.com";
static NSString* live_host = @"live.233.mistong.com";
static NSString* score_host = @"m.233.mistong.com";
static NSString* bigData_host = @"plog.ewt360.com";
static NSString* fm_host = @"xinli.233.mistong.com";
static NSString* messageCenter_host = @"messagecenter.233.mistong.com";
static NSString* teacher_host = @"teacher.233.mistong.com";
#else
static NSString* main_host = @"www.ewt360.com";
static NSString* community_host = @"bbs.ewt360.com";
static NSString* statistics_host = @"clog.ewt360.com";
static NSString* user_host = @"passport.ewt360.com";
static NSString* all_host = @"kc.ewt360.com";
static NSString* study_host = @"study.ewt360.com";
static NSString* live_host = @"live.ewt360.com";
static NSString* score_host = @"m.ewt360.com";
static NSString* bigData_host = @"plog.ewt360.com";
static NSString* fm_host = @"xinli.ewt360.com";
static NSString* messageCenter_host = @"messagecenter.ewt360.com";
static NSString* teacher_host = @"teacher.ewt360.com";

#endif

#endif /* HttpConfig_h */
