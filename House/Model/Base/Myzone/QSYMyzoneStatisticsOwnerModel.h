//
//  QSYMyzoneStatisticsOwnerModel.h
//  House
//
//  Created by ysmeng on 15/4/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSYMyzoneStatisticsOwnerModel : QSBaseModel

@property (nonatomic,copy) NSString *book_wait;             //!<待看房
@property (nonatomic,copy) NSString *book_ok;               //!<已看房
@property (nonatomic,copy) NSString *book_all;              //!<预约订单(所有)
@property (nonatomic,copy) NSString *transaction_wait;      //!<待成交
@property (nonatomic,copy) NSString *transaction_ok;        //!<已成交订单
@property (nonatomic,copy) NSString *transaction_all;       //!<已完成订单
@property (nonatomic,copy) NSString *tenement_rent;         //!<收藏的出租房
@property (nonatomic,copy) NSString *tenement_apartment;    //!<收藏的二手房
@property (nonatomic,copy) NSString *book_wait_bid;         //!<网页端使用统计数据
@property (nonatomic,copy) NSString *referrals_tenant;      //!<推荐房客

@end
