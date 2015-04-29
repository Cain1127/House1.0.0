//
//  QSYMyzoneStatisticsRenantModel.h
//  House
//
//  Created by ysmeng on 15/4/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSYMyzoneStatisticsRenantModel : QSBaseModel

@property (nonatomic,copy) NSString *book_wait;         //!<待看房
@property (nonatomic,copy) NSString *book_ok;           //!<已看房
@property (nonatomic,copy) NSString *book_all;          //!<预约订单(所有)
@property (nonatomic,copy) NSString *transaction_wait;  //!<待成交
@property (nonatomic,copy) NSString *transaction_ok;    //!<已成交订单
@property (nonatomic,copy) NSString *transaction_all;   //!<已完成订单
@property (nonatomic,copy) NSString *store_rent;        //!<收藏的出租房
@property (nonatomic,copy) NSString *store_apartment;   //!<收藏的二手房
@property (nonatomic,copy) NSString *store_village;     //!<关注小区
@property (nonatomic,copy) NSString *book_wait_bid;     //!<网页端使用
@property (nonatomic,copy) NSString *ask_for_total;     //!<总的求租求购

@end
