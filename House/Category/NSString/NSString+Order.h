//
//  NSString+Order.h
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Order)

/**
 *  @author             yangshengmeng, 15-04-03 19:04:40
 *
 *  @brief              根据给定的订单salerID和buyerID，返回当前用户在指定订单中，指定状态的提示信息
 *
 *  @param orderStatus  订单状态
 *  @param salerID      订单中业主的ID-即字段saler_id
 *  @param buyerID      订单中发起订单人的ID-即字段buyer_id
 *
 *  @return             返回当前用户，在指定订单状态时的提示信息
 *
 *  @since              1.0.0
 */
+ (NSString *)getCurrentUserStatusTitleWithStatus:(NSString*)orderStatus andSalerID:(NSString *)salerID andBuyerID:(NSString *)buyID;

@end
