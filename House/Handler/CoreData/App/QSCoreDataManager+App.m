//
//  QSCoreDataManager+App.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+App.h"
#import "QSCDConfigurationDataModel.h"
#import "QSConfigurationDataModel.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSBaseConfigurationDataModel.h"
#import "QSYAppDelegate.h"

///应用配置信息的CoreData模型
#define COREDATA_ENTITYNAME_APPLICATION_INFO @"QSCDApplicationInfoDataModel"
#define COREDATA_ENTITYNAME_CONFIGURATION_INFO @"QSCDConfigurationDataModel"
#define COREDATA_ENTITYNAME_BASECONFIGURATION_INFO @"QSCDBaseConfigurationDataModel"

@implementation QSCoreDataManager (App)

#pragma mark - 返回是否第一次运行应用
/**
 *  @author yangshengmeng, 15-01-26 12:01:37
 *
 *  @brief  获取当前应用是否第一次进入的状态：YES-第一次进入
 *
 *  @return 返回状态
 *
 *  @since  1.0.0
 */
+ (BOOL)getApplicationIsFirstLaunchStatus
{

    NSString *isFirstLaunchStatus = (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"is_first_launch"];
    
    if (nil == isFirstLaunchStatus) {
        
        return YES;
        
    }
         
    if (0 == [isFirstLaunchStatus intValue]) {
        
        return YES;
        
    }
    
    return NO;

}

+ (BOOL)updateApplicationIsFirstLaunchStatus:(NSString *)netStatus
{
    
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andUpdateField:@"is_first_launch" andFieldNewValue:(netStatus ? netStatus : @"0")];

}

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

    return (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"app_token"];

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
    
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andUpdateField:@"app_token" andFieldNewValue:token];

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

    return (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"app_token_id"];

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
    
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andUpdateField:@"app_token_id" andFieldNewValue:tokenID];

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
    NSString *localVersion = [self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"version"];
    
    ///如果原版本和新版本相一致，则直接返回YES
    if (localVersion && [localVersion isEqualToString:version]) {
        
        return YES;
        
    }
    
    ///如果原来没有版本信息，或者原来版本信息和最新版本不致，则更新版本
    return [self updateUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andUpdateField:@"version" andFieldNewValue:version];

}

/**
 *  @author             yangshengmeng, 15-01-28 16:01:46
 *
 *  @brief              获取给定区中的街道列表
 *
 *  @param districtKey  区的关键字
 *
 *  @return             返回街道选择列表
 *
 *  @since              1.0.0
 */
