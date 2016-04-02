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


@property (copy ,nonatomic) NSString *title;


//所有的歌曲
+ (NSArray *)musics;

//返回正在播放的歌曲
+ (MHMusicList*)playingMusic;
//设置音乐播放
+ (void)setPlayingMusic:(MHMusicList *)playingMusic;
//下一首歌曲
+ (MHMusicList *)nextMusic;
//上一首歌曲
+ (MHMusicList *)perviousMusic;

@end
