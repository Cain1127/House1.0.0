//
//  QSMapNewHouseDataModel.m
//  House
//
//  Created by 王树朋 on 15/5/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMapNewHouseDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"

@implementation QSMapNewHouseDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [super objectMapping];

    
    //mapping字典
    NSDictionary *mappingDict = @{@"total_house":@"total_house"
                                  };
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupan_msg" toKeyPath:@"loupan_msg" withMapping:[QSLoupanInfoDataModel objectMapping]]];
    
       [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loupanbuilding_msg" toKeyPath:@"loupanbuilding_msg" withMapping:[QSLoupanPhaseDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
