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
@property (nonatomic,copy) NSString *update_time;               //!<更新时间
@property (nonatomic,copy) NSString *tj_look_house_num;         //!<已看房人数
@property (nonatomic,copy) NSString *tj_wait_look_house_people; //!<待看房数
@property (nonatomic,copy) NSString *price_avg;                 //!<小区均价

@property (nonatomic,copy) NSString *is_syserver;               //!<是否已同步到服务端:1-已同步

@end
