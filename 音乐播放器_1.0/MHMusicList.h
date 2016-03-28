//
//  MHMusicList.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/23.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHMusicList : NSObject

//@property (copy ,nonatomic) NSString *fenZuTitle;name,signer,filename,singericon,lrcname
@property (copy ,nonatomic) NSString *singName;//歌名
@property (copy ,nonatomic) NSString *singer;//歌手
@property (copy ,nonatomic) NSString *fileName;//歌曲文件名
@property (copy ,nonatomic) NSString *singerIcon;//歌曲图片
@property (copy ,nonatomic) NSString *lrcName;//歌词文件名

@end
