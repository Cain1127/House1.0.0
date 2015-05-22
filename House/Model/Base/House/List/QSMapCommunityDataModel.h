//
//  QSMapCommunityDataModel.h
//  House
//
//  Created by 王树朋 on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommunityDataModel.h"
#import "QSHeaderDataModel.h"
@class QSMapCommunityDataSubModel;
@interface QSMapCommunityDataModel :QSBaseModel

@property (nonatomic,copy) NSString *rent_house_num;                                //!<小区内的出租房
@property (nonatomic,copy) NSString *resold_apartment_num;                          //!<小区内的二手房
@property (nonatomic,copy) NSString *total_num;                                     //!<小区房源套数;
@property (nonatomic,retain) QSMapCommunityDataSubModel *mapCommunityDataSubModel;  //!<小区基本模型数据

@end

@interface QSMapCommunityDataSubModel : QSCommunityDataModel

@property (nonatomic,copy) NSString *village_id;            //!<小区ID
@property (nonatomic,copy) NSString *coordinate_x;          //!<经度
@property (nonatomic,copy) NSString *coordinate_y;          //!<纬度

@end