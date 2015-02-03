//
//  QSCoreDataManager+User.m
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+User.h"
#import "QSCDBaseConfigurationDataModel.h"

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

    return (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andKeyword:@"user_current_city"];

}

///获取当前城市的key
+ (NSString *)getCurrentUserCityKey
{

    return (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andKeyword:@"user_current_city_key"];

}

///更新当前用户的所在城市
+ (BOOL)updateCurrentUserCity:(QSCDBaseConfigurationDataModel *)provinceModel andCity:(QSCDBaseConfigurationDataModel *)cityModel
{

    if (nil == provinceModel || nil == cityModel) {
        
        return NO;
        
    }
    
    [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andUpdateField:@"user_current_province" andFieldNewValue:provinceModel.val];
    
    [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andUpdateField:@"user_current_province_key" andFieldNewValue:[NSString stringWithFormat:@"%@",provinceModel.key]];
    
    [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andUpdateField:@"user_current_city" andFieldNewValue:cityModel.key];
    
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andUpdateField:@"user_current_city_key" andFieldNewValue:[NSString stringWithFormat:@"%@",cityModel.val]];

}

/**
 *  @author yangshengmeng, 15-01-23 10:01:47
 *
 *  @brief  返回当前用户当前所在的区
 *
 *  @return 返回区
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserDistrict
{

    return (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andKeyword:@"user_current_district"];

}

///更新当前用户所在区
+ (BOOL)updateCurrentUserDistrict:(NSString *)district
{

    if (nil == district) {
        
        return NO;
        
    }
    
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andUpdateField:@"user_current_district" andFieldNewValue:district];

}

/**
 *  @author yangshengmeng, 15-01-28 17:01:56
 *
 *  @brief  获取当前用户当前所在的街道
 *
 *  @return 返回街道
 *
 *  @since  1.0.0
 */
+ (NSString *)getCurrentUserStreet
{

    return (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andKeyword:@"user_current_street"];

}

///更新当前用户所在的街道
+ (BOOL)updateCurrentUserStreet:(NSString *)street
{

    if (nil == street) {
        
        return NO;
        
    }
    
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_USER_INFO andUpdateField:@"user_current_street" andFieldNewValue:street];

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
