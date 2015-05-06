//
//  QSYAskListOrderInfosModel.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskListOrderInfosModel.h"
#import "QSBaseHouseInfoDataModel.h"

@implementation QSYAskListOrderInfosModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"order_type",
                                                    @"add_time",
                                                    @"modefy_time",
                                                    @"order_status",
                                                    @"appoint_date",
                                                    @"bargain_team",
                                                    @"transaction_price",
                                                    @"source_id",
                                                    @"source_ask_for_id",
                                                    @"saler_id",
                                                    @"buyer_id",
                                                    @"last_operater_id",
                                                    @"o_expand_1",
                                                    @"o_expand_2",
                                                    @"appoint_start_time",
                                                    @"appoint_end_time",
                                                    @"buyer_name",
                                                    @"buyer_phone",
                                                    @"add_type",
                                                    @"last_buyer_bid",
                                                    @"last_saler_bid"]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house_msg" toKeyPath:@"house_msg" withMapping:[QSBaseHouseInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
