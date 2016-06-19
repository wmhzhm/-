//
//  MHMusicTool.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/29.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MHMusicList;
@class MHMusicListTableViewController;
@interface MHMusicTool : NSObject


@property (strong ,nonatomic) NSString *title;
//是否为网络歌曲
+ (BOOL)isOnline;
//存储网络歌曲列表
+ (void)setOnlineMusicListWithArray:(NSArray *)array;
//获取网络歌曲列表
+ (NSArray *)musicsOnline;
//设置网络音乐曲目
+ (void)setOnlinePlayingMusic:(MHMusicList *)playingMusic;
//本地所有的歌曲
+ (NSArray *)musics;
//返回播放歌曲所在组的内部序列
+ (NSUInteger)playingIndex;
//返回正在播放的歌曲
+ (MHMusicList*)playingMusic;
//设置音乐播放
+ (void)setPlayingMusic:(MHMusicList *)playingMusic;
//下一首歌曲
+ (MHMusicList *)nextMusic;
//上一首歌曲
+ (MHMusicList *)perviousMusic;
//重播本首歌曲
+ (MHMusicList *)replayMusic;
//得到列表内随机的音乐
+ (MHMusicList *)randomMusic;
//得到分组
+ (NSString *)GetTitle;

@end
