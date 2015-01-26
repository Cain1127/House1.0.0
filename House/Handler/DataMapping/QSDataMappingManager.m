//
//  QSDataMappingManager.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDataMappingManager.h"
#import "RestKit.h"
#import "RKMapperOperation.h"

@implementation QSDataMappingManager

#pragma mark - 按给定的数据模型解析数据并返回此模型
/**
 *  @author             yangshengmeng, 15-01-20 23:01:48
 *
 *  @brief              根据给定的数据对象解析并返回，传进来的数据模型必须实现对应的协议方法
 *
 *  @param data         需要解析的数据
 *  @param mappingClass 解析完成后的数据存放的模型
 *
 *  @return             返回解析后的数据模型
 *
 *  @since              1.0.0
 */
+ (void)analyzeDataWithData:(NSData *)data andMappingClass:(NSString *)mappingClassString andMappingCallBack:(void(^)(BOOL mappingStatus,id mappingResult))mappingCallBack
{

    ///判断给定的对象是否已实现对应的数据mapping接口
    Class mappingTempObject = NSClassFromString(mappingClassString);
    
    ///如若无法查找到此对象的类，直接返回nil
    if (nil == mappingTempObject) {
        
        mappingCallBack(NO,nil);
        return;
        
    }
    
    ///如若未实现mapping接口，直接返回nil
    if (![mappingTempObject respondsToSelector:@selector(objectMapping)]) {
        
        mappingCallBack(NO,nil);
        return;
        
    }
    
    ///使用协议指针指向mapping对象
    id<QSDataMappingProtocol> mappingObject = (id<QSDataMappingProtocol>)mappingTempObject;
    
    [self analyzeDataWithMapping:[mappingObject objectMapping] andData:data andMappingCallBack:mappingCallBack];

}

+ (void)analyzeDataWithMapping:(RKObjectMapping *)mapping andData:(NSData *)data andMappingCallBack:(void(^)(BOOL mappingStatus,id mappingResult))mappingCallBack
{
    
    ///数据检测
    NSParameterAssert(data);
    NSParameterAssert(mapping);
    
    NSDictionary *mappingDictionary = @{[NSNull null] : mapping};
    NSLog(@"==================正在解析数据======================");
    NSLog(@"mapping %@",mapping);
    NSLog(@"==================正在解析数据======================");
    
    ///数据序列化错信息
    NSError *error = nil;
    
    ///数据序列化:application/json
    id parsedData = [RKMIMETypeSerialization objectFromData:data MIMEType:@"application/json" error:&error];
    
    ///判断是否序列化成功
    if (error) {
        
        mappingCallBack(NO,nil);
        return;
        
    }
    
    RKMapperOperation *mapperOperation = [[RKMapperOperation alloc] initWithRepresentation:parsedData mappingsDictionary:mappingDictionary];
    [mapperOperation execute:&error];
    [mapperOperation waitUntilFinished];
    
    NSLog(@"================mapping成功====================");
    
    mappingCallBack(YES,mapperOperation.mappingResult.dictionary[[NSNull null]]);
    
}

@end
