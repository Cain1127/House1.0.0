//
//  QSOrderListOrderInfoDataModel.h
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@class QSOrderListOrderInfoPersonInfoDataModel;
@interface QSOrderListOrderInfoDataModel : QSBaseModel

@property (nonatomic,strong) NSString *id_;               //!<订单ID
@property (nonatomic,strong) NSString *order_type;        //!<订单类型
@property (nonatomic,strong) NSString *add_time;          //1<订单添加时间
@property (nonatomic,strong) NSString *order_status;      //!<订单状态
@property (nonatomic,strong) NSString *status;            //!<
@property (nonatomic,strong) NSString *buyer_name;        //!<买家姓名
@property (nonatomic,strong) NSString *buyer_phone;       //!<买家电话
@property (nonatomic,strong) QSOrderListOrderInfoPersonInfoDataModel *buyer_msg;         //!<买家

@end

@interface QSOrderListOrderInfoPersonInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *username;      //!<姓名
@property (nonatomic,copy) NSString *mobile;        //!<电话

@end


