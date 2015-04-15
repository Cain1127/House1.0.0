//
//  QSOrderDetailInfoDataModel.m
//  House
//
//  Created by CoolTea on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//
//
//                                  _oo8oo_
//                                 o8888888o
//                                 88" . "88
//                                 (| -_- |)
//                                 0\  =  /0
//                               ___/'==='\___
//                             .' \\|     |// '.
//                            / \\|||  :  |||// \
//                           / _||||| -:- |||||_ \
//                          |   | \\\  -  /// |   |
//                          | \_|  ''\---/''  |_/ |
//                          \  .-\__  '-'  __/-.  /
//                        ___'. .'  /--.--\  '. .'___
//                     ."" '<  '.___\_<|>_/___.'  >' "".
//                    | | :  `- \`.:`\ _ /`:.`/ -`  : | |
//                    \  \ `-.   \_ __\ /__ _/   .-` /  /
//                =====`-.____`.___ \_____/ ___.`____.-`=====
//                                  `=---=`
//
//
//               ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
//                          佛祖保佑         永不宕机/永无bug
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
    
    USER_COUNT_TYPE userType = [self getUserType];
    
    NSString *housePriceStr = self.house_msg.house_price;
    if (housePriceStr) {
        CGFloat pricef = [housePriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        housePriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *salerPriceStr = self.last_saler_bid;
    if (salerPriceStr) {
        CGFloat pricef = [salerPriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        salerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *buyerPriceStr = self.last_buyer_bid;
    if (buyerPriceStr) {
        CGFloat pricef = [buyerPriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        buyerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *myPriceStr = nil;
    NSString *otherPriceStr = nil;
    
    NSString *userTypeStr = @"";
    if (uUserCountTypeTenant==userType) {
        //房客身份
        userTypeStr = @"业主";
        myPriceStr = buyerPriceStr;
        otherPriceStr = salerPriceStr;
        if ([otherPriceStr isEqualToString:housePriceStr]) {
            otherPriceStr = @"";
        }
        
    }else {
        //非房客身份
        userTypeStr = @"房客";
        myPriceStr = salerPriceStr;
        otherPriceStr = buyerPriceStr;
        
    }
    
    NSString* priceStr = otherPriceStr;
    
    if (priceStr && ![priceStr isEqualToString:@""] && ![priceStr isEqualToString:@"0"]) {
        
        NSString* tempString = [NSString stringWithFormat:@"%@万",priceStr];
        
        priceInfoString = [[NSMutableAttributedString alloc] initWithString:tempString];
        
        [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(0, priceInfoString.length)];
        
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_16] range:NSMakeRange(0, priceInfoString.length)];
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_25] range:NSMakeRange(0, priceStr.length)];
        
    }else{
        
        priceInfoString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"等待%@还价",userTypeStr]];
        
        [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_GRAY range:NSMakeRange(0, priceInfoString.length)];
        
        [priceInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, priceInfoString.length)];
        
    }

    return priceInfoString;
    
}

