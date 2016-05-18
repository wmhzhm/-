//
//  MHLrcTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/6.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHLrcTool.h"
#import "MHLrc.h"

@implementation MHLrcTool


+ (NSArray *)parserLyricWithName:(NSString *)lycName
{
    //加载本地歌词文件
//    NSString *path = [[NSBundle mainBundle]pathForResource:lycName ofType:nil];
    NSArray  *paths  =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *filePath = [docDir stringByAppendingPathComponent:lycName];
    NSError *error;
    NSString *lyricStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error: %@",error);
    }
    NSMutableArray *timeForLyric = [NSMutableArray array];
    //以"\n"拆解字符串:"[00:00.000]ABCD","[00:00.000]BCDEF"
    NSArray *returnArr = [lyricStr componentsSeparatedByString:@"\n"];
    for (NSString *tempStr in returnArr) {
        if (![tempStr isEqualToString:@""]) {
            //在使用"]"拆解字符串后的结果("[00:00.000]","ABCD")
            NSArray *lyricAndTimeArr = [tempStr componentsSeparatedByString:@"]"];
            //将时间拆解成想要的格式:"00:00"，以作为字典的key
            NSString *timeKey = [[lyricAndTimeArr firstObject] substringWithRange:NSMakeRange(1, 5)];
            //以"00:00"，作为字典的key。"ABCD"(数组的最后一位)作为字典的value
            NSDictionary *lyricDic = @{timeKey:[lyricAndTimeArr lastObject]};
            //时间歌词的数组添加时间歌词字典
            [timeForLyric addObject:lyricDic];
        }
    }
    return timeForLyric;
}
    
//+ (NSArray *)parserLyricWithName:(NSString *)lycName
//{
//    //加载本地歌词文件
//    NSString *path = [[NSBundle mainBundle]pathForResource:lycName ofType:nil];
//    
//    NSError *error;
//    NSString *lyricStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
//    if (error) {
//        NSLog(@"error: %@",error);
//    }
//    //创建歌词数组
//    NSArray *lyricArray = [lyricStr componentsSeparatedByString:@"\n"];
//    //    NSLog(@"%ld",lyricArray.count);
//    //歌词截取
//    //[04:19.00][03:40.00][01:44.00]我的牵挂我的渴望 直至以后
//    //截取成
//    //[04:19.00]我的牵挂我的渴望 直至以后
//    //[03:40.00]我的牵挂我的渴望 直至以后
//    //[01:44.00]我的牵挂我的渴望 直至以后
//    //创建临时数组，用来盛放歌词模型类
//    NSMutableArray *tempArray = [NSMutableArray array];
//    //遍历数组
//    for (NSString *lyricStr in lyricArray) {
//        // 创建正则表达式
//        // [0-9]{2}  或者  \d = [0-9]
//        // 单"\"是转义符, 所以如果不希望转义, 需要在加一个"\"
//        //NSString *pattern = @"\\[[0-9]d{2}:[0-9]d{2}.[0-9]d{2}\\]";
//        NSString *pattern = @"\\[\\d{2}:\\d{2}.\\d{2}\\]";
//        //NSRegularExpressionCaseInsensitive: 忽略大小写
//        NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
//        
//        //匹配
//        NSArray *resultArr = [regular matchesInString:lyricStr options:NSMatchingReportCompletion range:NSMakeRange(0, lyricStr.length)];
//        
//        //获取歌词内容
//        //获取匹配到的最后一个结果
//        NSTextCheckingResult *lastResult = [resultArr lastObject];
//        //截取字符串：index  最后一个结果的location ＋ length
//        NSString *contentStr = [lyricStr substringFromIndex:lastResult.range.location + lastResult.range.length];
//        //获取歌词时间  ---> 遍历匹配结果
//        for (NSTextCheckingResult *result in resultArr) {
//            //获取每一个结果值
//            NSString *timeStr = [lyricStr substringWithRange:result.range];
//            //时间字符串转换成NSTimeInterver
//            //创建日期格式化类
//            NSDateFormatter *formatter = [NSDateFormatter new];
//            formatter.dateFormat = @"[mm:ss.SS]";
//            //时间转换
//            NSDate *currentDate = [formatter dateFromString:timeStr];
//            NSDate *beginDate = [formatter dateFromString:@"[00:00.00]"];
//            NSTimeInterval time = [currentDate timeIntervalSinceDate:beginDate];
//            //创建歌词模型类
//            MHLrc *lyricModel = [[MHLrc alloc]init];
//            lyricModel.beginTime = time;
//            lyricModel.content = contentStr;
//            [tempArray addObject:lyricModel];
//        }
//    }
//    //所有数据加载完成之后进行排序
//    //sortUsingDescriptors : 可变数组的排序方法, 可以传多个排序条件
//    //NSSortDescriptor : 排序描述类 ,需要告诉按照那个key, 升序还是降序
//    //ascending: 是否升序
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES];
//    [tempArray sortUsingDescriptors:@[sort]];
//    
//    return tempArray;
//
//}
@end
