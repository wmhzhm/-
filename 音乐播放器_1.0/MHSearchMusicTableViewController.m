//
//  MHSearchMusicTableViewController.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/4/18.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHSearchMusicTableViewController.h"
#import "MHPlayingViewController.h"
#import "MHSearchListModel.h"
#import "MHJSONTool.h"
#import "MHsongInf.h"
#import "MHMusicTool.h"
#import "MCDataEngine.h"
#import "MHMusicList.h"
#import "MHDownloader.h"
#import "MHSQLiteTool.h"

@interface MHSearchMusicTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong ,nonatomic) NSArray *musicListDict;
@property (strong ,nonatomic) NSArray *songInf;
@property (strong ,nonatomic) MHsongInf *songInfModel;
@property (strong ,nonatomic) MHPlayingViewController *playingViewController;

@property (weak, nonatomic) IBOutlet UIView *headView;//头部视图
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;//加载栏

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
    self.tableView.separatorColor = [UIColor blackColor];
    
    
}
- (MHPlayingViewController *)playingViewController
{
    if (_playingViewController == nil) {
        _playingViewController = [[MHPlayingViewController alloc] init];
        return _playingViewController;
    }
    return _playingViewController;
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
//下载歌曲
- (void)downloadSing:(id)sender
{
    UITableViewCell * cell = (UITableViewCell *)[sender superview];
//    UIButton *clicledBtn = (UIButton*)[sender self];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld",(long)[path row]);
    NSInteger rows = [path row];
    MHMusicList *downloadMusicList = [MHMusicTool musicsOnline][rows];
//    NSLog(@"获取数据%@",downloadMusicList);
    //根据模型下载数据
//    clicledBtn.enabled = NO;
    
    [MHDownloader downloadmusic:downloadMusicList WithMusicName:downloadMusicList.singName];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicListDict.count;
}


//生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"searchList";
    MHSearchListModel *listModel = [[MHSearchListModel alloc] initWithDict:self.musicListDict[indexPath.row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //设置点击后变透明灰色
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:188/255  green:32/255 blue:3/255 alpha:0.11];
        //设置cell背景透明
        cell.backgroundColor = [UIColor clearColor];
        
        
        //设置行不能被点击
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //添加下载按钮
        UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadBtn setImage:[UIImage imageNamed:@"download_btn"] forState:UIControlStateNormal];
        //添加按钮事件
        [downloadBtn addTarget:self action:@selector(downloadSing:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:downloadBtn];
        downloadBtn.translatesAutoresizingMaskIntoConstraints = NO;
        
        //按钮居中
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:downloadBtn
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:cell
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:0]];
        //按钮大小
        downloadBtn.bounds= CGRectMake(0, 0, 30, 30);
        
        //距离cell右边距为20像素
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:downloadBtn
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cell
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:-20]];
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
//    [self.view endEditing:YES];
//    //显示加载视图(未实现)
//    [self showIndicatorView];
//    //用音乐工具类加载歌曲进入播放器
//    [MHMusicTool setOnlinePlayingMusic:[MHMusicTool musicsOnline][indexPath.row]];
//    [self.playingViewController show];
}

- (void)showIndicatorView
{
    
}

//解析列表数据
- (void)JSONWithKeyWords:(NSString*)keyWords
{
    // 1. URL
    NSString *urlStr = [NSString stringWithFormat:@"http://sug.music.baidu.com/info/suggestion?format=json&version=2&from=0&word=%@&_=1405404358299",[keyWords stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
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
                                          
                                          NSArray *listDict;
                                              NSMutableArray *songInfArray = [NSMutableArray array];
                                          //遍历歌曲列表解析所有歌词ID
                                              for (NSDictionary *dict in songList) {
                                                  //获取一个列表模型
                                                  MHSearchListModel *listModel = [[MHSearchListModel alloc] initWithDict:dict];
                                                  //取出列表模型ID进行解析
                                                  MHsongInf *songInf = [self loadPathWithSongID:listModel.songid];
                                                  [songInfArray addObject:songInf];
                                              }
                                              listDict = [songInfArray copy];
                                              //保存网络歌曲列表
                                              [MHMusicTool setOnlineMusicListWithArray:listDict];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              self.musicListDict = songList;
                                            //刷新界面
                                               [self.tableView reloadData];
                                              
                                          });
                                      }//endElse
                                  }];
    [task resume];
}

//解析歌曲数据
- (MHsongInf *)loadPathWithSongID:(NSNumber *)songID
{
    NSString *urlStr = [NSString stringWithFormat:@"http://ting.baidu.com/data/music/links?songIds=%@&format=json",songID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //解析JSON数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                //去掉数据外壳
                self.songInf = [[dict objectForKey:@"data"] objectForKey:@"songList"];
                self.songInfModel = [[MHsongInf alloc] initWithDict:[self.songInf firstObject]];
    return self.songInfModel;
}



//搜索按钮
- (IBAction)clickSearchBtn {
    [self.view endEditing:YES];
    
   [self JSONWithKeyWords:self.searchTextField.text];
}
@end
