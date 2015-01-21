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
+ (NSArray *)getDataListWithKey:(NSString *)entityName andSortKeyWord:(NSString *)keyword andAscend:(BOOL)isAscend;

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
+ (instancetype)getDataWithKey:(NSString *)entityName andKeyword:(NSString *)keyword;

/**
 *  @author             yangshengmeng, 15-01-21 21:01:57
 *
 *  @brief              根据给定的字段和字段新内容更新CoreData数据
 *
 *  @param entityName   实体名
 *  @param fieldName    字段名
 *
 *  @return             更新结果：YES-更新成功，NO-更新失败
 *
 *  @since              1.0.0
 */
+ (BOOL)updateFieldWithKey:(NSString *)entityName andUpdateField:(NSString *)fieldName andFieldNewValue:(id)newValue;

@end
