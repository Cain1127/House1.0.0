//
//  QSOrderListHouseInfoDataModel.m
//  House
//
//  Created by CoolTea on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListHouseInfoDataModel.h"

@implementation QSOrderListHouseInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"title",
                                                    @"address",
                                                    @"cityid",
                                                    @"street",
                                                    @"negotiated",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"house_price",
                                                    @"house_area"]];
    return shared_mapping;
    
}

@end
