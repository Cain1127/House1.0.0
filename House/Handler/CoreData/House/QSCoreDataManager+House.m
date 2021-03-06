//
//  QSCoreDataManager+House.m
//  House
//
//  Created by ysmeng on 15/1/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+House.h"
#import "QSBaseConfigurationDataModel.h"
#import "NSDate+Formatter.h"

///配置信息的CoreData模型
#define COREDATA_ENTITYNAME_BASECONFIGURATION_INFO @"QSCDBaseConfigurationDataModel"

///房子列表的过滤条件
#define COREDATA_ENTITYNAME_HOUSELIST_FILTER @"QSCDHouseListFilter"

@implementation QSCoreDataManager (House)

/**
 *  @author yangshengmeng, 15-01-27 17:01:17
 *
 *  @brief  获取本地配置的户型数据
 *
 *  @return 返回户型数据
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseType
{

    NSMutableArray *houseTypeList = [[NSMutableArray alloc] init];
    NSArray *houseTypeTempArray = @[@"一室",@"二室",@"三室",@"四室",@"五室",@"五室以上"];
    NSArray *houseTypeKeyArray = @[@"1",@"2",@"3",@"4",@"5",@"5-over"];
    for (int i = 0; i < [houseTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseTypeKeyArray[i];
        tempModel.val = houseTypeTempArray[i];
        [houseTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseTypeList];

}

+ (NSString *)getHouseTypeValueWithKey:(NSString *)houseTypeKey
{

    if ([houseTypeKey isEqualToString:@"1"]) {
        
        return @"一室";
        
    }
    
    if ([houseTypeKey isEqualToString:@"2"]) {
        
        
        return @"二室";
    }
    
    if ([houseTypeKey isEqualToString:@"3"]) {
        
        
        return @"三室";
    }
    
    if ([houseTypeKey isEqualToString:@"4"]) {
        
        return @"四室";
        
    }
    
    if ([houseTypeKey isEqualToString:@"5"]) {
        
        return @"五室";
        
    }
    
    if ([houseTypeKey isEqualToString:@"5-over"]) {
        
        return @"五室以上";
        
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:41
 *
 *  @brief  获取房子售价的类型
 *
 *  @return 返回售价类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseSalePriceType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"house_price"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getHouseSalePriceValueWithKey:(NSString *)priceKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"house_price" andSecondFieldName:@"key" andSecndFieldValue:priceKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-03-25 17:03:16
 *
 *  @brief  是否可以议价选择项
 *
 *  @return 返回选项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseIsNegotiatedPriceType
{

    NSMutableArray *houseTypeList = [[NSMutableArray alloc] init];
    NSArray *houseTypeTempArray = @[@"一口价",@"可议价"];
    NSArray *houseTypeKeyArray = @[@"1",@"0"];
    for (int i = 0; i < [houseTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseTypeKeyArray[i];
        tempModel.val = houseTypeTempArray[i];
        [houseTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseTypeList];

}

+ (NSString *)getHouseIsNegotiatedPriceTypeWithKey:(NSString *)keyString
{

    if ([keyString isEqualToString:@"0"]) {
        
        return @"可议价";
        
    }
    
    if ([keyString isEqualToString:@"1"]) {
        
        return @"一口价";
        
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-03-06 15:03:43
 *
 *  @brief  返回房子的均价类型数据
 *
 *  @return 返回均价数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseAverageSalePriceType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"price_avg"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:16
 *
 *  @brief  获取房子面积类型列表数据
 *
 *  @return 返回房子面积类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseAreaType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"house_area"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getHouseAreaTypeWithKey:(NSString *)areaKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"house_area" andSecondFieldName:@"key" andSecndFieldValue:areaKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:48
 *
 *  @brief  获取房子出租的方式类型
 *
 *  @return 返回出租方式类型列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentType
{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"rent_property"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];
    
}

+ (NSString *)getHouseRentPropertyWithKey:(NSString *)keyString
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"rent_property" andSecondFieldName:@"key" andSecndFieldValue:keyString];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:29
 *
 *  @brief  返回出租房的租金类型列表
 *
 *  @return 返回类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentPriceType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"rent_price"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getHouseRentPriceValueWithKey:(NSString *)rentKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"rent_price" andSecondFieldName:@"key" andSecndFieldValue:rentKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:44
 *
 *  @brief  获取出租房的租金支付方式选择项
 *
 *  @return 返回租金支付方式选择项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseRentPayType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"payment"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getHouseRentTypeWithKey:(NSString *)payKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"payment" andSecondFieldName:@"key" andSecndFieldValue:payKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-04-02 10:04:49
 *
 *  @brief  返回出租房的限制条件选择项
 *
 *  @return 返回出租房的限制条件选择项
 *
 *  @since  1.0.0
 */