+ (NSArray *)getStreetListWithDistrictKey:(NSString *)districtKey
{

    NSMutableArray *streetList = [[NSMutableArray alloc] init];
    NSArray *streetTempArray = @[@"五山",@"员村",@"车陂",@"沙河",@"石牌",@"兴华",@"沙东",@"林和",@"棠下",@"猎德",@"冼村",@"天园",@"天河南",@"元岗",@"黄村",@"龙洞",@"长兴",@"凤凰",@"前进",@"珠吉",@"新塘",@"登峰"];
    for (int i = 0; i < [streetTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = [NSNumber numberWithInt:1001 + i];
        tempModel.val = streetTempArray[i];
        [streetList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:streetList];

}

#pragma mark - 返回指定城市可选区域列表
/**
 *  @author yangshengmeng, 15-01-20 10:01:58
 *
 *  @brief  返回指定城市的可选区域列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getDistrictListWithCityKey:(NSString *)cityKey
{
    
    NSMutableArray *districtList = [[NSMutableArray alloc] init];
    NSArray *districtTempArray = @[@"天河区",@"荔湾区",@"越秀区",@"海珠区",@"番禺区",@"白云区",@"黄埔区",@"花都区",@"南沙区",@"萝岗区",@"增城区"];
    for (int i = 0; i < 11; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = [NSNumber numberWithInt:1001 + i];
        tempModel.val = districtTempArray[i];
        [districtList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:districtList];
    
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
    
    NSMutableArray *cityList = [[NSMutableArray alloc] init];
    NSArray *cityTempArray = @[@"广州",@"深圳",@"北京",@"上海",@"乌鲁木齐"];
    for (int i = 0; i < [cityTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = [NSNumber numberWithInt:1001 + i];
        tempModel.val = cityTempArray[i];
        [cityList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:cityList];
    
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

    return [self getEntityListWithKey:COREDATA_ENTITYNAME_CONFIGURATION_INFO];

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
    
    for (QSConfigurationDataModel *obj in conList) {
        
        BOOL isInsertFlag = [self updateConfigurationWithModel:obj];
        if (!isInsertFlag) {
            
            return NO;
            
        }
        
    }
    
    return YES;

}

/**
 *  @author                 yangshengmeng, 15-01-26 15:01:28
 *
 *  @brief                  根据配置说明模型更新一个配置信息项，如若没有，则插入
 *
 *  @param confDataModel    配置说明信息的数据模型
 *
 *  @return                 返回更新标识：YES-更新成功
 *
 *  @since                  1.0.0
 */
+ (BOOL)updateConfigurationWithModel:(QSConfigurationDataModel *)confDataModel
{

    if (nil == confDataModel) {
        
        return NO;
        
    }
    
    ///获取上下文
    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    ///先查，是否存在对应的数据
    QSCDConfigurationDataModel *localModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_CONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:confDataModel.conf];
    
    ///错误信息
    NSError *error = nil;
    
    if (nil == localModel) {
        
        ///插入数据
        QSCDConfigurationDataModel *insertModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_CONFIGURATION_INFO inManagedObjectContext:mOContext];
        insertModel.conf = confDataModel.conf;
        insertModel.c_v = confDataModel.c_v;
        [mOContext save:&error];
        
    } else {
    
        localModel.c_v = confDataModel.c_v;
        [mOContext save:&error];
    
    }
    
    if (error) {
        
        return NO;
        
    }
    
    return YES;

}

/**
 *  @author             yangshengmeng, 15-01-26 16:01:06
 *
 *  @brief              更新基础配置信息
 *
 *  @param BaseConList  配置数组
 *
 *  @return             返回是否配置成功
 *
 *  @since              1.0.0
 */
+ (BOOL)updateBaseConfigurationList:(NSArray *)baseConList andKey:(NSString *)key
{

    ///删除原来对应配置项的配置信息
    BOOL isDeleteOldSuccess = [self clearEntityListWithEntityName:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andDeleteKey:key];
    
    if (!isDeleteOldSuccess) {
        
        return isDeleteOldSuccess;
        
    }
    
    ///获取上下文
    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    NSError *error = nil;
    
    for (QSBaseConfigurationDataModel *obj in baseConList) {
        
        ///重新添加基本配置信息
        QSCDBaseConfigurationDataModel *insertModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO inManagedObjectContext:mOContext];
        insertModel.conf = key;
        insertModel.key = obj.key;
        insertModel.val = obj.val;
        [mOContext save:&error];
        
        if (error) {
            
            ///打印错误
            break;
            
        }
        
    }
    
    if (error) {
        
        NSLog(@"====================配置信息插入失败====================");
        NSLog(@"配置类型：%@,错误：%@",key,error);
        NSLog(@"====================配置信息插入失败====================");
        return NO;
        
    }
    
    return YES;

}

#pragma mark - 进入应用时的过滤器标识
/**
 *  @author yangshengmeng, 15-01-23 14:01:22
 *
 *  @brief  获取本地是否已配置有过滤器
 *
 *  @return 返回配置情况：YES-已配置
 *
 *  @since  1.0.0
 */
+ (BOOL)getLocalFilterSettingFlag
{

    NSString *isSettingFilter = (NSString *)[self getUnirecordFieldWithKey:COREDATA_ENTITYNAME_APPLICATION_INFO andKeyword:@"is_setting_filter"];
    
    if (nil == isSettingFilter) {
        
        return NO;
        
    }
    
    if (0 == [isSettingFilter intValue]) {
        
        return NO;
        
    }
    
    return YES;

}

@end
