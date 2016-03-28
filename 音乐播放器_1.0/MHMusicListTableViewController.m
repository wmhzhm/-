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


@interface MHMusicListTableViewController ()
@property (strong ,nonatomic) NSMutableArray *musicList;
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
- (NSMutableArray *)musicList
{
        if (_musicList == nil) {

            NSArray *dictArray = [MHSQLiteTool musicListWithTitle:self.title];
            NSMutableArray *musicLists = [NSMutableArray array];
            for (MHMusicList *musicList in dictArray) {
                [musicLists addObject:musicList];
//                //加载Frame模型
//                MHFenZuFrame *msg = [[MHFenZuFrame alloc] init];
//                msg.fenZu = fenZu;
//                
//                [fenZuFrameArray addObject:msg];
//            }
//            _fenZuFrame = fenZuFrameArray;
            }
            _musicList = musicLists;
        }
    return _musicList;
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    }
    return cell;
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
