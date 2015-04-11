//
//  NSString+Order.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "NSString+Order.h"
#import "QSCoreDataManager+User.h"

@implementation NSString (Order)

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
+ (NSString *)getCurrentUserStatusTitleWithStatus:(NSString*)orderStatus andSalerID:(NSString *)salerID andBuyerID:(NSString *)buyerID
{
    
    NSString *statusStr = @"";
    USER_COUNT_TYPE currentUserOrderRole = [self getCurrentUserTypeWithOrderSalerID:salerID andBuyerID:buyerID];
    
    if (orderStatus&&[orderStatus isKindOfClass:[NSString class]]) {
        
        if ([orderStatus isEqualToString:@"500201"] ||
            [orderStatus isEqualToString:@"500203"]) {
            
            statusStr = @"待确认";
            
        } else if ([orderStatus isEqualToString:@"500210"]||
                   [orderStatus isEqualToString:@"500213"]) {
            
            statusStr = @"待看房";
            
        } else if ([orderStatus isEqualToString:@"500230"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"待确认已看房";
                
            }else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待评价";
            }
            
        } else if ([orderStatus isEqualToString:@"500231"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"待确认已看房";
                
            }else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待议价";
                
            }
            
        } else if ([orderStatus isEqualToString:@"500232"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"已完成看房";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                //房客角色
                statusStr = @"待评价";
            }
        } else if ([orderStatus isEqualToString:@"500202"]) {
            
        } else if ([orderStatus isEqualToString:@"500250"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"已完成看房";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待议价";
                
            }
            
        } else if ([orderStatus isEqualToString:@"500252"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"已还价";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待还价";
                
            }
            
        } else if ([orderStatus isEqualToString:@"500253"]) {
            
            statusStr = @"申请议价";
            
        } else if ([orderStatus isEqualToString:@"500254"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"待议价/成交";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待议价";
                
            }
            
        } else if ([orderStatus isEqualToString:@"500257"] ||
                   [orderStatus isEqualToString:@"500258"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"待还价";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                //房客角色
                statusStr = @"已还价";
            }
        } else if ([orderStatus isEqualToString:@"500259"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"待议价/成交";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待议价";
                
            }
            
        } else if ([orderStatus isEqualToString:@"500220"]) {
            
            statusStr = @"议价成功";
            
        } else if ([orderStatus isEqualToString:@"500221"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"待确认成交";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待我确认";
                
            }
            
        } else if ([orderStatus isEqualToString:@"500222"]) {
            
            if (currentUserOrderRole == uUserCountTypeOwner) {
                
                //业主角色
                statusStr = @"待确认成交";
                
            } else if (currentUserOrderRole == uUserCountTypeTenant) {
                
                //房客角色
                statusStr = @"待业主确认";
                
            }
            
        } else if ([orderStatus isEqualToString:@"500223"]) {
            
            statusStr = @"已成交";
            
        } else if ([orderStatus isEqualToString:@"500240"] ||
                   [orderStatus isEqualToString:@"500241"] ||
                   [orderStatus isEqualToString:@"500246"]) {
            
            statusStr = @"已取消";
            
        }
        
        //缺 成交订单  – 已取消 状态码未确定
        
    }
    
    return statusStr;
    
}

/**
 *  @author         yangshengmeng, 15-04-03 19:04:43
 *
 *  @brief          根据当前用户ID，订单的saler、buyerID,返回当前用户的类型
 *
 *  @param myID     我的账号ID
 *  @param salerID  订单中的salerID
 *  @param buyID    订单中的buyerID
 *
 *  @return         返回当前用户在此订单中的角色
 *
 *  @since          1.0.0
 */
+ (USER_COUNT_TYPE)getCurrentUserTypeWithOrderSalerID:(NSString *)salerID andBuyerID:(NSString *)buyerID
{
    
    USER_COUNT_TYPE userType = -1;
    NSString *userID = [QSCoreDataManager getUserID];
    
    if (userID) {
        
        if (salerID && [userID isEqualToString:salerID]) {
            
            userType = uUserCountTypeOwner;
            
        } else if (buyerID && [userID isEqualToString:buyerID]) {
            
            userType = uUserCountTypeTenant;
            
        }
        
    }
    
    return userType;
    
}

@end
