//
//  MHOnlineMusicController.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/16.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHOnlineMusicController.h"

@interface MHOnlineMusicController ()
@property (strong ,nonatomic) UISearchBar *searchBar;
@end

@implementation MHOnlineMusicController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置view背景：添加一个imageview到view中
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"1706442046308353"];
    [self.view addSubview:backgroundImageView];
//    UISearchBar *searchBar = [[UISearchBar alloc] init];
//    self.searchBar = searchBar;
//    [self.view addSubview:self.searchBar];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
