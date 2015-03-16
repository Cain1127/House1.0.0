//
//  QSOrderListOwnerMsgDataModel.m
//  House
//
//  Created by CoolTea on 15/3/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListOwnerMsgDataModel.h"

@implementation QSOrderListOwnerMsgDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    ///非继承
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///继承
    // RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"user_type",
                                                    @"id_",
                                                    @"username",
                                                    @"mobile",
                                                    @"sex",
                                                    @"avatar",
                                                    @"nickname",
                                                    @"level"
                                                    ]];
    return shared_mapping;
    
}

- (NSString*)getUserTypeStr
{
    
    NSString *userTypeStr = @"";
    
    if (self.user_type&&[self.user_type isKindOfClass:[NSString class]]) {
        
        if ([self.user_type isEqualToString:@"100101"]) {
            userTypeStr = @"房客";
        }else if ([self.user_type isEqualToString:@"100102"]) {
            userTypeStr = @"业主";
        }else if ([self.user_type isEqualToString:@"100103"]) {
            userTypeStr = @"中介";
        }else if ([self.user_type isEqualToString:@"100104"]) {
            userTypeStr = @"开发商";
        }
        
    }
    
    return userTypeStr;
    
}

@end
