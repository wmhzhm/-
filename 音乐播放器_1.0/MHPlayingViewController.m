//
//  MHPlayingViewController.m
//  音乐播放器_1.0
//
//  Created by wmh—future on 16/3/28.
//  Copyright © 2016年 wmh—future. All rights reserved.
//

#import "MHPlayingViewController.h"
#import "MHMusicTool.h"
#import "MHAudioTool.h"
#import "MHMusicList.h"

@interface MHPlayingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *slider;//滑块
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;//当前时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;//总时长
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//进度条
@property (weak, nonatomic) IBOutlet UIImageView *iconView;//背景图片
//@property (strong ,nonatomic) MHMusicList *playingMusic;
//音乐器播放对象
@property (strong ,nonatomic) AVAudioPlayer *player;
//定时器
@property (strong ,nonatomic) NSTimer *currentTimeTimer;
@end

@implementation MHPlayingViewController
static MHMusicList *playingMusic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)exit:(id)sender {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
        window.userInteractionEnabled=NO;
        //2.动画隐藏View
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
                 window.userInteractionEnabled=YES;
                     //设置view隐藏能够节省一些性能
                self.view.hidden=YES;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//界面显示
- (void)show
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled=NO;
 
    //2.添加播放界面
     //设置View的大小为覆盖整个窗口
    self.view.frame=window.bounds;
    //设置view显示
   self.view.hidden=NO;
    //把View添加到窗口上
    [window addSubview:self.view];
    //  检测歌曲是否被更换
    if (playingMusic != [MHMusicTool playingMusic]) {
        [self ResetPlayingMusic];
    }
    
//  //3.使用逐渐显示动画让View显示
    self.view.alpha = 0;
      [UIView animateWithDuration:0.5 animations:^{
          self.view.alpha = 1;
         } completion:^(BOOL finished) {
             //  设置音乐数据
             [self startPlayingMusic];
              window.userInteractionEnabled=YES;
         }];
}
//重置音乐
-(void)ResetPlayingMusic
{
         //1.重置界面数据
         self.iconView.image=[UIImage imageNamed:@"playing_background"];

        NSString *fileName = playingMusic.fileName;
        //2.停止播放
        [MHAudioTool stopMusic:playingMusic.fileName];
}

//开始播放
- (void)startPlayingMusic
{
    //设置界面数据
    if (playingMusic == [MHMusicTool playingMusic]) {
        //如果是正在播放的音乐则直接返回
        return;
    }
    playingMusic = [MHMusicTool playingMusic];
    self.iconView.image = [UIImage imageNamed:playingMusic.singerIcon];
#warning 还有部分数据没有设置
    //开始播放
    [MHAudioTool playMusic:playingMusic.fileName];
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
