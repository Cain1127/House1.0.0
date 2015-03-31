//
//  QSYAskRentAndSecondHandHouseTipsPopView.h
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

///求租求购事件回调
typedef enum
{

    aAskRentAndSecondHouseTipsActionTypeRent = 0,   //!<求租
    aAskRentAndSecondHouseTipsActionTypeBuy,        //!<求购

}ASK_RENTANDSECONDHOUSE_TIPS_ACTION_TYPE;

@interface QSYAskRentAndSecondHandHouseTipsPopView : UIView

/**
 *  @author         yangshengmeng, 15-03-31 15:03:25
 *
 *  @brief          创建一个将要发布求租，求购的询问页面
 *
 *  @param frame    大小和位置
 *  @param callBack 询问问事件回调
 *
 *  @return         返回当前创建的询问页
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andCallBack:(void(^)(ASK_RENTANDSECONDHOUSE_TIPS_ACTION_TYPE actionType))callBack;

@end
