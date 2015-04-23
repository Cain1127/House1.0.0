//
//  QSDeveloperActivityListReturnData.m
//  House
//
//  Created by 王树朋 on 15/4/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDeveloperActivityListReturnData.h"
#import "QSDeveloperActivityDataModel.h"

@implementation QSDeveloperActivityListReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"msg" withMapping:[QSDeveloperActivityListDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSDeveloperActivityListDataModel

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
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"records" withMapping:[QSDeveloperActivityDataModel objectMapping]]];
    
    return shared_mapping;

}

@end