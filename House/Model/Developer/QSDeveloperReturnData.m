//
//  QSDeveloperReturnData.m
//  House
//
//  Created by 王树朋 on 15/4/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDeveloperReturnData.h"
#import "QSDeveloperDataModel.h"

@implementation QSDeveloperReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"msg" withMapping:[QSDeveloperListReturnData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSDeveloperListReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    [shared_mapping addAttributeMappingsFromArray:@[
                                                    @"developers_loupan_num",
                                                    @"developers_activity_num",
                                                    @"total_view",
                                                    @"book_num",
                                                    @"best_loupan"
                                                    ]];
//    
//    ///在超类的mapping规则之上添加子类mapping
//    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"best_loupan" toKeyPath:@"best_loupan" withMapping:[QSDeveloperDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
