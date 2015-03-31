//
//  QSNewHouseActivityView.h
//  House
//
//  Created by ysmeng on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///活动回调类型
typedef enum
{

    aActivityCallBackActionTypeDetail = 0,//!<进入活动详情页
    aActivityCallBackActionTypeSignUP,

}ACTIVITY_CALLBACK_ACTION_TYPE;

/**
 *  @author yangshengmeng, 15-03-11 12:03:14
 *
 *  @brief  新房活动页自定义view
 *
 *  @since  1.0.0
 */
@class QSActivityDataModel;
@interface QSNewHouseActivityView : UIView

/**
 *  @author                     yangshengmeng, 15-03-11 12:03:16
 *
 *  @brief                      根据报名按钮点击后的回调，创建活动页面
 *
 *  @param frame                大小和位置
 *  @param signButtonCallBack   点击报名按钮的回调
 *
 *  @return                     返回活动页
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSignUpButtonCallBack:(void(^)(ACTIVITY_CALLBACK_ACTION_TYPE actionType))signButtonCallBack;

/**
 *  @author         yangshengmeng, 15-03-11 12:03:37
 *
 *  @brief          根据给定的数据模型，更新活动UI
 *
 *  @param model    活动模型
 *
 *  @since          1.0.0
 */
- (void)updateNewHouseActivityUI:(QSActivityDataModel *)model;

@end
