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

#define progressPadding 10
#define slider_Y self.slider.center.y
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

- (IBAction)tapProgress:(UITapGestureRecognizer *)sender;
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender;

@end

@implementation MHPlayingViewController
static MHMusicList *playingMusic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)exit:(id)sender {
    
    //离开时移除定时器
    [self removeCurrentTime];
    
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
    NSString *willPlayedMusic = playingMusic.fileName;
    NSString *isPlayingMusic = [MHMusicTool playingMusic].fileName;
    if (![willPlayedMusic isEqualToString:isPlayingMusic]) {
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
        //2.停止播放
        [MHAudioTool stopMusic:playingMusic.fileName];
    //清空播放器
    self.player = nil;
    //停止定时器
    [self removeCurrentTime];
    
}

//开始播放
- (void)startPlayingMusic
{
    //设置界面数据
    if (playingMusic == [MHMusicTool playingMusic]) {
        [self addCurrentTimeTimer];
        //如果是正在播放的音乐则直接返回
        return;
    }
    playingMusic = [MHMusicTool playingMusic];
    self.iconView.image = [UIImage imageNamed:playingMusic.singerIcon];
#warning 还有部分数据没有设置
    //开始播放
   self.player = [MHAudioTool playMusic:playingMusic.fileName];
    
    //设置时长
    self.totalTimeLabel.text = [self stringWithTime:self.player.duration];
    //添加定时器
    [self addCurrentTimeTimer];
}

//时间转换字符串函数
-(NSString *)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
}


#pragma mark - 设置定时器
//添加定时器
- (void)addCurrentTimeTimer
{
    //
    [self updateCurrentTime];
    
    //创建一个每一秒调用一次的定时器
    self.currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
}

//移除定时器
- (void)removeCurrentTime
{
    [self.currentTimeTimer invalidate];
    //清空定时器
    self.currentTimeTimer = nil;
}
//更新播放进度
-(void)updateCurrentTime
{
    //计算进度值
    double progress = self.player.currentTime / self.player.duration;
    //计算滑块的x值
    //计算滑块的x位置
    self.slider.center = CGPointMake((self.progressView.bounds.size.width * progress) + progressPadding, self.progressView.center.y);
    
    //设置当前播放时间
    self.currentTimeLabel.text = [self stringWithTime:self.player.currentTime];
    self.progressView.progress = progress;
}

//点击进度条
- (IBAction)tapProgress:(UITapGestureRecognizer *)sender {
    //获取当前点击的点
    CGPoint tapPoint = [sender locationInView:sender.view];
    NSLog(@"%f,%f",tapPoint.x,tapPoint.y);
    //切换歌曲的currentTime
    self.player.currentTime = (tapPoint.x / sender.view.bounds.size.width) * self.player.duration;
    //跟新播放进度
    [self updateCurrentTime];
}

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    //获得挪动的距离
    CGPoint panedLength = [sender translationInView:sender.view];
    //把挪动清零
    [sender setTranslation:CGPointZero inView:sender.view];
//     NSLog(@"panedLength:%f,%f",panedLength.x,panedLength.y);
    
    //计算滑块的frame
    self.slider.center = CGPointMake(self.slider.center.x + panedLength.x, slider_Y);
//    NSLog(@"slider.center : %f,%f",self.slider.center.x,self.slider.center.y);
    
    //防止滑块越界
    //计算滑块最大的X值
    CGFloat sliderMaxX = self.progressView.bounds.origin.x + self.progressView.bounds.size.width;
    if (self.slider.bounds.origin.x < 0) {
        self.slider.center = CGPointMake(0, slider_Y);
    }else if (self.slider.center.y > sliderMaxX)
    {
        self.slider.center = CGPointMake(sliderMaxX, slider_Y);
    }
    
    
    //设置进度条的进度
    double progress = (self.slider.center.x - progressPadding) / self.progressView.bounds.size.width;
    self.progressView.progress = progress;
    
    
    //设置时间
    NSTimeInterval time = self.player.duration * progress;
    self.currentTimeLabel.text = [self stringWithTime:time];
    
    
    //开始拖动时停止定时器
    if (sender.state == UIGestureRecognizerStateBegan) {
        //停止
        [self removeCurrentTime];
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
        //设置播放器开始播放的时间点
        self.player.currentTime=time;
    //添加定时器
    [self addCurrentTimeTimer];
    }
}


@end
