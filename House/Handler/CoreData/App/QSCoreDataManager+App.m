//
//  QSCoreDataManager+App.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+App.h"

///应用配置信息的CoreData模型
#define COREDATA_ENTITYNAME_APPLICATION_INFO @"QSCDApplicationInfoDataModel"

@implementation QSCoreDataManager (App)

#pragma mark - 返回token相关信息
/**
 *  @author yangshengmeng, 15-01-22 15:01:26
 *
 *  @brief  获取当前可用token
 *
 *  @return 返回当前可用token
 *
 *  @since  1.0.0
 */
+ (NSString *)getApplicationCurrentToken
{

    return (NSString *)[self getDataWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"app_token"];

}

/**
 *  @author yangshengmeng, 15-01-22 15:01:26
 *
 *  @brief  获取当前可用token
 *
 *  @return 返回当前可用token
 *
 *  @since  1.0.0
 */
+ (BOOL)updateApplicationCurrentToken:(NSString *)token
{

    if (nil == token) {
        
        return NO;
        
    }
    
    return [self updateFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andUpdateField:@"app_token" andFieldNewValue:token];

}

/**
 *  @author yangshengmeng, 15-01-22 15:01:45
 *
 *  @brief  获取当前网络请求的tokenID
 *
 *  @return 返回当前可用的tokenID
 *
 *  @since  1.0.0
 */
+ (NSString *)getApplicationCurrentTokenID
{

    return (NSString *)[self getDataWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"app_token_id"];

}

/**
 *  @author yangshengmeng, 15-01-22 15:01:45
 *
 *  @brief  获取当前网络请求的tokenID
 *
 *  @return 返回当前可用的tokenID
 *
 *  @since  1.0.0
 */
+ (BOOL)updateApplicationCurrentTokenID:(NSString *)tokenID
{

    if (nil == tokenID) {
        
        return NO;
        
    }
    
    return [self updateFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andUpdateField:@"app_token_id" andFieldNewValue:tokenID];

}

#pragma mark - 更新应用版本
/**
 *  @author         yangshengmeng, 15-01-22 16:01:43
 *
 *  @brief          更新应用配置信息版本
 *
 *  @param version  新版本
 *
 *  @return         返回是否更新成功
 *
 *  @since          1.0.0
 */
+ (BOOL)updateApplicationCurrentVersion:(NSString *)version
{

    ///先获取原版本，如果版本相同，则不更新
    NSString *localVersion = [self getDataWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"version"];
    
    ///如果原版本和新版本相一致，则直接返回YES
    if (localVersion && [localVersion isEqualToString:version]) {
        
        return YES;
        
    }
    
    ///如果原来没有版本信息，或者原来版本信息和最新版本不致，则更新版本
    return [self updateFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andUpdateField:@"version" andFieldNewValue:version];

}

#pragma mark - 返回指定城市可选区域列表
/**
 *  @author yangshengmeng, 15-01-20 10:01:58
 *
 *  @brief  返回指定城市的可选区域列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getDistrictWithCity:(NSString *)city
{
    
    return @[@"天河区",@"荔湾区",@"越秀区",@"海珠区",@"番禺区",@"白云区",@"黄埔区",@"花都区",@"南沙区",@"萝岗区",@"增城区"];
    
}

#pragma mark - 返回当前可选的城市列表
/**
 *  @author yangshengmeng, 15-01-20 10:01:47
 *
 *  @brief  返回城市列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getCityList
{
    
    return @[@"广州"];
    
}

#pragma mark - 应用中的基本配置信息获取/更新
/**
 *  @author yangshengmeng, 15-01-22 16:01:34
 *
 *  @brief  获取本地应用的配置信息版本数组
 *
 *  @return 返回配置信息数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getConfigurationList
{

    return nil;

}

/**
 *  @author         yangshengmeng, 15-01-22 16:01:58
 *
 *  @brief          更新本地的配置信息版本
 *
 *  @param conList  新的配置信息版本
 *
 *  @return         返回是否更新成功
 *
 *  @since          1.0.0
 */
+ (BOOL)updateConfigurationList:(NSArray *)conList
{

    return YES;

}

@end
