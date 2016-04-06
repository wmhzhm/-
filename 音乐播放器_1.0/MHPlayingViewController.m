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
#import "UIImage+MJ.h"
#import "MHSQLiteTool.h"

#define progressPadding 10
#define slider_Y self.slider.center.y
#define borderWidthWorth 10
#define loopAll @"loop_all"
#define loopSelf @"loop_self"
#define random  @"random"


@interface MHPlayingViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *slider;//滑块
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;//当前时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;//总时长
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;//进度条
@property (weak, nonatomic) IBOutlet UIImageView *iconView;//背景图片
//@property (strong ,nonatomic) MHMusicList *playingMusic;
@property (weak, nonatomic) IBOutlet UIImageView *iconViewBcg;
//循环设置按钮
@property (weak, nonatomic) IBOutlet UIButton *loopBtn;
//音乐器播放对象
@property (strong ,nonatomic) AVAudioPlayer *currentPlayer;
//定时器
@property (strong ,nonatomic) NSTimer *currentTimeTimer;
@property (strong ,nonatomic) NSTimer *rotateTimer;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *loopLabel;

@property (copy ,nonatomic) NSString *loopSet;

- (IBAction)tapProgress:(UITapGestureRecognizer *)sender;
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender;
- (IBAction)previous;
- (IBAction)next;
- (IBAction)playOrPause;
- (IBAction)loopSetting;

@end

@implementation MHPlayingViewController
static MHMusicList *playingMusic;
//static NSString *loopSet;

//static AVAudioPlayer *player;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loopLabel.layer.masksToBounds = YES;
    self.loopLabel.layer.cornerRadius = 12;
    self.loopLabel.backgroundColor = [UIColor blackColor];
//    self.loopLabel.layer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 100;
    self.iconViewBcg.layer.masksToBounds = YES;
    self.iconViewBcg.layer.cornerRadius = 110;
    self.iconViewBcg.image = [UIImage imageNamed:@"iconViewBcg"];
    //执行图片旋转
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(rotate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rotateTimer forMode:NSRunLoopCommonModes];
    
    //查询循坏设置
    self.loopSet = [MHSQLiteTool loopSetWorth];
    if (!self.loopSet) {
        [MHSQLiteTool initLoopSet];//初始化为全体循环
    }
    self.loopSet = [MHSQLiteTool loopSetWorth];
    
    [self setLoopBtnImage];
}

//实现图片旋转
- (void)rotate
{
    //弧度 = 度数 / 180 * M_PI
    _iconView.transform = CGAffineTransformRotate(_iconView.transform, 0.1 / 180 * M_PI);
}

//设置循环按钮的图片
- (void)setLoopBtnImage
{
    if ([self.loopSet isEqualToString:loopAll]) {
        [self.loopBtn setImage:[UIImage imageNamed:@"循环播放_btn"] forState:UIControlStateNormal];
    }else if ([self.loopSet isEqualToString:loopSelf])
    {
        [self.loopBtn setImage:[UIImage imageNamed:@"单曲循环_btn"] forState:UIControlStateNormal];
    }//endElseIf
    else if ([self.loopSet isEqualToString:random])
    {
        [self.loopBtn setImage:[UIImage imageNamed:@"随机播放_btn"] forState:UIControlStateNormal];
    }//endElseIf
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
    self.iconView.image = [UIImage imageNamed:@"playing_background"];
//    self.iconView.image = [UIImage circleImageWithName:@"playing_background" borderWidth:borderWidthWorth borderColor:[UIColor blackColor]];
        //2.停止播放
        [MHAudioTool stopMusic:playingMusic.fileName];
    //清空播放器
    self.currentPlayer = nil;
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
//        self.iconView.image = [UIImage circleImageWithName:playingMusic.singerIcon borderWidth:borderWidthWorth borderColor:[UIColor blackColor]];
#warning 还有部分数据没有设置
    //开始播放
    AVAudioPlayer *player = [MHAudioTool playMusic:playingMusic.fileName];
    player.delegate = self;
    self.currentPlayer = player;
    //设置时长
    self.totalTimeLabel.text = [self stringWithTime:self.currentPlayer.duration];
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
    self.currentTimeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
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
    double progress = self.currentPlayer.currentTime / self.currentPlayer.duration;
    //计算滑块的x值
    //计算滑块的x位置
    self.slider.center = CGPointMake((self.progressView.bounds.size.width * progress) + progressPadding, self.progressView.center.y);
    
    //设置当前播放时间
    self.currentTimeLabel.text = [self stringWithTime:self.currentPlayer.currentTime];
    self.progressView.progress = progress;
//    NSLog(@"%f,%f",self.player.currentTime,self.player.duration);
//    if ((int)self.player.currentTime == (int)self.player.duration) {
//        [self next];
//    }
    
}

//点击进度条
- (IBAction)tapProgress:(UITapGestureRecognizer *)sender {
    //获取当前点击的点
    CGPoint tapPoint = [sender locationInView:sender.view];
    NSLog(@"%f,%f",tapPoint.x,tapPoint.y);
    //切换歌曲的currentTime
    self.currentPlayer.currentTime = (tapPoint.x / sender.view.bounds.size.width) * self.currentPlayer.duration;
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
    
    //防止滑块越界
    //计算滑块最大的X值
    CGFloat sliderMaxX = self.progressView.bounds.origin.x + self.progressView.bounds.size.width;
    if (self.slider.bounds.origin.x < 0) {
        self.slider.center = CGPointMake(0, slider_Y);
          self.totalTimeLabel.text = [self stringWithTime:0];
    }else if (self.slider.center.y > sliderMaxX)
    {
        self.slider.center = CGPointMake(sliderMaxX, slider_Y);
        self.totalTimeLabel.text = [self stringWithTime:self.currentPlayer.duration];
    }
    
    
    //设置进度条的进度
    double progress = (self.slider.center.x - progressPadding) / self.progressView.bounds.size.width;
    self.progressView.progress = progress;
    
    
    //设置时间
    NSTimeInterval time = self.currentPlayer.duration * progress;
    self.currentTimeLabel.text = [self stringWithTime:time];
    
    
    //开始拖动时停止定时器
    if (sender.state == UIGestureRecognizerStateBegan) {
        //停止
        [self removeCurrentTime];
    }else if (sender.state == UIGestureRecognizerStateEnded)
    {
        //设置播放器开始播放的时间点
        self.currentPlayer.currentTime=time;
    //添加定时器
    [self addCurrentTimeTimer];
    }
}

