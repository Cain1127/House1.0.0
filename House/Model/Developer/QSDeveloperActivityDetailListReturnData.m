//
//  QSDeveloperActivityDetailListDataModel.m
//  House
//
//  Created by 王树朋 on 15/4/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDeveloperActivityDetailListReturnData.h"
#import "QSDeveloperActivityDetailDataModel.h"

@implementation QSDeveloperActivityDetailListDataModel

+(RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"total_page",
                                                    @"total_num",
                                                    @"page_num",
                                                    @"before_page",
                                                    @"per_page",
                                                    @"next_page"
                                                    ]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"records" withMapping:[QSDeveloperActivityDetailDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
