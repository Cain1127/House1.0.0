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
#import "QSRequestTaskDataModel.h"

@interface QSRequestManager ()

///网络请求管理器
@property (nonatomic,retain) AFHTTPRequestOperationManager *httpRequestManager;

///请求任务池：放置的对象为QSRequestTaskDataModel对象或它的子类
@property (nonatomic,retain) NSMutableArray *taskPool;

///请求任务处理使用的自定义线程
@property (nonatomic, strong) dispatch_queue_t requestOperationQueue;

@end

@implementation QSRequestManager

#pragma mark - ===============对象方法区域===============
//*****************************************************
//*****************************************************
//
//                      网络请求对象方法区域
//
//*****************************************************
//*****************************************************

#pragma mark - 返回网络请求的单例
/**
 *  @author yangshengmeng, 15-01-22 09:01:30
 *
 *  @brief  返回请求管理器的单例
 *
 *  @return 返回网格请求单例对象
 *
 *  @since  1.0.0
 */
+ (instancetype)shareRequestManager
{

    static QSRequestManager *requestManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ///对象初始化
        requestManager = [[QSRequestManager alloc] init];
        
        ///成员变量、属性、其他初始化
        [requestManager initRequestManagerProperty];
        
    });
    
    return requestManager;

}

#pragma mark - 网络请求相关的属性/变量等初始化
///网络请求相关的属性/变量等初始化
- (void)initRequestManagerProperty
{
    
    ///网络请求管理器初始化
    self.httpRequestManager = [AFHTTPRequestOperationManager manager];
    self.httpRequestManager.responseSerializer.acceptableContentTypes = [self.httpRequestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    ///任务池初始化
    self.taskPool = [[NSMutableArray alloc] init];
    
    ///请求任务操作线程初始化
    self.requestOperationQueue = dispatch_queue_create(QUEUE_REQUEST_OPERATION, DISPATCH_QUEUE_CONCURRENT);
    
    ///添加任务池观察
    [self addObserver:self forKeyPath:@"taskPool" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

}

#pragma mark - 任务池的添加/删除/返回
///添加一个网络请求任务
- (void)addRequestTaskToPool:(QSRequestTaskDataModel *)taskModel
{

    ///判断任务是否有效
    if (nil == taskModel) {
        
        return;
        
    }
    
    dispatch_barrier_async(self.requestOperationQueue, ^{
        
        ///查询原来是否已存在消息
        int i = 0;
        for (i = 0; i < _taskPool.count; i++) {
            
            QSRequestTaskDataModel *tempTaskModel = _taskPool[i];
            
            ///如果原来已有对应的消息，则不再添加
            if ((tempTaskModel.requestType == taskModel.requestType) &&
                ([tempTaskModel.requestURL isEqualToString:taskModel.requestURL]) &&
                (tempTaskModel.requestCallBack == taskModel.requestCallBack) &&
                ([tempTaskModel.dataMappingClass isEqualToString:taskModel.dataMappingClass])) {
                
                return;
                
            }
            
        }
        
        ///没有重复的，添加
        [[self mutableArrayValueForKey:@"taskPool"] addObject:taskModel];
        
    });

}

///从任务池中删除第一个任务
- (void)removeFirstObjectFromTaskPool
{

    ///如果任务池已为空，则不再删除
    if (0 >= [self.taskPool count]) {
        
        return;
        
    }
    
    ///在指定线程中删除元素
    dispatch_barrier_async(self.requestOperationQueue, ^{
        
        [[self mutableArrayValueForKey:@"taskPool"] removeObjectAtIndex:0];
        
    });

}

///获取第一个请求任务
- (QSRequestTaskDataModel *)getFirstObjectFromTaskPool
{

    if (0 >= [self.taskPool count]) {
        
        return nil;
        
    }
    
    NSArray *tempArray = [self getRequestTaskPool];
    
    return tempArray[0];

}

///返回当前所有的任务请求队列
- (NSArray *)getRequestTaskPool
{

    __block NSArray *tempArray = nil;
    
    dispatch_sync(self.requestOperationQueue, ^{
        
        tempArray = [NSArray arrayWithArray:_taskPool];
        
    });
    
    return tempArray;

}

#pragma mark - 任务池观察者回调
///任务池观察者回调：当任务池有数据变动时，此方法捕抓
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    ///观察是否清空
    if (0 >= [self.taskPool count]) {
        
        return;
        
    }
    
    ///如若还有请求任务，取第一个任务执行
    [self startRequestDataWithRequestTaskModel:self.taskPool[0]];

}

///开始请求数据
- (void)startRequestDataWithRequestTaskModel:(QSRequestTaskDataModel *)taskModel
{
    
    ///根据请求任务中的请求类型，使用不同的请求
    if (rRequestHttpRequestTypeGet == taskModel.httpRequestType) {
        
        [self.httpRequestManager GET:taskModel.requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            ///先获取响应结果
            BOOL isServerRespondSuccess = [[responseObject valueForKey:@"type"] boolValue];
            
            if (isServerRespondSuccess) {
                
                ///解析数据:QSHeaderDataModel/QSAdvertReturnData
                id analyzeResult = [QSDataMappingManager analyzeDataWithData:operation.responseData andMappingClass:taskModel.dataMappingClass];
                
                ///判断解析结果
                if (analyzeResult && taskModel.requestCallBack) {
                    
                    taskModel.requestCallBack(rRequestResultTypeSuccess,analyzeResult,nil,nil);
                    
                    
                } else {
                    
                    ///数据解析失败回调
                    taskModel.requestCallBack(rRequestResultTypeDataAnalyzeFail,nil,@"数据解析失败",@"1000");
                    
                }
                
            } else {
                
                ///解析数据
                id analyzeResult = [QSDataMappingManager analyzeDataWithData:operation.responseData andMappingClass:@"QSHeaderDataModel"];
                
                ///判断解析结果
                if (analyzeResult && taskModel.requestCallBack) {
                    
                    taskModel.requestCallBack(rRequestResultTypeFail,analyzeResult,nil,nil);
                    
                    
                } else {
                    
                    ///数据解析失败回调
                    taskModel.requestCallBack(rRequestResultTypeDataAnalyzeFail,nil,@"数据解析失败",@"1000");
                    
                }
                
            }
            
            ///开启下一次的请求
            [self removeFirstObjectFromTaskPool];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (taskModel.requestCallBack) {
                
                ///回调
                taskModel.requestCallBack(rRequestResultTypeBadNetworking,nil,[error.userInfo valueForKey:NSLocalizedDescriptionKey],[NSString stringWithFormat:@"%@%d",error.domain,(int)error.code]);
                
            }
            
            ///开启下一次的请求
            [self removeFirstObjectFromTaskPool];
            
        }];
        
    }
    
    ///POST请求
    if (rRequestHttpRequestTypePost == taskModel.httpRequestType) {
        
        
        
    }

}

