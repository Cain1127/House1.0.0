//
//  QSYAskListOrderInfosModel.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSYAskListOrderInfosModel : QSBaseModel

/*
 500101 一手房预约订单
 500102 二手房预约订单
 500103 出租房预约订单
 */

@property (nonatomic,copy) NSString *id_;               //!<订单ID
@property (nonatomic,copy) NSString *order_type;        //!<订单类型
@property (nonatomic,copy) NSString *add_time;          //!<添加时间
@property (nonatomic,copy) NSString *modefy_time;       //!<最后修改时间
@property (nonatomic,copy) NSString *order_status;      //!<订单状态
@property (nonatomic,copy) NSString *appoint_date;      //!<预约的日期
@property (nonatomic,copy) NSString *bargain_team;      //!<
@property (nonatomic,copy) NSString *transaction_price; //!<最后成交的价格
@property (nonatomic,copy) NSString *source_id;         //!<房源id
@property (nonatomic,copy) NSString *source_ask_for_id; //!<关联的求租/求购订单id
@property (nonatomic,copy) NSString *saler_id;          //!<出售者id
@property (nonatomic,copy) NSString *buyer_id;          //!<购买者id
@property (nonatomic,copy) NSString *last_operater_id;  //!<购买者id
@property (nonatomic,copy) NSString *o_expand_1;
@property (nonatomic,copy) NSString *o_expand_2;
@property (nonatomic,copy) NSString *appoint_start_time;//!<预约的开始时间
@property (nonatomic,copy) NSString *appoint_end_time;  //!<预约的结束时间
@property (nonatomic,copy) NSString *buyer_name;        //!<购买者姓名
@property (nonatomic,copy) NSString *buyer_phone;       //!<购买者手机
@property (nonatomic,copy) NSString *add_type;          //!<
@property (nonatomic,copy) NSString *last_buyer_bid;    //!<购买者最后出价
@property (nonatomic,copy) NSString *last_saler_bid;    //!<出售者最后出价

@end
