//
//  MHsongInf.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/19.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHsongInf : NSObject
//歌曲来源
@property (strong ,nonatomic) NSString *source;
//歌曲ID
@property (strong ,nonatomic) NSNumber *songId;
//未知
@property (strong ,nonatomic) NSString *songPicRadio;
//时长
@property (strong ,nonatomic) NSNumber *time;
//链接码
@property (strong ,nonatomic) NSNumber *linkCode;
//歌曲小图
@property (strong ,nonatomic) NSString *songPicSmall;
//歌手ID
@property (strong ,nonatomic) NSString *artistId;
//专辑名
@property (strong ,nonatomic) NSString *albumName;
//拷贝类型
@property (strong ,nonatomic) NSNumber *myTypeCopy;
//歌名
@property (strong ,nonatomic) NSString *songName;
//歌手名
@property (strong ,nonatomic) NSString *artistName;
//歌曲大图
@property (strong ,nonatomic) NSString *songPicBig;
//版本
@property (strong ,nonatomic) NSString *version;
//专辑ID
@property (strong ,nonatomic) NSNumber *albumId;
//歌曲链接
@property (strong ,nonatomic) NSString *songLink;
//展示链接
@property (strong ,nonatomic) NSString *showLink;
//大小
@property (strong ,nonatomic) NSNumber *size;
//歌词链接
@property (strong ,nonatomic) NSString *lrcLink;
// 问题id
@property (strong ,nonatomic) NSString *queryId;
//歌曲类型
@property (strong ,nonatomic) NSString *format;
//状态
@property (strong ,nonatomic) NSString *relateStatus;
//来源类型
@property (strong ,nonatomic) NSString *resourceType;
//码率
@property (strong ,nonatomic) NSNumber *rate;

- (instancetype)initWithDict:(NSDictionary *)songInf;

@end
