//
//  QSReleaseRentHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSReleaseRentHouseDataModel : QSBaseModel

@property (nonatomic,copy) NSString *district;
@property (nonatomic,copy) NSString *districtKey;
@property (nonatomic,copy) NSString *street;
@property (nonatomic,copy) NSString *streetKey;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *community;
@property (nonatomic,copy) NSString *communityKey;
@property (nonatomic,copy) NSString *houseType;
@property (nonatomic,copy) NSString *houseTypeKey;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *areaKey;
@property (nonatomic,copy) NSString *rentType;
@property (nonatomic,copy) NSString *rentTypeKey;
@property (nonatomic,copy) NSString *rentPrice;
@property (nonatomic,copy) NSString *rentPriceKey;
@property (nonatomic,copy) NSString *rentPaytype;
@property (nonatomic,copy) NSString *rentPaytypeKey;
@property (nonatomic,copy) NSString *whetherBargaining;
@property (nonatomic,copy) NSString *whetherBargainingKey;
@property (nonatomic,copy) NSString *houseStatus;
@property (nonatomic,copy) NSString *houseStatusKey;

@end
