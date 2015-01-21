//
//  QSCoreDataManager.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"
#import "QSYAppDelegate.h"

@implementation QSCoreDataManager

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

#pragma mark - 返回应用的指引状态
/**
 *  @author yangshengmeng, 15-01-20 10:01:15
 *
 *  @brief  获取应用指引状态：YES-已经指引过，NO-需要重新指引
 *
 *  @since  1.0.0
 */
+ (BOOL)getAppGuideIndexStatus
{
    
    NSString *indexStatus = (NSString *)[self getDataWithKey:@"QSHouseApplicationInfoModel" andKeyword:@"is_new_index"];
    
    ///如果当前没有配置，则返回NO
    if (nil == indexStatus) {
        
        return YES;
        
    }
    
    ///已存值时：0-表示当前有新的指引 1-表示当前没有新的指引
    int statusINT = [indexStatus intValue];
    
    return (statusINT == 1) ? NO : YES;

}

#pragma mark - 返回上一次进入应用的时间
/**
 *  @author yangshengmeng, 15-01-20 00:01:14
 *
 *  @brief  返回最后显示广告的时间
 *
 *  @return 返回上一次显示广告的时间日期整数字符串
 *
 *  @since  1.0.0
 */
+ (NSString *)getAdvertLastShowTime
{

    return (NSString *)[self getDataWithKey:@"QSHouseApplicationInfoModel" andKeyword:@"advert_last_show_time"];

}

#pragma mark - 本地搜索历史记录相关操作
/**
 *  @author yangshengmeng, 15-01-21 18:01:15
 *
 *  @brief  获取本地搜索历史
 *
 *  @return 返回搜索历史数组：数组中的模型为-QSFDangJiaSearchHistoryDataModel
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalSearchHistory
{

    return [self getDataListWithKey:@"QSFDangJiaSearchHistoryDataModel" andSortKeyWord:@"search_time" andAscend:YES];

}

///插入一个新的搜索历史
+ (BOOL)addLocalSearchHistory:(QSFDangJiaSearchHistoryDataModel *)model
{
    
    return YES;

}

///清空本地搜索历史
+ (BOOL)clearLocalSearchHistory
{

    return YES;

}

#pragma mark - 返回指定实体所有数据
/**
 *  @author             yangshengmeng, 15-01-21 18:01:56
 *
 *  @brief              返回指定实体所有数据数组
 *
 *  @param entityName   实体名
 *
 *  @return             返回实体数组
 *
 *  @since              1.0.0
 */
+ (NSArray *)getDataListWithKey:(NSString *)entityName andSortKeyWord:(NSString *)keyword andAscend:(BOOL)isAscend
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    NSEntityDescription *enty = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOContext];
    
    ///设置查找
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:enty];
    
    ///设置排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:keyword ascending:isAscend];
    [request setSortDescriptors:@[sort]];
    
    NSError *error;
    NSArray *resultList = [mOContext executeFetchRequest:request error:&error];
    
    ///判断是否查询失败
    if (error) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    return resultList;

}

#pragma mark - 返回coreData中的指定表中的某字段信息
/**
 *  @author             yangshengmeng, 15-01-20 09:01:45
 *
 *  @brief              查询指定表中的某字段信息
 *
 *  @param entityName   实体名
 *  @param keyword      字段名
 *
 *  @since              1.0.0
 */
+ (instancetype)getDataWithKey:(NSString *)entityName andKeyword:(NSString *)keyword
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    NSEntityDescription *enty = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOContext];
    
    ///设置查找
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:enty];
    
    ///设置排序
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:keyword ascending:YES];
    [request setSortDescriptors:@[sort]];
    
    NSError *error;
    NSArray *resultList = [mOContext executeFetchRequest:request error:&error];
    
    ///判断是否查询失败
    if (error) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    NSObject *resultModel = resultList[0];
    return resultModel ? ([resultModel valueForKey:keyword] ? [resultModel valueForKey:keyword] : nil) : nil;

}

@end
