//
//  MHDownloader.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/5/23.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHDownloader.h"
#import "MHMusicList.h"
#import "MHSQLiteTool.h"


@implementation MHDownloader

+ (void)downloadmusic:(MHMusicList *)musicModel WithMusicName:(NSString *)musicName
{
    //音乐下载
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URLSing = [NSURL URLWithString:musicModel.fileName];
    NSURLRequest *requestSing = [NSURLRequest requestWithURL:URLSing];
    
    NSURL *URLLrc = [NSURL URLWithString:musicModel.lrcName];
    NSURLRequest *requestLrc = [NSURLRequest requestWithURL:URLLrc];
    
    NSURL *URLPic = [NSURL URLWithString:musicModel.singerIcon];
    NSURLRequest *requestPic = [NSURLRequest requestWithURL:URLPic];

    
    NSURLSessionDownloadTask *downloadTaskSing = [manager downloadTaskWithRequest:requestSing progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",musicName]];
        //添加数据库
        [MHSQLiteTool addDownloadMusic:musicModel];
        return [NSURL fileURLWithPath:fileName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    //歌词下载
    NSURLSessionDownloadTask *downloadTaskLrc = [manager downloadTaskWithRequest:requestLrc progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lrc",musicName]];
        return [NSURL fileURLWithPath:fileName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    
    //图片下载
    NSURLSessionDownloadTask *downloadTaskPic = [manager downloadTaskWithRequest:requestPic progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",musicName]];
        return [NSURL fileURLWithPath:fileName];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    
    
    [downloadTaskSing resume];
    [downloadTaskLrc resume];
    [downloadTaskPic resume];
}
@end
