//
//  QSYOwnerPropertyDeleteTipsPopView.h
//  House
//
//  Created by ysmeng on 15/4/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{

    pPropertyDeleteActionTypeCancel = 99,   //!<返回
    pPropertyDeleteActionTypeConfirm,       //!<确认

}PROPERTY_DELETE_ACTION_TYPE;

@interface QSYOwnerPropertyDeleteTipsPopView : UIView

/**
 *  @author         yangshengmeng, 15-04-17 12:04:51
 *
 *  @brief          创建删除物业提示弹出框
 *
 *  @param frame    大小和位置
 *  @param callBack 提示框的事件回调
 *
 *  @return         返回当前创建的提示框
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(PROPERTY_DELETE_ACTION_TYPE actionType))callBack;

@end
