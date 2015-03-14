//
//  QSYLoginReturnData.h
//  House
//
//  Created by ysmeng on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

/**
 *  @author yangshengmeng, 15-03-14 11:03:09
 *
 *  @brief  登录后的返回数据
 *
 *  @since  1.0.0
 */
@class QSUserDataModel;
@interface QSYLoginReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSUserDataModel *userInfo;//!<用户信息

@end
