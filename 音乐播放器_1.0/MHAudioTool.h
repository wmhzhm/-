//
//  MHAudioTool.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/30.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MHAudioTool : NSObject
//播放音乐文件
+ (AVAudioPlayer *)playMusic:(NSString *)fileName;
//暂停播放
+ (void)pauseMusic:(NSString *)fileName;
//停止播放音乐文件
+ (void)stopMusic:(NSString *)fileName;
//播放音效文件
+ (void)playSound:(NSString *)fileName;
//摧毁音效
+ (void)disposeSound:(NSString *)fileName;

@end
