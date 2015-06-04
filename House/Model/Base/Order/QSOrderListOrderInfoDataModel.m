//
//  QSOrderListOrderInfoDataModel.m
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListOrderInfoDataModel.h"
#import "QSCoreDataManager+User.h"
#import <CoreText/CoreText.h>
#import "NSString+Order.h"

@implementation QSOrderListOrderInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
    // RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"order_type",
                                                    @"add_time",
                                                    @"order_status",
                                                    @"status",
                                                    @"buyer_name",
                                                    @"buyer_phone",
                                                    @"last_buyer_bid",
                                                    @"last_saler_bid",
                                                    @"transaction_price",
                                                    @"buyer_id",
                                                    @"saler_id",
                                                    @"appoint_date",
                                                    @"appoint_start_time",
                                                    @"appoint_end_time",
                                                    @"o_expand_1",
                                                    @"o_expand_2"
                                                    ]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"buyer_msg" toKeyPath:@"buyer_msg" withMapping:[QSOrderListOrderInfoPersonInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

- (USER_COUNT_TYPE)getUserType
{
    
    USER_COUNT_TYPE userType = -1;
    NSString *userID = [QSCoreDataManager getUserID];
    
    if ( userID ) {
        
        if (self.saler_id && [userID isEqualToString:self.saler_id]) {
            userType = uUserCountTypeOwner;
        }else if (self.buyer_id && [userID isEqualToString:self.buyer_id]) {
            userType = uUserCountTypeTenant;
        }
        
    }
    
    return userType;
    
}

//订单状态
- (NSString*)getStatusTitle
{
    
    NSString *statusStr = [NSString getCurrentUserStatusTitleWithStatus:self.order_status andSalerID:self.saler_id andBuyerID:self.buyer_id];
    
    NSLog(@"self.order_status: %@ statusStr: %@",self.order_status,statusStr);
    
    return statusStr;
    
}

- (NSArray*)getButtonSource
{
    NSMutableArray *btList = [NSMutableArray arrayWithCapacity:0];
    
    if (self.order_status&&[self.order_status isKindOfClass:[NSString class]]) {
        
        if ([self.order_status isEqualToString:@"500201"]) {
            //预约状态
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                //接受房客的预约
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"接受";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"拒绝";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_REJECT_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_REJECT_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500202"]) {
            //再预约中状态
        }else if ([self.order_status isEqualToString:@"500210"]) {
            //待看房中
            QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
            rightBt.bottionActionTag = [self.order_status integerValue];
            rightBt.buttonName = @"咨询";
            rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
            rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
            [btList addObject:rightBt];
            
        }else if ([self.order_status isEqualToString:@"500203"]) {
            //房客修改看房时间
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                //接受房客的预约
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"接受";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"拒绝";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_REJECT_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_REJECT_BT_SELECTED;
                [btList addObject:leftBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"咨询";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"电话";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
            
        }else if ([self.order_status isEqualToString:@"500213"]){
            //业主同意房客修改看房时间
            
            QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
            rightBt.bottionActionTag = [self.order_status integerValue];
            rightBt.buttonName = @"咨询";
            rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
            rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
            [btList addObject:rightBt];
            
            QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
            leftBt.bottionActionTag = [self.order_status integerValue];
            leftBt.buttonName = @"电话";
            leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
            leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
            [btList addObject:leftBt];
            
        }else if ([self.order_status isEqualToString:@"500230"]) {
            //看房待确认
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"确认完成预约看房";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_SELECTED;
                [btList addObject:rightBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"评价房源";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_COMMENT_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_COMMENT_BT_SELECTED;
                [btList addObject:rightBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500231"]) {
            //用户已确认
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"确认完成预约看房";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_SELECTED;
                [btList addObject:rightBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"咨询";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"电话";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500232"]) {
            //房主已确认
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"咨询";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"电话";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
                [btList addObject:leftBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"成交-成交预约订单";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"议价";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500250"]) {
            //议价状态
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"咨询";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"电话";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
                [btList addObject:leftBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"议价";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_SELECTED;
                [btList addObject:rightBt];
                
            }
            
        }else if ([self.order_status isEqualToString:@"500252"]) {
            //客户已还价格
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"同意还价";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPTPRICE_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPTPRICE_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"编辑出价";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_SELECTED;
                [btList addObject:leftBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色

                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"咨询";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"电话";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500253"]) {
            //客户申请议价
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                //是否接受房客申请议价
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"接受";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ACCEPT_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"拒绝";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_REJECT_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_REJECT_BT_SELECTED;
                [btList addObject:leftBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                //完成预约订单，进入成交流程
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"成交";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500254"]) {
            //房主拒绝还价
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                //完成预约订单，进入成交流程
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"成交";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"申请议价";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASKFORPRICE_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASKFORPRICE_BT_SELECTED;
                [btList addObject:leftBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"咨询";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"电话";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
            
        }else if ([self.order_status isEqualToString:@"500257"]) {
            //房主已还价格
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"同意还价";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                //房客成交预约已看房订单
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"成交";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"还价";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_TALKPRICE_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500258"]) {
            //最后一个议价阶段价格
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"咨询";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"电话";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
                [btList addObject:leftBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //房客成交预约已看房订单
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"成交";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500259"]) {
            //一口价待接受
            if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
            
                //完成预约订单，进入成交流程
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"成交";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
                QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
                leftBt.bottionActionTag = [self.order_status integerValue];
                leftBt.buttonName = @"申请议价";
                leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASKFORPRICE_BT_NORMAL;
                leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASKFORPRICE_BT_SELECTED;
                [btList addObject:leftBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500220"]) {
            //成功
            QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
            rightBt.bottionActionTag = [self.order_status integerValue];
            rightBt.buttonName = @"成交-房客成交已看房订单";
            rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
            rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
            [btList addObject:rightBt];
            
        }else if ([self.order_status isEqualToString:@"500221"]) {
            //客户确认成功
            //不处理
            
        }else if ([self.order_status isEqualToString:@"500222"]) {
            //商家确认成功
            //不处理
        }else if ([self.order_status isEqualToString:@"500223"]) {
            //双方都确认成功
            
            QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
            rightBt.bottionActionTag = [self.order_status integerValue];
            rightBt.buttonName = @"咨询";
            rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
            rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
            [btList addObject:rightBt];
            
            QSOrderButtonActionModel *leftBt = [[QSOrderButtonActionModel alloc] init];
            leftBt.bottionActionTag = [self.order_status integerValue];
            leftBt.buttonName = @"电话";
            leftBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
            leftBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
            [btList addObject:leftBt];
            
        }else if ([self.order_status isEqualToString:@"500301"]) {
            //客户确认成功
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"确认完成待成交订单";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"提醒";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_REMIND_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_REMIND_BT_SELECTED;
                [btList addObject:rightBt];
                
                
            }
        }else if ([self.order_status isEqualToString:@"500302"]) {
            //客户确认成功
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"提醒";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_REMIND_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_REMIND_BT_SELECTED;
                [btList addObject:rightBt];
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                QSOrderButtonActionModel *rightBt = [[QSOrderButtonActionModel alloc] init];
                rightBt.bottionActionTag = [self.order_status integerValue];
                rightBt.buttonName = @"确认完成待成交订单";
                rightBt.normalImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_NORMAL;
                rightBt.highLightImg = IMAGE_ZONE_ORDER_LIST_CELL_CONFIRM_BT_SELECTED;
                [btList addObject:rightBt];
                
            }
        }else if ([self.order_status isEqualToString:@"500240"]) {
            //系统取消
        }else if ([self.order_status isEqualToString:@"500241"]) {
            //客户不合适结束
        }else if ([self.order_status isEqualToString:@"500242"]) {
            //客户不提价结束
        }else if ([self.order_status isEqualToString:@"500246"]) {
            //商家不接受看房结束
        }
        
    }
    
    return btList;
}

- (NSString*)getAppointmentTimeString
{
    NSString *timeStr = @"";
    
    if (self.appoint_date && ![self.appoint_date isEqualToString:@""]) {
        timeStr = self.appoint_date;
    }
    
    if (self.appoint_start_time && ![self.appoint_start_time isEqualToString:@""]) {
        timeStr = [NSString stringWithFormat:@"时间:%@ %@",timeStr,self.appoint_start_time];
    }
    
    if (self.appoint_end_time && ![self.appoint_end_time isEqualToString:@""]) {
        timeStr = [NSString stringWithFormat:@"%@-%@",timeStr,self.appoint_end_time];
    }
    
    return timeStr;
}

//获取买家最近的出价，单位为万
- (NSString*)getBuyerLastPrice
{
    CGFloat priceF = 0;
    if (self.last_buyer_bid) {
        priceF = [self.last_buyer_bid floatValue]/10000.0;
    }
    
    NSInteger priceInt = (NSInteger)priceF;
    
    return [NSString stringWithFormat:@"%ld",(long)priceInt];
}

//获取卖家最近的出价，单位为万
- (NSString*)getSalerLastPrice
{
    CGFloat priceF = 0;
    if (self.last_saler_bid) {
        priceF = [self.last_saler_bid floatValue]/10000.0;
    }
    
    NSInteger priceInt = (NSInteger)priceF;
    
    return [NSString stringWithFormat:@"%ld",(long)priceInt];
}

@end

@implementation QSOrderListOrderInfoPersonInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
    // RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"username",
                                                    @"mobile",
                                                    @"id_",
                                                    @"level",
                                                    @"user_type",
                                                    @"avatar",
//                                                    @"nickname",
                                                    @"email",
                                                    @"realname",
                                                    @"tj_secondHouse_num",
                                                    @"tj_rentHouse_num"
                                                    ]];
    
    return shared_mapping;
    
}

- (QSUserSimpleDataModel*)transformToSimpleDataModel
{
    
    QSUserSimpleDataModel *userData = [[QSUserSimpleDataModel alloc] init];
    
    SetModelParam(username);
    SetModelParam(mobile);
    SetModelParam(id_);
    SetModelParam(level);
    SetModelParam(user_type);
    SetModelParam(avatar);
    SetModelParam(email);
    SetModelParam(realname);
    SetModelParam(tj_secondHouse_num);
    SetModelParam(tj_rentHouse_num);
    
    //    SetModelParam(nickname);
    userData.nickname = @"";
    
    return userData;
    
}

@end


@implementation QSOrderButtonActionModel


@end
