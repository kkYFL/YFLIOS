//
//  DatabaseEngine.m
//  Ewt360
//
//  Created by ZengQingNian on 15/8/17.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//




#import "DatabaseEngine.h"
#import "PackageModel.h"
#import "VideoDownloadListModel.h"
#import "TopicModel.h"
#import "TopicOptionModel.h"
#import "TopicInfoModel.h"
#import "FunctionUseModel.h"



#define DB_NAME                              @"ewt.sqlite"

static NSString* TABLE_NAME_VIDEO_DOWNLOAD = nil;
static NSString* TABLE_NAME_VIDEO_DOWNLOAD_TMP = nil;
static NSString* TABLE_NAME_VIDEO_PACKAGE = nil;
static NSString* TABLE_NAME_TOPIC = nil;
static NSString* TABLE_NAME_TOPIC_INFO = nil;
static NSString* TABLE_NAME_TOPIC_OPTION = nil;
static NSString* TABLE_NAME_FUNCTION_USE = nil;


@implementation DatabaseEngine

+ (DatabaseEngine *)sharedEngine
{
    static DatabaseEngine *engine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        engine = [[DatabaseEngine alloc] init];
    });
    
    return engine;
}

- (id)init
{
    self = [super init];
    if (self) {
        //
        fmdbQueue = [FMDatabaseQueue databaseQueueWithPath:[self databasePath]];
    }
    
    return self;
}

- (NSString *)databasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    //NSLog(@"数据路径: %@", dbPath);
    return dbPath;
}


- (void)createAllTableByIdentifier:(NSString *)userId
{
    TABLE_NAME_VIDEO_DOWNLOAD = [NSString stringWithFormat:@"%@_%@",@"video_download",userId];
    TABLE_NAME_VIDEO_DOWNLOAD_TMP = [NSString stringWithFormat:@"%@_%@_tmp",@"video_download",userId];
    TABLE_NAME_VIDEO_PACKAGE = [NSString stringWithFormat:@"%@_%@",@"video_package",userId];
    TABLE_NAME_TOPIC = [NSString stringWithFormat:@"%@_%@",@"topic",userId];
    TABLE_NAME_TOPIC_INFO = [NSString stringWithFormat:@"%@_%@",@"topicInfo",userId];
    TABLE_NAME_TOPIC_OPTION = [NSString stringWithFormat:@"%@_%@",@"topicOption",userId];
    TABLE_NAME_FUNCTION_USE = [NSString stringWithFormat:@"%@_%@",@"FunctionUse",userId];
    
    [self createVideoDownloadTable];
    [self createVideoPackageTable];
    [self createTopicTable];
    [self createTopicInfoTable];
    [self createTopicOptionTable];
    [self createFunctionUseTable];
}

#pragma mark - Actions
// 判断表是否存在
- (BOOL)isExistsTable:(NSString *)tableName
{
    __block BOOL bl = NO;
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) AS 'count' FROM sqlite_master WHERE type ='table' AND name = '%@'", tableName];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            int count = [rs intForColumn:@"count"];
            if (count == 0) {
                bl = NO;
            } else {
                bl = YES;
            }
        }
    }];
    
    return bl;
}




