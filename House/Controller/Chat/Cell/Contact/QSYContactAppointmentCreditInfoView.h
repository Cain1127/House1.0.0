//
//  QSYContactAppointmentCreditInfoView.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QSYContactDetailInfoModel;
@interface QSYContactAppointmentCreditInfoView : UIView

/**
 *  @author             yangshengmeng, 15-04-07 18:04:06
 *
 *  @brief              创建用户统计信息的UI
 *
 *  @param frame        大小和位置
 *  @param houseType    房子的类型
 *
 *  @return             返回当前创建的用户统计信息UI
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andHouseType:(USER_COUNT_TYPE)userType;

/**
 *  @author             yangshengmeng, 15-04-03 18:04:39
 *
 *  @brief              刷新联系人信用信息
 *
 *  @param userModel    联系人数据模型
 *
 *  @since              1.0.0
 */
- (void)updateContactInfoUI:(QSYContactDetailInfoModel *)userModel;

@end
