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

@interface MHSearchMusicTableViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong ,nonatomic) NSArray *musicListDict;
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

- (IBAction)clickSearchBtn {
    [self.view endEditing:YES];
    self.musicListDict = [MHJSONTool JSONWithKeyWords:self.searchTextField.text];
    [self.tableView reloadData];
}
@end