#pragma mark - 视频表
- (void)createVideoDownloadTable
{
    /*!
     *  @param download_status              下载状态（0 未开始。1 下载。2 暂停。3 下载完成。4 下载失败。5 等待中。）
     *  @param download_progress            进度条进度（0.0 ~ 1）
     *  @param download_percentage          进度百分比
     *  @param total_size                   文件总大小
     *  @param current_download_size        当前下载大小
     *  @param show_plat                    播放器选择(0、1自建;2当红)
     *  @param video_id_string
     *  @param live_barrage_download_url    直播弹幕下载地址
     *  @param live_barrage_local_path      直播弹幕本地地址
     *  @param key1                         密匙
     *  @param key2                         密匙
     */
    
    BOOL bl = [self isExistsTable:TABLE_NAME_VIDEO_DOWNLOAD];
    if (bl) {
        //
        [fmdbQueue inDatabase:^(FMDatabase *db) {
            /***** ***** ***** ***** 新增字段 ***** ***** ***** *****/
            // add show_plat
            if (![db columnExists:@"show_plat" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]) {
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_VIDEO_DOWNLOAD,@"show_plat"];
                [db executeUpdate:alertStr];
            }
            // add video_id_string
            if (![db columnExists:@"video_id_string" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]) {
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_VIDEO_DOWNLOAD,@"video_id_string"];
                [db executeUpdate:alertStr];
            }
            // add live_barrage_download_url
            if (![db columnExists:@"live_barrage_download_url" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]) {
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_VIDEO_DOWNLOAD,@"live_barrage_download_url"];
                [db executeUpdate:alertStr];
            }
            // add live_barrage_local_path
            if (![db columnExists:@"live_barrage_local_path" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]) {
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_VIDEO_DOWNLOAD,@"live_barrage_local_path"];
                [db executeUpdate:alertStr];
            }
            // add key1
            if (![db columnExists:@"key1" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]) {
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_VIDEO_DOWNLOAD,@"key1"];
                [db executeUpdate:alertStr];
            }
            // add key2
            if (![db columnExists:@"key2" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]) {
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_VIDEO_DOWNLOAD,@"key2"];
                [db executeUpdate:alertStr];
            }
            
            // add newfm_entertype
            if (![db columnExists:@"video_entertype" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]){
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ VARCHAR(5)",TABLE_NAME_VIDEO_DOWNLOAD,@"video_entertype"];
                [db executeUpdate:alertStr];
            }
            // add newfm_columnId
            if (![db columnExists:@"video_columnId" inTableWithName:TABLE_NAME_VIDEO_DOWNLOAD]){
                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ VARCHAR(5)",TABLE_NAME_VIDEO_DOWNLOAD,@"video_columnId"];
                [db executeUpdate:alertStr];
            }
            
            
            /***** ***** ***** ***** 修改表主键 ***** ***** ***** *****/
            [db beginTransaction];
            // create tmp table
            NSString *sql = [NSString stringWithFormat:@"CREATE TEMPORARY TABLE '%@' ('package_id' VARCHAR(5), 'package_type' VARCHAR(10), 'package_title' VARCHAR(20), 'video_id' VARCHAR(5), 'video_number' VARCHAR(20), 'video_title' VARCHAR(50), 'download_status' VARCHAR(5), 'download_url' VARCHAR(40), 'download_progress' VARCHAR(5), 'resumeable_path' VARCHAR(40), 'local_path' VARCHAR(40), download_percentage VARCHAR(5),total_size VARCHAR(5), current_download_size VARCHAR(5),'show_plat' VARCHAR(5),'video_id_string' VARCHAR(40),live_barrage_download_url VARCHAR(40),live_barrage_local_path VARCHAR(40), key1 VARCHAR(10), key2 VARCHAR(10), 'video_entertype' VARCHAR(5),'video_columnId' VARCHAR(5), PRIMARY KEY(package_id,video_id))", TABLE_NAME_VIDEO_DOWNLOAD_TMP];
            BOOL result = [db executeUpdate:sql];
            if (result) {
                //NSLog(@"创建表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD_TMP);
            } else {
                //NSLog(@"创建表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD_TMP);
            }
            
            // insert into tmp table
            sql = [NSString stringWithFormat:@"INSERT INTO '%@' SELECT * FROM '%@'",TABLE_NAME_VIDEO_DOWNLOAD_TMP, TABLE_NAME_VIDEO_DOWNLOAD];
            result = [db executeUpdate:sql];
            if (result) {
                //NSLog(@"插入表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD_TMP);
            } else {
                //NSLog(@"插入表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD_TMP);
            }
            
            // drop
            sql = [NSString stringWithFormat:@"DROP TABLE '%@'",TABLE_NAME_VIDEO_DOWNLOAD];
            result = [db executeUpdate:sql];
            if (result) {
                //NSLog(@"删除 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
            } else {
                //NSLog(@"删除 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
            }
            
            // create video table
            sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('package_id' VARCHAR(5), 'package_type' VARCHAR(10), 'package_title' VARCHAR(20), 'video_id' VARCHAR(5), 'video_number' VARCHAR(20), 'video_title' VARCHAR(50), 'download_status' VARCHAR(5), 'download_url' VARCHAR(40), 'download_progress' VARCHAR(5), 'resumeable_path' VARCHAR(40), 'local_path' VARCHAR(40), download_percentage VARCHAR(5),total_size VARCHAR(5), current_download_size VARCHAR(5),'show_plat' VARCHAR(5),'video_id_string' VARCHAR(40),live_barrage_download_url VARCHAR(40),live_barrage_local_path VARCHAR(40), key1 VARCHAR(10), key2 VARCHAR(10), 'video_entertype' VARCHAR(5),'video_columnId' VARCHAR(5), PRIMARY KEY(video_id,package_id))", TABLE_NAME_VIDEO_DOWNLOAD];
            
            result = [db executeUpdate:sql];
            if (result) {
                //NSLog(@"创建表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
            } else {
                //NSLog(@"创建表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
            }
            
            // insert
            sql = [NSString stringWithFormat:@"INSERT INTO '%@' SELECT * FROM '%@'",TABLE_NAME_VIDEO_DOWNLOAD, TABLE_NAME_VIDEO_DOWNLOAD_TMP];
            result = [db executeUpdate:sql];
            if (result) {
                //NSLog(@"插入表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
            } else {
                //NSLog(@"插入表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
            }
            
            // drop tmp table
            sql = [NSString stringWithFormat:@"DROP TABLE '%@'",TABLE_NAME_VIDEO_DOWNLOAD_TMP];
            result = [db executeUpdate:sql];
            if (result) {
                //NSLog(@"删除 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD_TMP);
            } else {
                //NSLog(@"删除 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD_TMP);
            }
            
            //
            [db commit];
        }];
    } else {
        //
        [fmdbQueue inDatabase:^(FMDatabase *db) {
            //
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('package_id' VARCHAR(5), 'package_type' VARCHAR(10), 'package_title' VARCHAR(20), 'video_id' VARCHAR(5), 'video_number' VARCHAR(20), 'video_title' VARCHAR(50), 'download_status' VARCHAR(5), 'download_url' VARCHAR(40), 'download_progress' VARCHAR(5), 'resumeable_path' VARCHAR(40), 'local_path' VARCHAR(40), download_percentage VARCHAR(5),total_size VARCHAR(5), current_download_size VARCHAR(5),'show_plat' VARCHAR(5),'video_id_string' VARCHAR(40),live_barrage_download_url VARCHAR(40),live_barrage_local_path VARCHAR(40), key1 VARCHAR(10), key2 VARCHAR(10), 'video_entertype' VARCHAR(5),'video_columnId' VARCHAR(5), PRIMARY KEY(video_id,package_id))", TABLE_NAME_VIDEO_DOWNLOAD];
            
            BOOL result = [db executeUpdate:sql];
            if (result) {
                //NSLog(@"创建表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
            } else {
                //NSLog(@"创建表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
            }
        }];
    }
}


