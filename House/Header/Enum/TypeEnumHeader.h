//
//  TypeEnumHeader.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_TypeEnumHeader_h
#define House_TypeEnumHeader_h

/*
 *  //用户类型
 *  user_type : "0" "房客";
 *  user_type : "1" "业主";
 *  user_type : "2" "中介";
 *  user_type : "3" "开发商";
 */
typedef enum
{

    uUserCountTypeTenant = 0,   //!<房客
    uUserCountTypeOwner,        //!<业主
    uUserCountTypeAgency,       //!<中介
    uUserCountTypeDeveloper     //!<开发商

}USER_COUNT_TYPE;               //!<用户账号类型

/*
 *   //建筑结构
 *  building_structure : "1" "塔楼";
 *  building_structure : "2" "板楼";
 *  building_structure : "3" "平房";
 */
typedef enum
{

    bBuildingStructureTypeTower = 1,    //!<塔楼
    bBuildingStructureTypeBoard,        //!<板楼
    bBuildingStructureTypeBungalow      //!<平房

}BUILDING_STRUCTURE_TYPE;       //!建筑结构

/*
 *  //装修类型
 *  decoration_type : "1" "豪华装修";
 *  decoration_type : "2" "精装修";
 *  decoration_type : "3" "中等装修";
 *  decoration_type : "4" "简装修";
 *  decoration_type : "5" "毛坯";
 */
typedef enum
{

    hHouseDecorationTypeLuxurious = 1,  //!<豪华装修
    hHouseDecorationTypeRefined,        //!<精装修
    hHouseDecorationTypeMedium,         //!<中等装修
    hHouseDecorationTypeSimple,         //!<简装修
    hHouseDecorationTypeRough           //!<毛坯

}HOUSE_DECORATION_TYPE;                 //!<房子装修类型

/*
 *  //特色标签
 *  features : "1" "地铁房";
 *  features : "2" "学位房";
 *  features : "3" "满五唯一";
 *  features : "4" "商住两用";
 *  features : "5" "交通便利";
 *  features : "6" "不限购";
 *  features : "7" "房东急售";
 *  features : "8" "免税房";
 */
typedef enum
{

    hHouseFeatureTypeMetro = 1,     //!<地铁房
    hHouseFeatureTypeDegree,        //!<学位房
    hHouseFeatureTypeOverFiveOnly,  //!<满五唯一:满五年，唯一一套房
    hHouseFeatureTypeDualUse,       //!<商住两用
    hHouseFeatureTypeConveniently,  //!<交通便利
    hHouseFeatureTypeNotPurchase,   //!<不限购
    hHouseFeatureTypeEmergencySale, //!<房东急售
    hHouseFeatureTypeTaxFree        //!<免税房

}HOUSE_FEATURE_TYPE;                //!<房子的特色标签

/*
 *  //配套设施
 *  installation : "1" "燃气/天然气";
 *  installation : "2" "暖气";
 *  installation : "3" "电梯";
 *  installation : "4" "车位";
 *  installation : "5" "车库";
 *  installation : "6" "花园";
 *  installation : "7" "露台";
 *  installation : "8" "阁楼";
 */
typedef enum
{

    hHouseInstallationTypeGas = 1,  //!<燃气/天燃气
    hHouseInstallationTypeHeating,  //!<暖气
    hHouseInstallationTypeLift,     //!<电梯
    hHouseInstallationTypePark,     //!<车位
    hHouseInstallationTypeGarage,   //!<车库
    hHouseInstallationTypeGarden,   //!<花园
    hHouseInstallationTypeTerrace,  //!<露台
    hHouseInstallationTypeLoft      //!<阁楼

}HOUSE_INSTALLATION_TYPE;

/**
 *  @author yangshengmeng, 15-01-20 21:01:02
 *
 *  @brief  当前客户端是否联网，联网的类型
 *
 *  @since  1.0.0
 */
typedef enum : NSInteger {
    
    NotReachable = 0,   //!<当前网络不可用
    ReachableViaWiFi,   //!<wifi
    ReachableViaWWAN    //!<3G
    
}NETWORK_STATUS;        //!<网络状态

/**
 *  @author yangshengmeng, 15-01-20 21:01:02
 *
 *  @brief  网络请求返回的结果标识
 *
 *  @since  1.0.0
 */
typedef enum
{

    rRequestResultTypeSuccess = 99,     //!<请求成功,服务端返回成功
    rRequestResultTypeFail,             //!<请求成功，服务端返回失败
    
    rRequestResultTypeDataAnalyzeFail,  //!<数据解析失败
    
    rRequestResultTypeError,            //!<请求类型有误
    rRequestResultTypeURLError,         //!<无法获取有效URL信息
    rRequestResultTypeMappingClassError,//!<无效的mapping类
    
    rRequestResultTypeNoNetworking,     //!<请求失败，无可用网络
    rRequestResultTypeBadNetworking     //!<请求失败，网络不稳定

}REQUEST_RESULT_STATUS;                 //!<网络请求结果标识

/**
 *  @author yangshengmeng, 15-01-20 21:01:02
 *
 *  @brief  http网络请求时使用的请求类型：POST,GET
 *
 *  @since  1.0.0
 */
typedef enum
{

    rRequestHttpRequestTypeGet = 0, //!<GET请求
    rRequestHttpRequestTypePost     //!<POST请求
    
}REQUEST_HTTPREQUEST_TYPE;

/**
 *  @author yangshengmeng, 15-01-20 21:01:51
 *
 *  @brief  统一的网络请求类别，通过传类型进入网络请求控制器进行请求
 *
 *  @since  1.0.0
 */
typedef enum
{

    rRequestTypeAdvert = 999,            //!<广告信息请求：此类型为首类型，请新添加的类型不要放在这个类型之前
    rRequestTypeAppBaseInfo = 1000,      //!<应用中的基本信息版本请求：如可选城市
    rRequestTypeAppBaseInfoConfiguration,//!<具体某个配置信息的请求
    
    rRequestTypeImage                    //!<图片请求：此类型为尾类型，请新添加的类型不要放在这个类型之后

}REQUEST_TYPE;

#endif
