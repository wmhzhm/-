//
//  MHDownloader.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/5/23.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@class MHMusicList;
@interface MHDownloader : NSObject

+ (void)downloadmusic:(MHMusicList *)musicModel WithMusicName:(NSString *)musicName;

@end
