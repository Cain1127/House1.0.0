//
//  QSRentHousePriceChangesDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHousePriceChangesDataModel.h"

@implementation QSHousePriceChangesDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"type",
                                                    @"obj_id",
                                                    @"title",
                                                    @"before_price",
                                                    @"revised_price",
                                                    @"update_time",
                                                    @"create_time",
                                                    @"price_changes_num"]];
    
    return shared_mapping;
    
}

@end
