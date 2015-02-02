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

#pragma mark - 返回指定实体数据
/**
 *  @author             yangshengmeng, 15-01-26 16:01:28
 *
 *  @brief              返回某个实体中的所有数据
 *
 *  @param entityName   实体名
 *
 *  @return             返回对应实体中所有数据的数组
 *
 *  @since              1.0.0
 */
+ (NSArray *)getEntityListWithKey:(NSString *)entityName
{

    return [self getEntityListWithKey:entityName andSortKeyWord:nil andAscend:YES];
    
}

/**
 *  @author             yangshengmeng, 15-01-26 16:01:08
 *
 *  @brief              返回指定实体中的所有数据，并按给定的字段排序查询
 *
 *  @param entityName   实体名
 *  @param keyword      需要排序的字段
 *  @param isAscend     排序：YES-升序,NO-降序
 *
 *  @return             返回查询的数据
 *
 *  @since              1.0.0
 */
+ (NSArray *)getEntityListWithKey:(NSString *)entityName andSortKeyWord:(NSString *)keyword andAscend:(BOOL)isAscend
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    NSEntityDescription *enty = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOContext];
    
    ///设置查找
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:enty];
    
    if (keyword) {
        
        ///设置排序
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:keyword ascending:isAscend];
        [request setSortDescriptors:@[sort]];
        
    }
    
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

/**
 *  @author             yangshengmeng, 15-01-26 16:01:48
 *
 *  @brief              查询给定实体中，指定关键字的数据，并返回
 *
 *  @param entityName   指定实体名
 *  @param keyword      需要搜索的字段名
 *  @param searchKey    字段中的内容
 *
 *  @return             返回查询结果
 *
 *  @since              1.0.0
 */
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey
{

    return [self searchEntityListWithKey:entityName andFieldKey:keyword andSearchKey:searchKey andAscend:YES];

}

/**
 *  @author yangshengmeng, 15-01-26 16:01:59
 *
 *  @brief              查询指定实体中，指定字段满足指定查询条件的数据集合
 *
 *  @param entityName   实体名
 *  @param keyword      字段名
 *  @param searchKey    查询关键字
 *  @param isAscend     排序：YES-升序
 *
 *  @return             返回查询的结果集
 *
 *  @since              1.0.0
 */
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey andAscend:(BOOL)isAscend
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    NSEntityDescription *enty = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOContext];
    
    ///设置查找
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:enty];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",keyword] stringByAppendingString:@"%@"],searchKey];
    [request setPredicate:predicate];
    
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

#pragma mark - 查询某实体中给定关键的第一个实体
/**
 *  @author             yangshengmeng, 15-01-26 15:01:31
 *
 *  @brief              根据给定的关键字，在指定的实体中查询数据并返回
 *
 *  @param entityname   实体名称
 *  @param fieldName    字段名
 *  @param searchKey    关键字
 *
 *  @return             返回搜索的结果
 *
 *  @since              1.0.0
 */
+ (instancetype)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey
{
    
    NSArray *resultList = [self searchEntityListWithKey:entityName andFieldKey:fieldName andSearchKey:searchKey];
    
    ///判断是否查询失败
    if (nil == resultList) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    id resultModel = [resultList firstObject];
    return resultModel ? resultModel : nil;
    
}

#pragma mark - 返回coreData中指定的单表中的某字段信息
/**
 *  @author             yangshengmeng, 15-01-26 17:01:37
 *
 *  @brief              获取单记录实体数据中指定的字段信息
 *
 *  @param entityName   实体名
 *  @param keyword      字段名
 *
 *  @return             返回给定字段的信息
 *
 *  @since              1.0.0
 */
+ (instancetype)getUnirecordFieldWithKey:(NSString *)entityName andKeyword:(NSString *)keyword
{

    NSArray *resultList = [self getEntityListWithKey:entityName andSortKeyWord:keyword andAscend:YES];
    
    ///判断是否查询失败
    if (nil == resultList) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    NSObject *resultModel = [resultList firstObject];
    return resultModel ? ([resultModel valueForKey:keyword] ? [resultModel valueForKey:keyword] : nil) : nil;

}

