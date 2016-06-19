//
//  MHSQLiteTool.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/21.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class MHFenZu;
@class MHMusicList;
@interface MHSQLiteTool : NSObject

+ (BOOL)addFenZu:(MHFenZu *)fenZu;
+ (BOOL)deleteFenZu:(MHFenZu *)fenZu;
+ (BOOL)deleteFMWithFenZu:(NSString *)title;
+ (BOOL)deleteFMWithName:(NSString *)name;
+ (BOOL)initLoopSet;
+ (BOOL)updateLoopSetWithModel:(NSString *)model;
+ (void)createTable:(const char *)sql named:(NSString *)tableName;
+ (void)addDownloadMusic:(MHMusicList *)musicModel;

+ (NSString *)loopSetWorth;
+ (NSArray *)fenZu;
+(NSArray *)musicListWithTitle:(NSString *)title;
//将指定歌曲加入指定分组
+ (void)addMusic:(MHMusicList *)musicModel ToFenZu:(NSString *)title;
@end
