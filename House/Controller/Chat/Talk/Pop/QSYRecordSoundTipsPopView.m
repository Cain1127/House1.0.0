//
//  QSYRecordSoundTipsPopView.m
//  House
//
//  Created by ysmeng on 15/5/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecordSoundTipsPopView.h"

#import "NSDate+Formatter.h"
#import "NSString+Format.h"

#import "QSUserSimpleDataModel.h"
#import "QSYSendMessageVideo.h"
#import "QSUserSimpleDataModel.h"

#import "QSCoreDataManager+User.h"
#import "QSSocketManager.h"

#import <lame/lame.h>
#import <AVFoundation/AVFoundation.h>

@interface QSYRecordSoundTipsPopView () <AVAudioRecorderDelegate>

@property (nonatomic,copy) NSString *userID;                    //!<用户ID
@property (nonatomic,strong) UIImageView *tipsImageView;        //!<指示图片
@property (nonatomic,strong) AVAudioRecorder *audioRecorder;    //!<音频录音机
@property (nonatomic,retain) NSMutableDictionary *recordSetting;//!<录音格式设置
@property (nonatomic,strong) NSTimer *timer;                    //!<录音声波监控
@property (nonatomic,copy) NSString *localFileName;             //!<录音的本地文件名
@property (nonatomic,copy) NSString *localMP3FileName;          //!<录音的本地MP3保存文件名
@property (nonatomic,retain) NSDate *starDate;                  //!<开始录音时间
@property (nonatomic,retain) NSDate *endDate;                   //!<开始录音时间
@property (nonatomic,assign) BOOL isHaveData;                   //!<是否有录音信息

@end

