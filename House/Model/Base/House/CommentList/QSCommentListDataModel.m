//
//  QSCommentListDataModel.m
//  House
//
//  Created by 王树朋 on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCommentListDataModel.h"

@implementation QSCommentListDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"type",
                                                    @"obj_id",
                                                    @"title",
                                                    @"content",
                                                    @"update_time",
                                                    @"status",
                                                    @"create_time"
                                                    ]];

    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user_msg" toKeyPath:@"userInfo" withMapping:[QsCommentListUserInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

@end

@implementation QsCommentListUserInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"username",
                                                    @"mobile",
                                                    @"level",
                                                    @"avatar"
                                                    ]];
    
    return shared_mapping;
    
}

@end