- (NSAttributedString*)priceStringOnMyPriceView
{
    
    NSMutableAttributedString *priceInfoString = nil;
    
    USER_COUNT_TYPE userType = [self getUserType];
    
    NSString *housePriceStr = self.house_msg.house_price;
    if (housePriceStr) {
        CGFloat pricef = [housePriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        housePriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *salerPriceStr = self.last_saler_bid;
    if (salerPriceStr) {
        CGFloat pricef = [salerPriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        salerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *buyerPriceStr = self.last_buyer_bid;
    if (buyerPriceStr) {
        CGFloat pricef = [buyerPriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        buyerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *myPriceStr = nil;
    NSString *otherPriceStr = nil;
    
    NSString *userTypeStr = @"";
    if (uUserCountTypeTenant==userType) {
        //房客身份
        userTypeStr = @"业主";
        myPriceStr = buyerPriceStr;
        otherPriceStr = salerPriceStr;
        
    }else {
        //非房客身份
        userTypeStr = @"房客";
        myPriceStr = salerPriceStr;
        otherPriceStr = buyerPriceStr;
        if ([myPriceStr isEqualToString:housePriceStr]) {
            myPriceStr = @"";
        }
        
    }
    
    NSString* priceStr = myPriceStr;
    NSString* tempString = @"";
    
    UIColor *textColor = COLOR_CHARACTERS_YELLOW;
    
    if (!priceStr || [priceStr isEqualToString:@""] || [priceStr isEqualToString:@"0"]) {
        
        tempString = @"输入您的还价";
        textColor = COLOR_CHARACTERS_GRAY;
    }else{
        
        tempString = [NSString stringWithFormat:@"%@万",priceStr];
        textColor = COLOR_CHARACTERS_YELLOW;
    }
    
    priceInfoString = [[NSMutableAttributedString alloc] initWithString:tempString];
    
    [priceInfoString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, priceInfoString.length)];
    
    [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_16] range:NSMakeRange(0, priceInfoString.length)];
    [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_25] range:NSMakeRange(0, priceStr.length)];
    
    return priceInfoString;
    
}

- (NSAttributedString*)titleStringOnBargainListView
{
    
    NSMutableAttributedString *countInfoString = nil;
    
    NSString* countStr = @"0";
    
    USER_COUNT_TYPE userType = [self getUserType];
    
    NSString* otherType = @"对方";
    
    if (uUserCountTypeTenant == userType) {
        otherType = @"业主";
    }else if (uUserCountTypeOwner == userType) {
        otherType = @"房客";
    }
    
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
    
    USER_COUNT_TYPE userType = [self getUserType];
    
    NSString *salerPriceStr = itemData.saler_bid;//@"290";
    if (salerPriceStr) {
        CGFloat pricef = [salerPriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        salerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *buyerPriceStr = itemData.buyer_bid;//@"310";
    if (buyerPriceStr) {
        CGFloat pricef = [buyerPriceStr floatValue]/10000.0;
        NSInteger priceInt = (NSInteger)pricef;
        buyerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    }
    
    NSString *myPriceStr = nil;
    NSString *otherPriceStr = nil;
    
    NSString *userTypeStr = @"";
    if (uUserCountTypeTenant==userType) {
        //房客身份
        userTypeStr = @"业主";
        myPriceStr = buyerPriceStr;
        otherPriceStr = salerPriceStr;
        
    }else {
        //非房客身份
        userTypeStr = @"房客";
        myPriceStr = salerPriceStr;
        otherPriceStr = buyerPriceStr;
        
    }
    
    
    NSString *myPriceInfoString = nil;
    
    if (myPriceStr && ![myPriceStr isEqualToString:@""] && ![myPriceStr isEqualToString:@"0"]) {
        
        myPriceInfoString = [NSString stringWithFormat:@"我的出价%@万",myPriceStr];
        
        itemInfoString = [[NSMutableAttributedString alloc] initWithString:myPriceInfoString];
        
        [itemInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_BLACK range:NSMakeRange(0, itemInfoString.length)];
        
        [itemInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, itemInfoString.length)];
        
        [itemInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(4, myPriceStr.length)];
        
        
    }
    
    if (otherPriceStr && ![otherPriceStr isEqualToString:@""] && ![otherPriceStr isEqualToString:@"0"]) {
        
        NSString *otherPriceString = [NSString stringWithFormat:@"%@还价%@万",userTypeStr,otherPriceStr];
        NSMutableAttributedString *otherPriceInfoString = [[NSMutableAttributedString alloc] initWithString:otherPriceString];
        
        [otherPriceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_BLACK range:NSMakeRange(0, otherPriceInfoString.length)];
        
        [otherPriceInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, otherPriceInfoString.length)];
        
        [otherPriceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(2+userTypeStr.length, otherPriceStr.length)];
        
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
    self.isShowPersonInfoView = flag;
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
    
    if ([self.order_status isEqualToString:@"500202"]) {
        NSString *lastOrderStatus = self.o_expand_1;
        self.o_expand_1 = self.order_status;
        self.order_status = lastOrderStatus;
    }
    
    [self setAllViewsFlagWithFlag:NO];
    
    if (self.order_status&&[self.order_status isKindOfClass:[NSString class]]) {
        
        if ([self.order_status isEqualToString:@"500201"] || [self.order_status isEqualToString:@"500203"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowAddressView = YES;
            self.isShowPersonInfoView = YES;
            
            
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
            self.isShowPersonInfoView = YES;
            
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
            self.isShowPersonInfoView = YES;
            
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
            
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
            self.isShowPersonInfoView = YES;
            
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
            self.isShowPersonInfoView = YES;
            
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
            self.isShowPersonInfoView = YES;
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
                self.isShowConfirmOrderButtonView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500258"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
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
            self.isShowPersonInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
        }else if ([self.order_status isEqualToString:@"500240"] || [self.order_status isEqualToString:@"500241"] || [self.order_status isEqualToString:@"500246"]) {
            
            self.isShowTitleView = YES;
            self.isShowShowingsTimeView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowPersonInfoView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                self.isShowOrderCancelByMeTipView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                
                self.isShowAppointmentSalerAgainButtonView = YES;
                self.isShowOrderCancelByOwnerTipView = YES;
                
            }
            
        }else if ([self.order_status isEqualToString:@"500302"]) {
            //成交订单待房客确认成交
            self.isShowTitleView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowPersonInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //取消成交、提醒房客
                self.isShowCancelTransAndWarmBuyerButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //取消成交、确定成交
                self.isShowCancelTransAndCompleteButtonView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500301"]) {
            //成交订单待业主确认成交
            self.isShowTitleView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowPersonInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
            if ([self getUserType] == uUserCountTypeOwner) {
                //业主角色
                //取消成交、确定成交
                self.isShowCancelTransAndCompleteButtonView = YES;
                
            }else if ([self getUserType] == uUserCountTypeTenant) {
                //房客角色
                //取消成交、提醒业主
                self.isShowCancelTransAndWarmSalerButtonView = YES;
                
            }
        }else if ([self.order_status isEqualToString:@"500320"]) {
            //成交订单已成交
            self.isShowTitleView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowPersonInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
        }else if ([self.order_status isEqualToString:@"500340"]
                  ||[self.order_status isEqualToString:@"500341"]
                  ||[self.order_status isEqualToString:@"500346"]) {
            //成交订单已取消
            self.isShowTitleView = YES;
            self.isShowHouseInfoView = YES;
            self.isShowHousePriceView = YES;
            self.isShowPersonInfoView = YES;
            self.isShowTransactionPriceView = YES;
            self.isShowBargainingPriceHistoryView = YES;
            
        }
        
        //缺 成交订单  – 已取消 状态码未确定
        
    }
    
    //FIXME: 测试用
//    [self setAllViewsFlagWithFlag:YES];
    
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