@implementation QSYRecordSoundTipsPopView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-05-12 10:05:11
 *
 *  @brief          根据当前语音聊天用户的ID，创建一个录音view
 *
 *  @param frame    大小和位置
 *  @param userID   当前聊天对象的用户ID
 *
 *  @return         返回当前的录音view
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)userID
{

    if (self = [super initWithFrame:frame]) {
        
        ///保存参数
        self.userID = userID;
        
        ///搭建UI
        [self createRecordSoundTipsViewUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createRecordSoundTipsViewUI
{

    self.tipsImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 115.0f, 115.0f)];
    self.tipsImageView.image = [UIImage imageNamed:IMAGE_CHAT_RECORDING];
    [self addSubview:self.tipsImageView];

}

#pragma mark - 检测当前的录音
/**
 *  @author yangshengmeng, 15-05-09 13:05:22
 *
 *  @brief  判断当前否存在录音数据
 *
 *  @return 返回判断结果
 *
 *  @since  1.0.0
 */
- (BOOL)isHaveSoundData
{

    return self.isHaveData;

}

#pragma mark - 开始录音
/**
 *  @author yangshengmeng, 15-05-09 13:05:53
 *
 *  @brief  开始录制
 *
 *  @since  1.0.0
 */
- (void)starRecordingSoundMessage
{

    if (![self.audioRecorder isRecording]) {
        
        ///配置录音
        [self setAudioSession];
        
        ///首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        [self.audioRecorder prepareToRecord];
        [self.audioRecorder record];
        self.timer.fireDate = [NSDate distantPast];
        
    }

}

#pragma mark - 停止录音
/**
 *  @author yangshengmeng, 15-05-09 13:05:42
 *
 *  @brief  停止录音
 *
 *  @since  1.0.0
 */
- (void)stopRecordingSoundMessage
{

    self.endDate = [NSDate date];
    [self.audioRecorder stop];
    self.timer.fireDate=[NSDate distantFuture];
    
    ///隐藏声波提示

}

#pragma mark - 发送语音消息
/**
 *  @author yangshengmeng, 15-05-09 13:05:42
 *
 *  @brief  开始上传语音消息
 *
 *  @since  1.0.0
 */
- (QSYSendMessageVideo *)starSendingSoundMessage:(QSUserSimpleDataModel *)contactModel
{

    QSYSendMessageVideo *messageModel = [[QSYSendMessageVideo alloc] init];
    
    ///获取本地用户数据模型
    QSUserSimpleDataModel *localUserModel = (QSUserSimpleDataModel *)[QSCoreDataManager getCurrentUserDataModel];
    
    ///封装数据模型
    messageModel.deviceUUID = APPLICATION_NSSTRING_SETTING([NSString getDeviceUUID], @"-1");
    messageModel.msgID = [NSDate currentDateTimeStamp];
    messageModel.fromID = APPLICATION_NSSTRING_SETTING(localUserModel.id_, @"-1");
    messageModel.toID = APPLICATION_NSSTRING_SETTING(contactModel.id_, @"-1");
    messageModel.readTag = @"-1";
    messageModel.showWidth = 240.0f;
    messageModel.showHeight = 50.0f;
    messageModel.timeStamp = messageModel.msgID;
    
    messageModel.f_name = APPLICATION_NSSTRING_SETTING(localUserModel.username, @"-1");
    messageModel.f_user_type = APPLICATION_NSSTRING_SETTING(localUserModel.user_type, @"-1");
    messageModel.f_leve = APPLICATION_NSSTRING_SETTING(localUserModel.level, @"-1");
    messageModel.f_avatar = APPLICATION_NSSTRING_SETTING(localUserModel.avatar, @"-1");
    
    messageModel.t_name = APPLICATION_NSSTRING_SETTING(contactModel.username, @"-1");
    messageModel.t_user_type = APPLICATION_NSSTRING_SETTING(contactModel.user_type, @"-1");
    messageModel.t_leve = APPLICATION_NSSTRING_SETTING(contactModel.level, @"-1");
    messageModel.t_avatar = APPLICATION_NSSTRING_SETTING(contactModel.avatar, @"-1");
    
    messageModel.unread_count = @"1";
    messageModel.sendType = qQSCustomProtocolChatSendTypePTP;
    messageModel.msgType = qQSCustomProtocolChatMessageTypeVideo;
    
    messageModel.videoURL = self.localFileName;
    messageModel.playTime = [NSString stringWithFormat:@"%.0f",[self.endDate timeIntervalSinceDate:self.starDate]];
    
    ///发送消息
#if 0
    
    [QSSocketManager sendMessageToPerson:messageModel andMessageType:qQSCustomProtocolChatMessageTypeVideo];
    
#endif
    
    return messageModel;

}

#pragma mark - 录音设置
- (void)setAudioSession
{
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
}

- (NSURL *)getSavePathWithFileName:(NSString *)fileName
{
    
    NSString *rootPath = [self getSavePathString];
    
    ///如果已存在对应的路径，返回
    if ([rootPath length] > 0) {
        
        NSString *filePath = [rootPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
        
        ///判断文件是否存在，不存在则创建
        BOOL isExitDirector = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        ///如果已存在对应的路径，返回
        if (isExitDirector) {
            
            NSURL *saveURL = [NSURL fileURLWithPath:filePath];
            return saveURL;
            
        } else {
        
            ///不存在创建
            BOOL isCreateSuccessDirector = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            
            if (isCreateSuccessDirector) {
                
                 NSURL *saveURL = [NSURL fileURLWithPath:filePath];
                return saveURL;
                
            }
        
        }
        
    }
    
    return nil;
    
}

- (NSString *)getSavePathString
{

    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [savePath stringByAppendingPathComponent:@"/audioCache"];
    
    ///判断文件夹是否存在，存在直接返回，不存在则创建
    BOOL isDir = NO;
    BOOL isExitDirector = [[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDir];
    
    ///如果已存在对应的路径，返回
    if (isDir && isExitDirector) {
        
        return rootPath;
        
    }
    
    ///不存在创建
    BOOL isCreateSuccessDirector = [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (isCreateSuccessDirector) {
        
        return rootPath;
        
    }
    
    return nil;

}

///当前录音的文件名
- (NSString *)localFileName
{
    
    if (nil == _localFileName) {
        
        _localFileName = [NSString stringWithFormat:@"%@_%@.caf",self.userID,[NSDate currentDateTimeStamp]];
        
    }
    
    return _localFileName;
    
}

- (NSString *)localMP3FileName
{

    if (nil == _localMP3FileName) {
        
        _localFileName = [self.localFileName stringByReplacingOccurrencesOfString:@".caf" withString:@".mp3"];
        
    }
    
    return _localMP3FileName;

}

///设置录音格式
- (NSDictionary *)getAudioSetting
{
    
    if (nil == _recordSetting) {
        
        ///初始化
        _recordSetting = [NSMutableDictionary dictionary];
        
        //设置录音格式
        [_recordSetting setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        
        //设置录音采样率，8000是电话采样率，对于一般录音已经够了
        [_recordSetting setObject:@(8000) forKey:AVSampleRateKey];
        
        //设置通道,这里采用单声道
        [_recordSetting setObject:@(1) forKey:AVNumberOfChannelsKey];
        
        //每个采样点位数,分为8、16、24、32
        [_recordSetting setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        
        //是否使用浮点数采样
        [_recordSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        //....其他设置等
        
    }
    
    return _recordSetting;
    
}

///录音机对象
- (AVAudioRecorder *)audioRecorder
{
    
    if (!_audioRecorder) {
        
        ///创建录音文件保存路径
        NSURL *url = [self getSavePathWithFileName:self.localFileName];
        self.starDate = [NSDate date];
        
        ///创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        
        ///创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        
        ///如果要监控声波则必须设置为YES
        _audioRecorder.meteringEnabled = YES;
        if (error) {
            
            APPLICATION_LOG_INFO(@"创建录音机对象->发生错误->错误信息：", error.localizedDescription)
            return nil;
            
        }
        
    }
    
    return _audioRecorder;
    
}

///声波监控定时器
- (NSTimer *)timer
{
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
        
    }
    
    return _timer;
    
}

- (void)audioPowerChange
{
    
    ///更新测量值
    [self.audioRecorder updateMeters];
    
    //取得第一个通道的音频，注意音频强度范围时-160到0
    float power = [self.audioRecorder averagePowerForChannel:0];
    
    ///计算当前声波
    CGFloat progress = power + 160.0f;
    
    ///设置录音数据
    if (progress > 60.0f) {
        
        self.isHaveData = YES;
        
    }
    
    ///设置当前声波
    NSString *currentSoundValue = [NSString stringWithFormat:@"%.2f",progress];
    APPLICATION_LOG_INFO(@"当前声波", currentSoundValue)
    
}

#pragma mark - 录音代理
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
    ///转码
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self audio_PCMtoMP3];
        
    });
    
    APPLICATION_LOG_INFO(@"录音", @"完成")
    
}

- (void)audio_PCMtoMP3
{
    
    ///本地mp3保存路径
    NSURL *mp3FilePath = [self getSavePathWithFileName:self.localMP3FileName];
    
    @try {
        
        int read, write;
        
        ///source 被转换的音频文件位置
        FILE *pcm = fopen([self.localFileName cStringUsingEncoding:1], "rb");
        
        ///skip file header
        fseek(pcm, 4 * 1024, SEEK_CUR);
        
        ///output 输出生成的Mp3文件位置
        FILE *mp3 = fopen([mp3FilePath.absoluteString cStringUsingEncoding:1], "wb");
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        //设置1为单通道，默认为2双通道
        lame_set_num_channels(lame,2);
        lame_set_brate(lame,8);
        lame_set_mode(lame,3);
        
        /* 2=high 5 = medium 7=low 音质*/
        lame_set_quality(lame,5);
        
        do {
            
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0) {
                
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                
            } else {
                
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
            }
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",[exception description]);
        
    } @finally {
        
        self.localMP3FileName = mp3FilePath.absoluteString;
        NSLog(@"MP3生成成功: %@",self.localMP3FileName);
        
    }
    
}

@end
