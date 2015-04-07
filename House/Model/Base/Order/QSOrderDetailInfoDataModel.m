//
//  QSOrderDetailInfoDataModel.m
//  House
//
//  Created by CoolTea on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderDetailInfoDataModel.h"

@implementation QSOrderDetailInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
//    RKObjectMapping *shared_mapping = nil;
//    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
     RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house_msg" toKeyPath:@"house_msg" withMapping:[QSOrderDetailInfoHouseDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"appoint_list" toKeyPath:@"appoint_list" withMapping:[QSOrderDetailAppointTimeDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"saler_msg" toKeyPath:@"saler_msg" withMapping:[QSOrderListOrderInfoPersonInfoDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"bargain_list" toKeyPath:@"bargain_list" withMapping:[QSOrderDetailBargainDataModel objectMapping]]];
    
    return shared_mapping;
    
}

- (NSAttributedString*)priceStringOnOtherPriceView
{
    
    NSMutableAttributedString *priceInfoString = nil;
    
    NSString* priceStr = @"";
    if (priceStr && ![priceStr isEqualToString:@""]) {
        
        NSString* tempString = [NSString stringWithFormat:@"%@万",priceStr];
        
        priceInfoString = [[NSMutableAttributedString alloc] initWithString:tempString];
        
        [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_GRAY range:NSMakeRange(0, priceInfoString.length)];
        
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_16] range:NSMakeRange(0, priceInfoString.length)];
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_25] range:NSMakeRange(0, priceStr.length)];
        
    }else{
        
        priceInfoString = [[NSMutableAttributedString alloc] initWithString:@"等待业主还价"];
        
        [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_GRAY range:NSMakeRange(0, priceInfoString.length)];
        
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, priceInfoString.length)];
        
    }

    return priceInfoString;
    
}

- (NSAttributedString*)priceStringOnMyPriceView
{
    
    NSMutableAttributedString *priceInfoString = nil;
    
    NSString* priceStr = @"388";
    NSString* tempString = [NSString stringWithFormat:@"%@万",priceStr];
    
    priceInfoString = [[NSMutableAttributedString alloc] initWithString:tempString];
    
    [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(0, priceInfoString.length)];
    
    [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_16] range:NSMakeRange(0, priceInfoString.length)];
    [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_25] range:NSMakeRange(0, priceStr.length)];
    
    return priceInfoString;
    
}

- (NSAttributedString*)titleStringOnBargainListView
{
    
    NSMutableAttributedString *countInfoString = nil;
    
    NSString* countStr = @"999999";
    NSString* otherType = @"业主";
    
    if (self.bargain_list&&[self.bargain_list count]>0) {
        countStr = [NSString stringWithFormat:@"%lu",(unsigned long)[self.bargain_list count]];
    }
    
    if (countStr && ![countStr isEqualToString:@""]) {
        
        NSString* tempString = [NSString stringWithFormat:@"我和%@的议价记录（%@）条",otherType,countStr];
        
        countInfoString = [[NSMutableAttributedString alloc] initWithString:tempString];
        
        [countInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_BLACK range:NSMakeRange(0, countInfoString.length)];
        
        [countInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, countInfoString.length)];
        
        [countInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(8+otherType.length, countStr.length)];
        
    }else{

        
    }
    
    return countInfoString;
    
}

- (NSAttributedString*)infoStringOnBargainListView:(QSOrderDetailBargainDataModel*)itemData
{
    
    NSMutableAttributedString *itemInfoString = nil;
    
    if (!itemData || ![itemData isKindOfClass:[QSOrderDetailBargainDataModel class]]) {
        NSLog(@"itemData 格式错误");
        return itemInfoString;
    }
    
    //FIXME: 缺房客与业主角色逻辑
    NSString *myPriceStr = itemData.saler_bid;//@"290";
    NSString *otherPriceStr = itemData.buyer_bid;//@"310";
    
    NSString *myPriceInfoString = nil;
    
    if (myPriceStr && ![myPriceStr isEqualToString:@""]) {
        
        myPriceInfoString = [NSString stringWithFormat:@"我的出价%@万",myPriceStr];
        
        itemInfoString = [[NSMutableAttributedString alloc] initWithString:myPriceInfoString];
        
        [itemInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_BLACK range:NSMakeRange(0, itemInfoString.length)];
        
        [itemInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, itemInfoString.length)];
        
        [itemInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(4, myPriceStr.length)];
        
        
    }
    
    if (otherPriceStr && ![otherPriceStr isEqualToString:@""]) {
        
        NSString *otherPriceString = [NSString stringWithFormat:@"业主还价%@万",otherPriceStr];
        NSMutableAttributedString *otherPriceInfoString = [[NSMutableAttributedString alloc] initWithString:otherPriceString];
        
        [otherPriceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_BLACK range:NSMakeRange(0, otherPriceInfoString.length)];
        
        [otherPriceInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, otherPriceInfoString.length)];
        
        [otherPriceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(4, otherPriceStr.length)];
        
        if (itemInfoString) {
            
            [itemInfoString appendAttributedString:[[NSAttributedString alloc] initWithString:@"|"]];
            [itemInfoString appendAttributedString:otherPriceInfoString];
            
        }else{
            
            itemInfoString = otherPriceInfoString;
            
        }
        
    }
    
    return itemInfoString;
    
}

