//
//  QSWRentHouseInfoDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"
#import "QSRentHouseInfoDataModel.h"

@interface QSWRentHouseInfoDataModel : QSRentHouseInfoDataModel

@property (nonatomic,copy) NSString *content;                   //!<简述
@property (nonatomic,copy) NSString *decoration;                //!<装饰
@property (nonatomic,copy) NSString *tj_look_house_num;         //!<已看房人数
@property (nonatomic,copy) NSString *tj_wait_look_house_people; //!<待看房数
@property (nonatomic,copy) NSString *price_avg;                 //!<小区均价
@property (nonatomic,copy) NSString *create_time;               //!<数据创建时间
@property (nonatomic,copy) NSString *is_store;                  //!<当前是否已收藏

@property (nonatomic,copy) NSString *tj_condition;              //!<内部条件评分
@property (nonatomic,copy) NSString *tj_environment;            //!<周边环境评分
@property (nonatomic,copy) NSString *book_num;                  //!<预约当前房源的次数
@property (nonatomic,copy) NSString *building_structure;        //!<房源的建筑结构

@property (nonatomic,copy) NSString *coordinate_x;              //!<经度
@property (nonatomic,copy) NSString *coordinate_y;              //!<纬度

@property (nonatomic,copy) NSString *is_syserver;               //!<是否已同步到服务端:1-已同步

@end
