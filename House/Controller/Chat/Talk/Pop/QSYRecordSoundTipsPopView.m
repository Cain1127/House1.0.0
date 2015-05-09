//
//  QSYRecordSoundTipsPopView.m
//  House
//
//  Created by ysmeng on 15/5/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecordSoundTipsPopView.h"

#import "QSUserSimpleDataModel.h"
#import "QSYSendMessageVideo.h"

@interface QSYRecordSoundTipsPopView ()

@property (nonatomic,strong) UIImageView *tipsImageView;//!<指示图片

@end

@implementation QSYRecordSoundTipsPopView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
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

    return NO;

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
    
    return messageModel;

}

@end
