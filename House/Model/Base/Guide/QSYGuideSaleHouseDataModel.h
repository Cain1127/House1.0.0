//
//  QSYGuideSaleHouseDataModel.h
//  House
//
//  Created by ysmeng on 15/5/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSYGuideSaleHouseDataModel : QSBaseModel

@property (nonatomic,copy) NSString *house_num;     //!<房源总数
@property (nonatomic,copy) NSString *house_shi_0;   //!<单间房源数量
@property (nonatomic,copy) NSString *house_shi_1;   //!<一房房源数量
@property (nonatomic,copy) NSString *house_shi_2;   //!<两房房源数量
@property (nonatomic,copy) NSString *house_shi_3;   //!<三房房源数量
@property (nonatomic,copy) NSString *house_shi_4;   //!<四房房源数量
@property (nonatomic,copy) NSString *house_shi_5;   //!<五房房源数量

@end
