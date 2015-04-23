//
//  QSSecondHouseInfoDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//
#import "QSBaseModel.h"
#import "QSHouseInfoDataModel.h"

@interface QSWSecondHouseInfoDataModel : QSHouseInfoDataModel

@property (nonatomic,copy) NSString *price_avg;                 //!<小区均价
@property (nonatomic,copy) NSString *coordinate_x;              //!<经度
@property (nonatomic,copy) NSString *coordinate_y;              //!<纬度
@property (nonatomic,copy) NSString *tj_condition;              //!<房源内部评分
@property (nonatomic,copy) NSString *tj_environment;            //!<周边环境评分
@property (nonatomic,copy) NSString *book_num;                  //!<当前房源预约订单数量
@property (nonatomic,copy) NSString *is_store;                  //!<当前用户是否已收藏

@property (nonatomic,copy) NSString *tj_look_house_num;         //!<已看房人数
@property (nonatomic,copy) NSString *tj_wait_look_house_people; //!<待看房数

@end
