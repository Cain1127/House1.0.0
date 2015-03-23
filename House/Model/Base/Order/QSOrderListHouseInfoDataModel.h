//
//  QSOrderListHouseInfoDataModel.h
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSOrderListHouseInfoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *title;             //!<标题
@property (nonatomic,copy) NSString *id_;               //!<房源ID
@property (nonatomic,copy) NSString *house_no;          //!<房源编号
@property (nonatomic,copy) NSString *cityid;            //!<城市ID
@property (nonatomic,copy) NSString *street;            //!<街道ID
@property (nonatomic,copy) NSString *address;           //!<地址
@property (nonatomic,copy) NSString *negotiated;        //!<是否一口价 1：是； 0：否
@property (nonatomic,copy) NSString *house_price;       //!<房价
@property (nonatomic,copy) NSString *house_area;        //!<面积
@property (nonatomic,copy) NSString *attach_file;       //!<房源大图URL
@property (nonatomic,copy) NSString *attach_thumb;      //!<房源小图URL

@end
