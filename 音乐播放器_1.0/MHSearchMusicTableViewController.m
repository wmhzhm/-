//
//  MHSearchMusicTableViewController.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/18.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHSearchMusicTableViewController.h"
#import "MHSearchListModel.h"
#import "MHJSONTool.h"


@interface MHSearchMusicTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong ,nonatomic) NSArray *musicListDict;
@property (strong ,nonatomic) NSArray *songInf;

- (IBAction)clickSearchBtn;
@end

@implementation MHSearchMusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    backImageView.image = [UIImage imageNamed:@"1706442046308356"];
    self.tableView.backgroundView = backImageView;
}

//隐藏导航栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//解析列表数据
- (void)JSONWithKeyWords:(NSString*)keyWords
{
    // 1. URL
    NSString *urlStr = [NSString stringWithFormat:@"http://sug.music.baidu.com/info/suggestion?format=json&version=2&from=0&word=%@&_=1405404358299",[keyWords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. NSURLRequest
    /**
     参数:
     timeoutInterval:开发中一定要指定超时时长,默认60秒,通常靠考虑到用户的网络环境,可以设置到10~20秒,不能太长,也不能太短
     */
    NSURLSessionConfiguration *session = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:session delegate:self delegateQueue:nil];
    
    
    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,
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
                                          self.musicListDict = songList;
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [self.tableView reloadData];
                                          });
                                            }//endElse
                                  }];
    
    [task resume];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicListDict.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"searchList";
    MHSearchListModel *listModel = [[MHSearchListModel alloc] initWithDict:self.musicListDict[indexPath.row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //设置点击后变透明灰色
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:188/255  green:32/255 blue:3/255 alpha:0.11];
        //设置cell背景透明
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = listModel.songname;
    cell.detailTextLabel.text = listModel.artistname;
    return cell;
}
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

//点击行触发
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    MHSearchListModel *listModel = [[MHSearchListModel alloc] initWithDict:self.musicListDict[indexPath.row]];
    NSLog(@"%@,%@,%ld",listModel.songname,listModel.artistname,(long)indexPath.row);
    
    NSNumber *songID = listModel.songid;
    [self loadPathWithSongID:songID];
}

//解析歌曲数据
- (void)loadPathWithSongID:(NSNumber *)songID
{
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
            self.songInf = [[dict objectForKey:@"data"] objectForKey:@"songList"];
        }
    }];
    [task resume];
}


//搜索按钮
- (IBAction)clickSearchBtn {
    [self.view endEditing:YES];

   [self JSONWithKeyWords:self.searchTextField.text];
}
@end
