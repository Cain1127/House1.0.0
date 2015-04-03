//
//  QSYContactDetailReturnData.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactDetailReturnData.h"
#import "QSYContactDetailInfoModel.h"

@implementation QSYContactDetailReturnData

+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"contactInfo" withMapping:[QSYContactDetailInfoModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
