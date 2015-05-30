//
//  QSYSystemMessageListDataModel.m
//  House
//
//  Created by ysmeng on 15/5/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSystemMessageListDataModel.h"
#import "QSYSendMessageSystem.h"

@implementation QSYSystemMessageListDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_id",
                                                    @"to_user",
                                                    @"to_address",
                                                    @"content",
                                                    @"title",
                                                    @"send_time",
                                                    @"over_time",
                                                    @"result",
                                                    @"accpet",
                                                    @"status",
                                                    @"send_type",
                                                    @"notice_type",
                                                    @"log",
                                                    @"sign"]];
    
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"extend" toKeyPath:@"expand" withMapping:[QSYSystemMessageListDataExtand objectMapping]]];
        
    return shared_mapping;
    
}

- (QSYSendMessageSystem *)changeToSimpleSystemMessageModel
{

    QSYSendMessageSystem *tempModel = [[QSYSendMessageSystem alloc] init];
    
    tempModel.fromID = @"system";
    tempModel.readTag = @"1";
    tempModel.timeStamp = self.send_time;
    tempModel.title = self.title;
    tempModel.desc = self.content;
    tempModel.f_name = self.expand.message_id;
    tempModel.f_avatar = self.expand.message_type;
    tempModel.unread_count = @"1";
    tempModel.msgType = qQSCustomProtocolChatMessageTypeSystem;
    
    ///扩展字段
    tempModel.exp_1 = nil;
    tempModel.exp_2 = nil;
    tempModel.exp_3 = nil;
    tempModel.exp_4 = nil;
    tempModel.exp_5 = nil;
    
    return tempModel;

}

@end

@implementation QSYSystemMessageListDataExtand

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"source_type",
                                                    @"message_id",
                                                    @"source_user_id",
                                                    @"expand_1",
                                                    @"expand_2"]];
    
    return shared_mapping;
    
}

@end