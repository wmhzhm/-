//
//  MHLrc.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/6.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHLrc : NSObject

/** 歌词的开始时间*/
@property (nonatomic) NSTimeInterval beginTime;

/** 歌词的内容*/
@property (nonatomic, copy) NSString *content;

@end
