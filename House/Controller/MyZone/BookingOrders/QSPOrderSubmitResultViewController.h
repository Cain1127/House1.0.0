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

@interface QSPOrderSubmitResultViewController : QSHeaderViewController

- (instancetype)initWithResultType:(ORDER_SUBMIT_RESULT_TYPE)type;

@end
