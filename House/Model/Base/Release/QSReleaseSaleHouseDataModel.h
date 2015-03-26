//
//  QSReleaseSaleHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSReleaseSaleHouseDataModel : QSBaseModel

@property (nonatomic,copy) NSString *trandType;         //!<物业类型
@property (nonatomic,copy) NSString *trandTypeKey;      //!<物业类型的Key
@property (nonatomic,copy) NSString *district;          //!<所在区
@property (nonatomic,copy) NSString *districtKey;       //!<所在区的key
@property (nonatomic,copy) NSString *street;            //!<所在街道
@property (nonatomic,copy) NSString *streetKey;         //!<所在街道的key
@property (nonatomic,copy) NSString *community;         //!<小区
@property (nonatomic,copy) NSString *communityKey;      //!<小区ID
@property (nonatomic,copy) NSString *address;           //!<详细地址
@property (nonatomic,copy) NSString *houseType;         //!<户型
@property (nonatomic,copy) NSString *houseTypeKey;      //!<户型key
@property (nonatomic,copy) NSString *area;              //!<面积
@property (nonatomic,copy) NSString *areaKey;           //!<面积key
@property (nonatomic,copy) NSString *salePrice;         //!<售价
@property (nonatomic,copy) NSString *salePriceKey;      //!<售价key
@property (nonatomic,copy) NSString *negotiatedPrice;   //!<是否议价
@property (nonatomic,copy) NSString *negotiatedPriceKey;//!<是否议价key
@property (nonatomic,copy) NSString *nature;            //!<房屋性质
@property (nonatomic,copy) NSString *natureKey;         //!<房屋性质key
@property (nonatomic,copy) NSString *buildingYear;      //!<建筑年代
@property (nonatomic,copy) NSString *buildingYearKey;   //!<建筑年代key
@property (nonatomic,copy) NSString *propertyRightYear; //!<产权年限
@property (nonatomic,copy) NSString *propertyRightYearKey;//!<产权年限key
@property (nonatomic,copy) NSString *floor;             //!<楼层
@property (nonatomic,copy) NSString *floorKey;          //!<楼层key
@property (nonatomic,copy) NSString *face;              //!<朝向
@property (nonatomic,copy) NSString *faceKey;           //!<朝向key
@property (nonatomic,copy) NSString *decoration;        //!<装修
@property (nonatomic,copy) NSString *decorationKey;     //!<装修key

///标签
@property (nonatomic,retain) NSMutableArray *featuresList;

///配套信息
@property (nonatomic,retain) NSMutableArray *installationList;

@end
