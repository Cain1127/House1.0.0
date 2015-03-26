//
//  QSFilterDataModel.h
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

/**
 *  @author yangshengmeng, 15-02-04 15:02:49
 *
 *  @brief  过滤器的普通数据模型
 *
 *  @since  1.0.0
 */
@interface QSFilterDataModel : QSBaseModel

@property (nonatomic, copy) NSString * buy_purpose_key;     //!<购房目的key
@property (nonatomic, copy) NSString * buy_purpose_val;     //!<购房目的
@property (nonatomic, copy) NSString * city_key;            //!<城市key
@property (nonatomic, copy) NSString * city_val;            //!<城市
@property (nonatomic, copy) NSString * decoration_key;      //!<装修key
@property (nonatomic, copy) NSString * decoration_val;      //!<装修
@property (nonatomic, copy) NSString * des;                 //!<备注
@property (nonatomic, copy) NSString * district_key;        //!<所在区key
@property (nonatomic, copy) NSString * district_val;        //!<所在区
@property (nonatomic, copy) NSString * filter_id;           //!<过滤器ID
@property (nonatomic, copy) NSString * floor_key;           //!<楼层key
@property (nonatomic, copy) NSString * floor_val;           //!<楼层
@property (nonatomic, copy) NSString * house_area_key;      //!<面积key
@property (nonatomic, copy) NSString * house_area_val;      //!<面积
@property (nonatomic, copy) NSString * house_face_key;      //!<朝向key
@property (nonatomic, copy) NSString * house_face_val;      //!<朝向
@property (nonatomic, copy) NSString * house_type_key;      //!<户型
@property (nonatomic, copy) NSString * house_type_val;      //!<户型
@property (nonatomic, copy) NSString * province_key;        //!<所在省key
@property (nonatomic, copy) NSString * province_val;        //!<所在省
@property (nonatomic, copy) NSString * rent_pay_type_key;   //!<租金支付方式key
@property (nonatomic, copy) NSString * rent_pay_type_val;   //!<租金支付方式
@property (nonatomic, copy) NSString * rent_price_key;      //!<租金key
@property (nonatomic, copy) NSString * rent_type_key;       //!<出租方式key
@property (nonatomic, copy) NSString * rent_type_val;       //!<出租方式
@property (nonatomic, copy) NSString * sale_price_key;      //!<售价key
@property (nonatomic, copy) NSString * sale_price_val;      //!<售价
@property (nonatomic, copy) NSString * avg_price_key;       //!<均价key
@property (nonatomic, copy) NSString * avg_price_val;       //!<均价
@property (nonatomic, copy) NSString * street_key;          //!<所在街道key
@property (nonatomic, copy) NSString * street_val;          //!<所在街道
@property (nonatomic, copy) NSString * trade_type_key;      //!<房子的物业类型key
@property (nonatomic, copy) NSString * trade_type_val;      //!<房子的物业类型
@property (nonatomic, copy) NSString * used_year_val;       //!<房龄
@property (nonatomic, copy) NSString * rent_price_val;      //!<租金
@property (nonatomic, copy) NSString * used_year_key;       //!<房龄key
@property (nonatomic, copy) NSString * filter_status;       //!<过滤器的当前状态:2-正在使用
@property (nonatomic, retain) NSMutableArray *features_list;//!<特色标签

@end
