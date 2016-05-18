//
//  MHJSONTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/18.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHJSONTool.h"
@interface MHJSONTool()<NSURLSessionDataDelegate>
@end
static NSArray *dictA = nil;
static NSArray *songA = nil;

@implementation MHJSONTool
//解析列表数据
//+ (NSArray*)JSONWithKeyWords:(NSString*)keyWords
//{
//    // 1. URL
//    NSString *urlStr = [NSString stringWithFormat:@"http://sug.music.baidu.com/info/suggestion?format=json&version=2&from=0&word=%@&_=1405404358299",[keyWords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
//    
//    NSURL *url = [NSURL URLWithString:urlStr];
//    
//    // 2. NSURLRequest
//    /**
//     参数:
//     timeoutInterval:开发中一定要指定超时时长,默认60秒,通常靠考虑到用户的网络环境,可以设置到10~20秒,不能太长,也不能太短
//     */
//    NSURLSessionConfiguration *session = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:session delegate:self delegateQueue:nil];
//    
//    
//    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,
//                                                                                     NSURLResponse * _Nullable response,
//                                                                                     NSError * _Nullable error)
//    {
//        if (error) {
//                        NSLog(@"网络不给力,%@",error);
//                        return;
//                    } else {
//                        // 将接收到的二进制数据反序列化为数据字典
//                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//                        //去掉两层外壳
//                        NSArray *songList = [[dict objectForKey:@"data"] objectForKey:@"song"];
//                        dictA = songList;
//                    }
//    }];
//
//    [task resume];
//    return dictA;
//}




//解析歌曲数据
+ (NSString *)loadPathWithSongID:(NSNumber *)songID
{
    NSString *loadPath = [[NSString alloc] init];
    //   歌曲id  http://ting.baidu.com/data/music/links?songIds=mid&format=json
    NSString *urlStr = [NSString stringWithFormat:@"http://ting.baidu.com/data/music/links?songIds=%@&format=json",songID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,
                                                                              NSURLResponse * _Nullable response,
                                                                              NSError * _Nullable error) {
        if (error) {
            NSLog(@"网络不给力，%@",error);
            return;
        }else
        {
            //解析JSON数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //去掉数据外壳
            songA = [[dict objectForKey:@"data"] objectForKey:@"songList"];
        }
    }];
    
    [task resume];
    return loadPath;
}


#pragma mark - dataTask delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"finish");
}
@end
