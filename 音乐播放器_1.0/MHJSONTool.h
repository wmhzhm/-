//
//  MHJSONTool.h
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/18.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MHJSONTool : NSObject
+ (NSArray*)JSONWithKeyWords:(NSString*)keyWords;
+ (NSString *)loadPathWithSongID:(NSNumber *)songID;
@end
