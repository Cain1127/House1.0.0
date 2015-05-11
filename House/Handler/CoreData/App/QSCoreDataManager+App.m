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

/**
 *  @author yangshengmeng, 15-05-06 16:05:11
 *
 *  @brief  返回当前配置的最新商业贷款利率
 *
 *  @return 返回当前最新的商业贷款利率
 *
 *  @since  1.0.0
 */
+ (CGFloat)getCurrentLastBusinessRate
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"loan_rate_bussiness"]];
    
    if ([tempArray count] > 0) {
        
        QSCDBaseConfigurationDataModel *tempModel = tempArray[0];
        if (tempModel) {
            
            return [tempModel.val floatValue] / 100.0f;
            
        }
        
    }
    
    return 0.0615f;

}

/**
 *  @author yangshengmeng, 15-05-06 16:05:43
 *
 *  @brief  查找当前最新的租房公积金贷款利率
 *
 *  @return 返回查找结果
 *
 *  @since  1.0.0
 */
+ (CGFloat)getCurrentLastAccumulationRate
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"loan_rate_CPF"]];
    
    if ([tempArray count] > 0) {
        
        QSCDBaseConfigurationDataModel *tempModel = tempArray[0];
        if (tempModel) {
            
            return [tempModel.val floatValue] / 100.0f;
            
        }
        
    }
    
    return 0.0405f;

}

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
    
    QSCoreDataManager *manager = [self shareCoreDataManager];
    NSString *memoryToken = [manager valueForKey:@"tokenString"];
    if ([memoryToken length] > 3) {
        
        return memoryToken;
        
    }

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
    
    QSCoreDataManager *manager = [self shareCoreDataManager];
    [manager setValue:token forKey:@"tokenString"];
    
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

#pragma mark - 返回对应区以下的所有街道
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

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:[NSString stringWithFormat:@"street%@",districtKey]]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        ///转换模型
        QSCDBaseConfigurationDataModel *obj1Model = obj1;
        QSCDBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

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
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:[NSString stringWithFormat:@"district%@",cityKey]]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        ///转换模型
        QSCDBaseConfigurationDataModel *obj1Model = obj1;
        QSCDBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];
    
}

#pragma mark - 返回当前可选的城市列表
/**
 *  @author         yangshengmeng, 15-02-03 11:02:42
 *
 *  @brief          获取对应省份的城市数据
 *
 *  @param cityKey  省份的key
 *
 *  @return         返回城市列表数组
 *
 *  @since          1.0.0
 */
+ (NSArray *)getCityListWithProvinceKey:(NSString *)cityKey
{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:[NSString stringWithFormat:@"city%@",cityKey]]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        ///转换模型
        QSCDBaseConfigurationDataModel *obj1Model = obj1;
        QSCDBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];
    
}

#pragma mark - 获取省份列表
/**
 *  @author yangshengmeng, 15-02-03 11:02:55
 *
 *  @brief  获取省份列表数据
 *
 *  @return 返回所有省的数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getProvinceList
{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"province"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
        ///转换模型
        QSCDBaseConfigurationDataModel *obj1Model = obj1;
        QSCDBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];
    
}

#pragma mark - 地区相关信息的查询
/**
 *  @author         yangshengmeng, 15-02-04 17:02:27
 *
 *  @brief          根据城市的key返回不同的省份信息
 *
 *  @param cityKey  key
 *
 *  @return         返回需求信息
 *
 *  @since          1.0.0
 */
+ (id)getProvinceModelWithCityKey:(NSString *)cityKey
{

    if (!cityKey) {
        
        return nil;
        
    }
    
    ///查询城市自身的conf
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:cityKey];
    
    ///判断是否存在
    if (!cityModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *cityConf = cityModel.conf;
    
    ///省的key
    NSString *provinceKey = [cityConf substringFromIndex:4];
    
    ///省的模型
    QSCDBaseConfigurationDataModel *provinceModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:provinceKey];
    
    if (!provinceModel) {
        
        return nil;
        
    }
    
    return provinceModel;

}

+ (NSString *)getProvinceKeyWithCityKey:(NSString *)cityKey
{

    if (!cityKey) {
        
        return nil;
        
    }
    
    ///查询城市自身的conf
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:cityKey];
    
    ///判断是否存在
    if (!cityModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *cityConf = cityModel.conf;
    
    ///省的key
    NSString *provinceKey = [cityConf substringFromIndex:4];
    
    ///省的模型
    QSCDBaseConfigurationDataModel *provinceModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:provinceKey];
    
    if (!provinceModel) {
        
        return nil;
        
    }
    
    return provinceModel.key;

}

