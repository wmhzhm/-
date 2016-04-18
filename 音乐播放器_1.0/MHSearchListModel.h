//
//  MHListModel.h
//  API测试
//
//  Created by wmh—future on 16/4/17.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHSearchListModel : NSObject

@property (copy ,nonatomic) NSString *bitrate_fee;
@property (strong ,nonatomic) NSNumber *yyr_artist;
@property (copy ,nonatomic) NSString *songname;
@property (copy ,nonatomic) NSString *artistname;
@property (strong ,nonatomic) NSNumber *songid;
@property (assign ,nonatomic) BOOL has_mv;
@property (copy ,nonatomic) NSString *encrypted_songid;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

//{"bitrate_fee":"{\"0\":\"0|0\",\"1\":\"0|0\"}",
//    "yyr_artist":"1",
//    "songname":"小苹果",
//    "artistname":"俺酱",
//    "songid":"73899871",
//    "has_mv":"0",
//    "encrypted_songid":""}