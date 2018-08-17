//
//  EWTWebViewJumperConfig.h
//  Ewt360
//
//  Created by zwz on 2017/11/29.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#ifndef EWTWebViewJumperConfig_h
#define EWTWebViewJumperConfig_h

typedef NS_ENUM(NSUInteger, WebViewJumperType) {
    VideoDetail = 1, // 课程详情
    PostDetail = 2, // 帖子详情
    PsychologyFMDetail = 3, // 心理FM
    LiveVideoDetail = 4, //直播详情
    FMTestingList = 5,   // FM测试列表
    FMEssayList  = 6, // FM文章列表
    FMSunnyList = 7, // FM 列表
    CMSection = 8, // 社区板块
    LiveVideoListDetail = 9,// 直播系列
    FMPlateNewsDetail = 10, // 板报评论详情
    VolunteerMap = 11, //志愿填报3D地图
    DeleteWebCache = 88, // 清理web缓存
    Web_ChangePassword = 99, // 密码修改
    GetAppBaseInfo = 999  // 获取app的基本信息
};
#endif /* EWTWebViewJumperConfig_h */
