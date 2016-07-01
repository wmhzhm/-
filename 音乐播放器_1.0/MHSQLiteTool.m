//
//  MHSQLiteTool.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/21.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHSQLiteTool.h"
#import "MHFenZu.h"
#import "MHMusicList.h"

@implementation MHSQLiteTool

    //创建数据库实例
    static sqlite3 *_db;

+ (void)initialize
{
    //打开数据库
    //获取沙盒路径
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"fenZu.sqlite"];
    NSLog(@"沙盒路径-------: %@",fileName);
    int result = sqlite3_open(fileName.UTF8String/*OC字符串转为C语言Char类型字符串*/, &_db);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        //成功之后自动创建表
        //创建t_fenZu表
        //title:分组名 icon:分组图片
        const char *sql = "create table if not exists t_fenZu (title text primary key,icon text);";
        [MHSQLiteTool createTable:sql named:@"t_fenZu"];
        
        //创建t_music表
        //name:歌名 singer:歌手 filename:歌曲文件名  singericon:歌手图片
        const char *sql_1 = "create table if not exists t_music (name text primary key,signer text,filename text,lrcname text,singericon text)";
        [MHSQLiteTool createTable:sql_1 named:@"t_music"];
        
        //创建关联表t_FM
        //title:列表 name:歌名
        const char *sql_2 = "create table if not exists t_FM (title text references t_fenZu(title),name text references t_music(name),primary key(title,name))";
        [MHSQLiteTool createTable:sql_2 named:@"t_FM"];
        
        //创建循环设置表t_loopSetting
        //
        const char *sql_3 = "create table if not exists t_loopSetting (loop text primary key,currentLoop text)";
        [MHSQLiteTool createTable:sql_3 named:@"t_loopSetting"];
        
        }else{
        NSLog(@"打开数据库失败");
    }
     //初始化分组
     const char *sql = "select * from t_fenZu;";
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        return;
    }else{
    NSString *sql3 = [NSString stringWithFormat:@"insert into t_fenZu (title,icon) values('%@','%@');",@"下载音乐",@"downloadMusic"];
        NSString *sql1 = [NSString stringWithFormat:@"insert into t_fenZu (title,icon) values('%@','%@');",@"我的最爱",@"favoriteMusic"];
     NSString *sql2 = [NSString stringWithFormat:@"insert into t_fenZu (title,icon) values('%@','%@');",@"我的音乐",@"myMusic"];
    char *errorMes = NULL;
    sqlite3_exec(_db, sql1.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    sqlite3_exec(_db, sql2.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    sqlite3_exec(_db, sql3.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    }
}

//创建表
+ (void)createTable:(const char *)sql named:(NSString *)tableName
{
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql, NULL, NULL, &errorMes);
    if (result == SQLITE_OK) {
        NSLog(@"建表成功");
    }else{
        NSLog(@"建表失败,错误为:%s",errorMes);
    }
}

//添加分组数据
+ (BOOL)addFenZu:(MHFenZu *)fenZu
{
    NSString *sql = [NSString stringWithFormat:@"insert into t_fenZu (title,icon) values('%@','%@');",fenZu.title,fenZu.icon];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
    return result == SQLITE_OK;
}

//删除分组数据
+ (BOOL)deleteFenZu:(MHFenZu *)fenZu{
    
    NSString *sql = [NSString stringWithFormat:@"delete from t_fenZu where title='%@' and icon='%@';",fenZu.title,fenZu.icon];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
    return result == SQLITE_OK;
}

+ (void)deleteMusic:(MHMusicList *)musicModel FromFenZu:(NSString *)title
{
    NSString *sql = [NSString stringWithFormat:@"delete from t_FM where title='%@' and name='%@';",title,musicModel.singName];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
}
//取得分组数据
+ (NSArray *)fenZu
{
    NSMutableArray *fenZus = nil;
    //定义sql语句
    const char *sql = "select * from t_fenZu;";
    //定义结果集stmt
    sqlite3_stmt *stmt = NULL;
    //检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"查询语句合法");
        fenZus = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {//查询到数据的时候
            //获得该行的数据
            MHFenZu *fenZu = [[MHFenZu alloc] init];
            //获得第0列的title
            const unsigned char *fTitle = sqlite3_column_text(stmt, 0);
            fenZu.title = [NSString stringWithUTF8String:(const char*)fTitle];
            //获得第1列的icon
            const unsigned char *fIcon = sqlite3_column_text(stmt, 1);

            NSString *sIcon = [NSString stringWithUTF8String:(const char *)fIcon];
            fenZu.icon = sIcon;
            
            //把分组数据添加到数组
            [fenZus addObject:fenZu];
        }
    }
    return fenZus;
}

