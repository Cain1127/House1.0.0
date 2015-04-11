//
//  QSYSendMessageVideo.h
//  House
//
//  Created by ysmeng on 15/4/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSendMessageBaseModel.h"

@interface QSYSendMessageVideo : QSYSendMessageBaseModel

@property (nonatomic,copy) NSString *videoURL;//!<音频聊天数据
@property (nonatomic,copy) NSString *playTime;//!<播放时长

@end