- (void)setAllViewsFlagWithFlag:(BOOL)flag
{
    //重置Flag
    self.isShowTitleView = flag;
    self.isShowShowingsTimeView = flag;
    self.isShowShowingsActivitiesView = flag;
    self.isShowHouseInfoView = flag;
    self.isShowHousePriceView = flag;
    self.isShowAddressView = flag;
    self.isShowOwnerInfoView = flag;
    self.isShowActivitiesPhoneView = flag;
    self.isShowOtherPriceView = flag;
    self.isShowMyPriceView = flag;
    self.isShowInputMyPriceView = flag;
    self.isShowTransactionPriceView = flag;
    self.isShowBargainingPriceHistoryView = flag;
    self.isShowRemarkRejectPriceView = flag;
    self.isShowOrderCancelByOwnerTipView = flag;
    self.isShowCommentNoteTipsView = flag;
    self.isShowOrderCancelByMeTipView = flag;
    
    self.isShowComplaintAndCommentButtonView = flag;
    self.isShowComplaintAndCompletedButtonView = flag;
    self.isShowAppointAgainAndPriceAgainButtonView = flag;
    self.isShowAppointAgainView = flag;
    self.isShowAppointAgainAndRejectPriceButtonView = flag;
    self.isShowRejectAndAcceptAppointmentButtonView = flag;
    self.isShowCancelTransAndWarmBuyerButtonView = flag;
    self.isShowCancelTransAndWarmSalerButtonView = flag;
    self.isShowCancelTransAndCompleteButtonView = flag;
    self.isShowAcceptOrRejectApplicationView = flag;
    self.isShowAppointAgainOrCancelApplicationView = flag;
    self.isShowAppointAgainAndApplicationBargainView = flag;
    
    self.isShowChangeOrderButtonEnableView = flag;
    self.isShowChangeOrderButtonDisableView = flag;
    self.isShowConfirmOrderButtonView = flag;
    self.isShowConfirmOrderDisableButtonView = flag;
    self.isShowSubmitPriceButtonView = flag;
    self.isShowRejectPriceButtonView = flag;
    self.isShowAppointmentSalerAgainButtonView = flag;
    self.isShowChangeAppointmentButtonView = flag;
    self.isShowCancelAppointmentButtonView = flag;
    self.isShowAppointmentAgainButtonView = flag;
    
}