+ (NSArray *)getRentHouseLimitedTypes
{

    NSMutableArray *houseTypeList = [[NSMutableArray alloc] init];
    NSArray *houseTypeTempArray = @[@"男女不限",@"欢男生",@"限女生"];
    NSArray *houseTypeKeyArray = @[@"990601",@"990602",@"990603"];
    for (int i = 0; i < [houseTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseTypeKeyArray[i];
        tempModel.val = houseTypeTempArray[i];
        [houseTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseTypeList];

}

+ (NSString *)getRentHouseLimitedTypeWithKey:(NSString *)limitedKey
{

    int limitedType = [limitedKey intValue];
    switch (limitedType) {
            ///男女不限
        case rRentHouseLimitedTypeUnLimited:
            
            return @"男女不限";
            
            break;
            
            ///男女不限
        case rRentHouseLimitedTypeMale:
            
            return @"欢男生";
            
            break;
            
            ///男女不限
        case rRentHouseLimitedTypeFemale:
            
            return @"限女生";
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:46
 *
 *  @brief  获取房子的装修类型
 *
 *  @return 返回房子装修类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseDecorationType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"decoration_type"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

///根据装修的key，获取装修描述
+ (NSString *)getHouseDecorationTypeWithKey:(NSString *)decorationKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"decoration_type" andSecondFieldName:@"key" andSecndFieldValue:decorationKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:15
 *
 *  @brief  获取房子朝向类型数据
 *
 *  @return 返回房子朝向类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseFaceType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"house_face"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

///查找朝向
+ (NSString *)getHouseFaceTypeWithKey:(NSString *)decorationKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"house_face" andSecondFieldName:@"key" andSecndFieldValue:decorationKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:25
 *
 *  @brief  获取房子的楼层类型数据
 *
 *  @return 返回房子楼层类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseFloorType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"floor_which"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getHouseFloorTypeWithKey:(NSString *)floorKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"floor_which" andSecondFieldName:@"key" andSecndFieldValue:floorKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-02-02 10:02:22
 *
 *  @brief  获取房子的产权年限数据
 *
 *  @return 返回产权选择项数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHousePropertyRightType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"used_year"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getHousePropertyRightValueWithKey:(NSString *)keyString
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"used_year" andSecondFieldName:@"key" andSecndFieldValue:keyString];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-02-05 14:02:40
 *
 *  @brief  获取房子的房龄类型数组
 *
 *  @return 返回房龄数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseUsedYearType
{

    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSArray *houseUsedYearTypeTempArray = @[@"2年以下",@"2-5年",@"5-10年",@"10年以上"];
    NSArray *houseUsedYearTypeKeyArray = @[@"2-under",@"2-5",@"5-10",@"10-over"];
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];

}

+ (NSString *)getHouseUsedYearTypeWithKey:(NSString *)usedYearKey
{

    if ([usedYearKey isEqualToString:@"2-under"]) {
        
        return @"2年以下";
        
    }
    
    if ([usedYearKey isEqualToString:@"2-5"]) {
        
        return @"2-5年";
        
    }
    
    if ([usedYearKey isEqualToString:@"5-10"]) {
        
        return @"5-10年";
        
    }
    
    if ([usedYearKey isEqualToString:@"10-over"]) {
        
        return @"10年以上";
        
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-01-29 15:01:06
 *
 *  @brief  返回房子列表中主要过滤类型
 *
 *  @return 返回类型数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseListMainType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"type"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

///查询主列表类型的对象
+ (id)getHouseListMainTypeModelWithID:(NSString *)typeID
{

    return [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"type" andSecondFieldName:@"key" andSecndFieldValue:typeID];

}

/**
 *  @author yangshengmeng, 15-02-02 09:02:31
 *
 *  @brief  获取房子的物业类型
 *
 *  @return 返回可以选择的物业类型
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseTradeType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"property_type"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

///根据物业类型的key，返回物业类型描述
+ (NSString *)getHouseTradeTypeWithKey:(NSString *)tradeKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"property_type" andSecondFieldName:@"key" andSecndFieldValue:tradeKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-01-27 17:01:23
 *
 *  @brief  返回购房目的数组
 *
 *  @return 返回数组
 *
 *  @since  1.0.0
 */
+ (NSArray *)getPurpostPerchaseType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"intent"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

///根据给定的key，查找对应的购房目的
+ (NSString *)getPerpostPerchaseTypeWithKey:(NSString *)perpostKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"intent" andSecondFieldName:@"key" andSecndFieldValue:perpostKey];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-03-13 18:03:26
 *
 *  @brief  返回建筑结构信息
 *
 *  @return 所有建筑类型数据
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseBuildingStructureType
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"building_structure"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getHouseBuildingStructureTypeWithKey:(NSString *)key
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"building_structure" andSecondFieldName:@"key" andSecndFieldValue:key];
    return tempModel.val;
    
}

/**
 *  @author     yangshengmeng, 15-02-12 13:02:13
 *
 *  @brief      查询对应特色标签的值
 *
 *  @param key  标签的key
 *
 *  @return     返回对应标签的值
 *
 *  @since      1.0.0
 */
+ (NSArray *)getHouseFeatureListWithType:(FILTER_MAIN_TYPE)filterType
{

    switch (filterType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
        
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"features_loupan"]];
            
            ///排序
            [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                QSBaseConfigurationDataModel *obj1Model = obj1;
                QSBaseConfigurationDataModel *obj2Model = obj2;
                
                return [obj1Model.key intValue] > [obj2Model.key intValue];
                
            }];
            
            return [NSArray arrayWithArray:tempArray];
        
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"features_loupan"]];
            
            ///排序
            [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                QSBaseConfigurationDataModel *obj1Model = obj1;
                QSBaseConfigurationDataModel *obj2Model = obj2;
                
                return [obj1Model.key intValue] > [obj2Model.key intValue];
                
            }];
            
            return [NSArray arrayWithArray:tempArray];
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"features"]];
            
            ///排序
            [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                QSBaseConfigurationDataModel *obj1Model = obj1;
                QSBaseConfigurationDataModel *obj2Model = obj2;
                
                return [obj1Model.key intValue] > [obj2Model.key intValue];
                
            }];
            
            return [NSArray arrayWithArray:tempArray];
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"features_rent"]];
            
            ///排序
            [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                QSBaseConfigurationDataModel *obj1Model = obj1;
                QSBaseConfigurationDataModel *obj2Model = obj2;
                
                return [obj1Model.key intValue] > [obj2Model.key intValue];
                
            }];
            
            return [NSArray arrayWithArray:tempArray];
            
        }
            break;
            
        default:
            
            break;
    }
    
    return nil;

}