- (void)insertIntoVideoDownloadTableWithPackage_id:(NSString *)package_id
                                      package_type:(NSString *)package_type
                                     package_title:(NSString *)package_title
                                          video_id:(NSString *)video_id
                                      video_number:(NSString *)video_number
                                       video_title:(NSString *)video_title
                                   download_status:(NSString *)download_status
                                      download_url:(NSString *)download_url
                                 download_progress:(NSString *)download_progress
                                         show_plat:(NSString *)show_plat
                                   video_id_string:(NSString *)video_id_string
                                              key1:(NSString *)key1
                                              key2:(NSString *)key2
                                        totalBytes:(NSString *)totalBytes
                               download_percentage:(NSString *)download_percentage
                                 totalBytesWritten:(NSString *)totalBytesWritten
                                   video_entertype:(NSString *)video_entertype
                                    video_columnId:(NSString *)video_columnId
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {

        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@(package_id,package_type,package_title,video_id,video_number,video_title,download_status,download_url,download_progress,show_plat,video_id_string,key1,key2,total_size,download_percentage,current_download_size,video_entertype,video_columnId) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",TABLE_NAME_VIDEO_DOWNLOAD];
        
        BOOL result = [db executeUpdate:sql,package_id,package_type,package_title,video_id,video_number,video_title,download_status,download_url,download_progress,show_plat,video_id_string,key1,key2,totalBytes,download_percentage,totalBytesWritten,video_entertype,video_columnId];
        if (result) {
            NSLog(@"插入表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            NSLog(@"插入表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}



- (void)updateVideoDownloadTableWithResumeable_path:(NSString *)resumeable_path
                                           video_id:(NSString *)video_id
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET resumeable_path='%@' WHERE video_id='%@'",TABLE_NAME_VIDEO_DOWNLOAD,resumeable_path,video_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。-保存可恢复数据路径",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}


- (void)updateVideoWithDownload_progress:(NSString *)download_progress
                     download_percentage:(NSString *)download_percentage
                              total_size:(NSString *)total_size
                   current_download_size:(NSString *)current_download_size
                         download_status:(NSString *)download_status
                                video_id:(NSString *)video_id
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET download_progress='%@', download_percentage='%@', total_size='%@', current_download_size='%@', download_status='%@' WHERE video_id='%@'",TABLE_NAME_VIDEO_DOWNLOAD,download_progress,download_percentage,total_size,current_download_size,download_status,video_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}


- (void)updateVideoWithDownload_status:(NSString *)download_status
                            local_path:(NSString *)local_path
                            total_size:(NSString *)total_size
                              video_id:(NSString *)video_id
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET download_status='%@', local_path='%@', total_size='%@' WHERE video_id='%@'",TABLE_NAME_VIDEO_DOWNLOAD,download_status,local_path,total_size,video_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}

- (void)updateVideoDownloadStatus:(NSString *)download_status video_id:(NSString *)video_id
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET download_status='%@' WHERE video_id='%@'",TABLE_NAME_VIDEO_DOWNLOAD,download_status,video_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。-更新下载状态",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}

