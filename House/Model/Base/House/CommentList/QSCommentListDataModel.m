//
//  QSCommentListDataModel.m
//  House
//
//  Created by 王树朋 on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommentListDataModel.h"

@implementation QSCommentListDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"evaluater_id",
                                                    @"score",
                                                    @"desc",
                                                    @"status",
                                                    @"suitable",
                                                    @"manner_score",
                                                    @"evaluater_type",
                                                    @"expand_1",
                                                    @"expand_2",
                                                    @"reviewed",
                                                    ]];

    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"owner_msg" toKeyPath:@"owner_msg" withMapping:[QSCommentListOwnerInfoDataModel objectMapping]]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"order_msg" toKeyPath:@"order_msg" withMapping:[QSCommentListOrderInfoDataModel objectMapping]]];
    return shared_mapping;
    
}

@end

@implementation QSCommentListOwnerInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_type",
                                                    @"username",
                                                    @"email",
                                                    @"mobile",
                                                    @"realname",
                                                    @"avatar",
                                                    @"tj_secondHouse_num",
                                                    @"tj_rentHouse_num",
                                                    @"level"

                                                    ]];
    
    return shared_mapping;
    
}
@end
@implementation QSCommentListOrderInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"order_type",
                                                    @"add_time",
                                                    @"modefy_time",
                                                    @"order_status",
                                                    @"status",
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
                                                    @"last_saler_bid"
                                                    ]];
    
    return shared_mapping;
    
}

@end