+ (NSString *)getProvinceValWithCityKey:(NSString *)cityKey
{

    if (!cityKey) {
        
        return nil;
        
    }
    
    ///查询城市自身的conf
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:cityKey];
    
    ///判断是否存在
    if (!cityModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *cityConf = cityModel.conf;
    
    ///省的key
    NSString *provinceKey = [cityConf substringFromIndex:4];
    
    ///省的模型
    QSCDBaseConfigurationDataModel *provinceModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:provinceKey];
    
    if (!provinceModel) {
        
        return nil;
        
    }
    
    return provinceModel.val;

}

+ (id)getProvinceModelWithProvinceKey:(NSString *)provinceKey
{

    if (!provinceKey) {
        
        return nil;
        
    }
    
    ///省的模型
    QSCDBaseConfigurationDataModel *provinceModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:provinceKey];
    
    if (!provinceModel) {
        
        return nil;
        
    }
    
    return provinceModel;

}

+ (NSString *)getProvinceValWithLProvinceKey:(NSString *)provinceKey
{

    if (!provinceKey) {
        
        return nil;
        
    }
    
    ///省的模型
    QSCDBaseConfigurationDataModel *provinceModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:provinceKey];
    
    if (!provinceModel) {
        
        return nil;
        
    }
    
    return provinceModel.val;

}

/**
 *  @author             yangshengmeng, 15-02-04 17:02:31
 *
 *  @brief              根据区的key返回对应城市的信息
 *
 *  @param districtKey  区key
 *
 *  @return             返回城市信息
 *
 *  @since              1.0.0
 */
+ (id)getCityModelWithDitrictKey:(NSString *)districtKey
{

    if (!districtKey) {
        
        return nil;
        
    }
    
    ///查询区自身的conf
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    ///判断是否存在
    if (!districtModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *districtConf = districtModel.conf;
    
    ///省的key
    NSString *cityKey = [districtConf substringFromIndex:8];
    
    ///省的模型
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:cityKey];
    
    if (!cityModel) {
        
        return nil;
        
    }
    
    return cityModel;

}

+ (NSString *)getCityKeyWithDitrictKey:(NSString *)districtKey
{

    if (!districtKey) {
        
        return nil;
        
    }
    
    ///查询区自身的conf
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    ///判断是否存在
    if (!districtModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *districtConf = districtModel.conf;
    
    ///省的key
    NSString *cityKey = [districtConf substringFromIndex:8];
    
    ///省的模型
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:cityKey];
    
    if (!cityModel) {
        
        return nil;
        
    }
    
    return cityModel.key;

}

+ (NSString *)getCityValWithDitrictKey:(NSString *)districtKey
{

    if (!districtKey) {
        
        return nil;
        
    }
    
    ///查询区自身的conf
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    ///判断是否存在
    if (!districtModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *districtConf = districtModel.conf;
    
    ///省的key
    NSString *cityKey = [districtConf substringFromIndex:8];
    
    ///省的模型
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:cityKey];
    
    if (!cityModel) {
        
        return nil;
        
    }
    
    return cityModel.val;

}

+ (id)getCityModelWithCityKey:(NSString *)districtKey
{

    if (!districtKey) {
        
        return nil;
        
    }
    
    ///省的模型
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    if (!cityModel) {
        
        return nil;
        
    }
    
    return cityModel;

}

+ (NSString *)getCityValWithCityKey:(NSString *)districtKey
{

    if (!districtKey) {
        
        return nil;
        
    }
    
    ///省的模型
    QSCDBaseConfigurationDataModel *cityModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    if (!cityModel) {
        
        return nil;
        
    }
    
    return cityModel.val;

}

/**
 *  @author             yangshengmeng, 15-02-04 17:02:59
 *
 *  @brief              根据街道的key，查找所在区的信息
 *
 *  @param streetKey    街道key
 *
 *  @return             返回区信息
 *
 *  @since              1.0.0
 */
