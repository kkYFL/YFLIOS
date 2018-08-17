//
//  EWTModuleType.h
//  Ewt360
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 铭师堂. All rights reserved.
//

#ifndef EWTModuleType_h
#define EWTModuleType_h


typedef enum : NSUInteger {
    MessageCenter = 1,                  // 消息中心 1
    Search,                             // 搜索    2
    Download,                           // 下载    3
    Bulletinboard,                      // 公告栏  4
    Sign,                               // 签到    5
    LearnCenter,                        // 学习中心 6
    Exam_lib,                           // 题库入口 7
    Eword,                              // Eword   8
    JoinMembership,                     // 注册会员 9
    InformationContinue,                // 信息完成 10
    SubjectSort,                        // 科目排序 11
    SubjectEntrance,                    // 科目入口 12
    CourseContent,                      // 课程内容 13
    LiveEntrance,                       // 直播入口 14
    LiveContent,                        // 直播内容 15
    Finding,                            // 发现    16
    FMEntrance,                         // FM入口  17
    FMContent,                          // FM内容  18
    PsychologyTestEntrance,             // 心理测试入口 19
    PsychologyTestContent,              // 心理测试内容 20
    SocialZoneEntrance,                 // 社区入口    21
    SocialZoneContent,                  // 社区内容    22
    VolunteerReport,                    // 志愿者报告  23
    NewsContent,                        // 志愿填报咨询内容  24
    //生涯规划
    CareerHomeBanner,                   // 志愿规划-首页banner    25
    CareerHomeTest,                     // 生涯规划-首页心理测评   26
    CareerHomeVolunteer,                // 生涯规划-首页志愿填报   27
    CareerHomeXuanke,                   // 生涯规划-首页选课系统   28
    CareerHomeCollegeLibra,             // 生涯规划-首页院校库    29
    CareerHomeMajorLibra,               // 生涯规划-首页专业库    30
    CareerHomeProfessionLibra,          // 生涯规划-首页职业库    31
    CareerHome3DSchoole,                // 生涯规划-首页3D地图    32
    CareerHomeCareerCourse,             // 生涯规划-首页生涯课程   33
    CareerHomeCareerNews,               // 生涯规划-首页生涯资讯   34
    CareerHomeSuccessCases,             // 生涯规划-首页成功案例   35
    CareerHomeMyCareer,                 // 生涯规划-首页我的生涯   36
    
    //E讲堂
    EClass_Supremacy,                   //至尊专区   37
    
    // FM
    FMHomeBanner,                       //FM首页Banner     38
    FMHomeListen,                       //FM首页听FM       39
    FMHomeDoTest,                       //FM首页做测试      40
    FMHomeReadingNewspaper,             //FM首页读板报       41
    FMHomeAskQuestions,                 //FM首页问问题       42
    FMHomePlayDetail,                   //FM首页点击进入播放详情 43
    
    //个人中心
    PersonalInfo,                       // 个人资料    44
    OnlineBuyCard,                      // 在线购卡    45
    HomeWork,                           // 作业       46
    Attention,                          // 关注       47
    Setting,                            // 设置       48
    MyScore,                            // 我的学分    49
    MyLivings,                          // 我的直播    50
    HelpAndFeedback,                   // 帮助与反馈   51
    OpenPermission                     // 首页开通会员  52
} KEntranceType;





#endif /* EWTModuleType_h */

