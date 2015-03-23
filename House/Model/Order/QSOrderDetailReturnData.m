//
//  QSOrderDetailReturnData.m
//  House
//
//  Created by CoolTea on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderDetailReturnData.h"

@implementation QSOrderDetailReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"orderDetailData" withMapping:[QSOrderDetailInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
