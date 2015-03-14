//
//  QSYLoginReturnData.m
//  House
//
//  Created by ysmeng on 15/3/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYLoginReturnData.h"
#import "QSUserDataModel.h"

@implementation QSYLoginReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"userInfo" withMapping:[QSUserDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
