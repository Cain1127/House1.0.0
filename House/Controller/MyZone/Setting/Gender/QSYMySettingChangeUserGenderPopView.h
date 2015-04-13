//
//  QSYMySettingChangeUserGenderPopView.h
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///修改姓名的回调
typedef enum
{
    
    mMysettingChangeGenderActionTypeCancel = 99,  //!<取消
    mMysettingChangeGenderActionTypeConfirm,      //!<确认
    
}MYSETTING_CHANGE_GENDER_ACTION_TYPE;

@interface QSYMySettingChangeUserGenderPopView : UIView

/**
 *  @author             yangshengmeng, 15-04-12 12:04:03
 *
 *  @brief              创建性别设置页
 *
 *  @param frame        大小和位置
 *  @param selectedKey  当前的性别
 *  @param callBack     选择并确认后的回调
 *
 *  @return             返回当前创建的性别设置
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedGender:(NSString *)selectedKey andCallBack:(void(^)(MYSETTING_CHANGE_GENDER_ACTION_TYPE actionType,id parmas))callBack;

@end
