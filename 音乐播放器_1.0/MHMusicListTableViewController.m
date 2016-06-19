//
//  MHMusicListTableViewController.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/23.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHMusicListTableViewController.h"
#import <sqlite3.h>
#import "MHSQLiteTool.h"
#import "MHMusicList.h"
#import "MHPlayingViewController.h"
#import "MHMusicTool.h"
#import "MHFenZu.h"

@interface MHMusicListTableViewController ()
@property (strong ,nonatomic) NSMutableArray *musicList;
@property (strong ,nonatomic) MHPlayingViewController *playingViewController;
@property (strong ,nonatomic) UIView *menuViewF;
@property (strong ,nonatomic) UITableView *menuTableView;
@property (strong ,nonatomic) NSMutableArray *menuArray;
@property (strong ,nonatomic) MHMusicList *selectMusic;
@end

@implementation MHMusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    backImageView.userInteractionEnabled = YES;
    
    backImageView.image = [UIImage imageNamed:@"1706442046308357"];
    self.tableView.backgroundView = backImageView;
    self.navigationItem.titleView.backgroundColor = [UIColor blackColor];
    //    self.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//懒加载保证只有一个实体存在
- (MHPlayingViewController *)playingViewController
{
    if (_playingViewController == nil) {
        _playingViewController = [[MHPlayingViewController alloc] init];
    }
    return _playingViewController;
}

- (NSMutableArray *)musicList
{
        if (_musicList == nil) {
            NSArray *dictArray = [MHSQLiteTool musicListWithTitle:self.title];
            NSMutableArray *musicLists = [NSMutableArray array];
            for (MHMusicList *musicList in dictArray) {
                [musicLists addObject:musicList];
            }
            _musicList = musicLists;
        }
    return _musicList;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//歌曲分组菜单
- (void)changeFenZu:(id)sender
{
    NSLog(@"clicked Btn");
    UITableViewCell * cell = (UITableViewCell *)[sender superview];
    //    UIButton *clicledBtn = (UIButton*)[sender self];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSLog(@"%ld",(long)[path row]);
    NSInteger rows = [path row];
    self.selectMusic = [MHMusicTool musics][rows];
    
    NSArray *array = [MHSQLiteTool fenZu];
    self.menuArray = [NSMutableArray array];
    for (MHFenZu *fenZu in array) {
        NSLog(@"fenZu.title :%@   GetTitle:%@",fenZu.title,[MHMusicTool GetTitle]);
        if (![fenZu.title isEqualToString:[MHMusicTool GetTitle]]) {
            [self.menuArray addObject:fenZu];
        }
    }
    
    
    //菜单视图的容器视图
    self.menuViewF = [[UIView alloc] init];
    self.menuViewF.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.menuViewF.backgroundColor = [UIColor clearColor];
    
    //加载菜单View
    self.menuTableView = [[UITableView alloc] init];
    self.menuTableView.frame = CGRectMake(self.view.bounds.size.width * 1 / 8, self.view.bounds.size.height / 3, self.view.bounds.size.width * 6 / 8, 90);
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    //加载背景按钮
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.backgroundColor = [UIColor whiteColor];
    buttonCancel.alpha = 0.5;
    [buttonCancel addTarget:self action:@selector(clickCalcelBtn) forControlEvents:UIControlEventTouchUpInside];
    buttonCancel.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self.view addSubview:self.menuViewF];
    [self.menuViewF addSubview:buttonCancel];
    [self.menuViewF addSubview:self.menuTableView];
    
    
}
- (void)clickCalcelBtn
{
    NSLog(@"clickBtnNamedcancelBtn");
    [self.menuViewF removeFromSuperview];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.menuTableView]) {
        return self.menuArray.count;
    }else{
    return self.musicList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.menuTableView]) {
        static NSString *ID = @"menuCell";
        MHFenZu *fenZu = self.menuArray[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        cell.textLabel.text = fenZu.title;
        return cell;
    }else{
    static NSString *ID = @"listCell";
    MHMusicList *musicList = self.musicList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",musicList.singName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:188/255  green:32/255 blue:3/255 alpha:0.11];
        cell.detailTextLabel.text = musicList.singName;
        
        //设置cell背景透明
        cell.backgroundColor = [UIColor clearColor];
        
        UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *btnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_btn"]];
        btnImage.frame = CGRectMake(0, 0, 30, 30);
        [downloadBtn addSubview:btnImage];
        
        //添加按钮事件
        [downloadBtn addTarget:self action:@selector(changeFenZu:) forControlEvents:UIControlEventTouchUpInside];
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
//        downloadBtn.frame= CGRectMake(0, 0, 20, 20);
        
        //距离cell右边距为20像素
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:downloadBtn
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cell
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:-20]];

    }
    return cell;
    }
}


#pragma  mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.menuTableView]) {
        //将歌曲加入到分组内
        MHFenZu *fenZu = self.menuArray[indexPath.row];
        //将歌曲添加到指定分组
        [MHSQLiteTool addMusic:self.selectMusic ToFenZu:fenZu.title];
        [self clickCalcelBtn];
    }else{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //设置播放歌曲数据
    MHMusicTool *musicTool = [[MHMusicTool alloc] init];
    musicTool.title = self.title;
    
    [MHMusicTool setPlayingMusic:[MHMusicTool musics][indexPath.row]];
    
    [self.playingViewController show];
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
