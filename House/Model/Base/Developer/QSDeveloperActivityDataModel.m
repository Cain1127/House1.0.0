//
//  QSDeveloperActivityDataModel.m
//  House
//
//  Created by 王树朋 on 15/4/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDeveloperActivityDataModel.h"

@implementation QSDeveloperActivityDataModel

+(RKObjectMapping *)objectMapping
{

    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addAttributeMappingsFromArray:@[
                                            @"id_",
                                            @"people_num",
                                            @"user_id",
                                            @"loupan_id",
                                            @"loupan_building_id",
                                            @"loupan_periods",
                                            @"title",
                                            @"content",
                                            @"start_time",
                                            @"end_time",
                                            @"view_count",
                                            @"commend",
                                            @"attach_file",
                                            @"attach_thumb",
                                            @"update_time",
                                            @"sort_desc",
                                            @"status",
                                            @"create_time",
                                            @"apply_num"
     
                                            ]];
    
    return shared_mapping;

}

@end
