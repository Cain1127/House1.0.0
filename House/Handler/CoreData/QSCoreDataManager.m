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
