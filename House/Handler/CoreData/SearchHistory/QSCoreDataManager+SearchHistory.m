//
//  QSCoreDataManager+SearchHistory.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+SearchHistory.h"
#import "QSYAppDelegate.h"

///应用配置信息的CoreData模型
#define COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO @"QSCDLocalSearchHistoryDataModel"

@implementation QSCoreDataManager (SearchHistory)

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
    
    return [self getEntityListWithKey:COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO andSortKeyWord:@"search_time" andAscend:YES];
    
}

///插入一个新的搜索历史
+ (BOOL)addLocalSearchHistory:(QSCDLocalSearchHistoryDataModel *)model
{
    
    if (nil == model) {
        
        return NO;
        
    }
    
    ///获取主上下文
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    ///错误信息
    NSError *error = nil;
    
    ///插入数据
    QSCDLocalSearchHistoryDataModel *insertModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO inManagedObjectContext:tempContext];
    insertModel.search_keywork = model.search_keywork;
    insertModel.search_sub_type = model.search_sub_type;
    insertModel.search_time = model.search_time;
    insertModel.search_type = model.search_type;
    [tempContext save:&error];
    
    if (error) {
        
        return NO;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    return YES;
    
}

///清空本地搜索历史
+ (BOOL)clearLocalSearchHistory
{
    
    return [self clearEntityListWithEntityName:COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO];
    
}

@end
