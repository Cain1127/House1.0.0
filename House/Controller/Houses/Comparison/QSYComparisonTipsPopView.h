//
//  QSYComparisonTipsPopView.h
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///比一比提示按钮的类型
typedef enum
{
    
    cComparisonTipsActionTypeConfirm = 0,   //!<确定进行比一比
    cComparisonTipsActionTypeCancel,        //!<取消
    
}COMPARISION_TIPS_ACTION_TYPE;

@interface QSYComparisonTipsPopView : UIView

/**
 *  @author         yangshengmeng, 15-03-19 23:03:35
 *
 *  @brief          创建比一比提示说明弹出窗口
 *
 *  @param frame    大小和位置
 *  @param callBack 点击选择后的回调
 *
 *  @return         返回当前创建的比一比提示窗口
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andShareCallBack:(void(^)(COMPARISION_TIPS_ACTION_TYPE actionType))callBack;

@end
