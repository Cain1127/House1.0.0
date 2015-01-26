//
//  TypeEnumHeader.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#ifndef House_TypeEnumHeader_h
#define House_TypeEnumHeader_h

/**
 *  //用户10  ，房源20， 聊天30 ，订单50 ，公共99
 //用户类型
 $enums["user_type"]["100101"]='房客';
 $enums["user_type"]["100102"]='业主';
 $enums["user_type"]["100103"]='中介';
 $enums["user_type"]["100104"]='开发商';
 
 //-------------->楼盘使用的字段
 //楼盘均价
 $enums["price_avg"]["10000"]='一万元以下';
 $enums["price_avg"]["10000-15000"]='1万-1.5万';
 $enums["price_avg"]["15000-20000"]='1.5万-2万';
 $enums["price_avg"]["20000-30000"]='2万-3万';
 $enums["price_avg"]["30000-40000"]='3万-4万';
 $enums["price_avg"]["40000-50000"]='4万-5万';
 $enums["price_avg"]["50000"]='5万以上';
 
 //建筑结构
 $enums['building_structure']['200101']='塔楼';
 $enums['building_structure']['200102']='板楼';
 $enums['building_structure']['200103']='平房';
 
 //使用年限
 $enums['used_year']['40']='40年';
 $enums['used_year']['50']='50年';
 //$enums['used_year']['60']='60年';
 $enums['used_year']['70']='70年';
 
 //装修类型
 $enums['decoration_type']['200201']='豪华装修';
 $enums['decoration_type']['200202']='精装修';
 $enums['decoration_type']['200203']='中等装修';
 $enums['decoration_type']['200204']='简装修';
 $enums['decoration_type']['200205']='无坯';
 
 //特色标签
 $enums['features']['200301']='地铁房';
 $enums['features']['200302']='学位房';
 $enums['features']['200303']='满五唯一';
 $enums['features']['200304']='商住两用';
 $enums['features']['200305']='交通便利';
 $enums['features']['200306']='不限购';
 $enums['features']['200307']='房东急售';
 $enums['features']['200308']='免税房';
 
 //水电
 $enums['water']['40']='40年';
 $enums['water']['50']='50年';
 //$enums['water']['60']='60年';
 $enums['water']['70']='70年';
 
 //采暖
 $enums['heating']['40']='40年';
 $enums['heating']['50']='50年';
 //$enums['heating']['60']='60年';
 $enums['heating']['70']='70年';
 
 //添加小区的
 //建筑年代
 $enums['building_year']['1990']='1990年';
 $enums['building_year']['1991']='1991年';
 $enums['building_year']['1992']='1992年';
 $enums['building_year']['1993']='1993年';
 $enums['building_year']['1994']='1994年';
 
 //installation配套设施 小区
 $enums['installation']['200401']='燃气/天然气';
 $enums['installation']['200402']='暖气';
 $enums['installation']['200403']='电梯';
 $enums['installation']['200404']='车位';
 $enums['installation']['200405']='车库';
 $enums['installation']['200406']='花园';
 $enums['installation']['200407']='露台';
 $enums['installation']['200408']='阁楼';
 
 //类型
 $enums['type']['200501']='楼盘';
 $enums['type']['200502']='新房';
 $enums['type']['200503']='小区';
 $enums['type']['200504']='二手房';
 $enums['type']['200505']='出租房';
 
 //房屋性质
 $enums['house_nature']['200601']='满五';
 $enums['house_nature']['200602']='免税';
 //出租性质
 $enums['rent_property']['200701']='整租';
 $enums['rent_property']['200702']='合租';
 //付款方式
 $enums['payment']['200801']='一押一付';
 $enums['payment']['200802']='二押一付';
 //户型结构-室
 $enums['house_shi']['200901']='一';
 $enums['house_shi']['200902']='二';
 $enums['house_shi']['200903']='三';
 $enums['house_shi']['200904']='四';
 //户型结构-厅
 $enums['house_ting']['201001']='一';
 $enums['house_ting']['201002']='二';
 $enums['house_ting']['201003']='三';
 $enums['house_ting']['201004']='四';
 //户型结构-位
 $enums['house_wei']['201101']='一';
 $enums['house_wei']['201102']='二';
 $enums['house_wei']['201103']='三';
 $enums['house_wei']['201104']='四';
 //户型结构-厨
 $enums['house_chufang']['201201']='一';
 $enums['house_chufang']['201202']='二';
 $enums['house_chufang']['201203']='三';
 $enums['house_chufang']['201204']='四';
 //户型结构-阳台
 $enums['house_yangtai']['201301']='一';
 $enums['house_yangtai']['201302']='二';
 $enums['house_yangtai']['201303']='三';
 $enums['house_yangtai']['201304']='四';
 //购房目的
 $enums['intent']['201401']='刚需房';
 $enums['intent']['201402']='改善房';
 $enums['intent']['201403']='婚房';
 $enums['intent']['201404']='学位房';
 $enums['intent']['201405']='养老房';
 $enums['intent']['201406']='投资房';
 
 //朝向
 $enums['house_face']['201501']='朝东';
 $enums['house_face']['201502']='东南';
 $enums['house_face']['201503']='朝南';
 $enums['house_face']['201504']='西南';
 $enums['house_face']['201505']='朝西';
 $enums['house_face']['201506']='西北';
 $enums['house_face']['201507']='朝北';
 $enums['house_face']['201508']='东北';
 $enums['house_face']['201509']='朝东';
 $enums['house_face']['201510']='朝东';
 
 //配套设施  求租
 $enums['installation']['201601']='拎包入住';
 $enums['installation']['201602']='家电齐全';
 $enums['installation']['201603']='可上网';
 $enums['installation']['201604']='可洗澡';
 $enums['installation']['201605']='可做饭';
 $enums['installation']['201606']='空调房';
 $enums['installation']['201607']='有暖气';
 $enums['installation']['201608']='带车位';
 */

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

}BUILDING_STRUCTURE_TYPE;               //!建筑结构

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
    rRequestTypeAppBaseInfoConfiguration = 1001,//!<具体某个配置信息的请求
    
    rRequestTypeImage                    //!<图片请求：此类型为尾类型，请新添加的类型不要放在这个类型之后

}REQUEST_TYPE;                           //!<请求类型

#endif
