//
//  QSYMessageVideoTableViewCell.m
//  House
//
//  Created by ysmeng on 15/4/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMessageVideoTableViewCell.h"

#import "NSString+Calculation.h"
#import "NSDate+Formatter.h"

#import "QSYSendMessageVideo.h"

#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>

///关联
static char UserIconKey;    //!<头像关联
static char SecondKey;      //!<秒数关联
static char TimeStampKey;   //!<时间戳

@interface QSYMessageVideoTableViewCell () <AVAudioPlayerDelegate>

@property (nonatomic,assign) MESSAGE_FROM_TYPE messageType; //!<消息的归属类型
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;    //!<音频播放器，用于播放录音文件
@property (nonatomic,copy) NSString *audioFileName;         //!<语音文件地址
@property (nonatomic,strong) UIView *indicatorRootView;     //!<语音消息指示的底view
@property (nonatomic,strong) UIButton *indicatorView;       //!<语音消息指示图片
@property (nonatomic,strong) NSTimer *timer;                //!<播放语音时的动画定时器
@property (assign) CGRect indicatorFrame;                   //!<语音播放指示图片的原始frame

@end

@implementation QSYMessageVideoTableViewCell

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-04-06 13:04:23
 *
 *  @brief                  创建音频聊天显示框
 *
 *  @param style            风格
 *  @param reuseIdentifier  复用标签
 *  @param isMyMessage      消息是当前用户的还是其他人发送过来的
 *
 *  @return                 返回当前创建的文字聊天信息展示框
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMessageType:(MESSAGE_FROM_TYPE)isMyMessage
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///保存消息类型
        self.messageType = isMyMessage;
        
        ///搭建UI
        [self createMessageVideoUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createMessageVideoUI
{

    ///根据消息的类型，计算不同控件的坐标
    CGFloat xpointIcon = SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat xpointArrow = xpointIcon + 40.0f + 3.0f;
    CGFloat xpointMessage = xpointArrow + 5.0f;
    CGFloat widthMessage = 120.0f;
    CGFloat xpointSecond = xpointMessage + widthMessage + 2.0f;
    CGFloat widthSecond = 40.0f;
    CGFloat xpointIndicator = 10.0f;
    if (mMessageFromTypeMY == self.messageType) {
        
        xpointIcon = SIZE_DEVICE_WIDTH - 40.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
        xpointArrow = xpointIcon - 3.0f - 5.0f;
        xpointMessage = xpointArrow - widthMessage;
        xpointSecond = xpointMessage - 2.0f - widthSecond;
        xpointIndicator = widthMessage - 49.0f;
        
    }
    
    ///时间戳
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 180.0f) / 2.0f, 15.0f, 180.0f, 15.0f)];
    timeLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [self.contentView addSubview:timeLabel];
    objc_setAssociatedObject(self, &TimeStampKey, timeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(xpointIcon, timeLabel.frame.origin.y + timeLabel.frame.size.height + 8.0f, 40.0f, 40.0f)];
    iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    [self.contentView addSubview:iconView];
    objc_setAssociatedObject(self, &UserIconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像六角
    QSImageView *iconSixformView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconView.frame.size.width, iconView.frame.size.height)];
    iconSixformView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconView addSubview:iconSixformView];
    
    ///指示三角
    QSImageView *arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(xpointArrow, iconView.frame.origin.y + 20.0f - 7.5f, 5.0f, 15.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHAT_MESSAGE_SENDER_ARROW_HIGHLIGHTED];
    if (mMessageFromTypeMY == self.messageType) {
        
        arrowIndicator.image = [UIImage imageNamed:IMAGE_CHAT_MESSAGE_MY_ARROW_NORMAL];;
        
    }
    [self.contentView addSubview:arrowIndicator];
    
    ///秒数
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(xpointSecond, iconView.frame.origin.y, widthSecond, 50.0f)];
    secondLabel.textAlignment = NSTextAlignmentRight;
    secondLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    secondLabel.text = @"7''";
    [self.contentView addSubview:secondLabel];
    objc_setAssociatedObject(self, &SecondKey, secondLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///消息图片底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(xpointMessage, iconView.frame.origin.y, widthMessage, 50.0f)];
    rootView.layer.cornerRadius = 4.0f;
    rootView.backgroundColor = COLOR_CHARACTERS_LIGHTGRAY;
    if (mMessageFromTypeMY == self.messageType) {
        
        rootView.backgroundColor = COLOR_CHARACTERS_YELLOW;
        
    }
    [self.contentView addSubview:rootView];
    
    ///语音指示的底图
    self.indicatorFrame = CGRectMake(xpointIndicator, 3.0f, 44.0f, 44.0f);
    self.indicatorRootView = [[UIView alloc] initWithFrame:self.indicatorFrame];
    self.indicatorView.clipsToBounds = YES;
    [rootView addSubview:self.indicatorRootView];
    
    ///语音图片
    self.indicatorView = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断是否正在播放
        if (![_audioPlayer isPlaying]) {
            
            ///播放音频
            [self audioPlayerWithAudioName:self.audioFileName];
            
            ///改变指示动画
            button.selected = YES;
            self.timer.fireDate = [NSDate distantPast];
            
        }
        
    }];
    [self.indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_SENDER_INDICATOR_NORMAL] forState:UIControlStateNormal];
    [self.indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_SENDER_INDICATOR_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_SENDER_INDICATOR_SELECTED] forState:UIControlStateSelected];
    if (mMessageFromTypeMY) {
        
        [self.indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_MY_INDICATOR_NORMAL] forState:UIControlStateNormal];
        [self.indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_MY_INDICATOR_HIGHLIGHTED] forState:UIControlStateHighlighted];
        [self.indicatorView setImage:[UIImage imageNamed:IMAGE_CHAT_MESSAGE_SOUND_MY_INDICATOR_SELECTED] forState:UIControlStateSelected];
        
    }
    [self.indicatorRootView addSubview:self.indicatorView];

}