- (void)updateVideoDownloadStatusTo:(NSString *)download_status from:(NSString *)status
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET download_status='%@' WHERE download_status='%@'",TABLE_NAME_VIDEO_DOWNLOAD,download_status,status];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。-更新下载状态（启动）",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}

- (void)updateLiveBarrageLocalPathWithLiveId:(NSString *)liveId path:(NSString *)path
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET live_barrage_local_path='%@' WHERE video_id='%@'",TABLE_NAME_VIDEO_DOWNLOAD,path,liveId];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。-更新下载状态（启动）",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}


- (NSMutableArray *)selectAllVideo
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_NAME_VIDEO_DOWNLOAD];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.showPlat = [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}


- (NSString *)selectResumeablePathFromVideoDownloadTableWithVideo_id:(NSString *)video_id
{
    __block NSString *returnStr = @"";
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE video_id = '%@'",TABLE_NAME_VIDEO_DOWNLOAD,video_id];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            returnStr = [result stringForColumn:@"resumeable_path"];
        }
        [result close];
    }];
    
    return returnStr;
}
- (NSMutableArray *)selectNoDownloadVideoWithPackage_id:(NSString *)package_id {
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE package_id = '%@' AND download_status != '%@'",TABLE_NAME_VIDEO_DOWNLOAD,package_id,@"3"];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}

- (NSMutableArray *)selectDownloadingVideoWithDownload_status:(NSString *)download_status
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE download_status != '%@' ORDER BY video_id ASC",TABLE_NAME_VIDEO_DOWNLOAD,download_status];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}

- (NSMutableArray *)selectVideoWithStatus:(NSString *)download_status
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE download_status = '%@' ORDER BY video_id ASC",TABLE_NAME_VIDEO_DOWNLOAD,download_status];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}

- (NSMutableArray *)selectDownloadingVideoWithDownload_status:(NSString *)download_status
                                                   package_id:(NSString *)package_id
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE download_status != '%@' AND package_id='%@' ORDER BY video_id ASC",TABLE_NAME_VIDEO_DOWNLOAD,download_status,package_id];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}


- (NSMutableArray *)selectVideoWithVideo_id:(NSString *)video_id
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE video_id = '%@'",TABLE_NAME_VIDEO_DOWNLOAD,video_id];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.localPath = [result stringForColumn:@"local_path"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}

- (NSMutableArray *)selectVideoWithVideo_Id:(NSString *)video_Id package_Id:(NSString *)package_Id
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE video_id = '%@' AND package_id='%@'",TABLE_NAME_VIDEO_DOWNLOAD,video_Id, package_Id];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.localPath = [result stringForColumn:@"local_path"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}


- (NSMutableArray *)selectVideoWithVideo_id:(NSString *)video_id
                            download_status:(NSString *)download_status
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE video_id = '%@' AND download_status='%@'",TABLE_NAME_VIDEO_DOWNLOAD,video_id,download_status];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.localPath = [result stringForColumn:@"local_path"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray;
}







- (NSMutableArray *)selectVideoDownloadTableWithPackage_id:(NSString *)package_id
                                           download_status:(NSString *)download_status
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE package_id = '%@' AND download_status='%@'",TABLE_NAME_VIDEO_DOWNLOAD,package_id,download_status];

        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            VideoDownloadListModel *vdlm = [[VideoDownloadListModel alloc] init];
            vdlm.videoID = [result stringForColumn:@"video_id"];
            vdlm.videoIdString = [result stringForColumn:@"video_id_string"];
            vdlm.number = [result stringForColumn:@"video_number"];
            vdlm.title = [result stringForColumn:@"video_title"];
            vdlm.downloadURL = [result stringForColumn:@"download_url"];
            vdlm.downloadStatus = [result stringForColumn:@"download_status"];
            vdlm.downloadProgress = [result stringForColumn:@"download_progress"];
            vdlm.downloadPercentage = [result stringForColumn:@"download_percentage"];
            vdlm.totalSize = [result stringForColumn:@"total_size"];
            vdlm.currentDownloadSize = [result stringForColumn:@"current_download_size"];
            vdlm.packageID = [result stringForColumn:@"package_id"];
            vdlm.packageType = [result stringForColumn:@"package_type"];
            vdlm.localPath = [result stringForColumn:@"local_path"];
            vdlm.showPlat= [result stringForColumn:@"show_plat"];
            vdlm.liveBarrageDownloadURL = [result stringForColumn:@"live_barrage_download_url"];
            vdlm.liveBarrageLocalPath   = [result stringForColumn:@"live_barrage_local_path"];
            vdlm.key1   = [result stringForColumn:@"key1"];
            vdlm.key2   = [result stringForColumn:@"key2"];
            vdlm.enterType = [result stringForColumn:@"video_entertype"];
            vdlm.columnId = [result stringForColumn:@"video_columnId"];
            
            [returnArray addObject:vdlm];
        }
        [result close];
    }];
    return returnArray.copy;
}

