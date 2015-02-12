//
//  QSGuideLookingforRoomViewController.h
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSGuideHeaderViewController.h"

/**
 *  @author yangshengmeng, 15-01-28 09:01:55
 *
 *  @brief  我要找房指引页
 *
 *  @since  1.0.0
 */
@interface QSGuideLookingforRoomViewController : QSGuideHeaderViewController

/**
 *  @author         yangshengmeng, 15-02-06 14:02:29
 *
 *  @brief          根据给定的城市创建找房指引页
 *
 *  @param cityKey  城市key
 *  @param cityVal  城市val
 *
 *  @return         返回找房指引页
 *
 *  @since          1.0.0
 */
- (instancetype)initWithCityKey:(NSString *)cityKey andCityVal:(NSString *)cityVal;

@end
