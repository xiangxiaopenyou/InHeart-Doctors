//
//  AudioPlayerView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/24.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "AudioPlayerView.h"
#import <GJCFUitils.h>
#import <UIImageView+WebCache.h>
@interface AudioPlayerView ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *playingTime;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *maxTime;
@property (weak, nonatomic) IBOutlet UISlider *paceSlider;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (copy, nonatomic) NSString *audioUrlString;
@property (strong, nonatomic) id playTimeObserver;
@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) BOOL isRemoveNot; //是否移除通知

@end
@implementation AudioPlayerView

- (void)setupContents:(NSString *)urlString imageUrl:(NSString *)imageUrlString {
    _audioUrlString = urlString;
    self.playButton.hidden = NO;
    self.paceSlider.enabled = YES;
    [self.backgroundImageView sd_setImageWithURL:XLURLFromString(imageUrlString) placeholderImage:nil];
}
#pragma mark - Getters
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (void)updateAudioPlayer:(NSString *)urlString {
    if (_isRemoveNot) {
        [self removeObserverAndNotification];
        [self initialControls];
        _isRemoveNot = NO;
    }
    self.playerItem = [AVPlayerItem playerItemWithURL:XLURLFromString(urlString)];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self monitoringPlayback:self.playerItem];  //监听播放状态
    [self addEndTimeNotification];
    //[self play];
    _isRemoveNot = YES;
}


// 各控件设初始值
- (void)initialControls{
    [self stop];
    self.playingTime.text = @"00:00";
    self.paceSlider.value = 0.0f;
}

- (void)stop {
    _isPlaying = NO;
    [self.player pause];
    self.playButton.selected = NO;
}
- (void)play {
    _isPlaying = YES;
    [self.player play];
    self.playButton.selected = YES;
}

#pragma mark - _playTimeObserver
- (void)monitoringPlayback:(AVPlayerItem *)item {
    GJCFWeakObject(self) weakSelf = self;
    //这里设置每秒执行30次
    _playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 计算当前在第几秒
        float currentPlayTime = (double)item.currentTime.value/item.currentTime.timescale;
        [weakSelf updateVideoSlider:currentPlayTime];
    }];
}
- (void)updateVideoSlider:(float)currentTime{
    self.paceSlider.value = currentTime;
    self.playingTime.text = XLConvertTime(currentTime);
}
//播放完成
-(void)addEndTimeNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
#pragma mark - KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([self.playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            CMTime duration = item.duration;// 获取音频总长度
            [self setMaxDuratuin:CMTimeGetSeconds(duration)];
            [self play];
        }else if([self.playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            [self stop];
        }
    }
}
#pragma mark - 移除通知&KVO
- (void)removeObserverAndNotification{
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)setMaxDuratuin:(float)duration{
    self.paceSlider.maximumValue = duration;
    self.maxTime.text = XLConvertTime(duration);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)changeSlider:(id)sender {
    CMTime dragedCMTime = CMTimeMake(self.paceSlider.value, 1);
    [self.playerItem seekToTime:dragedCMTime];
}
- (void)playbackFinished:(NSNotification *)notify {
    
}
- (IBAction)playClick:(id)sender {
    if (_isPlaying) {
        [self stop];
    } else {
        if (self.playerItem) {
            [self play];
        } else {
            [self updateAudioPlayer:_audioUrlString];
        }
    }
    
}

@end