- (void)deleteVideoWithVideo_id:(NSString *)video_id
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE video_id='%@'",TABLE_NAME_VIDEO_DOWNLOAD,video_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"删表 %@ 成功。",TABLE_NAME_VIDEO_DOWNLOAD);
        } else {
            //NSLog(@"删表 %@ 失败。",TABLE_NAME_VIDEO_DOWNLOAD);
        }
    }];
}










#pragma mark - 视频包表
- (void)createVideoPackageTable
{
    /*!
     *  @param
     *  @param
     */
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (package_id VARCHAR(5) PRIMARY KEY, package_type VARCHAR(10), package_title VARCHAR(20), image_url VARCHAR(20), grade VARCHAR(10))", TABLE_NAME_VIDEO_PACKAGE];
        
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"创建表 %@ 成功。",TABLE_NAME_VIDEO_PACKAGE);
        } else {
            //NSLog(@"创建表 %@ 失败。",TABLE_NAME_VIDEO_PACKAGE);
        }
    }];
}

- (void)insertIntoVideoPackageTableWithPackage_id:(NSString *)package_id
                                     package_type:(NSString *)package_type
                                    package_title:(NSString *)package_title
                                        image_url:(NSString *)image_url
                                            grade:(NSString *)grade
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@(package_id,package_type,package_title,image_url,grade) VALUES(?,?,?,?,?)",TABLE_NAME_VIDEO_PACKAGE];
        
        BOOL result = [db executeUpdate:sql,package_id,package_type,package_title,image_url,grade];
        if (result) {
            //NSLog(@"插入表 %@ 成功。",TABLE_NAME_VIDEO_PACKAGE);
        } else {
            //NSLog(@"插入表 %@ 失败。",TABLE_NAME_VIDEO_PACKAGE);
        }
    }];
}
- (NSMutableArray *)selectVideoPackageTable {
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY package_id ASC",TABLE_NAME_VIDEO_PACKAGE];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            PackageModel *pm = [[PackageModel alloc] init];
            pm.packageID     = [result stringForColumn:@"package_id"];
            pm.type          = [result stringForColumn:@"package_type"];
            pm.title         = [result stringForColumn:@"package_title"];
            pm.imageURL      = [result stringForColumn:@"image_url"];
            pm.grade         = [result stringForColumn:@"grade"];
            [returnArray addObject:pm];
        }
        [result close];
    }];
    return returnArray;
}
#pragma mark - 选择题-题目
- (void)createTopicTable {
    /*!
     *  @param topic_id                 题目ID
     *  @param topic_title              题目标题
     *  @param part                     第几部分（3:第一部分 4:第二部分 1:第三部分）
     *  @param exam_before_answer       考前测评答案（A、B、C、D）
     *  @param exam_after_answer        考后测评答案（A、B、C、D）
     */
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (topic_id VARCHAR(5) PRIMARY KEY, topic_title VARCHAR(10), part CHAR(4), exam_before_answer CHAR(4), exam_after_answer CHAR(4))", TABLE_NAME_TOPIC];
        
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"创建表 %@ 成功。",TABLE_NAME_TOPIC);
        } else {
            //NSLog(@"创建表 %@ 失败。",TABLE_NAME_TOPIC);
        }
    }];
}

- (void)insertIntoTopicTableWithTopic_id:(NSString *)topic_id
                             topic_title:(NSString *)topic_title
                                    part:(NSString *)part
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@(topic_id,topic_title,part) VALUES(?,?,?)",TABLE_NAME_TOPIC];
        
        BOOL result = [db executeUpdate:sql,topic_id,topic_title,part];
        if (result) {
            //NSLog(@"插入表 %@ 成功。",TABLE_NAME_TOPIC);
        } else {
           // NSLog(@"插入表 %@ 失败。",TABLE_NAME_TOPIC);
        }
    }];
}


- (NSMutableArray *)selectAllTopic
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_NAME_TOPIC];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            TopicModel *tm = [[TopicModel alloc] init];
            tm.topicID      = [result stringForColumn:@"topic_id"];
            tm.topicTitle   = [result stringForColumn:@"topic_title"];
            tm.part         = [result stringForColumn:@"part"];
            tm.examBeforeAnswer       = [result stringForColumn:@"exam_before_answer"];
            tm.examAfterAnswer        = [result stringForColumn:@"exam_after_answer"];
            [returnArray addObject:tm];
        }
        [result close];
    }];
    return returnArray;
}

