//
//  QSOrderListReturnData.m
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListReturnData.h"

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
        //FIXME: 要修改为真实的当前用户ID！
        
        if ([self.ownerData.id_ isEqual:@"3"]) {
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

@end