+ (QSBaseConfigurationDataModel *)getHouseFeatureModelWithKey:(NSString *)key andFilterType:(FILTER_MAIN_TYPE)listType
{

    switch (listType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features_loupan" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features_loupan" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel;
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel;
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features_rent" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

+ (NSString *)getHouseFeatureWithKey:(NSString *)key andFilterType:(FILTER_MAIN_TYPE)listType
{
    
    switch (listType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features_loupan" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features_loupan" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
        
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
        
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"features_rent" andSecondFieldName:@"key" andSecndFieldValue:key];
            return tempModel.val;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-03-26 11:03:05
 *
 *  @brief  返回二手房的房屋性质
 *
 *  @return 返回二手房的房屋性质
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseNatureTypes
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"house_nature"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (QSBaseConfigurationDataModel *)getHouseNatureModelWithKey:(NSString *)keyString
{

    return [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"house_nature" andSecondFieldName:@"key" andSecndFieldValue:keyString];

}

+ (NSString *)getHouseNatureValueWithKey:(NSString *)keyString
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"house_nature" andSecondFieldName:@"key" andSecndFieldValue:keyString];
    return tempModel.val;

}

/**
 *  @author yangshengmeng, 15-03-26 11:03:21
 *
 *  @brief  返回建筑年代选择项
 *
 *  @return 返回建筑年代所有数据
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHouseBuildingYearTypes
{

    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSMutableArray *houseUsedYearTypeTempArray = [[NSMutableArray alloc] init];
    NSMutableArray *houseUsedYearTypeKeyArray = [[NSMutableArray alloc] init];
    
    ///获取当前年
    NSString *currentDate = [NSDate formatNSTimeToNSDateString:[NSDate currentDateTimeStamp]];
    NSString *currentYear = [currentDate substringToIndex:4];
    
    ///构建年代数据
    for (int i = 1980; i <= [currentYear intValue]; i++) {
        
        [houseUsedYearTypeTempArray addObject:[NSString stringWithFormat:@"%d年",i]];
        [houseUsedYearTypeKeyArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];

}

/**
 *  @author             yangshengmeng, 15-03-26 12:03:22
 *
 *  @brief              返回不同房源类型的配套信息
 *
 *  @param filterType   房源类型
 *
 *  @return             返回对应类型的配套信息
 *
 *  @since              1.0.0
 */
+ (NSArray *)getHouseInstallationTypes:(FILTER_MAIN_TYPE)filterType
{
    
    switch (filterType) {
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
        
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"installation_rent"]];
            
            ///排序
            [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                QSBaseConfigurationDataModel *obj1Model = obj1;
                QSBaseConfigurationDataModel *obj2Model = obj2;
                
                return [obj1Model.key intValue] > [obj2Model.key intValue];
                
            }];
            
            return [NSArray arrayWithArray:tempArray];
        
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
         
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"installation"]];
            
            ///排序
            [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                QSBaseConfigurationDataModel *obj1Model = obj1;
                QSBaseConfigurationDataModel *obj2Model = obj2;
                
                return [obj1Model.key intValue] > [obj2Model.key intValue];
                
            }];
            
            return [NSArray arrayWithArray:tempArray];
            
        }
            break;
            
        default:
            break;
    }

    return nil;

}


