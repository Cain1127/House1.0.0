//
//  QSUserSimpleDataModel.m
//  House
//
//  Created by ysmeng on 15/2/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserSimpleDataModel.h"

@implementation QSUserSimpleDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"id_",
                                                    @"user_type",
                                                    @"nickname",
                                                    @"username",
                                                    @"avatar",
                                                    @"email",
                                                    @"mobile",
                                                    @"realname",
                                                    @"tj_secondHouse_num",
                                                    @"tj_rentHouse_num",
                                                    @"level"]];
    
    return shared_mapping;
    
}

/**
 *  @author yangshengmeng, 15-02-12 17:02:48
 *
 *  @brief  返回当前用户的名字
 *
 *  @return 返回当前用户的名字
 *
 *  @since  1.0.0
 */
- (NSString *)getUserDisplayName
{

    if (self.nickname) {
        
        return self.nickname;
        
    }
    
    return self.username;

}

@end
