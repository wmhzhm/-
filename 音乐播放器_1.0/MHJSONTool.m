//
//  MHJSONTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/18.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHJSONTool.h"

static NSArray *dictA = nil;

@implementation MHJSONTool
+ (NSArray*)JSONWithKeyWords:(NSString*)keyWords
{
    // 1. URL
    NSString *urlStr = [NSString stringWithFormat:@"http://sug.music.baidu.com/info/suggestion?format=json&version=2&from=0&word=%@&_=1405404358299",[keyWords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. NSURLRequest
    /**
     参数:
     timeoutInterval:开发中一定要指定超时时长,默认60秒,通常靠考虑到用户的网络环境,可以设置到10~20秒,不能太长,也不能太短
     */
    NSLog(@"%@",url);
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,
                                                                                     NSURLResponse * _Nullable response,
                                                                                     NSError * _Nullable error)
    {
        if (error) {
                        NSLog(@"网络不给力,%@",error);
                        return;
                    } else {
                        // 将接收到的二进制数据反序列化为数据字典
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                        //去掉两层外壳
                        NSArray *songList = [[dict objectForKey:@"data"] objectForKey:@"song"];
                        dictA = songList;
                    }
    }];
    [task resume];
    
    
    
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (connectionError) {
//            NSLog(@"网络不给力,%@",connectionError);
//            return;
//        } else {
//            // 将接收到的二进制数据反序列化为数据字典
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//            //去掉两层外壳
//            NSDictionary *songList = [[dict objectForKey:@"data"] objectForKey:@"song"];
//            dictA = songList;
//        }
//    }];
    return dictA;
}
@end