//上一首歌曲
- (IBAction)previous {
    //开始播放之前先警用一切app点击事件，防止误操作
     UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    //重置当前的歌曲
    [self ResetPlayingMusic];
    
    //获得上一首歌曲
    [MHMusicTool setPlayingMusic:[MHMusicTool perviousMusic]];
    
    //播放
    [self startPlayingMusic];
    
    //恢复app点击功能
    window.userInteractionEnabled = YES;
}

//下一首歌曲
- (IBAction)next {
    //开始播放之前先警用一切app点击事件，防止误操作
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    //重置当前的歌曲
    [self ResetPlayingMusic];
    
    //获得下一首歌曲
    [MHMusicTool setPlayingMusic:[MHMusicTool nextMusic]];
    
    //播放
    [self startPlayingMusic];
    
    //恢复app点击功能
    window.userInteractionEnabled = YES;
    
}

//单曲循环
- (void)loopCurrentMusic
{
        //开始播放之前先警用一切app点击事件，防止误操作
        UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
        window.userInteractionEnabled = NO;
        
        //重置当前的歌曲
        [self ResetPlayingMusic];
        
        //获得本首歌曲
        [MHMusicTool setPlayingMusic:[MHMusicTool replayMusic]];
        
        //播放
        [self startPlayingMusic];
        
        //恢复app点击功能
        window.userInteractionEnabled = YES;
}

//随机播放
- (void)randomPlay
{
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    //重置当前的歌曲
    [self ResetPlayingMusic];
    
    //获得随机得到的歌曲
    [MHMusicTool setPlayingMusic:[MHMusicTool randomMusic]];
    
    //播放
    [self startPlayingMusic];
    
    //恢复app点击功能
    window.userInteractionEnabled = YES;
}

//播放模式Label显示（渐变消失）
- (void)loopLabelShowWithModel:(NSString *)model
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled=NO;
    
    self.loopLabel.hidden = NO;
    self.loopLabel.alpha = 0;
    [UIView animateWithDuration:1.5 animations:^{
          [self.loopLabel setTitle:model forState:UIControlStateNormal];
        self.loopLabel.alpha = 0.5;
    }completion:^(BOOL finished)
    {
        [UIView animateWithDuration:1.0 animations:^{
            self.loopLabel.alpha = 0;
        }completion:^(BOOL finished){
            self.loopLabel.hidden = YES;
                window.userInteractionEnabled = YES;
        }];
    }];
}

//暂停或播放
- (IBAction)playOrPause {
    if (!self.playOrPauseButton.isSelected) {//暂停播放
        self.playOrPauseButton.selected = YES;
        //改变图标
//        self.playOrPauseButton.imageView.image = [UIImage imageNamed:@"pause_btn"];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        //暂停
        [MHAudioTool pauseMusic:playingMusic.fileName];
        //移除定时器
        [self removeCurrentTime];
    }else
    {
        self.playOrPauseButton.selected = NO;
        //改变图标
//        self.playOrPauseButton.imageView.image = [UIImage imageNamed:@"play_btn"];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        //播放
        [MHAudioTool playMusic:playingMusic.fileName];
        //添加定时器
        [self addCurrentTimeTimer];
    }
    
}
//播放模式设置
- (IBAction)loopSetting {
    UIWindow *window=[[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;

    if ([self.loopSet isEqualToString:loopAll]) {
        //是全体循环则变成单曲循环
        //改变静态变量
        self.loopSet = loopSelf;
        [MHSQLiteTool updateLoopSetWithModel:self.loopSet];
//        [self.loopLabel setTitle:@"单曲循环" forState:UIControlStateNormal];
        [self loopLabelShowWithModel:@"单曲循环"];
    }else if([self.loopSet isEqualToString:loopSelf]) {
        //是单曲循环则变成随机播放
         //改变静态变量
        self.loopSet = random;
        [MHSQLiteTool updateLoopSetWithModel:self.loopSet];
//        [self.loopLabel setTitle:@"随机播放" forState:UIControlStateNormal];
        [self loopLabelShowWithModel:@"随机播放"];
    }else if ([self.loopSet isEqualToString:random]) {
        //是随机播放则变成全体循环
         //改变静态变量
        self.loopSet = loopAll;
        [MHSQLiteTool updateLoopSetWithModel:self.loopSet];
//        [self.loopLabel setTitle:@"全体循环" forState:UIControlStateNormal];
        [self loopLabelShowWithModel:@"全体循环"];
    }
    [self setLoopBtnImage];
    window.userInteractionEnabled = YES;
}



#pragma mark - AVAudioPlayer,delegate方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"finish");
    if(flag)
    {
        if ([self.loopSet isEqualToString:loopAll]) {
            [self next];
        }else if ([self.loopSet isEqualToString:loopSelf])
        {
            [self loopCurrentMusic];
        }//endElseIf
        else if ([self.loopSet isEqualToString:random])
        {
            [self randomPlay];
        }//endElseIf
    }
}

@end
