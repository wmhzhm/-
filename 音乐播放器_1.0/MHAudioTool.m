//
//  MHAudioTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/30.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHAudioTool.h"


@implementation MHAudioTool

//存放所有的播放器
static NSMutableDictionary *_musicPlayers;
+ (NSMutableDictionary *)musicPlayers
{
    if (_musicPlayers == nil) {
        _musicPlayers = [NSMutableDictionary dictionary];
    }
    return _musicPlayers;
}


//存放所有音效ID
static NSMutableDictionary *_soundIDs;
+ (NSMutableDictionary *)soundIDs
{
    if (_soundIDs == nil) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}


//播放音乐文件
+ (BOOL)playMusic:(NSString *)fileName
{
    if (!fileName) return NO;//如果没有传入文件名，那么直接返回
         //1.取出对应的播放器
         AVAudioPlayer *player=[self musicPlayers][fileName];
    
         //2.如果播放器没有创建，那么就进行初始化
         if (!player) {
                 //2.1音频文件的URL
                 NSURL *url=[[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
             if (!url){
                return NO;//如果url为空，那么直接返回
             }
                 //2.2创建播放器
                 player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
                //2.3缓冲
             if (![player prepareToPlay]) {
                 //如果缓冲失败，那么就直接返回
                 return NO;
             }
                 //2.4存入字典
                 [self musicPlayers][fileName]=player;
             }
         //3.播放
        if (![player isPlaying]) {
                //如果当前没处于播放状态，那么就播放
                return [player play];
            }
    
         return YES;//正在播放，那么就返回YES
}

//暂停播放
+ (void)pauseMusic:(NSString *)fileName
{
    if (!fileName) {
        //找不到文件直接返回
        return;
    }
    AVAudioPlayer *player = [self musicPlayers][fileName];
    [player pause];
}
//停止播放音乐文件
+ (void)stopMusic:(NSString *)fileName
{
    if (!fileName) {
        return;
    }
    AVAudioPlayer *player = [self musicPlayers][fileName];
    //停止播放
    [player stop];
    //移除播放器
    [[self musicPlayers] removeObjectForKey:fileName];
}

//播放音效文件
+ (void)playSound:(NSString *)fileName
{
    if (!fileName) {
        return;
    }
    //播放音效
    //取出音效
//    SystemSoundID soundID = [[self soundIDs][[fileName] unsignedIntegerValue];
    SystemSoundID soundID = [[self soundIDs][fileName] unsignedIntValue];
    //如果音效ID不存在就创建一个
    if (!soundID) {
        //加载url
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        if (!url) {
            return;
        }
        
//        OSStatus status = AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [self soundIDs][fileName] = @(soundID);
    }
    //播放
    AudioServicesPlaySystemSound(soundID);
}

//摧毁音效
+ (void)disposeSound:(NSString *)fileName
{
    if (!fileName) {
        return;
    }
    SystemSoundID soundID = [[self soundIDs][fileName] unsignedIntValue];
    if (!soundID) {
        return;
    }
    //销毁ID
    AudioServicesDisposeSystemSoundID(soundID);
    //从字典中移除
    [[self soundIDs][fileName] removeObjectForKey:fileName];
}
@end
