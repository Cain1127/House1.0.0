//
//  QSRequestManager.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 15-01-20 21:01:17
 *
 *  @brief  网络请求管理器
 *
 *  @since  1.0.0
 */
@interface QSRequestManager : NSObject

/**
 *  @author yangshengmeng, 15-01-22 09:01:30
 *
 *  @brief  返回请求管理器的单例
 *
 *  @return 返回网格请求单例对象
 *
 *  @since  1.0.0
 */
+ (instancetype)shareRequestManager;

/**
 *  @author             yangshengmeng, 15-01-20 21:01:18
 *
 *  @brief              根据不同的请求类型，进行不同的请求，并返回对应的请求结果信息
 *
 *  @param requestType  请求类型
 *  @param callBack     请求结束时的回调
 *
 *  @since              1.0.0
 */
+ (void)requestDataWithType:(REQUEST_TYPE)requestType andCallBack:(void(^)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode))callBack;

/**
 *  @author             yangshengmeng, 15-01-26 14:01:24
 *
 *  @brief              根据不同的请求类型和参数，进行网络请求
 *
 *  @param requestType  请求类型
 *  @param params       请求参数
 *  @param callBack     回调
 *
 *  @since              1.0.0
 */
+ (void)requestDataWithType:(REQUEST_TYPE)requestType andParams:(NSDictionary *)params andCallBack:(void(^)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode))callBack;

@end
