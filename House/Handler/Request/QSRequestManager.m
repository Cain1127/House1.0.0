//
//  QSRequestManager.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRequestManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "QSDataMappingManager.h"

@implementation QSRequestManager

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
+ (void)requestDataWithType:(REQUEST_TYPE)requestType andCallBack:(void(^)(REQUEST_RESULT_STATUS resultStatus,id resultData,NSString *errorInfo,NSString *errorCode))callBack
{

    switch (requestType) {
            
            ///广告请求
        case rRequestTypeAdvert:
        {
            
            AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
            
            requestManager.responseSerializer.acceptableContentTypes = [requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
            
            [requestManager GET:[NSString stringWithFormat:@"%@%@",URLFDangJiaIPHome,URLAdvert] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                ///先获取响应结果
                BOOL isServerRespondSuccess = [[responseObject valueForKey:@"type"] boolValue];
                
                if (isServerRespondSuccess) {
                    
                    ///解析数据:QSHeaderDataModel/QSAdvertReturnData
                    id analyzeResult = [QSDataMappingManager analyzeDataWithData:operation.responseData andMappingClass:@"QSAdvertReturnData"];
                    
                    ///判断解析结果
                    if (analyzeResult && callBack) {
                        
                        callBack(rRequestResultTypeSuccess,analyzeResult,nil,nil);
                        
                        
                    } else {
                        
                        ///数据解析失败回调
                        callBack(rRequestResultTypeDataAnalyzeFail,nil,@"数据解析失败",@"1000");
                        
                    }
                    
                } else {
                
                    ///解析数据
                    id analyzeResult = [QSDataMappingManager analyzeDataWithData:operation.responseData andMappingClass:@"QSHeaderDataModel"];
                    
                    ///判断解析结果
                    if (analyzeResult && callBack) {
                        
                        callBack(rRequestResultTypeFail,analyzeResult,nil,nil);
                        
                        
                    } else {
                        
                        ///数据解析失败回调
                        callBack(rRequestResultTypeDataAnalyzeFail,nil,@"数据解析失败",@"1000");
                        
                    }
                
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                if (callBack) {
                    
                    ///回调
                    callBack(rRequestResultTypeBadNetworking,nil,[error.userInfo valueForKey:NSLocalizedDescriptionKey],[NSString stringWithFormat:@"%@%ld",error.domain,error.code]);
                    
                }
                
            }];

        }
            break;
            
            ///应用配置信息请求
        case rRequestTypeAppBaseInfo:
            
            break;
            
            ///图片请求
        case rRequestTypeImage:
            
            break;
            
        default:
            break;
    }

}

@end
