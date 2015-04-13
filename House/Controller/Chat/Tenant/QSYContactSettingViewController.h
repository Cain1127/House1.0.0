//
//  QSYContactSettingViewController.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

///联系人设置回调
typedef enum
{

    cContactSettingCallBackActionTypeAddContact = 99,
    cContactSettingCallBackActionTypeDeleteContact,

}CONTACT_SETTING_CALLBACK_ACTION_TYPE;

@interface QSYContactSettingViewController : QSTurnBackViewController

/**
 *  @author             yangshengmeng, 15-04-13 15:04:00
 *
 *  @brief              根据联系人的ID，创建联系人信息设置页面
 *
 *  @param contactID    联系人ID
 *  @param contactName  联系人名
 *  @param isFriend     是否是当前用户的联系人
 *  @param isImport     是否是重点联系人
 *  @param callBack     联系人的部分设置回调：如添加成为联系人
 *
 *  @return             返回当前创建的联系人设置页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID andContactName:(NSString *)contactName isFriends:(NSString *)isFriend isImport:(NSString *)isImport andCallBack:(void(^)(CONTACT_SETTING_CALLBACK_ACTION_TYPE actionType,id params))callBack;

@end