+ (QSBaseConfigurationDataModel *)getHouseInstallationModelWithKey:(NSString *)keyString andHouseType:(FILTER_MAIN_TYPE)filterType
{

    switch (filterType) {
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
        
            return [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"installation" andSecondFieldName:@"key" andSecndFieldValue:keyString];
        
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
        
            return [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"installation_rent" andSecondFieldName:@"key" andSecndFieldValue:keyString];
        
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  返回星期选择项
 *
 *  @return 返回星期选择项
 *
 *  @since  1.0.0
 */
+ (NSArray *)getWeeksPickedType
{

    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSArray *houseUsedYearTypeTempArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray *houseUsedYearTypeKeyArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"0"];
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];

}

+ (QSBaseConfigurationDataModel *)getWeekPickedModelWithKey:(NSString *)keyString
{

    QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
    tempModel.key = keyString;
    
    if ([keyString isEqualToString:@"1"]) {
        
        tempModel.val = @"周一";
        
    }
    
    if ([keyString isEqualToString:@"2"]) {
        
        tempModel.val = @"周二";
        
    }
    
    if ([keyString isEqualToString:@"3"]) {
        
        tempModel.val = @"周三";
        
    }
    
    if ([keyString isEqualToString:@"4"]) {
        
        tempModel.val = @"周四";
        
    }
    
    if ([keyString isEqualToString:@"5"]) {
        
        tempModel.val = @"周五";
        
    }
    
    if ([keyString isEqualToString:@"6"]) {
        
        tempModel.val = @"周六";
        
    }
    
    if ([keyString isEqualToString:@"0"]) {
        
        tempModel.val = @"周天";
        
    }
    
    return tempModel;

}

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  出租房的状态
 *
 *  @return 返回出租房的状态
 *
 *  @since  1.0.0
 */
