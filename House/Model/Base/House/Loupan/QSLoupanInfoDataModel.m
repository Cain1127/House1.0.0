//
//  QSLoupanInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLoupanInfoDataModel.h"

@implementation QSLoupanInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"house_no",
                                                    @"building_structure",
                                                    @"decoration_type",
                                                    @"heating",
                                                    @"company_property",
                                                    @"fee",
                                                    @"water",
                                                    @"open_time",
                                                    @"area_covered",
                                                    @"areabuilt",
                                                    @"volume_rate",
                                                    @"green_rate",
                                                    @"licence",
                                                    @"parking_lot",
                                                    @"loupan_status"]];
    
    return shared_mapping;
    
}

@end