- (void)updateViewsFlags
{
    
    [self setAllViewsFlagWithFlag:NO];
    
    if (self.order_status&&[self.order_status isKindOfClass:[NSString class]]) {
        
        if ([self.order_status isEqualToString:@"500201"] || [self.order_status isEqualToString:@"500203"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowAddressView = YES;
            self.isShowOwnerInfoView = YES;
            
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //接受预约、拒绝预约
                self.isShowRejectAndAcceptAppointmentButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //修改订单-不能点击
                self.isShowChangeOrderButtonDisableView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500210"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowAddressView = YES;
            self.isShowOwnerInfoView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //取消预
                self.isShowCancelAppointmentButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //修改订单
                self.isShowChangeOrderButtonEnableView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500213"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowAddressView = YES;
            self.isShowOwnerInfoView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //取消预约
                self.isShowCancelAppointmentButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //修改订单-不能点击
                self.isShowChangeOrderButtonDisableView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500230"]) {
        
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowCommentNoteTipsView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //我要投诉、完成看房
                self.isShowComplaintAndCompletedButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //我要投诉、评价房源
                self.isShowComplaintAndCommentButtonView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500231"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowOwnerInfoView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                self.isShowCommentNoteTipsView = YES;
                
                //我要投诉、完成看房
                self.isShowComplaintAndCompletedButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                self.isShowHousePriceView = YES;
                
                //G-06-4-按钮不能点击 再次预约、议价、我要成交
                self.isShowAppointAgainAndPriceAgainButtonView = YES;
                self.isShowConfirmOrderButtonView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500232"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowOwnerInfoView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                self.isShowCommentNoteTipsView = YES;
                //我要投诉、评价房源
                self.isShowComplaintAndCommentButtonView = YES;
            }
            
        }else if ([self.order_status isEqualToString:@"500250"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowOwnerInfoView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                self.isShowHousePriceView = YES;
                self.isShowInputMyPriceView = YES;
                self.isShowSubmitPriceButtonView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500252"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowOtherPriceView = YES;
            self.isShowMyPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
                //G-29-1/G-29-2  同意还价、编辑出价、拒绝还价
                //拒绝还价
                self.isShowRejectPriceButtonView = YES;
                
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                self.isShowRemarkRejectPriceView = YES;
                
//                G-07-1-可点击：再次预约、
//                不可点击：同意还价、拒绝还价、编辑还价、我要成交
                //FIXME: 混乱的按钮……
                
                self.isShowAppointAgainAndRejectPriceButtonView = YES;
                
                
            }
        }else if ([self.order_status isEqualToString:@"500258"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //不能点击：成交
                self.isShowConfirmOrderDisableButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //再次预约、我要成交
                self.isShowAppointAgainView = YES;
                self.isShowConfirmOrderButtonView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500253"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //接受申请、拒绝申请
                self.isShowAcceptOrRejectApplicationView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //再次预约、取消申请、成交
                self.isShowAppointAgainOrCancelApplicationView = YES;
                self.isShowConfirmOrderButtonView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500254"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //再次预约、申请议价、成交
                self.isShowAppointAgainAndApplicationBargainView = YES;
                self.isShowConfirmOrderButtonView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500257"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowOtherPriceView = YES;
            self.isShowMyPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //不可点击-同意还价、编辑出价、拒绝还价
                self.isShowRejectPriceButtonView = YES;
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //再次预约、我要成交、同意还价、拒绝还价、编辑还价
                self.isShowAppointAgainAndRejectPriceButtonView = YES;
                self.isShowConfirmOrderButtonView = YES;
            }
        }else if ([self.order_status isEqualToString:@"500259"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //再次预约、申请议价、成交
                self.isShowConfirmOrderButtonView = YES;
                self.isShowAppointAgainAndApplicationBargainView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500220"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //我要成交
                self.isShowConfirmOrderButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //再次预约、我要成交
                self.isShowAppointAgainView = YES;
                self.isShowConfirmOrderButtonView = YES;

            }
            
        }else if ([self.order_status isEqualToString:@"500221"]) {
            
            self.isShowTitleView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //取消成交、提醒房客
                self.isShowCancelTransAndWarmBuyerButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //取消成交、确认成交
                self.isShowCancelTransAndCompleteButtonView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500222"]) {
            
            self.isShowTitleView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //取消成交、确认成交
                self.isShowCancelTransAndCompleteButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //取消成交、提醒业主
                self.isShowCancelTransAndWarmSalerButtonView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500223"]) {
            
            self.isShowTitleView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowOwnerInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
        }else if ([self.order_status isEqualToString:@"500240"] || [self.order_status isEqualToString:@"500241"] || [self.order_status isEqualToString:@"500246"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowOwnerInfoView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                self.isShowOrderCancelByMeTipView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                self.isShowAppointmentSalerAgainButtonView = YES;
                self.isShowOrderCancelByOwnerTipView = YES;
                
            }
            
        }
        
        //缺 成交订单  – 已取消 状态码未确定
        
    }
    
    //FIXME: 测试用
    [self setAllViewsFlagWithFlag:YES];
    
}

@end


@implementation QSOrderDetailAppointTimeDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"time"
                                                    ]];
    
    return shared_mapping;
    
}

@end


@implementation QSOrderDetailBargainDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"buyer_bid",
                                                    @"saler_bid",
                                                    @"expand_1",
                                                    @"expand_2"
                                                    ]];
    
    return shared_mapping;
    
}

@end


@implementation QSOrderDetailInfoHouseDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///继承
     RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"user_id",
                                                    @"title_second",
                                                    @"village_id",
                                                    @"village_name",
                                                    @"introduce",
                                                    @"content",
                                                    @"floor_num",
                                                    @"floor_which",
                                                    @"house_nature",
                                                    @"building_year",
                                                    @"house_face",
                                                    @"decoration_type",
                                                    @"building_structure",
                                                    @"used_year",
                                                    @"installation",
                                                    @"features",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"elevator",
                                                    @"cycle",
                                                    @"time_interval_start",
                                                    @"time_interval_end",
                                                    @"name",
                                                    @"tel",
                                                    @"entrust",
                                                    @"entrust_company",
                                                    @"view_count",
                                                    @"provinceid",
                                                    @"areaid",
                                                    @"commend",
                                                    @"update_time",
                                                    @"sort_desc",
                                                    @"status",
                                                    @"create_time",
                                                    @"video_url",
                                                    @"reservation_num",
                                                    @"property_type",
                                                    @"attention_count",
                                                    @"favorite_count",
                                                    @"tj_condition",
                                                    @"tj_environment",
                                                    @"coordinate_x",
                                                    @"coordinate_y"]];
    return shared_mapping;
    
}

@end
