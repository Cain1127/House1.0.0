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

@property (nonatomic,copy) NSString *id_;               //!<户型ID
@property (nonatomic,copy) NSString *user_id;           //!<用户ID
@property (nonatomic,copy) NSString *house_no;          //!<房源号
@property (nonatomic,copy) NSString *title;             //!<标题
@property (nonatomic,copy) NSString *title_second;      //!<副标题
@property (nonatomic,copy) NSString *address;           //!<地址
@property (nonatomic,copy) NSString *village_id;        //!<小区ID
@property (nonatomic,copy) NSString *village_name;      //!<小区名
@property (nonatomic,copy) NSString *content;           //!<简述

@property (nonatomic,copy) NSString *floor_num;         //!<层数
@property (nonatomic,copy) NSString *floor_which;       //!<第几层
@property (nonatomic,copy) NSString *house_face;        //!<朝向
@property (nonatomic,copy) NSString *decoration;        //!<装饰
@property (nonatomic,copy) NSString *decoration_type;   //!<装修类型
@property (nonatomic,copy) NSString *used_year;         //!<产权
@property (nonatomic,copy) NSString *installation;      //!<结构
@property (nonatomic,copy) NSString *rent_property;     //!<出租方式
@property (nonatomic,copy) NSString *lead_time;         //!<入住时间

@property (nonatomic,copy) NSString *features;          //!<特色标签

@property (nonatomic,copy) NSString *house_shi;         //!<室
@property (nonatomic,copy) NSString *house_ting;        //!<厅
@property (nonatomic,copy) NSString *house_wei;         //!<卫
@property (nonatomic,copy) NSString *house_chufang;     //!<厨房
@property (nonatomic,copy) NSString *house_yangtai;     //!<阳台
@property (nonatomic,copy) NSString *house_area;        //!<面积
@property (nonatomic,copy) NSString *elevator;          //!<是否电梯

@property (nonatomic,copy) NSString *rent_price;        //!<出租价格
@property (nonatomic,copy) NSString *entrust;           //!<是否委托
@property (nonatomic,copy) NSString *update_time;       //!<更新时间
@property (nonatomic,copy) NSString *attach_file;       //!<大图
@property (nonatomic,copy) NSString *attach_thumb;      //!<小图
@property (nonatomic,copy) NSString *status;            //!<状态

@property (nonatomic,copy) NSString *view_count;                 //!<浏览量
@property (nonatomic,copy) NSString *reservation_num;            //!<预约数
@property (nonatomic,copy) NSString *tj_look_house_num;          //!<已看房人数
@property (nonatomic,copy) NSString *tj_wait_look_house_people;  //!<待看房数
@property (nonatomic,copy) NSString *price_avg;                  //!<小区均价

@end