- (NSMutableArray *)selectTopicWithRow:(int)row
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ limit 1 offset '%d'",TABLE_NAME_TOPIC,row];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            TopicModel *tm = [[TopicModel alloc] init];
            tm.topicID      = [result stringForColumn:@"topic_id"];
            tm.topicTitle   = [result stringForColumn:@"topic_title"];
            tm.part         = [result stringForColumn:@"part"];
            tm.examBeforeAnswer       = [result stringForColumn:@"exam_before_answer"];
            tm.examAfterAnswer        = [result stringForColumn:@"exam_after_answer"];
            [returnArray addObject:tm];
        }
        [result close];
    }];
    return returnArray;
}

- (void)updateTopicWithTopic_id:(NSString *)topic_id answerType:(NSString *)answerType answer:(NSString *)answer
{
    /*!
     *  @param answerType 答案类型（1:考前答案。2:考后答案）
     */
    NSString *str = @"";
    if ([answerType isEqualToString:@"1"]) {
        str = @"exam_before_answer";
    } else if ([answerType isEqualToString:@"2"]) {
        str = @"exam_after_answer";
    } else {
        
    }
    
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET '%@'='%@' WHERE topic_id='%@'",TABLE_NAME_TOPIC,str,answer,topic_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。",TABLE_NAME_TOPIC);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_TOPIC);
        }
    }];
}

- (void)updateTopicWithTopic_id:(NSString *)topic_id examBeforeAnswer:(NSString *)answer
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET exam_before_answer ='%@' WHERE topic_id='%@'",TABLE_NAME_TOPIC,answer,topic_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。",TABLE_NAME_TOPIC);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_TOPIC);
        }
    }];
}

- (void)updateTopicWithTopic_id:(NSString *)topic_id examAfterAnswer:(NSString *)answer
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET exam_after_answer ='%@' WHERE topic_id='%@'",TABLE_NAME_TOPIC,answer,topic_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
           // NSLog(@"修改表 %@ 成功。",TABLE_NAME_TOPIC);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_TOPIC);
        }
    }];
}


//- (void)updateTopicWithTopic_id:(NSString *)topic_id currentRow:(NSString *)row
//{
//    [fmdbQueue inDatabase:^(FMDatabase *db) {
//        //
//        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET current_row ='%@' WHERE topic_id='%@'",TABLE_NAME_TOPIC,row,topic_id];
//        BOOL result = [db executeUpdate:sql];
//        if (result) {
//            NSLog(@"修改表 %@ 成功。",TABLE_NAME_TOPIC);
//        } else {
//            NSLog(@"修改表 %@ 失败。",TABLE_NAME_TOPIC);
//        }
//    }];
//}
//
//- (void)updateTopicWithTopic_id:(NSString *)topic_id report_id:(NSString *)report_id
//{
//    [fmdbQueue inDatabase:^(FMDatabase *db) {
//        //
//        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET report_id ='%@' WHERE topic_id='%@'",TABLE_NAME_TOPIC,report_id,topic_id];
//        BOOL result = [db executeUpdate:sql];
//        if (result) {
//            NSLog(@"修改表 %@ 成功。",TABLE_NAME_TOPIC);
//        } else {
//            NSLog(@"修改表 %@ 失败。",TABLE_NAME_TOPIC);
//        }
//    }];
//}





#pragma mark - 题目信息表
- (void)createTopicInfoTable
{
    /*!
     *  @param exam_type_id     题目类型（1:考前题目。2考后题目）
     *  @param current_row      当前做到第几题
     *  @param report_id        报告ID
     */
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (exam_type_id VARCHAR(5) PRIMARY KEY, current_row VARCHAR(5), report_id VARCHAR(5))", TABLE_NAME_TOPIC_INFO];
        
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"创建表 %@ 成功。",TABLE_NAME_TOPIC_INFO);
        } else {
           // NSLog(@"创建表 %@ 失败。",TABLE_NAME_TOPIC_INFO);
        }
    }];
}


- (void)insertIntoTopicInfoTableWithExamTypeID:(NSString *)exam_type_id
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@(exam_type_id) VALUES(?)",TABLE_NAME_TOPIC_INFO];
        
        BOOL result = [db executeUpdate:sql,exam_type_id];
        if (result) {
           // NSLog(@"插入表 %@ 成功。",TABLE_NAME_TOPIC_INFO);
        } else {
           // NSLog(@"插入表 %@ 失败。",TABLE_NAME_TOPIC_INFO);
        }
    }];
}

