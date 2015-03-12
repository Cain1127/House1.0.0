//
//  QSCoreDataManager+Collected.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Collected.h"

#import "QSYAppDelegate.h"

#import "QSCollectedCommunityDataModel.h"
#import "QSCDCollectedCommunityDataModel.h"

///收藏CoreData实体名
#define COREDATA_ENTITYNAME_COLLECTED @"QSCDCollectedCommunityDataModel"
@implementation QSCoreDataManager (Collected)

/**
 *  @author yangshengmeng, 15-03-12 14:03:09
 *
 *  @brief  返回本地保存的数据列表
 *
 *  @return 返回本地保存的数据列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalCollectedDataSource
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
        
        QSCollectedCommunityDataModel *tempModel = [[QSCollectedCommunityDataModel alloc] init];
        tempModel.collected_id = obj.collected_id;
        tempModel.collected_time = obj.collected_time;
        tempModel.collected_type = obj.collected_type;
        tempModel.collectid_title = obj.collectid_title;
        tempModel.collected_status = obj.collected_status;
        tempModel.collected_old_price = obj.collected_old_price;
        tempModel.collected_new_price = obj.collected_new_price;
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

/**
 *  @author yangshengmeng, 15-03-12 14:03:30
 *
 *  @brief  查询未上传服务端的收藏记录
 *
 *  @return 返回本地保存中，未上传服务端的收藏记录
 *
 *  @since  1.0.0
 */
+ (NSArray *)getUncommitedCollectedDataSource
{
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COLLECTED andFieldKey:@"collected_status" andSearchKey:@"0"];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
        
        QSCollectedCommunityDataModel *tempModel = [[QSCollectedCommunityDataModel alloc] init];
        tempModel.collected_id = obj.collected_id;
        tempModel.collected_time = obj.collected_time;
        tempModel.collected_type = obj.collected_type;
        tempModel.collectid_title = obj.collectid_title;
        tempModel.collected_status = obj.collected_status;
        tempModel.collected_old_price = obj.collected_old_price;
        tempModel.collected_new_price = obj.collected_new_price;
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

/**
 *  @author             yangshengmeng, 15-03-12 14:03:24
 *
 *  @brief              保存收藏的数据
 *
 *  @param dataSource   内存中的收藏数据
 *
 *  @return             返回保存是否成功
 *
 *  @since              1.0.0
 */
+ (BOOL)saveCollectedDataSource:(NSArray *)dataSource
{
    
    BOOL saveFlag = YES;
    
    for (QSCollectedCommunityDataModel *obj in dataSource) {
        
        BOOL result = [self saveCollectedDataWithModel:obj];
        if (result) {
            
            continue;
            
        } else {
        
            saveFlag = NO;
            break;
        
        }
        
    }
    return saveFlag;
    
}

/**
 *  @author                 yangshengmeng, 15-03-12 14:03:28
 *
 *  @brief                  保存给定的一个收藏记录
 *
 *  @param collectedModel   收藏记录的数据模型
 *
 *  @return                 返回是否保存成功
 *
 *  @since                  1.0.0
 */
+ (BOOL)saveCollectedDataWithModel:(QSCollectedCommunityDataModel *)collectedModel
{
    
    ///校验
    if (nil == collectedModel) {
        
        return NO;
        
    }
    
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collected_id == %@",collectedModel.collected_id];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"CoreData.SearchCollectedData.Error:%@",error);
        return NO;
    }
    
    ///判断本地是否有数据
    if ([fetchResultArray count] > 0) {
        
        QSCDCollectedCommunityDataModel *cdCollectedModel = fetchResultArray[0];
        cdCollectedModel.collected_id = collectedModel.collected_id;
        cdCollectedModel.collected_time = collectedModel.collected_time;
        cdCollectedModel.collected_type = collectedModel.collected_type;
        cdCollectedModel.collectid_title = collectedModel.collectid_title;
        cdCollectedModel.collected_status = collectedModel.collected_status;
        cdCollectedModel.collected_old_price = collectedModel.collected_old_price;
        cdCollectedModel.collected_new_price = collectedModel.collected_new_price;
        
        [tempContext save:&error];
        
    } else {
    
        QSCDCollectedCommunityDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COLLECTED inManagedObjectContext:tempContext];
        
        cdCollectedModel.collected_id = collectedModel.collected_id;
        cdCollectedModel.collected_time = collectedModel.collected_time;
        cdCollectedModel.collected_type = collectedModel.collected_type;
        cdCollectedModel.collectid_title = collectedModel.collectid_title;
        cdCollectedModel.collected_status = collectedModel.collected_status;
        cdCollectedModel.collected_old_price = collectedModel.collected_old_price;
        cdCollectedModel.collected_new_price = collectedModel.collected_new_price;
        
        [tempContext save:&error];
    
    }
    
    ///判断是否保存成功
    if (error) {
        
        NSLog(@"CoreData.SaveCollectedData.Error:%@",error);
        return NO;
        
    } else {
    
        return YES;
    
    }
    
}

@end
