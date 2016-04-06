//
//  MHLrcTool.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/6.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHLrcTool : NSObject


//根据文件名来解析歌词数据，并返回数据
+ (NSArray *)parserLyricWithName: (NSString *)lycName;

@end
