//
//  QSOrderListReturnData.m
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListReturnData.h"
#import "QSCoreDataManager+User.h"

@implementation QSOrderListReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"orderListHeaderData" withMapping:[QSOrderListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSOrderListHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"orderList" withMapping:[QSOrderListItemData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSOrderListItemData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house_msg" toKeyPath:@"houseData" withMapping:[QSOrderListHouseInfoDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"owner_msg" toKeyPath:@"ownerData" withMapping:[QSOrderListOwnerMsgDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"orderInfoList" withMapping:[QSOrderListOrderInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

- (NSString*)getHouseTitle
{
    NSString *titleStr = @"";
    if (self.houseData&&self.houseData.title)
    {
        titleStr = self.houseData.title;
    }
    return titleStr;
}

- (NSString*)getHouseSmallImgUrl{
    
    NSString *url = @"";
    if (self.houseData&&self.houseData.attach_thumb) {
        url = self.houseData.attach_thumb;
    }
    return url;
}

- (NSString*)getHouseLargeImgUrl
{
    NSString *url = @"";
    if (self.houseData&&self.houseData.attach_file) {
        url = self.houseData.attach_file;
    }
    return url;
}

- (BOOL)getUserIsOwnerFlag
{
    BOOL flag = NO;
    if (self.ownerData&&self.ownerData.id_)
    {
        NSString *userID = [QSCoreDataManager getUserID];
 
        if ([self.ownerData.id_ isEqual:userID]) {
            flag = YES;
        }
    }
    return flag;
}

- (NSString*)getHouseTypeImg
{
    
    NSString *imgFileName = @"";
    
    if ([self getUserIsOwnerFlag]) {
        //非房客
        
    }else{
        //房客
        if (self.orderInfoList&&[self.orderInfoList count]>0) {
            
            QSOrderListOrderInfoDataModel *orderInfoData = [self.orderInfoList objectAtIndex:0];
            if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                if (orderInfoData.order_type&&[orderInfoData.order_type isKindOfClass:[NSString class]]) {
                    
                    //500101:一手房购买订单, 500102 二手房，500103出租房
                    if ([orderInfoData.order_type isEqualToString:@"500101"])
                    {
                        //“新”图标
                        imgFileName = IMAGE_ZONE_ORDER_LIST_CELL_NEW_CION;
                        
                    }else if ([orderInfoData.order_type isEqualToString:@"500102"])
                    {
                        //“购”图标
                        imgFileName = IMAGE_ZONE_ORDER_LIST_CELL_BUY_CION;
                        
                    }else if ([orderInfoData.order_type isEqualToString:@"500103"])
                    {
                        //“租”图标
                        imgFileName = IMAGE_ZONE_ORDER_LIST_CELL_RENT_CION;
                        
                    }
                    
                }
            }
        }
    }
    return imgFileName;
    
}

//获取订单列表房源标题下方第一个Label显示的名字身份简介字符串
- (NSString*)getPersonInfoOnCellStringWithSelectIndex:(NSInteger)index
{
    
    NSString *personName = @"";
    
    if (self.orderInfoList&&[self.orderInfoList count]>index) {
        
        QSOrderListOrderInfoDataModel *orderInfoData = [self.orderInfoList objectAtIndex:index];
        if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
            if (orderInfoData.order_status&&[orderInfoData.order_status isKindOfClass:[NSString class]]) {
                
                if ([orderInfoData.order_status isEqualToString:@"500201"]
                    ||[orderInfoData.order_status isEqualToString:@"500203"]
                    ||[orderInfoData.order_status isEqualToString:@"500210"]
                    ||[orderInfoData.order_status isEqualToString:@"500213"]
                    ||[orderInfoData.order_status isEqualToString:@"500230"]
                    ||[orderInfoData.order_status isEqualToString:@"500231"]
                    ||[orderInfoData.order_status isEqualToString:@"500232"]
                    ||[orderInfoData.order_status isEqualToString:@"500252"]
                    ||[orderInfoData.order_status isEqualToString:@"500258"]
                    ||[orderInfoData.order_status isEqualToString:@"500253"]
                    ||[orderInfoData.order_status isEqualToString:@"500254"]
                    ||[orderInfoData.order_status isEqualToString:@"500257"]
                    ||[orderInfoData.order_status isEqualToString:@"500259"]
                    ||[orderInfoData.order_status isEqualToString:@"500220"]
                    ||[orderInfoData.order_status isEqualToString:@"500221"]
                    ||[orderInfoData.order_status isEqualToString:@"500222"]
                    ||[orderInfoData.order_status isEqualToString:@"500223"]
                    ||[orderInfoData.order_status isEqualToString:@"500301"]
                    ||[orderInfoData.order_status isEqualToString:@"500302"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        personName = [NSString stringWithFormat:@"房客:%@",orderInfoData.buyer_name];
                    }else if ([orderInfoData getUserType] == uUserCountTypeTenant) {
                        //房客角色
                        if (self.ownerData&&[self.ownerData isKindOfClass:[QSOrderListOwnerMsgDataModel class]]) {
                            personName = [NSString stringWithFormat:@"业主:%@",self.ownerData.username];
                        }
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500250"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        personName = [NSString stringWithFormat:@"房客:%@",orderInfoData.buyer_name];
                    }
                }
                
                
            }
        }
    }
    
    return personName;
}

