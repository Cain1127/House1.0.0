//
//  QSCoreDataManager+User.m
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+User.h"

///应用配置信息的CoreData模型
#define COREDATA_ENTITYNAME_USER_INFO @"QSCDUserDataModel"

@implementation QSCoreDataManager (User)

///获取当前用户ID
+ (NSString *)getUserID
{

    return (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andKeyword:@"user_id"];

}

/**
 *  @author yangshengmeng, 15-01-23 10:01:47
 *
 *  @brief  返回当前用户所在的城市
 *
 *  @return 返回城市
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserCity
{

    return @"广州";

}

/**
 *  @author yangshengmeng, 15-01-27 12:01:42
 *
 *  @brief  返回当前用户的权限类型
 *
 *  @return 返回用户权限类型
 *
 *  @since  1.0.0
 */
+ (USER_COUNT_TYPE)getCurrentUserCountType
{

    NSString *userCountTypeString = (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andKeyword:@"user_count_type"];
    
    ///如果没有配置，默认返回普通客户
    if (nil == userCountTypeString) {
        
        return uUserCountTypeTenant;
        
    }
    
    int userCountType = [userCountTypeString intValue];
    
    return userCountType;
    
}

/**
 *  @author         yangshengmeng, 15-01-27 12:01:41
 *
 *  @brief          更新当前用户的类型
 *
 *  @param userType 用户类型
 *
 *  @return         返回更新是否成功
 *
 *  @since          1.0.0
 */
+ (BOOL)updateCurrentUserCountType:(USER_COUNT_TYPE)userType
{

    if (uUserCountTypeTenant > userType || uUserCountTypeDeveloper < userType) {
        
        return NO;
        
    }
    
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andUpdateField:@"user_count_type" andFieldNewValue:[NSString stringWithFormat:@"%d",userType]];

}

@end
