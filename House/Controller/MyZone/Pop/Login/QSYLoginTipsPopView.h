//
//  QSYLoginTipsPopView.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///登录/取消按钮事件
typedef enum
{
    
    lLoginTipsActionTypeCancel = 0, //!<出售物业
    lLoginTipsActionTypeLogin,      //!<出租物业
    
}LOGIN_TIPS_ACTION_TYPE;

@interface QSYLoginTipsPopView : UIView

/**
 *  @author         yangshengmeng, 15-04-03 10:04:55
 *
 *  @brief          创建登录提示框
 *
 *  @param frame    大小和位置
 *  @param callBack 提示框内的事件回调
 *
 *  @return         返回当前创建的提示框
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(LOGIN_TIPS_ACTION_TYPE actionType))callBack;

@end