+ (NSArray *)getRentHouseStatusTypes
{

    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSArray *houseUsedYearTypeTempArray = @[@"在租中",@"自住中",@"吉屋"];
    NSArray *houseUsedYearTypeKeyArray = @[@"1",@"2",@"3"];
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];

}

+ (NSString *)getRentHouseStatusTypeValueWithKey:(NSString *)keyString
{

    if ([keyString isEqualToString:@"1"]) {
        
        return @"在租中";
        
    }
    
    if ([keyString isEqualToString:@"2"]) {
        
        return @"自住中";
        
    }
    
    
    if ([keyString isEqualToString:@"3"]) {
        
        return @"吉屋";
        
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  房子的物业管理费
 *
 *  @return 返回出房子的物业管理费
 *
 *  @since  1.0.0
 */
+ (NSArray *)getHousePropertyManagementFees
{

    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSArray *houseUsedYearTypeTempArray = @[@"1 元/月/㎡",
                                            @"2 元/月/㎡",
                                            @"3 元/月/㎡",
                                            @"4 元/月/㎡",
                                            @"5 元/月/㎡",
                                            @"6 元/月/㎡"];
    
    NSArray *houseUsedYearTypeKeyArray = @[@"1",
                                           @"2",
                                           @"3",
                                           @"4",
                                           @"5",
                                           @"6"];
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];

}

+ (NSString *)getHousePropertyManagementFeeValueWithKey:(NSString *)keyString
{

    if ([keyString isEqualToString:@"1"]) {
        
        return @"1 元/月/㎡";
        
    }
    
    if ([keyString isEqualToString:@"2"]) {
        
        return @"2 元/月/㎡";
        
    }
    
    if ([keyString isEqualToString:@"3"]) {
        
        return @"3 元/月/㎡";
        
    }
    
    if ([keyString isEqualToString:@"4"]) {
        
        return @"4 元/月/㎡";
        
    }
    
    if ([keyString isEqualToString:@"5"]) {
        
        return @"5 元/月/㎡";
        
    }
    
    if ([keyString isEqualToString:@"6"]) {
        
        return @"6 元/月/㎡";
        
    }
    
    return nil;

}

/**
 *  @author yangshengmeng, 15-03-27 12:03:37
 *
 *  @brief  出租房的入住时间
 *
 *  @return 返回出租房的可入住时间选择项
 *
 *  @since  1.0.0
 */
+ (NSArray *)getRentHouseLeadTimeTyps
{

    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self searchEntityListWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldKey:@"conf" andSearchKey:@"lead_time"]];
    
    ///排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSBaseConfigurationDataModel *obj1Model = obj1;
        QSBaseConfigurationDataModel *obj2Model = obj2;
        
        return [obj1Model.key intValue] > [obj2Model.key intValue];
        
    }];
    
    return [NSArray arrayWithArray:tempArray];

}

+ (NSString *)getRentHouseLeadTimeTypeWithKey:(NSString *)typeKey
{

    QSBaseConfigurationDataModel *tempModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_BASECONFIGURATION_INFO andFieldName:@"conf" andFieldSearchKey:@"lead_time" andSecondFieldName:@"key" andSecndFieldValue:typeKey];
    return tempModel.val;

}

/*!
 *  @author wangshupeng, 15-04-07 15:04:35
 *
 *  @brief  代款方式，用来进行贷款信息计算
 *
 *  @return 返回所有的代款类型
 *
 *  @since  1.0.0
 */
+ (NSArray *)getMortgageTypes
{
    
    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSArray *houseUsedYearTypeTempArray = @[@"等额本息",
                                            @"等额本金"];
    
    NSArray *houseUsedYearTypeKeyArray = @[@"1",
                                           @"2"];
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];
    
}

+ (NSString *)getMortgageTypeWithKey:(NSString *)typeKey
{
    
    if (1 == [typeKey intValue]) {
        
        return @"等额本息";
        
    }
    
    if (2 == [typeKey intValue]) {
        
        return @"等额本金";
        
    }
    
    return nil;
    
}

/*!
 *  @author wangshupeng, 15-04-07 15:04:35
 *
 *  @brief  代款年限，用来进行贷款信息计算
 *
 *  @return 返回所有的代款年限
 *
 *  @since  1.0.0
 */
