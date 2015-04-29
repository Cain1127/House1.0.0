//
//  QSYMyzoneStatisticsRenantModel.m
//  House
//
//  Created by ysmeng on 15/4/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMyzoneStatisticsRenantModel.h"

@implementation QSYMyzoneStatisticsRenantModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"book_wait",
                                                    @"book_ok",
                                                    @"book_all",
                                                    @"transaction_wait",
                                                    @"transaction_ok",
                                                    @"transaction_all",
                                                    @"store_rent",
                                                    @"store_apartment",
                                                    @"store_village",
                                                    @"book_wait_bid",
                                                    @"ask_for_total"]];
    
    return shared_mapping;
    
}

@end
