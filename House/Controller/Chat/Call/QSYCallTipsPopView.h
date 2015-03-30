//
//  QSYCallTipsPopView.h
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///打电话联系前的提示框事件类型
typedef enum
{

    cCallTipsCallBackActionTypeCancel = 0,  //!<取消
    cCallTipsCallBackActionTypeConfirm,     //!<确认

}CALL_TIPS_CALLBACK_ACTION_TYPE;

@interface QSYCallTipsPopView : UIView

- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)userName andPhone:(NSString *)phone andCallBack:(void(^)(CALL_TIPS_CALLBACK_ACTION_TYPE actionType))callBack;

@end