- (NSMutableArray *)selectTopicInfo
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_NAME_TOPIC_INFO];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            TopicInfoModel *tim = [[TopicInfoModel alloc] init];
            tim.currentRow = [result stringForColumn:@"current_row"];
            tim.reportID = [result stringForColumn:@"report_id"];
            [returnArray addObject:tim];
        }
        [result close];
    }];
    return returnArray;
}

- (NSMutableArray *)selectTopicInfoWithExamTypeID:(NSString *)exam_type_id
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE exam_type_id = '%@'",TABLE_NAME_TOPIC_INFO,exam_type_id];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            TopicInfoModel *tim = [[TopicInfoModel alloc] init];
            tim.currentRow = [result stringForColumn:@"current_row"];
            tim.reportID = [result stringForColumn:@"report_id"];
            [returnArray addObject:tim];
        }
        
        [result close];
    }];
    return returnArray;
}

- (void)updateTopicInfoWithWithExamTypeID:(NSString *)exam_type_id currentRow:(NSString *)row
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET current_row ='%@' WHERE exam_type_id='%@'",TABLE_NAME_TOPIC_INFO,row,exam_type_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"修改表 %@ 成功。",TABLE_NAME_TOPIC_INFO);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_TOPIC_INFO);
        }
    }];
}

- (void)updateTopicInfoWithWithExamTypeID:(NSString *)exam_type_id report_id:(NSString *)report_id
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET report_id ='%@' WHERE exam_type_id='%@'",TABLE_NAME_TOPIC_INFO,report_id,exam_type_id];
        BOOL result = [db executeUpdate:sql];
        if (result) {
           // NSLog(@"修改表 %@ 成功。",TABLE_NAME_TOPIC_INFO);
        } else {
            //NSLog(@"修改表 %@ 失败。",TABLE_NAME_TOPIC_INFO);
        }
    }];
}


#pragma mark - 选择题-选项
- (void)createTopicOptionTable
{
    /*!
     *  @param
     *  @param
     */
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (topic_id VARCHAR(5), option VARCHAR(20))", TABLE_NAME_TOPIC_OPTION];
        
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"创建表 %@ 成功。",TABLE_NAME_TOPIC_OPTION);
        } else {
           // NSLog(@"创建表 %@ 失败。",TABLE_NAME_TOPIC_OPTION);
        }
    }];
}

- (void)insertIntoTopicOptionTableWithTopic_id:(NSString *)topic_id
                                        option:(NSString *)option
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@(topic_id,option) VALUES(?,?)",TABLE_NAME_TOPIC_OPTION];
        
        BOOL result = [db executeUpdate:sql,topic_id,option];
        if (result) {
           // NSLog(@"插入表 %@ 成功。",TABLE_NAME_TOPIC_OPTION);
        } else {
           // NSLog(@"插入表 %@ 失败。",TABLE_NAME_TOPIC_OPTION);
        }
    }];
}


- (NSMutableArray *)selectTopicOptionWithTopic_id:(NSString *)topic_id
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE topic_id = '%@'",TABLE_NAME_TOPIC_OPTION,topic_id];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            TopicOptionModel *tom = [[TopicOptionModel alloc] init];
            tom.topicID = [result stringForColumn:@"topic_id"];
            tom.option = [result stringForColumn:@"option"];
            [returnArray addObject:tom];
        }
        [result close];
    }];
    return returnArray;
}



- (NSMutableArray *)selectTopicWithPart:(NSString *)part
{



    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE part = '%@'",TABLE_NAME_TOPIC,part];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            TopicModel *tm = [[TopicModel alloc] init];
            tm.topicID      = [result stringForColumn:@"topic_id"];
            tm.topicTitle   = [result stringForColumn:@"topic_title"];
            tm.part         = [result stringForColumn:@"part"];
            tm.examBeforeAnswer       = [result stringForColumn:@"exam_before_answer"];
            tm.examAfterAnswer        = [result stringForColumn:@"exam_after_answer"];
            [returnArray addObject:tm];
        }
        
        
        [result close];
    }];
    return returnArray;

}





