//
//  MHMusicTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/29.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHMusicTool.h"
#import "MHMusicList.h"
#import "MHSearchListModel.h"
#import "MHSQLiteTool.h"
#import "MHsongInf.h"
#import "MHMusicListTableViewController.h"


@implementation MHMusicTool

static NSString *title_static;
static NSString *playing_title;
static NSArray *onlineMusicList;
static  MHMusicList *_playingMusic;
static bool isOnline = NO;


//存储网络歌曲列表
+ (void)setOnlineMusicListWithArray:(NSArray *)array
{
    onlineMusicList = array;
}

+ (BOOL)isOnline
{
    return isOnline;
}

//返回网络歌曲列表
+ (NSArray *)musicsOnline
{
    isOnline = YES;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (MHsongInf *musicInf in onlineMusicList) {
        //将模型转换
        MHMusicList *music = [[MHMusicList alloc] init];
        music.singName = musicInf.songName;
        music.singer = musicInf.artistName;
//        music.fileName = [NSString stringWithFormat:@"%@.%@",musicInf.songName,musicInf.format];
        //此处以url的形式，让其方便媒体流播放
        music.fileName = musicInf.songLink;
        music.singerIcon = musicInf.songPicBig;
        music.lrcName = musicInf.lrcLink;
        [arrayM addObject:music];
    }
    return [arrayM copy];
}


//返回所有列表内音乐
+ (NSArray *)musics
{
    isOnline = NO;
    NSArray *dictArray = [MHSQLiteTool musicListWithTitle:title_static];
    NSMutableArray *musicLists = [NSMutableArray array];
    for (MHMusicList *musicList in dictArray) {
        [musicLists addObject:musicList];
    }
    NSArray *array = musicLists;
    return array;
}

- (void)setTitle:(NSString *)title
{
    title_static = title;
}

//返回正在播放的歌曲
+ (MHMusicList*)playingMusic
{
    return _playingMusic;
}
//设置网络歌曲曲目
+ (void)setOnlinePlayingMusic:(MHMusicList *)playingMusic
{
    NSArray *music = [self musicsOnline];
    BOOL isContains = NO;
    //因为isContant是比较对象地址，而这里需要比较值，所以采用提取名字字符串(主键不会有相同的)的方法来比较
    for (MHMusicList *musicInList  in music) {
        NSString *playingName = playingMusic.singName;
        NSString *musicInListName = musicInList.singName;
        if ([playingName isEqualToString:musicInListName]) {
            isContains = YES;
            break;
        }
    }
    BOOL isExists = playingMusic;
    if (!isExists || !isContains){
        return;
    }
    if (_playingMusic == playingMusic)
    {
        return;
    }
    _playingMusic=playingMusic;
}
//设置本地歌曲曲目
+ (void)setPlayingMusic:(MHMusicList *)playingMusic
{
    NSArray *music = [self musics];
    BOOL isContains = NO;
    //因为isContant是比较对象地址，而这里需要比较值，所以采用提取名字字符串(主键不会有相同的)的方法来比较
    for (MHMusicList *musicInList  in music) {
        NSString *playingName = playingMusic.fileName;
        NSString *musicInListName = musicInList.fileName;
        if ([playingName isEqualToString:musicInListName]) {
            isContains = YES;
            break;
        }
    }
    BOOL isExists = playingMusic;
       if (!isExists || !isContains){
        return;
    }
    if (_playingMusic == playingMusic)
    {
        return;
    }
     _playingMusic=playingMusic;
}


//返回播放歌曲所在组的内部序列
+ (NSUInteger)playingIndex
{
    NSMutableArray *musicNameList = [NSMutableArray array];
    NSArray *musicList;
    for (MHMusicList *array in [MHMusicTool musics]) {
        [musicNameList addObject:array.fileName];
    }
    musicList = musicNameList;
    
    NSUInteger playingIndex = [musicList indexOfObject:_playingMusic.fileName];
    //设置下一首音乐的索引

    return playingIndex;
}

//下一首歌曲
+ (MHMusicList *)nextMusic
{
    NSUInteger nextIndex = 0;
   
      if (_playingMusic) {
          NSUInteger playingIndex = [self playingIndex];
              //设置下一首音乐的索引
            nextIndex = playingIndex+1;
                //检查数组越界，如果下一首音乐是最后一首，那么重置为0
               if (nextIndex>=[self musics].count) {
                       nextIndex=0;
                  }
          }
    return [self musics][nextIndex];
}
//重播本首歌曲
+ (MHMusicList *)replayMusic
{
    NSUInteger nextIndex = 0;
    
    if (_playingMusic) {
        NSUInteger playingIndex = [self playingIndex];
        //设置本首音乐的索引
        nextIndex = playingIndex;
    }
    return [self musics][nextIndex];
}
//随机播放
+ (MHMusicList *)randomMusic
{
    NSInteger count = [MHMusicTool musics].count - 1;
    NSUInteger randomIndex = (NSUInteger)(0 + (arc4random() % (count - 0 + 1)));
    while (randomIndex == [self playingIndex] && count != 0) {
       randomIndex = (NSUInteger)(0 + (arc4random() % (count - 0 + 1)));
    }
    //清空正在播放的音乐，不然随机到本身会一直循环
    return [self musics][randomIndex];
}

//上一首歌曲
+ (MHMusicList *)perviousMusic
{
    //设定一个初值
      NSInteger previousIndex = 0;
      if (_playingMusic) {
              //获取当前播放音乐的索引
          NSInteger playingIndex = [self playingIndex];
                //设置下一首音乐的索引
               previousIndex = playingIndex-1;
               //检查数组越界，如果下一首音乐是最后一首，那么重置为0
              if (previousIndex<0) {
                      previousIndex=[self musics].count-1;
                 }
           }
      return [self musics][previousIndex];
}
@end
