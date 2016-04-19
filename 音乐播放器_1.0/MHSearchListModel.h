//
//  MHListModel.h
//  API测试
//
//  Created by wmh—future on 16/4/17.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHSearchListModel : NSObject
//比特率
@property (copy ,nonatomic) NSString *bitrate_fee;
//未知
@property (strong ,nonatomic) NSNumber *yyr_artist;
//歌名
@property (copy ,nonatomic) NSString *songname;
//歌手名
@property (copy ,nonatomic) NSString *artistname;
//歌曲id
@property (strong ,nonatomic) NSNumber *songid;
//是否有mv
@property (assign ,nonatomic) BOOL has_mv;
//id解码数
@property (copy ,nonatomic) NSString *encrypted_songid;

//根据字典加载模型
- (instancetype)initWithDict:(NSDictionary *)dict;
@end