+ (id)getDistrictModelWithStreetKey:(NSString *)streetKey
{

    if (!streetKey) {
        
        return nil;
        
    }
    
    ///查询街道自身的conf
    QSCDBaseConfigurationDataModel *streetModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:streetKey];
    
    ///判断是否存在
    if (!streetModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *streetConf = streetModel.conf;
    
    ///区的key
    NSString *districtKey = [streetConf substringFromIndex:6];
    
    ///区的模型
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    if (!districtModel) {
        
        return nil;
        
    }
    
    return districtModel;

}

+ (NSString *)getDistrictKeyWithStreetKey:(NSString *)streetKey
{

    if (!streetKey) {
        
        return nil;
        
    }
    
    ///查询街道自身的conf
    QSCDBaseConfigurationDataModel *streetModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:streetKey];
    
    ///判断是否存在
    if (!streetModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *streetConf = streetModel.conf;
    
    ///区的key
    NSString *districtKey = [streetConf substringFromIndex:6];
    
    ///区的模型
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    if (!districtModel) {
        
        return nil;
        
    }
    
    return districtModel.key;

}

+ (NSString *)getDistrictValWithStreetKey:(NSString *)streetKey
{

    if (!streetKey) {
        
        return nil;
        
    }
    
    ///查询街道自身的conf
    QSCDBaseConfigurationDataModel *streetModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:streetKey];
    
    ///判断是否存在
    if (!streetModel) {
        
        return nil;
        
    }
    
    ///conf
    NSString *streetConf = streetModel.conf;
    
    ///区的key
    NSString *districtKey = [streetConf substringFromIndex:6];
    
    ///区的模型
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    if (!districtModel) {
        
        return nil;
        
    }
    
    return districtModel.val;

}

+ (id)getDistrictModelWithDistrictKey:(NSString *)districtKey
{

    if (!districtKey) {
        
        return nil;
        
    }
    
    ///区的模型
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    if (!districtModel) {
        
        return nil;
        
    }
    
    return districtModel;

}

+ (NSString *)getDistrictValWithDistrictKey:(NSString *)districtKey
{

    if (!districtKey) {
        
        return nil;
        
    }
    
    ///区的模型
    QSCDBaseConfigurationDataModel *districtModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:districtKey];
    
    if (!districtModel) {
        
        return nil;
        
    }
    
    return districtModel.val;

}

/**
 *  @author             yangshengmeng, 15-02-04 17:02:09
 *
 *  @brief              根据街道的key查询街道相关的信息
 *
 *  @param streetKey    街道的key
 *
 *  @return             返回街道相关信息
 *
 *  @since              1.0.0
 */
+ (id)getStreetModelWithStreetKey:(NSString *)streetKey
{

    if (!streetKey) {
        
        return nil;
        
    }
    
    ///查询街道自身的conf
    QSCDBaseConfigurationDataModel *streetModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:streetKey];
    
    ///判断是否存在
    if (!streetModel) {
        
        return nil;
        
    }
    
    return streetModel;

}

+ (NSString *)getStreetValWithStreetKey:(NSString *)streetKey
{

    if (!streetKey) {
        
        return nil;
        
    }
    
    ///查询街道自身的conf
    QSCDBaseConfigurationDataModel *streetModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"key" andFieldSearchKey:streetKey];
    
    ///判断是否存在
    if (!streetModel) {
        
        return nil;
        
    }
    
    return streetModel.val;
    
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
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    ///先查，是否存在对应的数据
    QSCDConfigurationDataModel *localModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_CONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:confDataModel.conf];
    
    ///错误信息
    NSError *error = nil;
    
    if (nil == localModel) {
        
        ///插入数据
        QSCDConfigurationDataModel *insertModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_CONFIGURATION_INFO inManagedObjectContext:tempContext];
        insertModel.conf = confDataModel.conf;
        insertModel.c_v = confDataModel.c_v;
        [tempContext save:&error];
        
    } else {
    
        localModel.c_v = confDataModel.c_v;
        [tempContext save:&error];
    
    }
    
    if (error) {
        
        return NO;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
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
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSError *error = nil;
    
    for (QSBaseConfigurationDataModel *obj in baseConList) {
        
        ///重新添加基本配置信息
        QSCDBaseConfigurationDataModel *insertModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO inManagedObjectContext:tempContext];
        insertModel.conf = key;
        insertModel.key = obj.key;
        insertModel.val = obj.val;
        
        [tempContext save:&error];
        
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
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    return YES;

}

@end
