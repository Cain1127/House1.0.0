//
//  QSYDeleteAskRentAndBuyHouseTipsPopView.h
//  House
//
//  Created by ysmeng on 15/4/5.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///删除求租求购事件回调
typedef enum
{
    
    dDeleteAskRentAndBuyHouseTipsActionTypeCancel = 0,      //!<取消
    dDeleteAskRentAndBuyHouseTipsActionTypeConfirm,         //!<确认
    
}DELETE_ASK_RENTANDBUYHOUSE_TIPS_ACTION_TYPE;

@interface QSYDeleteAskRentAndBuyHouseTipsPopView : UIView

- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(DELETE_ASK_RENTANDBUYHOUSE_TIPS_ACTION_TYPE actionType))callBack;

@end