#pragma mark - 播放语音时的动画定时器
- (NSTimer *)timer
{

    if (nil == _timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(changePlayingImage) userInfo:nil repeats:YES];
        
    }
    
    return _timer;

}

- (void)changePlayingImage
{
    
    int rangeWith = rand() % 30;
    
    ///设置当前声波
    CGFloat xpointIndicator = 10.0f;
    CGFloat widthIndicator = 14.0f + rangeWith;
    if (mMessageFromTypeMY == self.messageType) {
        
        xpointIndicator = 120.0f - widthIndicator - 5.0f;
        
    }
    self.indicatorRootView.frame = CGRectMake(xpointIndicator, self.indicatorFrame.origin.y, widthIndicator, self.indicatorFrame.size.height);

}

#pragma mark - 录音播放
///录音播放对象
- (void)audioPlayerWithAudioName:(NSString *)audioFileName
{
    
    if ([audioFileName length] <= 0) {
        
        return;
        
    }
    
    NSURL *audioURL = [self getSavePathWithFileName:audioFileName];
    
    ///停止原播放器
    if ([_audioPlayer isPlaying]) {
        
        [_audioPlayer stop];
        _audioPlayer = nil;
        
    }
    
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    _audioPlayer.numberOfLoops = 0;
    [_audioPlayer prepareToPlay];
    _audioPlayer.delegate = self;
    if (error) {
        
        APPLICATION_LOG_INFO(@"创建播放器->发生错误->错误信息：", error.localizedDescription)
        return;
        
    }
    
    [_audioPlayer play];
    
}

- (NSURL *)getSavePathWithFileName:(NSString *)fileName
{
    
    NSString *rootPath = [self getSavePathString];
    NSString *filePath = [rootPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    NSURL *saveURL = [NSURL fileURLWithPath:filePath];
    
    return saveURL;
    
}

- (NSString *)getSavePathString
{
    
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [savePath stringByAppendingPathComponent:@"/audioCache"];
    return rootPath;
    
}

#pragma mark - 刷新UI
- (void)updateMessageWordUI:(QSYSendMessageVideo *)model
{
    
    ///更新时间戳
    UILabel *timeLabel = objc_getAssociatedObject(self, &TimeStampKey);
    if (timeLabel && [model.timeStamp length] > 0) {
        
        timeLabel.text = [NSDate formatNSTimeToNSDateString:model.timeStamp];
        
    }
    
    ///更新头像
    UIImageView *icontView = objc_getAssociatedObject(self, &UserIconKey);
    if (icontView && [model.f_avatar length] > 0) {
        
        [icontView loadImageWithURL:[model.f_avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    } else {
        
        icontView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
        
    }
    
    ///更新音频秒数
    UILabel *secondLabel = objc_getAssociatedObject(self, &SecondKey);
    if ([model.playTime floatValue] > 0.5f) {
        
        secondLabel.text = [NSString stringWithFormat:@"%@''",model.playTime];
        
    } else {
    
        secondLabel.text = nil;
    
    }
    
    ///保存语音本地路径
    if ([model.videoURL length] > 0) {
        
        self.audioFileName = model.videoURL;
        
    } else {
    
        self.audioFileName = nil;
    
    }
    
}

#pragma mark - 录音播放
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    self.indicatorRootView.frame = self.indicatorFrame;
    self.indicatorView.selected = NO;
    self.timer.fireDate = [NSDate distantFuture];
    [self.timer invalidate];
    self.timer = nil;

}

@end
