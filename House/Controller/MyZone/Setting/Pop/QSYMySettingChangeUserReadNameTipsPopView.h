//
//  QSYMySettingChangeUserReadNameTipsPopView.h
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///修改姓名的回调
typedef enum
{

    mMysettingChangeNameActionTypeCancel = 99,  //!<取消
    mMysettingChangeNameActionTypeConfirm,      //!<确认

}MYSETTING_CHANGE_NAME_ACTION_TYPE;

@interface QSYMySettingChangeUserReadNameTipsPopView : UIView

/**
 *  @author         yangshengmeng, 15-04-12 12:04:23
 *
 *  @brief          创建一个修改用户真姓名的提示框
 *
 *  @param frame    大小和位置
 *  @param callBack 确认或者取消时的回调
 *
 *  @return         返回当前创建的提示框
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(MYSETTING_CHANGE_NAME_ACTION_TYPE actionType,id parmas))callBack;

@end