#pragma mark - 单条数据的表更新数据
/**
 *  @author             yangshengmeng, 15-01-26 17:01:36
 *
 *  @brief              更新单记录表中，指定字段的信息
 *
 *  @param entityName   实体名
 *  @param fieldName    字段名
 *  @param newValue     对应字段的新值
 *
 *  @return             返回更新是否成功
 *
 *  @since              1.0.0
 */
+ (BOOL)updateUnirecordFieldWithKey:(NSString *)entityName andUpdateField:(NSString *)fieldName andFieldNewValue:(id)newValue
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOContext];
    [fetchRequest setEntity:entity];
    
    ///查询条件
    NSPredicate* predicate = [NSPredicate predicateWithValue:YES];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [mOContext executeFetchRequest:fetchRequest error:&error];
    
    ///判断读取出来的原数据
    if (nil == fetchResultArray) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///检测原来是否已有数据
    if (0 >= [fetchResultArray count]) {
        
        ///插入数据
        NSObject *model = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:mOContext];
        [model setValue:newValue forKey:fieldName];
        [mOContext save:&error];
        
    } else {
    
        ///获取模型后更新保存
        NSObject *model = fetchResultArray[0];
        [model setValue:newValue forKey:fieldName];
        [mOContext save:&error];
    
    }
    
    if (error) {
        
        return NO;
        
    }
    
    return YES;

}

#pragma mark - 清空给定实体中所有的数据
/**
 *  @author             yangshengmeng, 15-01-21 23:01:28
 *
 *  @brief              清空某个实体模型中所有的数据
 *
 *  @param entityName   实体名
 *
 *  @return             删除结果标识：YES-删除成功,NO-删除失败
 *
 *  @since              1.0.0
 */
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *resultArray = [mOContext executeFetchRequest:fetchRequest error:&error];
    
    ///查询失败
    if (error) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///如果本身数据就为0，则直接返回YES
    if (0 >= [resultArray count]) {
        
        return YES;
        
    }
    
    ///遍历删除
    for (NSManagedObject *obj in resultArray) {
        
        [mOContext deleteObject:obj];
        
    }
    
    ///确认删除结果
    BOOL isChangeSuccess = [mOContext save:&error];
    if (!isChangeSuccess) {
        
        NSLog(@"CoreData.DeleteData.Error:%@",error);
        
    }
    
    return isChangeSuccess;

}

/**
 *  @author             yangshengmeng, 15-01-26 18:01:50
 *
 *  @brief              删除给定实体中对应字段为特定关键字的所有记录
 *
 *  @param entityName   实体名
 *  @param fieldKey     字段名
 *  @param deleteKey    字段的内容
 *
 *  @return             返回删除是否成功
 *
 *  @since              1.0.0
 */
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName andFieldKey:(NSString *)fieldKey andDeleteKey:(NSString *)deleteKey
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mOContext = appDelegate.managedObjectContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mOContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setEntity:entity];
    
    ///设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",fieldKey] stringByAppendingString:@"%@"],deleteKey];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [mOContext executeFetchRequest:fetchRequest error:&error];
    
    ///查询失败
    if (error) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///如果本身数据就为0，则直接返回YES
    if (0 >= [resultArray count]) {
        
        return YES;
        
    }
    
    ///遍历删除
    for (NSManagedObject *obj in resultArray) {
        
        [mOContext deleteObject:obj];
        
    }
    
    ///确认删除结果
    BOOL isChangeSuccess = [mOContext save:&error];
    if (!isChangeSuccess) {
        
        NSLog(@"CoreData.DeleteData.Error:%@",error);
        
    }
    
    return isChangeSuccess;

}

@end
