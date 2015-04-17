//
//  QSYSystemSettingViewController.h
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

///系统设置时相关事件回调
typedef enum
{

    sSystemSettingActionTypeLogout = 99,//!<退出登录
    sSystemSettingActionTypeLogin,      //!<登录

}SYSTEMSETTING_ACTION_TYPE;

@interface QSYSystemSettingViewController : QSTurnBackViewController

///系统设置相关事件回调
@property (nonatomic,copy) void(^systemSettingCallBack)(SYSTEMSETTING_ACTION_TYPE actionType,id params);

@end
