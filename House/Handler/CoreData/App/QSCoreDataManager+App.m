//
//  QSCoreDataManager+App.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+App.h"

@implementation QSCoreDataManager (App)

#pragma mark - 返回指定城市可选区域列表
/**
 *  @author yangshengmeng, 15-01-20 10:01:58
 *
 *  @brief  返回指定城市的可选区域列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getDistrictWithCity:(NSString *)city
{
    
    return @[@"天河区",@"荔湾区",@"越秀区",@"海珠区",@"番禺区",@"白云区",@"黄埔区",@"花都区",@"南沙区",@"萝岗区",@"增城区"];
    
}

#pragma mark - 返回当前可选的城市列表
/**
 *  @author yangshengmeng, 15-01-20 10:01:47
 *
 *  @brief  返回城市列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getCityList
{
    
    return @[@"广州"];
    
}

@end
