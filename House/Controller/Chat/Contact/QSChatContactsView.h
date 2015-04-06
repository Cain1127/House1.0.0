//
//  QSChatContactsView.h
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///联系人列表事件类型
typedef enum
{

    cContactListActionTypeLookSecondHandHouse = 9,  //!<查看周边二手房
    cContactListActionTypeGotoContactDetail,        //!<查看联系人详情

}CONTACT_LIST_ACTION_TYPE;

/**
 *  @author yangshengmeng, 15-02-09 11:02:11
 *
 *  @brief  联系人列表
 *
 *  @since  1.0.0
 */
@interface QSChatContactsView : UIView

/**
 *  @author         yangshengmeng, 15-04-03 11:04:18
 *
 *  @brief          创建联系人列表
 *
 *  @param frame    大小和位置
 *  @param userType 当前用户的类型
 *  @param callBack 列表中相关事件的回调
 *
 *  @return         返回当前创建的联系人列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType andCallBack:(void(^)(CONTACT_LIST_ACTION_TYPE actionType,id params))callBack;

/**
 *  @author yangshengmeng, 15-04-03 11:04:53
 *
 *  @brief  更新联系人列表
 *
 *  @since  1.0.0
 */
- (void)rebuildContactsView;

@end
