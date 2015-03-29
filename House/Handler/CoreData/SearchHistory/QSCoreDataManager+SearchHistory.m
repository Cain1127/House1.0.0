//
//  QSCoreDataManager+SearchHistory.m
//  House
//
//  Created by ysmeng on 15/1/21.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+SearchHistory.h"
#import "QSLocalSearchHistoryDataModel.h"
#import "QSCDLocalSearchHistoryDataModel.h"
#import "QSYAppDelegate.h"

///应用配置信息的CoreData模型
#define COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO @"QSCDLocalSearchHistoryDataModel"

@implementation QSCoreDataManager (SearchHistory)

#pragma mark - 本地搜索搜索历史
/**
 *  @author             yangshengmeng, 15-01-21 18:01:15
 *
 *  @brief              获取本地搜索历史
 *
 *  @param  houseType   房源类型
 *
 *  @return             返回搜索历史数组：数组中的模型为-QSFDangJiaSearchHistoryDataModel
 *
 *  @since              1.0.0
 */
+ (NSArray *)getLocalSearchHistoryWithHouseType:(FILTER_MAIN_TYPE)houseType
{
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO andFieldKey:@"search_type" andSearchKey:[NSString stringWithFormat:@"%d",houseType]];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tempArray count]; i++) {
        
        QSLocalSearchHistoryDataModel *tempModel = [[QSLocalSearchHistoryDataModel alloc] init];
        QSCDLocalSearchHistoryDataModel *saveModel = tempArray[i];
        tempModel.search_type = saveModel.search_type;
        tempModel.search_time = saveModel.search_time;
        tempModel.search_sub_type = saveModel.search_sub_type;
        tempModel.search_keywork = saveModel.search_keywork;
        [resultArray addObject:tempModel];
        
    }
    
    return [NSArray arrayWithArray:resultArray];
    
}

///插入一个新的搜索历史
+ (void)addLocalSearchHistory:(QSLocalSearchHistoryDataModel *)model andCallBack:(void(^)(BOOL flag))callBack
{
    
    if (nil == model) {
        
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///获取主上下文
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSString *typeString = @"search_type == %@ AND ";
    NSString *keyString = @"search_keywork == %@";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[typeString stringByAppendingString:keyString],model.search_type,model.search_keywork];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"CoreData.SearchCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///判断本地是否有数据
    if ([fetchResultArray count] > 0) {
        
        QSCDLocalSearchHistoryDataModel *insertModel = fetchResultArray[0];
        insertModel.search_keywork = model.search_keywork;
        insertModel.search_sub_type = model.search_sub_type;
        insertModel.search_time = model.search_time;
        insertModel.search_type = model.search_type;
        [tempContext save:&error];
        
    } else {
        
        QSCDLocalSearchHistoryDataModel *insertModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO inManagedObjectContext:tempContext];
        insertModel.search_keywork = model.search_keywork;
        insertModel.search_sub_type = model.search_sub_type;
        insertModel.search_time = model.search_time;
        insertModel.search_type = model.search_type;
        [tempContext save:&error];
        
    }
    
    ///判断是否保存成功
    if (error) {
        
        NSLog(@"CoreData.SaveCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }
    
}

///清空本地搜索历史
+ (void)clearLocalSearchHistoryWithHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(BOOL flag))callBack
{
    
    BOOL deleteResult = [self clearEntityListWithEntityName:COREDATA_ENTITYNAME_LOCALSEARCHISTORY_INFO andFieldKey:@"search_type" andDeleteKey:[NSString stringWithFormat:@"%d",houseType]];
    if (callBack) {
        
        callBack(deleteResult);
        
    }
    
}

@end