//获得music列表数据
+(NSArray *)musicListWithTitle:(NSString *)title
{
    NSMutableArray *musicLists = nil;
    //定义sql语句
#pragma mark - 未修复SQL注入漏洞

    NSString *sql_2 = [NSString stringWithFormat:@"select t_music.name,signer,filename,singericon,lrcname from t_music,t_FM where t_music.name = t_FM.name and title='%@';",title];
    const char *sql = sql_2.UTF8String;
    //定义结果集stmt
    sqlite3_stmt *stmt = NULL;
    //检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"查询语句合法");
        musicLists = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {//查询到数据的时候
            //获得该行的数据
            MHMusicList *musicList = [[MHMusicList alloc] init];
            //获得第0列的歌名
            const unsigned char *fTitle = sqlite3_column_text(stmt, 0);
            musicList.singName = [NSString stringWithUTF8String:(const char*)fTitle];
            //获取第一列的歌手
             const unsigned char *fSigner = sqlite3_column_text(stmt, 1);
            musicList.singer = [NSString stringWithUTF8String:(const char*)fSigner];
            //获取第二列的文件名
             const unsigned char *fFileName = sqlite3_column_text(stmt, 2);
            musicList.fileName = [NSString stringWithUTF8String:(const char*)fFileName];
            //获取第三列的歌曲图片名
             const unsigned char *fSingerIcon = sqlite3_column_text(stmt, 3);
            musicList.singerIcon = [NSString stringWithUTF8String:(const char*)fSingerIcon];
            //获取第四列的歌词文件名
             const unsigned char *fLrcName = sqlite3_column_text(stmt, 4);
            musicList.lrcName = [NSString stringWithUTF8String:(const char*)fLrcName];
            
            //把分组数据添加到数组
            [musicLists addObject:musicList];
        }
    }
    return musicLists;
}

//添加下载歌曲数据
+ (void)addDownloadMusic:(MHMusicList *)musicModel
{
    NSString *sql = [NSString stringWithFormat:@"insert into t_music (name,signer,filename,lrcname,singericon) values('%@','%@','%@.mp3','%@.lrc','%@.jpg');",musicModel.singName,musicModel.singer,musicModel.singName,musicModel.singName,musicModel.singName];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
    //将歌曲加入下载分组
    NSString *sql1 = [NSString stringWithFormat:@"insert into t_FM (title,name) values('%@','%@');",@"下载音乐",musicModel.singName];
    int result1 = sqlite3_exec(_db, sql1.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result1 != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
}

//将指定歌曲加入指定分组
+ (void)addMusic:(MHMusicList *)musicModel ToFenZu:(NSString *)title
{
        char *errorMes = NULL;
        //将歌曲加入下载分组
        NSString *sql1 = [NSString stringWithFormat:@"insert into t_FM (title,name) values('%@','%@');",title,musicModel.singName];
        int result1 = sqlite3_exec(_db, sql1.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
        if (result1 != SQLITE_OK) {
            NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
        }
}


//删除分组时操作FM表
+ (BOOL)deleteFMWithFenZu:(NSString *)title
{
    NSString *sql = [NSString stringWithFormat:@"delete from t_FM where title='%@';",title];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
    return result == SQLITE_OK;
}
//删除分组内音乐时操作FM表
+ (BOOL)deleteFMWithName:(NSString *)name
{
    NSString *sql = [NSString stringWithFormat:@"delete from t_FM where name='%@';",name];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
    return result == SQLITE_OK;
}


//得到循坏设置的值
+ (NSString *)loopSetWorth
{
    NSString *loopSetWorth = nil;
    //定义sql语句
    NSString *sql_2 = [NSString stringWithFormat:@"select currentLoop from t_loopSetting where loop = 'nowLoop';"];
    const char *sql = sql_2.UTF8String;
    //定义结果集stmt
    sqlite3_stmt *stmt = NULL;
    //检测SQL语句的合法性
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"查询语句合法");
        while (sqlite3_step(stmt) == SQLITE_ROW) {//查询到数据的时候
            //获取第0列的设置值
            const unsigned char *fSigner = sqlite3_column_text(stmt, 0);
            loopSetWorth = [NSString stringWithUTF8String:(const char*)fSigner];
                    }//endWhile
    }//endIf
    return loopSetWorth;
}

+ (BOOL)initLoopSet
{
    NSString *sql = [NSString stringWithFormat:@"insert into t_loopSetting (loop,currentLoop) values('%@','%@');",@"nowLoop",@"loop_all"];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
    return result == SQLITE_OK;
}

//更新loopSet
+ (BOOL)updateLoopSetWithModel:(NSString *)model
{
//    NSLog(@"要更新的模式为%@",model);
    NSString *sql = [NSString stringWithFormat:@"update  t_loopSetting set currentLoop='%@' where loop='nowLoop';",model];
    char *errorMes = NULL;
    int result = sqlite3_exec(_db, sql.UTF8String/*将NSString转为Char类型*/, NULL, NULL, &errorMes);
    if (result != SQLITE_OK) {
        NSLog(@"%@",[NSString stringWithUTF8String:errorMes]);
    }
    return result == SQLITE_OK;
}

@end
