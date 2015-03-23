//
//  QSOrderListOrderInfoDataModel.h
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSOrderButtonActionModel : QSBaseModel

@property (nonatomic,assign) NSInteger bottionActionTag;    //!<按钮操作类型
@property (nonatomic,strong) NSString *buttonName;          //!<按钮名，不显示
@property (nonatomic,strong) NSString *normalImg;           //!<按钮默认图
@property (nonatomic,strong) NSString *highLightImg;        //!<按钮高亮图

@end

@class QSOrderListOrderInfoPersonInfoDataModel;
@interface QSOrderListOrderInfoDataModel : QSBaseModel

@property (nonatomic,strong) NSString *id_;                 //!<订单ID
@property (nonatomic,strong) NSString *order_type;          //!<订单类型
@property (nonatomic,strong) NSString *add_time;            //!<订单添加时间
@property (nonatomic,strong) NSString *modefy_time;         //!<最后修改的时间
@property (nonatomic,strong) NSString *order_status;        //!<订单状态
@property (nonatomic,strong) NSString *status;              //!<是否删除
@property (nonatomic,strong) NSString *bargain_team;        //!<最近讨论的流水组
@property (nonatomic,strong) NSString *transaction_price;   //!<成交的价格
@property (nonatomic,strong) NSString *buyer_name;          //!<买家姓名
@property (nonatomic,strong) NSString *buyer_phone;         //!<买家电话
@property (nonatomic,strong) NSString *last_buyer_bid;      //!<买家最近的出价
@property (nonatomic,strong) NSString *last_saler_bid;      //!<卖家最近的出价
@property (nonatomic,strong) NSString *buyer_id;            //!<买家ID
@property (nonatomic,strong) NSString *saler_id;            //!<卖家ID
@property (nonatomic,strong) NSString *appoint_date;        //!<预约日期
@property (nonatomic,strong) NSString *appoint_start_time;  //!<预约起始时
@property (nonatomic,strong) NSString *appoint_end_time;    //!<预约结束时
@property (nonatomic,strong) NSString *source_id;           //!<关联的房源id
@property (nonatomic,strong) NSString *source_ask_for_id;   //!<来源求租/求购订单id
@property (nonatomic,strong) NSString *last_operater_id;    //!<最后操作者id
@property (nonatomic,strong) NSString *add_type;            //!<添加类型
@property (nonatomic,strong) NSString *o_expand_1;          //!<
@property (nonatomic,strong) NSString *o_expand_2;          //!<


@property (nonatomic,strong) QSOrderListOrderInfoPersonInfoDataModel *buyer_msg;         //!<买家

- (NSString*)getStatusStr;      //获取订单状态字符串

- (NSString*)getTimeStr;        //获取订单预约时间字符串

- (NSArray*)getButtonAction;    //获取当前支持的按钮操作

@end

@interface QSOrderListOrderInfoPersonInfoDataModel : QSBaseModel


@property (nonatomic,copy) NSString *username;      //!<姓名
@property (nonatomic,copy) NSString *mobile;        //!<电话
@property (nonatomic,copy) NSString *id_;           //!<用户ID
@property (nonatomic,copy) NSString *level;         //!<

@end


