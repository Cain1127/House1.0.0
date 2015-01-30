//
//  QSCustomPopRootView.h
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///弹出框的单击事件
typedef enum
{

    cCustomPopviewActionTypeDefault = 0,        //!<默认事件：点击灰色地区时
    cCustomPopviewActionTypeCancel,             //!<取消事件
    cCustomPopviewActionTypeUnLimited,          //!<不限
    cCustomPopviewActionTypeSingleSelected,     //!<单选
    cCustomPopviewActionTypeSelectedAll,        //!<全选
    cCustomPopviewActionTypeMultipleSelected    //!<多选

}CUSTOM_POPVIEW_ACTION_TYPE;

/**
 *  @author yangshengmeng, 15-01-27 15:01:18
 *
 *  @brief  自定义从底往上弹的view
 *
 *  @since  1.0.0
 */
@interface QSCustomPopRootView : UIView

@property (nonatomic,copy) void(^customPopviewTapCallBack)(CUSTOM_POPVIEW_ACTION_TYPE actionType,id params,int selectedIndex);//!<自定义弹框的回调事件

@end
