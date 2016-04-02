//
//  MHMusicTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/29.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHMusicTool.h"
#import "MHMusicList.h"
#import "MHSQLiteTool.h"
#import "MHMusicListTableViewController.h"


@implementation MHMusicTool

static NSString *title_static;
static NSString *playing_title;
static  MHMusicList *_playingMusic;
//返回所有列表内音乐
+ (NSArray *)musics
{
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

//- (BOOL)playingMusic:(MHMusicList*)playingMusic isEqual:(MHMusicList *)musicInList
//{
//    if (playingMusic.singName == musicInList.singName/*数据库里singName是主键所以不会存在重复名字*/) {
//        return YES;
//    }
//    return NO;
//}

+ (void)setPlayingMusic:(MHMusicList *)playingMusic
{
//    NSLog(@"%@",playingMusic.fileName);
    //判断是否在一个分组内
//    BOOL isSameTitle = NO;
//    if (playing_title == title_static) {
//        isSameTitle = YES;
//        NSLog(@"isSameTitle");
//    }
//    if (!isSameTitle) {
//        _playingMusic=playingMusic;
//        playing_title = title_static;
//        return;
//    }
//    else{
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
//    }//endElse
}

//下一首歌曲
+ (MHMusicList *)nextMusic
{
    NSInteger nextIndex = 0;
      if (_playingMusic) {
             //获取当前播放音乐的索引
              NSInteger playingIndex = [[self musics] indexOfObject:_playingMusic];
              //设置下一首音乐的索引
            nextIndex = playingIndex+1;
                //检查数组越界，如果下一首音乐是最后一首，那么重置为0
               if (nextIndex>=[self musics].count) {
                       nextIndex=0;
                  }
          }
    return [self musics][nextIndex];
}
//上一首歌曲
+ (MHMusicList *)perviousMusic
{
    //设定一个初值
      NSInteger previousIndex = 0;
      if (_playingMusic) {
              //获取当前播放音乐的索引
              NSInteger playingIndex = [[self musics] indexOfObject:_playingMusic];
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
