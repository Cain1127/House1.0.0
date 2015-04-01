//
//  QSYAskRentAndBuyDataModel.m
//  House
//
//  Created by ysmeng on 15/3/31.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAskRentAndBuyDataModel.h"

@implementation QSYAskRentAndBuyDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"type",
                                                    @"title",
                                                    @"title_second",
                                                    @"content",
                                                    @"intent",
                                                    @"rent_property",
                                                    @"price",
                                                    @"property_type",
                                                    @"decoration_type",
                                                    @"floor_which",
                                                    @"house_face",
                                                    @"installation",
                                                    @"features",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"house_area",
                                                    @"provinceid",
                                                    @"cityid",
                                                    @"areaid",
                                                    @"street",
                                                    @"view_count",
                                                    @"commend",
                                                    @"commend_num",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"status",
                                                    @"payment"]];
    
    return shared_mapping;
    
}

@end
