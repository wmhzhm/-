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
        const char *sql_1 = "create table if not exists t_music (name text primary key,signer text,filename text,singericon text)";
        [MHSQLiteTool createTable:sql_1 named:@"t_music"];
        
        //创建关联表t_FM
        //title:列表 name:歌名
        const char *sql_2 = "create table if not exists t_FM (title text references t_fenZu(title),name text references t_music(name),primary key(title,name))";
        [MHSQLiteTool createTable:sql_2 named:@"t_FM"];
        
        }else{
        NSLog(@"打开数据库失败");
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
    NSString *sql_1 = [NSString stringWithFormat:@"select name from t_FM where title='%@';",title];
    const char *sql = sql_1.UTF8String;
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
            //获得第0列的
            const unsigned char *fTitle = sqlite3_column_text(stmt, 0);
            musicList.singName = [NSString stringWithUTF8String:(const char*)fTitle];
            //把分组数据添加到数组
            [musicLists addObject:musicList];
        }
    }
    return musicLists;
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
@end
