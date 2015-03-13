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

@property (nonatomic,copy) NSString *price_avg;                  //!<小区均价
@property (nonatomic,copy) NSString *coordinate_x;               //!<经度
@property (nonatomic,copy) NSString *coordinate_y;               //!<纬度

@end
