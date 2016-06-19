//
//  MHTableViewController.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/16.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHTableViewController.h"
#import "MHFenZuCell.h"
#import "MHFenZu.h"
#import "MHFenZuFrame.h"
#import <sqlite3.h>
#import "MHSQLiteTool.h"
#import "MHMusicListTableViewController.h"
#import "MHMusicTool.h"

@interface MHTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (strong ,nonatomic) NSMutableArray *fenZuFrame;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@end

@implementation MHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置背景
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    backImageView.userInteractionEnabled = YES;
    
    backImageView.image = [UIImage imageNamed:@"1706442046308357"];
    self.tableView.backgroundView = backImageView;
    self.navigationItem.titleView.backgroundColor = [UIColor blackColor];
//    self.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.textField.delegate = self;
    self.tableView. userInteractionEnabled = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textField.hidden = YES;
}
//单例懒加载
- (NSMutableArray *)fenZuFrame
{
    if (_fenZuFrame == nil) {
//    NSArray *dictArrayPlist = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FenZu" ofType:@"plist"]];
      NSArray *dictArray = [MHSQLiteTool fenZu];
        NSMutableArray *fenZuFrameArray = [NSMutableArray array];
        for (MHFenZu *fenZu in dictArray) {
            //加载Frame模型
            MHFenZuFrame *msg = [[MHFenZuFrame alloc] init];
            msg.fenZu = fenZu;
            
            [fenZuFrameArray addObject:msg];
        }
        _fenZuFrame = fenZuFrameArray;
    }
    return _fenZuFrame;
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

//设置点击空白处放弃键盘为第一响应者
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",self.class);
}

#pragma mark - Table view Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.fenZuFrame.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLastCell = (indexPath.row == self.fenZuFrame.count);

    if (isLastCell) {
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
         MHFenZuCell *cell = [MHFenZuCell cellWithTableView:self.tableView];
        //设置键盘类型
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.frame = CGRectMake(Padding, Padding, [UIScreen mainScreen].bounds.size.width - Padding * 2, cell.bounds.size.height);
        self.textField.placeholder = @"输入新的分组名...";
        self.textField.text = @"";
//        self.textField.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView addSubview:self.textField];
        return cell;
    }else{
        MHFenZuCell *cell = [MHFenZuCell cellWithTableView:self.tableView];
    //传回模型
    cell.fenZuFrame = self.fenZuFrame[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHMusicListTableViewController *musicListController = [[MHMusicListTableViewController alloc] init];
    MHFenZuFrame *fenZuFrame = [self.fenZuFrame objectAtIndex:indexPath.row];
    NSString *selectName = fenZuFrame.fenZu.title;
    musicListController.title = selectName;
    MHMusicTool *musicTool = [[MHMusicTool alloc] init];
    musicTool.title = selectName;
    
    [self.navigationController pushViewController:musicListController animated:YES];
}


#pragma mark - Table view Delegate
//设置Cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isLastCell = (indexPath.row == self.fenZuFrame.count);
    if (isLastCell) {
        return 44;
    }else{
    MHFenZuFrame *fenZuFrame = self.fenZuFrame[indexPath.row];
    return fenZuFrame.cellHeight;
    }
}

//设置cell的编辑图标
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {//处于编辑状态，判断行数是否最后一行
    if (indexPath.row == self.fenZuFrame.count) {
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
    }else{//不处于编辑状态，cell状态不变
        return UITableViewCellEditingStyleNone;
    }
}
//实现cell的插入与删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
       if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据
        MHFenZuFrame *fenZuFrame = self.fenZuFrame[indexPath.row];
        MHFenZu *fenZu = fenZuFrame.fenZu;
#pragma woring - 需要添加原始分组不准删除的代码与删除分组时会删除内部歌曲索引的警告
           //删除分组内所有歌曲
           [MHSQLiteTool deleteFMWithFenZu:fenZu.title];
        BOOL result = [MHSQLiteTool deleteFenZu:fenZu];
        if (result) {
        [self.fenZuFrame removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
         [self.tableView reloadData];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
#pragma woring - 未实现数据库操作
    }else if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        if (self.textField.text.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加失败" message:@"标题不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }else{
            // 增加数据模型
        MHFenZu* fenZu = [[MHFenZu alloc] init];
        fenZu.title = self.textField.text;
        fenZu.icon = @"newFenZu";
       
        //实现数据库增加
        BOOL result = [MHSQLiteTool addFenZu:fenZu];
            
            if (result) {//数据库添加成功
                //转换数据模型为Frame模型
                MHFenZuFrame *fenZuFrame = [[MHFenZuFrame alloc] init];
                fenZuFrame.fenZu = fenZu;
                //更改内存以及表视图
                [self.fenZuFrame insertObject:fenZuFrame atIndex:[self.fenZuFrame count]];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                //刷新数据
                [self.tableView reloadData];
                //弹出成功提示
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }else{//数据库添加失败
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加失败" message:@"标题不可重复" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
        }
    }
    [self.view endEditing:YES];
}
//设置非编辑时cell最后一行不可用
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.fenZuFrame count]) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark - UIViewController生命周期方法，用于想用视图编辑状态的方法

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.textField.hidden = NO;
    }else{
        self.textField.hidden = YES;
        [self.view endEditing:YES];
    }
}

#pragma mark -- UITextFieldDelegate委托方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma mark -- UITextFieldDelegate委托方法,避免键盘遮挡文本框
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*)textField.superview.superview.superview;
    [self.tableView setContentOffset:CGPointMake(0.0, cell.frame.origin.y) animated:YES];
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
