//
//  QSHouseTypeDataModel.m
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHouseTypeDataModel.h"

@implementation QSHouseTypeDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"title",
                                                    @"title_second",
                                                    @"loupan_id",
                                                    @"loupan_building_id",
                                                    @"introduce",
                                                    @"content",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"house_area",
                                                    @"loupan_periods",
                                                    @"building_no",
                                                    @"view_count",
                                                    @"attach_file",
                                                    @"attach_thumb",
                                                    @"room_features"]];
    
    return shared_mapping;
    
}

@end
