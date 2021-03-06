//
//  QSYRecordSoundTipsPopView.h
//  House
//
//  Created by ysmeng on 15/5/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSUserSimpleDataModel;
@class QSYSendMessageVideo;
@interface QSYRecordSoundTipsPopView : UIView

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
- (instancetype)initWithFrame:(CGRect)frame withUserID:(NSString *)userID;

/**
 *  @author yangshengmeng, 15-05-09 13:05:22
 *
 *  @brief  判断当前否存在录音数据
 *
 *  @return 返回判断结果
 *
 *  @since  1.0.0
 */
- (BOOL)isHaveSoundData;

/**
 *  @author yangshengmeng, 15-05-09 13:05:53
 *
 *  @brief  开始录制
 *
 *  @since  1.0.0
 */
- (void)starRecordingSoundMessage;

/**
 *  @author yangshengmeng, 15-05-09 13:05:42
 *
 *  @brief  停止录音
 *
 *  @since  1.0.0
 */
- (void)stopRecordingSoundMessage;

/**
 *  @author yangshengmeng, 15-05-09 13:05:42
 *
 *  @brief  开始上传语音消息
 *
 *  @since  1.0.0
 */
- (QSYSendMessageVideo *)starSendingSoundMessage:(QSUserSimpleDataModel *)contactModel;

@end
