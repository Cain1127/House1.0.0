//
//  QSCommentListReturnData.m
//  House
//
//  Created by 王树朋 on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommentListReturnData.h"
#import "QSCommentListDataModel.h"

@implementation QSCommentListReturnData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"msg" toKeyPath:@"msgInfo" withMapping:[QSCommentListHeaderData objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QSCommentListHeaderData

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    ///先获取超类的mapping规则
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"records" toKeyPath:@"commentList" withMapping:[QSCommentListDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end
