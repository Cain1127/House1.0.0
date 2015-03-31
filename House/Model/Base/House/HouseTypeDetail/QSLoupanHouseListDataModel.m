//
//  QSLoupanHouseListDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSLoupanHouseListDataModel.h"
#import "QSHouseTypeDataModel.h"
#import "QSPhotoDataModel.h"

@implementation QSLoupanHouseListDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    
    ///推荐户型信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"photo" toKeyPath:@"photo" withMapping:[QSPhotoDataModel objectMapping]]];
    
    
    return shared_mapping;
    
}


@end