#pragma mark - ===============类方法区域===============
//*****************************************************
//*****************************************************
//
//                      网络请求类方法区域
//
//*****************************************************
//*****************************************************

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
    
    ///判断类型是否准确
    if ((rRequestTypeAdvert > requestType) || (rRequestTypeImage < requestType)) {
        
        if (callBack) {
            
            callBack(rRequestResultTypeError,nil,@"请求类型错误",nil);
            
        }
        
        return;
        
    }
    
    ///创建网络请求任务
    QSRequestTaskDataModel *requestTask = [[QSRequestTaskDataModel alloc] init];
    
    ///保存请求类型
    requestTask.requestType = requestType;
    
    ///保存回调
    if (callBack) {
        
        requestTask.requestCallBack = callBack;
        
    }
    
    ///获取请求地址
    NSString *requestURLString = [self getRequestURLWithRequestType:requestType];
    
    ///校验
    if ((nil == requestURLString) || (!([requestURLString hasPrefix:@"http://"]))) {
        
        if (callBack) {
            
            callBack(rRequestResultTypeURLError,nil,@"无法获取有效URL信息",nil);
            
        }
        return;
        
    }
    requestTask.requestURL = requestURLString;
    
    ///获取请求使用的数据解析对象名
    NSString *mappingClassName = [self getDataMappingObjectName:requestType];
    
    ///校验
    if ((nil == mappingClassName) ||
        (0 >= [mappingClassName length]) ||
        (!([NSClassFromString(mappingClassName) isSubclassOfClass:NSClassFromString(@"QSBaseModel")]))) {
        
        if (callBack) {
            
            callBack(rRequestResultTypeMappingClassError,nil,@"无效的mapping类",nil);
            
        }
        
        return;
        
    }
    
    requestTask.dataMappingClass = mappingClassName;
    
    ///返回请求类型
    requestTask.httpRequestType = [self getHttpRequestTypeWithType:requestType];
    
    ///添加请求任务
    [[self shareRequestManager] addRequestTaskToPool:requestTask];

}

#pragma mark - 返回不同请求的网络请求地址
///返回不同的请求类型的请求地址
+ (NSString *)getRequestURLWithRequestType:(REQUEST_TYPE)requestType
{

    NSDictionary *taskDictionary = [self getTaskInfoDictionaryWithRequsetType:requestType];
    
    ///校验
    if ((nil == taskDictionary) || (0 >= [taskDictionary count])) {
        
        return nil;
        
    }
    
    ///获取配置的类名
    NSString *urlString = [taskDictionary valueForKey:@"url"];
    
    return [NSString stringWithFormat:@"%@%@",URLFDangJiaIPHome,urlString];

}

#pragma mark - 返回不同请求类型所使用的http请求类型
///返回不同请求类型所使用的http请求类型
+ (REQUEST_HTTPREQUEST_TYPE)getHttpRequestTypeWithType:(REQUEST_TYPE)taskType
{
    
    return rRequestHttpRequestTypeGet;
    
}

#pragma mark - 返回数据解析的类型
///返回每个请求类型的数据解析使用的类名
+ (NSString *)getDataMappingObjectName:(REQUEST_TYPE)requestType
{

    NSDictionary *taskDictionary = [self getTaskInfoDictionaryWithRequsetType:requestType];
    
    ///校验
    if ((nil == taskDictionary) || (0 >= [taskDictionary count])) {
        
        return nil;
        
    }
    
    ///获取配置的类名
    NSString *className = [taskDictionary valueForKey:@"class"];
    
    return className;

}

///返回给定类型的请求配置信息字典
+ (NSDictionary *)getTaskInfoDictionaryWithRequsetType:(REQUEST_TYPE)requestType
{

    NSDictionary *requestInfoDictionary = [self getRequestInfoDictionary];
    
    ///校验
    if ((nil == requestInfoDictionary) || (0 >= [requestInfoDictionary count])) {
        
        return nil;
        
    }
    
    ///请求关键字
    NSString *keyword = [NSString stringWithFormat:@"%d",requestType];
    
    ///获取配置的类名
    NSDictionary *taskDictionary = [requestInfoDictionary valueForKey:keyword];
    
    return taskDictionary;

}

#pragma mark - 返回网络请求的配置字典
///返回网络请求的配置字典
+ (NSDictionary *)getRequestInfoDictionary
{

    NSString *path = [[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME_REQUEST ofType:PLIST_FILE_TYPE];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];

}

@end