+ (NSArray *)getMortgageYears
{
    
    NSMutableArray *houseUsedYearTypeList = [[NSMutableArray alloc] init];
    NSArray *houseUsedYearTypeTempArray = @[@"1年",
                                            @"2年",
                                            @"3年",
                                            @"4年",
                                            @"5年",
                                            @"6年",
                                            @"7年",
                                            @"8年",
                                            @"9年",
                                            @"10年",
                                            @"11年",
                                            @"12年",
                                            @"13年",
                                            @"14年",
                                            @"15年",
                                            @"16年",
                                            @"17年",
                                            @"18年",
                                            @"19年",
                                            @"20年",
                                            @"21年",
                                            @"22年",
                                            @"23年",
                                            @"24年",
                                            @"25年",
                                            @"26年",
                                            @"27年",
                                            @"28年",
                                            @"29年",
                                            @"30年"
                                            
                                            ];
    
    NSArray *houseUsedYearTypeKeyArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",
                                           @"30"];
    for (int i = 0; i < [houseUsedYearTypeTempArray count]; i++) {
        
        QSBaseConfigurationDataModel *tempModel = [[QSBaseConfigurationDataModel alloc] init];
        tempModel.key = houseUsedYearTypeKeyArray[i];
        tempModel.val = houseUsedYearTypeTempArray[i];
        [houseUsedYearTypeList addObject:tempModel];
        
    }
    return [NSArray arrayWithArray:houseUsedYearTypeList];
    
}

+ (NSString *)getMortgageYearsWithKey:(NSString *)typeKey
{
    
    if (1 == [typeKey intValue]) {
        
        return @"1年";
        
    }
    
    if (2 == [typeKey intValue]) {
        
        return @"2年";
        
    }
    if (3 == [typeKey intValue]) {
        
        return @"3年";
        
    }
    
    if (4 == [typeKey intValue]) {
        
        return @"4年";
        
    }
    if (5 == [typeKey intValue]) {
        
        return @"5年";
        
    }
    
    if (6 == [typeKey intValue]) {
        
        return @"6年";
        
    }
    if (7 == [typeKey intValue]) {
        
        return @"7年";
        
    }
    
    if (8 == [typeKey intValue]) {
        
        return @"8年";
        
    }
    if (9 == [typeKey intValue]) {
        
        return @"9年";
        
    }
    
    if (10 == [typeKey intValue]) {
        
        return @"10年";
        
    }
    if (11 == [typeKey intValue]) {
        
        return @"11年";
        
    }
    
    if (12 == [typeKey intValue]) {
        
        return @"12年";
        
    }
    if (13 == [typeKey intValue]) {
        
        return @"13年";
        
    }
    
    if (14 == [typeKey intValue]) {
        
        return @"14年";
        
    }
    if (15 == [typeKey intValue]) {
        
        return @"15年";
        
    }
    
    if (16 == [typeKey intValue]) {
        
        return @"16年";
        
    }
    if (17 == [typeKey intValue]) {
        
        return @"17年";
        
    }
    
    if (18 == [typeKey intValue]) {
        
        return @"18年";
        
    }
    if (19 == [typeKey intValue]) {
        
        return @"19年";
        
    }
    
    if (20 == [typeKey intValue]) {
        
        return @"20年";
        
    }
    if (21 == [typeKey intValue]) {
        
        return @"21年";
        
    }
    
    if (22 == [typeKey intValue]) {
        
        return @"22年";
        
    }
    if (23 == [typeKey intValue]) {
        
        return @"23年";
        
    }
    
    if (24 == [typeKey intValue]) {
        
        return @"24年";
        
    }
    if (25 == [typeKey intValue]) {
        
        return @"25年";
        
    }
    
    if (26 == [typeKey intValue]) {
        
        return @"26年";
        
    }
    if (27 == [typeKey intValue]) {
        
        return @"27年";
        
    }
    
    if (28 == [typeKey intValue]) {
        
        return @"28年";
        
    }
    if (29 == [typeKey intValue]) {
        
        return @"29年";
        
    }
    
    if (30 == [typeKey intValue]) {
        
        return @"30年";
        
    }
    
    return nil;
    
}
@end
