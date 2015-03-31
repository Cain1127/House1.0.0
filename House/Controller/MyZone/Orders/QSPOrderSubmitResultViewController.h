//
//  QSPOrderSubmitResultViewController.h
//  House
//
//  Created by CoolTea on 15/3/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderViewController.h"

typedef enum
{
    
    oOrderSubmitResultTypeBookSuccessed = 301,          //!<预约成功
    oOrderSubmitResultTypeCancelSuccessed,              //!<取消预约成功
    
}ORDER_SUBMIT_RESULT_TYPE;

typedef enum
{
    
    oOrderSubmitResultBackTypeAuto = 801,           //!<自动返回
    oOrderSubmitResultBackTypeToDetail,             //!<点击查看预约详情按钮返回
    oOrderSubmitResultBackTypeToMoreHouse,          //!<点击查看推荐房源按钮返回
    
}ORDER_SUBMIT_RESULT_BACK_TYPE;

@interface QSPOrderSubmitResultViewController : QSHeaderViewController

- (instancetype)initWithResultType:(ORDER_SUBMIT_RESULT_TYPE)type andAutoBackCallBack:(void(^)(ORDER_SUBMIT_RESULT_BACK_TYPE)) callBack;

@end
