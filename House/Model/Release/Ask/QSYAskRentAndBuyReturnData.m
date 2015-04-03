//
//  QSYAskRentAndBuyReturnData.m
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRentAndBuyReturnData.h"
#import "QSYAskRentAndBuyDataModel.h"
#import "QSYAskListOrderInfosModel.h"

@implementation QSYAskRentAndBuyReturnData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"is_pass",
                                                    @"rent_num",
                                                    @"purchase_num"]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"headerData" withMapping:[QSYAskRentAndBuyHeaderData objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"order_list" toKeyPath:@"orderList" withMapping:[QSYAskListOrderInfosModel objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSYAskRentAndBuyHeaderData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///添加附加mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"is_pass",@"rent_num",@"purchase_num"]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"dataList" withMapping:[QSYAskRentAndBuyDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end