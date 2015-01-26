//
//  QSCoreDataManager.h
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author yangshengmeng, 15-01-21 18:01:59
 *
 *  @brief  CoreData操作控制器
 *
 *  @since  1.0.0
 */
@interface QSCoreDataManager : NSObject

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
+ (NSArray *)getEntityListWithKey:(NSString *)entityName;

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
+ (NSArray *)getEntityListWithKey:(NSString *)entityName andSortKeyWord:(NSString *)keyword andAscend:(BOOL)isAscend;

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
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey;

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
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey andAscend:(BOOL)isAscend;

/**
 *  @author             yangshengmeng, 15-01-26 15:01:31
 *
 *  @brief              根据给定的关键字，在指定的实体中查询数据并返回第一个实体
 *
 *  @param entityname   实体名称
 *  @param fieldName    字段名
 *  @param searchKey    关键字
 *
 *  @return             返回搜索的结果
 *
 *  @since              1.0.0
 */
+ (instancetype)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey;

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
+ (instancetype)getUnirecordFieldWithKey:(NSString *)entityName andKeyword:(NSString *)keyword;

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
+ (BOOL)updateUnirecordFieldWithKey:(NSString *)entityName andUpdateField:(NSString *)fieldName andFieldNewValue:(id)newValue;

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
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName;

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
+ (BOOL)clearEntityListWithEntityName:(NSString *)entityName andFieldKey:(NSString *)fieldKey andDeleteKey:(NSString *)deleteKey;

@end
