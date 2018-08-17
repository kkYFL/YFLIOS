//
//  EWTMyDownloadManagerHeader.h
//  EWTBase
//
//  Created by MengLingChao on 2018/7/4.
//  Copyright © 2018年 Huangbaoyang. All rights reserved.
//

#ifndef EWTMyDownloadManagerHeader_h
#define EWTMyDownloadManagerHeader_h

/**视频下载状态*/
typedef NS_ENUM(NSInteger, EWTVideoDownloadStatus) {
    EWTVideoDownloadStatusNotStart = 0,//未开始
    EWTVideoDownloadStatusDownloading = 1,//下载中
    EWTVideoDownloadStatusPaused = 2,//暂停
    EWTVideoDownloadStatusDone = 3,//下载完成
    EWTVideoDownloadStatusFail = 4,//下载失败
    EWTVideoDownloadStatusWaiting = 5,//等待中
};

//下载中
#define EWTMyDownloadManagerWriteDataNotification @"EWTMyDownloadManagerWriteDataNotification"
//
#define EWTMyDownloadManagerFinishNotification @"EWTMyDownloadManagerFinishNotification"
//
#define EWTMyDownloadManagerCompletionNotification @"EWTMyDownloadManagerCompletionNotification"
//
#define EWTMyDownloadUpdateDownloadModelNotification @"EWTMyDownloadUpdateDownloadModelNotification"
////
//#define EWTMyDownloadTableViewNeedBeginUpdatesNotification @"EWTMyDownloadTableViewNeedBeginUpdatesNotification"
////
//#define EWTMyDownloadTableViewNeedEndUpdatesNotification @"EWTMyDownloadTableViewNeedEndUpdatesNotification"
//
#define EWTMyDownloadTableViewNeedReloadDataNotification @"EWTMyDownloadTableViewNeedReloadDataNotification"

#endif /* EWTMyDownloadManagerHeader_h */
