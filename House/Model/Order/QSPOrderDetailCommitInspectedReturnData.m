//
//  QSPOrderDetailCommitInspectedReturnData.m
//  House
//
//  Created by CoolTea on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailCommitInspectedReturnData.h"

@implementation QSPOrderDetailCommitInspectedReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"msg"]];
    
    return shared_mapping;
    
}

@end
