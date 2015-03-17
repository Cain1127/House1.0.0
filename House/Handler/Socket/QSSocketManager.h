//
//  QSSocketManager.h
//  House
//
//  Created by ysmeng on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSSocketManager : NSObject

/**
 *  @author yangshengmeng, 15-03-17 14:03:18
 *
 *  @brief  socket单例
 *
 *  @return 返回当前的socket管理器
 *
 *  @since  1.0.0
 */
+ (instancetype)shareSocketManager;

- (void)sendMessageToPersion:(NSString *)tID andMessage:(NSString *)msg;

@end
