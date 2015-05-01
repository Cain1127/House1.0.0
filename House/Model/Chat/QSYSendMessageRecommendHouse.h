//
//  QSYSendMessageRecommendHouse.h
//  House
//
//  Created by ysmeng on 15/5/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSendMessageBaseModel.h"

@interface QSYSendMessageRecommendHouse : QSYSendMessageBaseModel

@property (nonatomic,copy) NSString *houseID;           //!<房源ID
@property (nonatomic,copy) NSString *originalImage;     //!<房源图片url
@property (nonatomic,copy) NSString *smallImage;        //!<房源图片url
@property (nonatomic,copy) NSString *district;          //!<所在区
@property (nonatomic,copy) NSString *districtKey;       //!<所在区key
@property (nonatomic,copy) NSString *street;            //!<所在街道
@property (nonatomic,copy) NSString *streetKey;         //!<所在Key
@property (nonatomic,copy) NSString *houseTing;         //!<房源厅数量
@property (nonatomic,copy) NSString *houseShi;          //!<房源室数量
@property (nonatomic,copy) NSString *houseArea;         //!<房源面积
@property (nonatomic,copy) NSString *housePrice;        //!<房源售价
@property (nonatomic,copy) NSString *rentPrice;         //!<租金
@property (nonatomic,copy) NSString *title;             //!<房源标题

@end