#pragma mark - 功能使用表
- (void)createFunctionUseTable
{
    /*!
     *  @param
     *  @param
     *  @param
     */
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        // AUTOINCREMENT
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' (id INTEGER PRIMARY KEY AUTOINCREMENT,event_id VARCHAR(5), event_name VARCHAR(20), event_type VARCHAR(20), current_activity VARCHAR(40), from_activity VARCHAR(40), stay_time VARCHAR(10), timestamp VARCHAR(15), network_type VARCHAR(10), click_event_id VARCHAR(10), extension VARCHAR(20))", TABLE_NAME_FUNCTION_USE];
        
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"创建表 %@ 成功。",TABLE_NAME_FUNCTION_USE);
        } else {
            //NSLog(@"创建表 %@ 失败。",TABLE_NAME_FUNCTION_USE);
        }
        
        // add click event id
        if (![db columnExists:@"click_event_id" inTableWithName:TABLE_NAME_FUNCTION_USE]) {
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_FUNCTION_USE,@"click_event_id"];
            [db executeUpdate:alertStr];
        }
        
        // add extension column
        if (![db columnExists:@"extension" inTableWithName:TABLE_NAME_FUNCTION_USE]) {
            NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ INTEGER",TABLE_NAME_FUNCTION_USE,@"extension"];
            [db executeUpdate:alertStr];
        }
        
    }];
}

- (void)insertIntoFunctionUseTableWithEvent_id:(NSString *)event_id
                                    event_name:(NSString *)event_name
                                    event_type:(NSString *)event_type
                              current_activity:(NSString *)current_activity
                                 from_activity:(NSString *)from_activity
                                     stay_time:(NSString *)stay_time
                                     timestamp:(NSString *)timestamp
                                  network_type:(NSString *)network_type
                                click_event_id:(NSString *)click_event_id
                                     extension:(NSString *)extension
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@(event_id,event_name,event_type,current_activity,from_activity,stay_time,timestamp,network_type,click_event_id,extension)VALUES(?,?,?,?,?,?,?,?,?,?)",TABLE_NAME_FUNCTION_USE];
        
        BOOL result = [db executeUpdate:sql,event_id,event_name,event_type,current_activity,from_activity,stay_time,timestamp,network_type,click_event_id,extension];
        if (result) {
            //NSLog(@"插入表 %@ 成功。",TABLE_NAME_FUNCTION_USE);
        } else {
            //NSLog(@"插入表 %@ 失败。",TABLE_NAME_FUNCTION_USE);
        }
    }];
}

- (NSMutableArray *)selectFunctionUse
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_NAME_FUNCTION_USE];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            FunctionUseModel *fum = [[FunctionUseModel alloc] init];
            fum.event_id         = [result stringForColumn:@"event_id"];
            fum.event_name       = [result stringForColumn:@"event_name"];
            fum.event_type       = [result stringForColumn:@"event_type"];
            fum.current_activity = [result stringForColumn:@"current_activity"];
            fum.from_activity    = [result stringForColumn:@"from_activity"];
            fum.stay_time        = [result stringForColumn:@"stay_time"];
            fum.timestamp        = [result stringForColumn:@"timestamp"];
            fum.network_type     = [result stringForColumn:@"network_type"];
            fum.click_event_id   = [result stringForColumn:@"click_event_id"];
            fum.extension        = [result stringForColumn:@"extension"];
            [returnArray addObject:fum];
        }
        [result close];
    }];
    return returnArray;
}

- (NSMutableArray *)selectLastRecordFromFunctionUse
{
    NSMutableArray *returnArray = [NSMutableArray array];
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY id DESC LIMIT 0,1",TABLE_NAME_FUNCTION_USE];
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            FunctionUseModel *fum = [[FunctionUseModel alloc] init];
            fum.event_id         = [result stringForColumn:@"event_id"];
            fum.event_name       = [result stringForColumn:@"event_name"];
            fum.event_type       = [result stringForColumn:@"event_type"];
            fum.current_activity = [result stringForColumn:@"current_activity"];
            fum.from_activity    = [result stringForColumn:@"from_activity"];
            fum.stay_time        = [result stringForColumn:@"stay_time"];
            fum.timestamp        = [result stringForColumn:@"timestamp"];
            fum.network_type     = [result stringForColumn:@"network_type"];
            fum.click_event_id   = [result stringForColumn:@"click_event_id"];
            fum.extension        = [result stringForColumn:@"extension"];
            [returnArray addObject:fum];
        }
        [result close];
    }];
    return returnArray;
}

- (void)deleteFunctionUseWithRow:(int)row
{
    [fmdbQueue inDatabase:^(FMDatabase *db) {
        //NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ LIMIT '%d' OFFSET '0'",TABLE_NAME_FUNCTION_USE,row];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id IN(SELECT id FROM %@ LIMIT %d)",TABLE_NAME_FUNCTION_USE,TABLE_NAME_FUNCTION_USE,row];
        BOOL result = [db executeUpdate:sql];
        if (result) {
            //NSLog(@"删表 %@ 成功。",TABLE_NAME_FUNCTION_USE);
        } else {
            //NSLog(@"删表 %@ 失败。",TABLE_NAME_FUNCTION_USE);
        }
    }];
}





@end
