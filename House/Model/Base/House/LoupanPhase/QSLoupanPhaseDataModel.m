//
//  QSLoupanPhaseDataModel.m
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLoupanPhaseDataModel.h"

@implementation QSLoupanPhaseDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"house_no",
                                                    @"loupan_id",
                                                    @"loupan_periods",
                                                    @"building_no",
                                                    @"open_time",
                                                    @"checkin_time",
                                                    @"households_num",
                                                    @"ladder",
                                                    @"ladder_family",
                                                    @"tel",
                                                    @"price_avg",
                                                    @"min_house_area",
                                                    @"max_house_area",
                                                    @"tj_condition",
                                                    @"tj_environment",
                                                    @"is_store"]];
    
    return shared_mapping;
    
}

@end
