//
//  QSRequestTaskDataModel.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 15-01-22 10:01:11
 *
 *  @brief  所有网络请求任务的数据模型
 *
 *  @since  1.0.0
 */
@interface QSRequestTaskDataModel : NSObject

@property (nonatomic,assign) REQUEST_TYPE requestType;                  //!<请求类型
@property (nonatomic,assign) REQUEST_HTTPREQUEST_TYPE httpRequestType;  //!<http请求时的类型
@property (nonatomic,copy) NSString *requestURL;                        //!<请求地址
@property (nonatomic,copy) NSString *dataMappingClass;                  //!<数据解析对应的类名

@property (nonatomic,copy) void(^requestCallBack)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode);                            //!<请求后的回调

@end
