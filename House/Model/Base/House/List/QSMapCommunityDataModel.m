//
//  QSMapCommunityDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSMapCommunityDataModel.h"

@implementation QSMapCommunityDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    //mapping字典
    NSDictionary *mappingDict = @{@"total_num":@"total_num"
                                  };
    [shared_mapping addAttributeMappingsFromDictionary:mappingDict];
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"houseing_estate_msg" toKeyPath:@"mapCommunityDataSubModel" withMapping:[QSMapCommunityDataSubModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
@implementation QSMapCommunityDataSubModel

/////解析规则
//+ (RKObjectMapping *)objectMapping
//{
//    
//    RKObjectMapping *shared_mapping = [super objectMapping];
//    
//    ///在超类的mapping规则之上添加子类mapping
//    [shared_mapping addAttributeMappingsFromArray:@[@"coordinate_x",
//                                                    @"coordinate_y"
//                                                    ]];
//    
//    return shared_mapping;
//    
//}

@end
