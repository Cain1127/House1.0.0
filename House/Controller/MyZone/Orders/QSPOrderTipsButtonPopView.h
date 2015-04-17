//
//  QSPOrderTipsButtonPopView.h
//  House
//
//  Created by CoolTea on 15/4/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define     DefaultHeight       160.0f

///提示按钮的类型
typedef enum
{
    
    oOrderButtonTipsActionTypeCancel = 0,     //!<取消
    oOrderButtonTipsActionTypeConfirm,        //!<确定
    
}ORDER_BUTTON_TIPS_ACTION_TYPE;

@interface QSPOrderTipsButtonPopView : UIView

- (instancetype)initWithShareCallBack:(void(^)(UIButton *button,ORDER_BUTTON_TIPS_ACTION_TYPE actionType))callBack;

@end