//获取订单列表房源标题下方第二个Label显示的时间价格等简介字符串
- (NSAttributedString*)getSummaryOnCellAttributedStringWithSelectIndex:(NSInteger)index
{
    
    NSAttributedString *summaryString = nil;
    
    if (self.orderInfoList&&[self.orderInfoList count]>0) {
        
        QSOrderListOrderInfoDataModel *orderInfoData = [self.orderInfoList objectAtIndex:index];
        if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
            if (orderInfoData.order_status&&[orderInfoData.order_status isKindOfClass:[NSString class]]) {
                
                if ([orderInfoData.order_status isEqualToString:@"500201"]
                    ||[orderInfoData.order_status isEqualToString:@"500203"]
                    ||[orderInfoData.order_status isEqualToString:@"500210"]
                    ||[orderInfoData.order_status isEqualToString:@"500213"]
                    ||[orderInfoData.order_status isEqualToString:@"500230"]
                    ||[orderInfoData.order_status isEqualToString:@"500232"]) {
                    
                    //预约时间
                    summaryString = [self blackWithString:[orderInfoData getAppointmentTimeString]];
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500231"]) {
                    //再预约中状态
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        //预约时间
                        summaryString = [self blackWithString:[orderInfoData getAppointmentTimeString]];
                        
                    }else if ([orderInfoData getUserType] == uUserCountTypeTenant) {
                        //房客角色
                        //显示 （二手房）售价/ （出租房）租金
                        if (orderInfoData.order_type&&[orderInfoData.order_type isKindOfClass:[NSString class]]) {
                            if (orderInfoData.order_type) {
                                
                                //500101:一手房购买订单, 500102 二手房，500103出租房
                                if ([orderInfoData.order_type isEqualToString:@"500101"])
                                {
                                    
                                }else if ([orderInfoData.order_type isEqualToString:@"500102"])
                                {
                                    if (self.houseData&&[self.houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                                        
                                        summaryString = [self priceStringWithTip:@"售价:" withPricef:[self.houseData.house_price floatValue]];
                                    }
                                }else if ([orderInfoData.order_type isEqualToString:@"500103"])
                                {
                                    if (self.houseData&&[self.houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                                        
                                        summaryString = [self priceStringWithTip:@"租金:" withPricef:[self.houseData.house_price floatValue]];
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500250"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        //预约时间
                        summaryString = [self blackWithString:[orderInfoData getAppointmentTimeString]];
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500252"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        summaryString = [self priceStringWithTip:@"房客议价:" withPricef:[orderInfoData.last_buyer_bid floatValue]];
                    }else if ([orderInfoData getUserType] == uUserCountTypeTenant) {
                        //房客角色
                        summaryString = [self priceStringWithTip:@"我还价:" withPricef:[orderInfoData.last_buyer_bid floatValue]];
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500258"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        summaryString = [self priceStringWithTip:@"协议价格:" withPricef:[orderInfoData.last_saler_bid floatValue]];
                    }else if ([orderInfoData getUserType] == uUserCountTypeTenant) {
                        //房客角色
                        summaryString = [self priceStringWithTip:@"协议价格:" withPricef:[orderInfoData.last_saler_bid floatValue]];
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500253"]
                          || [orderInfoData.order_status isEqualToString:@"500254"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        if (self.houseData&&[self.houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                            
                            //是否一口价 1：是； 0：否
                            if (self.houseData.negotiated && [self.houseData.negotiated isEqualToString:@"1"]) {
                                
                                summaryString = [self priceStringWithTip:@"一口价:" withPricef:[self.houseData.house_price floatValue]];
                                
                            }
                            
                        }
                    }else if ([orderInfoData getUserType] == uUserCountTypeTenant) {
                        //房客角色
                        if (self.houseData&&[self.houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                            
                            //是否一口价 1：是； 0：否
                            if (self.houseData.negotiated && [self.houseData.negotiated isEqualToString:@"1"]) {
                                
                                summaryString = [self priceStringWithTip:@"一口价:" withPricef:[self.houseData.house_price floatValue]];
                                
                            }
                        }
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500257"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        summaryString = [self priceStringWithTip:@"我出价:" withPricef:[orderInfoData.last_saler_bid floatValue]];
                    }else if ([orderInfoData getUserType] == uUserCountTypeTenant) {
                        //房客角色
                        summaryString = [self priceStringWithTip:@"业主还价:" withPricef:[orderInfoData.last_saler_bid floatValue]];
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500259"]) {
                    
                    //显示 （二手房）售价/ （出租房）租金
                    if (orderInfoData.order_type&&[orderInfoData.order_type isKindOfClass:[NSString class]]) {
                        if (orderInfoData.order_type) {
                            
                            //500101:一手房购买订单, 500102 二手房，500103出租房
                            if ([orderInfoData.order_type isEqualToString:@"500101"])
                            {
                                
                            }else if ([orderInfoData.order_type isEqualToString:@"500102"])
                            {
                                if (self.houseData&&[self.houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                                    
                                    summaryString = [self priceStringWithTip:@"售价:" withPricef:[self.houseData.house_price floatValue]];
                                }
                            }else if ([orderInfoData.order_type isEqualToString:@"500103"])
                            {
                                if (self.houseData&&[self.houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                                    
                                    summaryString = [self priceStringWithTip:@"租金:" withPricef:[self.houseData.house_price floatValue]];
                                }
                            }
                        }
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500221"]
                          ||[orderInfoData.order_status isEqualToString:@"500222"]
                          ||[orderInfoData.order_status isEqualToString:@"500223"]
                          ||[orderInfoData.order_status isEqualToString:@"500220"]) {
                    
                    if ([orderInfoData getUserType] == uUserCountTypeOwner) {
                        //业主角色
                        summaryString = [self priceStringWithTip:@"成交价格:" withPricef:[orderInfoData.transaction_price floatValue]];
                    }else if ([orderInfoData getUserType] == uUserCountTypeTenant) {
                        //房客角色
                        summaryString = [self priceStringWithTip:@"成交价格:" withPricef:[orderInfoData.transaction_price floatValue]];
                    }
                    
                }else if ([orderInfoData.order_status isEqualToString:@"500301"]
                          ||[orderInfoData.order_status isEqualToString:@"500302"]) {
                    
                    
                    summaryString = [self priceStringWithFirstTip:@"总价:" withFirstPricef:[self.houseData.house_price floatValue] WithSecondTip:@"万|协商价:" withSecondPricef:[orderInfoData.last_saler_bid floatValue]];
                    
                }
                
            }
        }
    }
    
    return summaryString;
}

//        NSString *tempPrice = @"430";
//        NSString *lastPrice = @"350";
//
//        if (tempPrice&&[tempPrice isKindOfClass:[NSString class]]) {
//
//            tempString = [NSString stringWithFormat:@"总价%@万|协商价%@万",tempPrice,lastPrice];
//            summaryString = [[NSMutableAttributedString alloc] initWithString:tempString];
//            [summaryString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(2, tempPrice.length)];
//            [summaryString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(7+tempPrice.length, lastPrice.length)];
//
//        }
//    summaryString = [self priceStringWithTip:@"售价：" withPricef:3513.12];

- (NSAttributedString*)blackWithString:(NSString*)string
{
    
    NSMutableAttributedString *tempString = [[NSMutableAttributedString alloc] initWithString:string];
    [tempString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];
    //设置字体大小
    [tempString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_12] range:NSMakeRange(0, string.length)];

    return tempString;
    
}

- (NSAttributedString*)priceStringWithTip:(NSString*)tipString withPricef:(CGFloat)pricef
{
    
    pricef = pricef/10000.0;
    NSInteger priceInt = (NSInteger)pricef;
    
    NSString *priceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
    NSString *tempString = [NSString stringWithFormat:@"%@%@万",tipString,priceStr];
    NSMutableAttributedString *summaryString = [[NSMutableAttributedString alloc] initWithString:tempString];
    [summaryString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(tipString.length, priceStr.length)];
    //设置字体大小
    [summaryString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_12] range:NSMakeRange(0, summaryString.length)];
    [summaryString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_14] range:NSMakeRange(tipString.length, priceStr.length)];
    return summaryString;
    
}

- (NSAttributedString*)priceStringWithFirstTip:(NSString*)tip1String withFirstPricef:(CGFloat)price1f WithSecondTip:(NSString*)tip2String withSecondPricef:(CGFloat)price2f
{
    
    price1f = price1f/10000.0;
    NSInteger price1Int = (NSInteger)price1f;
    NSString *price1Str = [NSString stringWithFormat:@"%ld",(long)price1Int];
    
    price2f = price2f/10000.0;
    NSInteger price2Int = (NSInteger)price2f;
    NSString *price2Str = [NSString stringWithFormat:@"%ld",(long)price2Int];
    
    NSMutableAttributedString *summaryString;
    
    if (price1Str&&[price1Str isKindOfClass:[NSString class]]) {
        
        NSString *tempString = [NSString stringWithFormat:@"%@%@%@%@万",tip1String,price1Str,tip2String,price2Str];
        
        summaryString = [[NSMutableAttributedString alloc] initWithString:tempString];
        
        [summaryString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, summaryString.length)];
        [summaryString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(tip1String.length, price1Str.length)];
        [summaryString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(tip1String.length+price1Str.length+tip2String.length, price2Str.length)];
        
    }

    return summaryString;
    
}


@end