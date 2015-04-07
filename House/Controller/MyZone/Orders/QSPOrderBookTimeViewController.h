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
    bBookTypeViewControllerChange,              //!<两个按钮时左按钮
    
}BOOKTIME_VIEWCONTROLLER_TYPE;

@interface QSPOrderBookTimeViewController : QSTurnBackViewController

- (instancetype)initWithSubmitCallBack:(void(^)(NSInteger resultTag))callBack;

@property ( nonatomic, assign ) BOOKTIME_VIEWCONTROLLER_TYPE vcType;
@property ( nonatomic, strong ) id houseInfo;        //!<房源信息数据模型

@end
