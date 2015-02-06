//
//  QSBaseModel.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@implementation QSBaseModel

///数据解析方法
+ (RKObjectMapping *)objectMapping
{

    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    return shared_mapping;

}

///数据存入CoreData
- (BOOL)saveModelDataIntoCoreData
{

    return NO;

}

///将数据从CoreData中取出来
+ (QSBaseModel *)getModelDataFromCoreData
{

    return nil;

}

@end
