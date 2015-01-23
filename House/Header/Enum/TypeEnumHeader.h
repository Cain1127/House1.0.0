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

}USER_COUNT_TYPE;

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
