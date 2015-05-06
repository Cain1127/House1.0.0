//
//  QSRequestTaskDataModel.h
//  House
//
//  Created by ysmeng on 15/1/22.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

///当前请求任务的状态
typedef enum
{

    rRequestTaskStatusDefault = 99,     //!<初始的默认状态
    rRequestTaskStatusRequesting,       //!<请求任务正在进行
    rRequestTaskStatusFinishSuccess,    //!<请求任务已完成-请求成功
    rRequestTaskStatusFinishFail,       //!<请求任务已完成-请求失败

}REQUEST_TASK_STATUS;

/**
 *  @author yangshengmeng, 15-01-22 10:01:11
 *
 *  @brief  所有网络请求任务的数据模型
 *
 *  @since  1.0.0
 */
@interface QSRequestTaskDataModel : NSObject

/**
 *  @author yangshengmeng, 15-05-06 12:05:36
 *
 *  @brief  请求任务的状态:rRequestTaskStatusDefault->rRequestTaskStatusFinishFail
 *
 *  @since  1.0.0
 */
@property (nonatomic,assign) REQUEST_TASK_STATUS requestStatus;

@property (nonatomic,assign) REQUEST_TYPE requestType;                  //!<请求类型
@property (nonatomic,assign) REQUEST_HTTPREQUEST_TYPE httpRequestType;  //!<http请求时的类型
@property (nonatomic,copy) NSString *requestURL;                        //!<请求地址
@property (nonatomic,copy) NSString *dataMappingClass;                  //!<数据解析对应的类名
@property (nonatomic,retain) NSDictionary *requestParams;               //!<附加的请求参数

@property (nonatomic,copy) void(^requestCallBack)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode);                            //!<请求后的回调

@end
