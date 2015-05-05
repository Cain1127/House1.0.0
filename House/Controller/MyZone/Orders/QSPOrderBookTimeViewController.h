//
//  QSPOrderBookTimeViewController.h
//  House
//
//  Created by CoolTea on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSTurnBackViewController.h"

typedef enum
{
    
    bBookTypeViewControllerBook = 201,          //!<一个按钮
    bBookTypeViewControllerBookAgain,           //!<一个按钮
    bBookTypeViewControllerChange,              //!<两个按钮时左按钮
    
}BOOKTIME_VIEWCONTROLLER_TYPE;

typedef enum
{
    
    bBookResultTypeSucess = 101,        //!<提交成功
    bBookResultTypeFail,                //!<提交失败
    
}BOOKTIME_RESULT_TYPE;

@interface QSPOrderBookTimeViewController : QSTurnBackViewController

- (instancetype)initWithSubmitCallBack:(void(^)(BOOKTIME_RESULT_TYPE resultTag,NSString *orderID))callBack;

@property ( nonatomic, assign ) BOOKTIME_VIEWCONTROLLER_TYPE vcType;

@property ( nonatomic, assign ) FILTER_MAIN_TYPE houseType;

@property ( nonatomic, strong ) id houseInfo;           //!<新预约时只需要传房源信息数据模型

@property ( nonatomic, strong ) NSString *orderID;      //!<修改订单时需要传订单ID
@property ( nonatomic, strong ) NSString *personName;   //!<修改订单时需要传预约姓名
@property ( nonatomic, strong ) NSString *personPhone;  //!<修改订单时需要传预约号码


@end
