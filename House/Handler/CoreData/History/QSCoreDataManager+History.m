//
//  QSCoreDataManager+History.m
//  House
//
//  Created by ysmeng on 15/3/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+History.h"

#import "QSYAppDelegate.h"
#import "NSDate+Formatter.h"

#import "QSCDHistorySecondHandHouseDataModel.h"
#import "QSCDHistorySecondHandHousePhotoDataModel.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSHousePriceChangesDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"
#import "QSPhotoDataModel.h"

#import "QSCDHistoryRentHouseDataModel.h"
#import "QSCDHistoryRentHousePhotoDataModel.h"
#import "QSRentHouseDetailDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSDetailCommentListReturnData.h"
#import "QSCommentListDataModel.h"

#import "QSCDHistoryNewHouseDataModel.h"
#import "QSCDHistoryNewHousePhotoDataModel.h"
#import "QSCDHistoryNewHouseActivityDataModel.h"
#import "QSCDHistoryNewHouseAllHouseDataModel.h"
#import "QSCDHistoryNewHouseRecommendHousesDataModel.h"
#import "QSNewHouseDetailDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSRateDataModel.h"
#import "QSActivityDataModel.h"
#import "QSHouseTypeDataModel.h"

#import "QSCoreDataManager+User.h"

///浏览记录相关实体名
#define COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY @"QSCDHistorySecondHandHouseDataModel"
#define COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY_PHOTO @"QSCDHistorySecondHandHousePhotoDataModel"

#define COREDATA_ENTITYNAME_RENTHOUSE_HISTORY @"QSCDHistoryRentHouseDataModel"
#define COREDATA_ENTITYNAME_RENTHOUSE_HISTORY_PHOTO @"QSCDHistoryRentHousePhotoDataModel"

#define COREDATA_ENTITYNAME_NEWHOUSE_HISTORY @"QSCDHistoryNewHouseDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_PHOTO @"QSCDHistoryNewHousePhotoDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_ACTIVITY @"QSCDHistoryNewHouseActivityDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_ALLHOUSE @"QSCDHistoryNewHouseAllHouseDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_RECHOUSE @"QSCDHistoryNewHouseRecommendHousesDataModel"

@implementation QSCoreDataManager (History)

#pragma mark - 查询浏览数据
/**
 *  @author yangshengmeng, 15-03-12 14:03:09
 *
 *  @brief  根据房源类型，返回本地保存的浏览数据列表
 *
 *  @return 返回本地保存的数据列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalHistoryDataSourceWithType:(FILTER_MAIN_TYPE)type
{
    
    switch (type) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            return [self getLocalHistoryNewHouse];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            return [self getLocalHistorySecondHandHouse];
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            return [self getLocalHistoryRentHouse];
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

///返回浏览过的新房列表
+ (NSArray *)getLocalHistoryNewHouse
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    ///过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"history_id = %@",userID];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"create_time" ascending:YES];
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY andCustomPredicate:predicate andCustomSort:sort];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistoryNewHouseDataModel *obj in tempArray) {
        
        if ([obj.is_syserver intValue] == 0 ||
            [obj.is_syserver intValue] == 1) {
            
            QSNewHouseDetailDataModel *tempModel = [self histtory_ChangeModel_NewHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回浏览过的二手房列表
+ (NSArray *)getLocalHistorySecondHandHouse
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    ///过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"history_id = %@",userID];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"create_time" ascending:YES];
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY andCustomPredicate:predicate andCustomSort:sort];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistorySecondHandHouseDataModel *obj in tempArray) {
        
        if ([obj.is_syserver intValue] == 0 ||
            [obj.is_syserver intValue] == 1) {
            
            QSSecondHouseDetailDataModel *tempModel = [self histtory_ChangeModel_SecondHandHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回浏览过的出租房列表
+ (NSArray *)getLocalHistoryRentHouse
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    ///过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"history_id = %@",userID];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"create_time" ascending:YES];
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY andCustomPredicate:predicate andCustomSort:sort];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistoryRentHouseDataModel *obj in tempArray) {
        
        if ([obj.is_syserver intValue] == 0 ||
            [obj.is_syserver intValue] == 1) {
            
            QSRentHouseDetailDataModel *tempModel = [self histtory_ChangeModel_RentHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

#pragma mark - 返回本地添加未上传服务端的记录
/**
 *  @author yangshengmeng, 15-03-12 14:03:30
 *
 *  @brief  查询未上传服务端的浏览记录
 *
 *  @return 返回本地保存中，未上传服务端的浏览记录
 *
 *  @since  1.0.0
 */
+ (NSArray *)getUncommitedHistoryDataSource:(FILTER_MAIN_TYPE)type
{
    
    switch (type) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            return [self getLocalUnCommitHistoryNewHouse];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            return [self getLocalUnCommitHistorySecondHandHouse];
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            return [self getLocalUnCommitHistoryRentHouse];
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

///返回收藏中，未上传服务端的新房列表
+ (NSArray *)getLocalUnCommitHistoryNewHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistoryNewHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0) {
            
            QSNewHouseDetailDataModel *tempModel = [self histtory_ChangeModel_NewHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏中，未上传服务端的二手房列表
+ (NSArray *)getLocalUnCommitHistorySecondHandHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistorySecondHandHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0) {
            
            QSSecondHouseDetailDataModel *tempModel = [self histtory_ChangeModel_SecondHandHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏中，未上传服务端的出租房列表
+ (NSArray *)getLocalUnCommitHistoryRentHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistoryRentHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0) {
            
            QSRentHouseDetailDataModel *tempModel = [self histtory_ChangeModel_RentHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

#pragma mark - 查询本地已删除，未上传服务端的数据
/**
 *  @author     yangshengmeng, 15-03-19 23:03:11
 *
 *  @brief      根据类型，查询删除的浏览，并且未同步服务端的记录
 *
 *  @param type 类型
 *
 *  @return     返回未同步服务端删除的数据
 *
 *  @since      1.0.0
 */
+ (NSArray *)getDeleteUnCommitedHistoryDataSoucre:(FILTER_MAIN_TYPE)type
{
    
    switch (type) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            return [self getLocalUnCommitDeletedHistoryNewHouse];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            return [self getLocalUnCommitDeletedHistorySecondHandHouse];
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            return [self getLocalUnCommitDeletedHistoryRentHouse];
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

///返回本地已删除，未同步服务端的新房列表
+ (NSArray *)getLocalUnCommitDeletedHistoryNewHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistoryNewHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 3) {
            
            QSNewHouseDetailDataModel *tempModel = [self histtory_ChangeModel_NewHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回本地已删除，未同步服务端的二手房列表
+ (NSArray *)getLocalUnCommitDeletedHistorySecondHandHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistorySecondHandHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 3) {
            
            QSSecondHouseDetailDataModel *tempModel = [self histtory_ChangeModel_SecondHandHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回本地已删除，未同步服务端的出租房列表
+ (NSArray *)getLocalUnCommitDeletedHistoryRentHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDHistoryRentHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 3) {
            
            QSRentHouseDetailDataModel *tempModel = [self histtory_ChangeModel_RentHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

#pragma mark - 保存浏览记录
/**
 *  @author                 yangshengmeng, 15-03-19 11:03:24
 *
 *  @brief                  保存浏览记录
 *
 *  @param collectedModel   需要保存的数据模型：二手房详情，新房详情，出租房详情
 *  @param dataType         数据分类：小区、新房、二手房等
 *  @param callBack         保存后的回调
 *
 *
 *  @since                  1.0.0
 */
+ (void)saveHistoryDataWithModel:(id)historyModel andHistoryType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack
{

    switch (dataType) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            [self saveHistoryNewHouseWithDetailModel:historyModel andCallBack:callBack];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            [self saveHistorySecondHandHouseWithDetailModel:historyModel andCallBack:callBack];
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            [self saveHistoryRentHouseWithDetailModel:historyModel andCallBack:callBack];
            
            break;
            
        default:
            break;
    }
    
}

///添加出租房浏览记录
+ (void)saveHistoryRentHouseWithDetailModel:(QSRentHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && history_id == %@",collectedModel.house.id_,userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
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
        
        QSCDHistoryRentHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self histtory_ChangeModel_RentHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.history_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDHistoryRentHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY inManagedObjectContext:tempContext];
        [self histtory_ChangeModel_RentHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.history_id = userID;
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
    
    ///回调通知浏览记录的变化
    [self performCoredataChangeCallBack:cCoredataDataTypeAddRentHouseHistory andChangeType:dDataChangeTypeIncrease andParamsID:collectedModel.house.id_ andParams:nil];
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }

}

///添二手房浏览记录
+ (void)saveHistorySecondHandHouseWithDetailModel:(QSSecondHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && history_id == %@",collectedModel.house.id_,userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
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
        
        QSCDHistorySecondHandHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self histtory_ChangeModel_SecondHandHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.history_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDHistorySecondHandHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY inManagedObjectContext:tempContext];
        [self histtory_ChangeModel_SecondHandHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.history_id = userID;
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
    
    ///回调通知浏览记录的变化
    [self performCoredataChangeCallBack:cCoredataDataTypeAddSecondHandHouseHistory andChangeType:dDataChangeTypeIncrease andParamsID:collectedModel.house.id_ andParams:nil];
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }

}

///添加新房浏览记录
+ (void)saveHistoryNewHouseWithDetailModel:(QSNewHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && history_id == %@",collectedModel.loupan.id_,userID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
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
        
        QSCDHistoryNewHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self histtory_ChangeModel_NewHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.history_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDHistoryNewHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY inManagedObjectContext:tempContext];
        [self histtory_ChangeModel_NewHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.history_id = userID;
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

#pragma mark - 删除本地浏览记录
/**
 *  @author             yangshengmeng, 15-05-05 10:05:28
 *
 *  @brief              删除对应类型的浏览记录
 *
 *  @param houseType    房源类型
 *  @param issyServer   是否已删除服务端数据
 *
 *  @since              1.0.0
 */
+ (void)deleteAllHistoryDataWithType:(FILTER_MAIN_TYPE)houseType isSysServer:(BOOL)issyServer
{

    ///当前用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"history_id = %@",userID];
    
    switch (houseType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            if (issyServer) {
                
                [self clearEntityListWithEntityName:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY];
                return;
                
            }
        
            NSArray *newHouseArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY andCustomPredicate:predicate andCustomSort:nil];
            
            for (int i = 0; i < [newHouseArray count]; i++) {
                
                QSCDHistoryNewHouseDataModel *localModel = newHouseArray[i];
                QSNewHouseDetailDataModel *tempModel = [self histtory_ChangeModel_NewHouse_CDModel_T_DetailMode:localModel];
                tempModel.is_syserver = @"3";
                [self saveHistoryNewHouseWithDetailModel:tempModel andCallBack:^(BOOL flag) {
                    
                }];
                
            }
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            if (issyServer) {
                
                [self clearEntityListWithEntityName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY];
                return;
                
            }
            
            NSArray *secondHouseArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY andCustomPredicate:predicate andCustomSort:nil];
            
            for (int i = 0; i < [secondHouseArray count]; i++) {
                
                QSCDHistorySecondHandHouseDataModel *localModel = secondHouseArray[i];
                QSSecondHouseDetailDataModel *tempModel = [self histtory_ChangeModel_SecondHandHouse_CDModel_T_DetailMode:localModel];
                tempModel.is_syserver = @"3";
                [self saveHistorySecondHandHouseWithDetailModel:tempModel andCallBack:^(BOOL flag) {
                    
                }];
                
            }
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            if (issyServer) {
                
                [self clearEntityListWithEntityName:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY];
                return;
                
            }
            
            NSArray *rentHouseArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY andCustomPredicate:predicate andCustomSort:nil];
            
            for (int i = 0; i < [rentHouseArray count]; i++) {
                
                QSCDHistoryRentHouseDataModel *localModel = rentHouseArray[i];
                QSRentHouseDetailDataModel *tempModel = [self histtory_ChangeModel_RentHouse_CDModel_T_DetailMode:localModel];
                tempModel.house.is_syserver = @"3";
                [self saveHistoryRentHouseWithDetailModel:tempModel andCallBack:^(BOOL flag) {
                    
                }];
                
            }
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 新房数据模型转换
///将新房的详情数据模型转换为本地保存的数据模型
+ (void)histtory_ChangeModel_NewHouse_DetailMode_T_CDModel:(QSNewHouseDetailDataModel *)collectedModel andCDModel:(QSCDHistoryNewHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{
    
    ///楼盘本身信息
    cdCollectedModel.id_ = collectedModel.loupan.id_;
    cdCollectedModel.user_id = collectedModel.loupan.user_id;
    cdCollectedModel.introduce = collectedModel.loupan.introduce;
    cdCollectedModel.title = collectedModel.loupan.title;
    cdCollectedModel.title_second = collectedModel.loupan.title_second;
    cdCollectedModel.address = collectedModel.loupan.address;
    cdCollectedModel.floor_num = collectedModel.loupan.floor_num;
    cdCollectedModel.property_type = collectedModel.loupan.property_type;
    cdCollectedModel.used_year = collectedModel.loupan.used_year;
    cdCollectedModel.installation = collectedModel.loupan.installation;
    cdCollectedModel.features = collectedModel.loupan.features;
    cdCollectedModel.view_count = collectedModel.loupan.view_count;
    cdCollectedModel.provinceid = collectedModel.loupan.provinceid;
    cdCollectedModel.cityid = collectedModel.loupan.cityid;
    cdCollectedModel.areaid = collectedModel.loupan.areaid;
    cdCollectedModel.street = collectedModel.loupan.street;
    cdCollectedModel.commend = collectedModel.loupan.commend;
    cdCollectedModel.attach_file = collectedModel.loupan.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.loupan.attach_thumb;
    cdCollectedModel.favorite_count = collectedModel.loupan.favorite_count;
    cdCollectedModel.attention_count = collectedModel.loupan.attention_count;
    cdCollectedModel.status = collectedModel.loupan.status;
    cdCollectedModel.house_no = collectedModel.loupan.house_no;
    cdCollectedModel.building_structure = collectedModel.loupan.building_structure;
    cdCollectedModel.decoration_type = collectedModel.loupan.decoration_type;
    cdCollectedModel.heating = collectedModel.loupan.heating;
    cdCollectedModel.company_property = collectedModel.loupan.company_property;
    cdCollectedModel.fee = collectedModel.loupan.fee;
    cdCollectedModel.water = collectedModel.loupan.water;
    cdCollectedModel.open_time = collectedModel.loupan.open_time;
    cdCollectedModel.area_covered = collectedModel.loupan.area_covered;
    cdCollectedModel.areabuilt = collectedModel.loupan.areabuilt;
    cdCollectedModel.volume_rate = collectedModel.loupan.volume_rate;
    cdCollectedModel.green_rate = collectedModel.loupan.green_rate;
    cdCollectedModel.licence = collectedModel.loupan.licence;
    cdCollectedModel.parking_lot = collectedModel.loupan.parking_lot;
    cdCollectedModel.loupan_status = collectedModel.loupan.loupan_status;
    
    ///业主信息
    cdCollectedModel.user_type = collectedModel.user.user_type;
    cdCollectedModel.nickname = collectedModel.user.nickname;
    cdCollectedModel.username = collectedModel.user.username;
    cdCollectedModel.avatar = collectedModel.user.avatar;
    cdCollectedModel.email = collectedModel.user.email;
    cdCollectedModel.mobile = collectedModel.user.mobile;
    cdCollectedModel.realname = collectedModel.user.realname;
    cdCollectedModel.tj_rentHouse_num = collectedModel.user.tj_rentHouse_num;
    cdCollectedModel.tj_secondHouse_num = collectedModel.user.tj_secondHouse_num;
    cdCollectedModel.web = collectedModel.user.web;
    cdCollectedModel.qq = collectedModel.user.qq;
    cdCollectedModel.sex = collectedModel.user.sex;
    cdCollectedModel.vocation = collectedModel.user.vocation;
    cdCollectedModel.age = collectedModel.user.age;
    cdCollectedModel.idcard = collectedModel.user.idcard;
    cdCollectedModel.tel = collectedModel.user.tel;
    cdCollectedModel.developer_intro = collectedModel.user.developer_intro;
    cdCollectedModel.developer_name = collectedModel.user.developer_name;
    
    ///具体某一期的信息
    cdCollectedModel.phase_id = collectedModel.loupan_building.id_;
    cdCollectedModel.phase_user_id= collectedModel.loupan_building.user_id;
    cdCollectedModel.phase_introduce = collectedModel.loupan_building.introduce;
    cdCollectedModel.phase_title = collectedModel.loupan_building.title;
    cdCollectedModel.phase_title_second = collectedModel.loupan_building.title_second;
    cdCollectedModel.phase_address = collectedModel.loupan_building.address;
    cdCollectedModel.phase_floor_num = collectedModel.loupan_building.floor_num;
    cdCollectedModel.phase_property_type = collectedModel.loupan_building.property_type;
    cdCollectedModel.phase_used_year = collectedModel.loupan_building.used_year;
    cdCollectedModel.phase_installation = collectedModel.loupan_building.installation;
    cdCollectedModel.phase_features = collectedModel.loupan_building.features;
    cdCollectedModel.phase_view_count = collectedModel.loupan_building.view_count;
    cdCollectedModel.phase_provinceid = collectedModel.loupan_building.provinceid;
    cdCollectedModel.phase_cityid = collectedModel.loupan_building.cityid;
    cdCollectedModel.phase_areaid = collectedModel.loupan_building.areaid;
    cdCollectedModel.phase_street = collectedModel.loupan_building.street;
    cdCollectedModel.phase_commend = collectedModel.loupan_building.commend;
    cdCollectedModel.phase_attach_file = collectedModel.loupan_building.attach_file;
    cdCollectedModel.phase_attach_thumb = collectedModel.loupan_building.attach_thumb;
    cdCollectedModel.phase_favorite_count = collectedModel.loupan_building.favorite_count;
    cdCollectedModel.phase_attention_count = collectedModel.loupan_building.attention_count;
    cdCollectedModel.phase_status = collectedModel.loupan_building.status;
    cdCollectedModel.phase_house_no = collectedModel.loupan_building.house_no;
    cdCollectedModel.phase_loupan_id = collectedModel.loupan_building.loupan_id;
    cdCollectedModel.phase_loupan_periods = collectedModel.loupan_building.loupan_periods;
    cdCollectedModel.phase_building_no = collectedModel.loupan_building.building_no;
    cdCollectedModel.phase_open_time = collectedModel.loupan_building.open_time;
    cdCollectedModel.phase_checkin_time = collectedModel.loupan_building.checkin_time;
    cdCollectedModel.phase_households_num = collectedModel.loupan_building.households_num;
    cdCollectedModel.phase_ladder = collectedModel.loupan_building.ladder;
    cdCollectedModel.phase_ladder_family = collectedModel.loupan_building.ladder_family;
    cdCollectedModel.phase_tel = collectedModel.loupan_building.tel;
    cdCollectedModel.phase_price_avg = collectedModel.loupan_building.price_avg;
    cdCollectedModel.phase_min_house_area = collectedModel.loupan_building.min_house_area;
    cdCollectedModel.phase_max_house_area = collectedModel.loupan_building.max_house_area;
    cdCollectedModel.phase_tj_condition = collectedModel.loupan_building.tj_condition;
    cdCollectedModel.phase_tj_environment = collectedModel.loupan_building.tj_environment;
    
    ///贷款信息
    cdCollectedModel.loan_base_rate = collectedModel.loan.base_rate;
    cdCollectedModel.loan_first_rate = collectedModel.loan.first_rate;
    cdCollectedModel.loan_procedures_fee = collectedModel.loan.procedures_fee;
    cdCollectedModel.loan_loan_year = collectedModel.loan.loan_year;
    
    ///时间出戳
    cdCollectedModel.create_time = [NSDate date];
    
    ///图片信息
    if ([collectedModel.loupanBuilding_photo count] > 0) {
        
        ///清空原信息
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
        for (QSPhotoDataModel *photoModel in collectedModel.loupanBuilding_photo) {
            
            ///转换模型
            QSCDHistoryNewHousePhotoDataModel *cdPhotoModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_PHOTO inManagedObjectContext:tempContext];
            
            cdPhotoModel.id_ = photoModel.id_;
            cdPhotoModel.type = photoModel.type;
            cdPhotoModel.title = photoModel.title;
            cdPhotoModel.mark = photoModel.mark;
            cdPhotoModel.attach_file = photoModel.attach_file;
            cdPhotoModel.attach_thumb = photoModel.attach_thumb;
            cdPhotoModel.house_info = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addPhotosObject:cdPhotoModel];
            
        }
        
    }
    
    ///推荐户型信息
    if ([collectedModel.loupanHouse_commend count] > 0) {
        
        ///清空原信息
        [cdCollectedModel removeRecommend_houses:cdCollectedModel.recommend_houses];
        
        for (QSHouseTypeDataModel *houseTypeModel in collectedModel.loupanHouse_commend) {
            
            ///转换模型
            QSCDHistoryNewHouseRecommendHousesDataModel *cdHouseTypeModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_RECHOUSE inManagedObjectContext:tempContext];
            
            cdHouseTypeModel.room_features = houseTypeModel.room_features;
            cdHouseTypeModel.attach_file = houseTypeModel.attach_file;
            cdHouseTypeModel.attach_thumb = houseTypeModel.attach_thumb;
            cdHouseTypeModel.building_no = houseTypeModel.building_no;
            cdHouseTypeModel.content = houseTypeModel.content;
            cdHouseTypeModel.house_area = houseTypeModel.house_area;
            cdHouseTypeModel.house_chufang = houseTypeModel.house_chufang;
            cdHouseTypeModel.house_shi = houseTypeModel.house_shi;
            cdHouseTypeModel.house_ting = houseTypeModel.house_ting;
            cdHouseTypeModel.house_wei = houseTypeModel.house_wei;
            cdHouseTypeModel.house_yangtai = houseTypeModel.house_yangtai;
            cdHouseTypeModel.id_ = houseTypeModel.id_;
            cdHouseTypeModel.introduce = houseTypeModel.introduce;
            cdHouseTypeModel.loupan_building_id = houseTypeModel.loupan_building_id;
            cdHouseTypeModel.loupan_id = houseTypeModel.loupan_id;
            cdHouseTypeModel.loupan_periods = houseTypeModel.loupan_periods;
            cdHouseTypeModel.title = houseTypeModel.title;
            cdHouseTypeModel.title_second = houseTypeModel.title_second;
            cdHouseTypeModel.user_id = houseTypeModel.user_id;
            cdHouseTypeModel.view_count = houseTypeModel.view_count;
            cdHouseTypeModel.house_info = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addRecommend_housesObject:cdHouseTypeModel];
            
        }
        
    }
    
    ///所有户型信息
    if ([collectedModel.loupanHouse count] > 0) {
        
        ///清空原信息
        [cdCollectedModel removeAll_houses:cdCollectedModel.all_houses];
        
        for (QSHouseTypeDataModel *houseTypeModel in collectedModel.loupanHouse) {
            
            ///转换模型
            QSCDHistoryNewHouseAllHouseDataModel *cdHouseTypeModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_ALLHOUSE inManagedObjectContext:tempContext];
            
            cdHouseTypeModel.room_features = houseTypeModel.room_features;
            cdHouseTypeModel.attach_file = houseTypeModel.attach_file;
            cdHouseTypeModel.attach_thumb = houseTypeModel.attach_thumb;
            cdHouseTypeModel.building_no = houseTypeModel.building_no;
            cdHouseTypeModel.content = houseTypeModel.content;
            cdHouseTypeModel.house_area = houseTypeModel.house_area;
            cdHouseTypeModel.house_chufang = houseTypeModel.house_chufang;
            cdHouseTypeModel.house_shi = houseTypeModel.house_shi;
            cdHouseTypeModel.house_ting = houseTypeModel.house_ting;
            cdHouseTypeModel.house_wei = houseTypeModel.house_wei;
            cdHouseTypeModel.house_yangtai = houseTypeModel.house_yangtai;
            cdHouseTypeModel.id_ = houseTypeModel.id_;
            cdHouseTypeModel.introduce = houseTypeModel.introduce;
            cdHouseTypeModel.loupan_building_id = houseTypeModel.loupan_building_id;
            cdHouseTypeModel.loupan_id = houseTypeModel.loupan_id;
            cdHouseTypeModel.loupan_periods = houseTypeModel.loupan_periods;
            cdHouseTypeModel.title = houseTypeModel.title;
            cdHouseTypeModel.title_second = houseTypeModel.title_second;
            cdHouseTypeModel.user_id = houseTypeModel.user_id;
            cdHouseTypeModel.view_count = houseTypeModel.view_count;
            cdHouseTypeModel.house_info = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addAll_housesObject:cdHouseTypeModel];
            
        }
        
    }
    
    ///活动信息
    if ([collectedModel.loupan_activity count] > 0) {
        
        ///清空原信息
        [cdCollectedModel removeActivities:cdCollectedModel.activities];
        
        for (QSActivityDataModel *activityModel in collectedModel.loupan_activity) {
            
            ///转换模型
            QSCDHistoryNewHouseActivityDataModel *cdActivityModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_HISTORY_ACTIVITY inManagedObjectContext:tempContext];
            
            cdActivityModel.id_ = activityModel.id_;
            cdActivityModel.people_num = activityModel.people_num;
            cdActivityModel.user_id = activityModel.user_id;
            cdActivityModel.loupan_id = activityModel.loupan_id;
            cdActivityModel.loupan_building_id = activityModel.loupan_building_id;
            cdActivityModel.loupan_periods = activityModel.loupan_periods;
            cdActivityModel.title = activityModel.title;
            cdActivityModel.content = activityModel.content;
            cdActivityModel.start_time = activityModel.start_time;
            cdActivityModel.end_time = activityModel.end_time;
            cdActivityModel.view_count = activityModel.view_count;
            cdActivityModel.attach_file = activityModel.attach_file;
            cdActivityModel.attach_thumb = activityModel.attach_thumb;
            cdActivityModel.house_info = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addActivitiesObject:cdActivityModel];
            
        }
        
    }
    
}

+ (QSNewHouseDetailDataModel *)histtory_ChangeModel_NewHouse_CDModel_T_DetailMode:(QSCDHistoryNewHouseDataModel *)cdCollectedModel
{

    QSNewHouseDetailDataModel *collectedModel = [[QSNewHouseDetailDataModel alloc] init];
    collectedModel.loupan = [[QSLoupanInfoDataModel alloc] init];
    collectedModel.user = [[QSUserBaseInfoDataModel alloc] init];
    collectedModel.loupan_building = [[QSLoupanPhaseDataModel alloc] init];
    collectedModel.loan = [[QSRateDataModel alloc] init];
    
    ///楼盘本身信息
    collectedModel.loupan.id_ = cdCollectedModel.id_;
    collectedModel.loupan.user_id = cdCollectedModel.user_id;
    collectedModel.loupan.introduce = cdCollectedModel.introduce;
    collectedModel.loupan.title = cdCollectedModel.title;
    collectedModel.loupan.title_second = cdCollectedModel.title_second;
    collectedModel.loupan.address = cdCollectedModel.address;
    collectedModel.loupan.floor_num = cdCollectedModel.floor_num;
    collectedModel.loupan.property_type = cdCollectedModel.property_type;
    collectedModel.loupan.used_year = cdCollectedModel.used_year;
    collectedModel.loupan.installation = cdCollectedModel.installation;
    collectedModel.loupan.features = cdCollectedModel.features;
    collectedModel.loupan.view_count = cdCollectedModel.view_count;
    collectedModel.loupan.provinceid = cdCollectedModel.provinceid;
    collectedModel.loupan.cityid = cdCollectedModel.cityid;
    collectedModel.loupan.areaid = cdCollectedModel.areaid;
    collectedModel.loupan.street = cdCollectedModel.street;
    collectedModel.loupan.commend = cdCollectedModel.commend;
    collectedModel.loupan.attach_file = cdCollectedModel.attach_file;
    collectedModel.loupan.attach_thumb = cdCollectedModel.attach_thumb;
    collectedModel.loupan.favorite_count = cdCollectedModel.favorite_count;
    collectedModel.loupan.attention_count = cdCollectedModel.attention_count;
    collectedModel.loupan.status = cdCollectedModel.status;
    collectedModel.loupan.house_no = cdCollectedModel.house_no;
    collectedModel.loupan.building_structure = cdCollectedModel.building_structure;
    collectedModel.loupan.decoration_type = cdCollectedModel.decoration_type;
    collectedModel.loupan.heating = cdCollectedModel.heating;
    collectedModel.loupan.company_property = cdCollectedModel.company_property;
    collectedModel.loupan.fee = cdCollectedModel.fee;
    collectedModel.loupan.water = cdCollectedModel.water;
    collectedModel.loupan.open_time = cdCollectedModel.open_time;
    collectedModel.loupan.area_covered = cdCollectedModel.area_covered;
    collectedModel.loupan.areabuilt = cdCollectedModel.areabuilt;
    collectedModel.loupan.volume_rate = cdCollectedModel.volume_rate;
    collectedModel.loupan.green_rate = cdCollectedModel.green_rate;
    collectedModel.loupan.licence = cdCollectedModel.licence;
    collectedModel.loupan.parking_lot = cdCollectedModel.parking_lot;
    collectedModel.loupan.loupan_status = cdCollectedModel.loupan_status;
    
    ///业主信息
    collectedModel.user.id_ = cdCollectedModel.user_id;
    collectedModel.user.user_type = cdCollectedModel.user_type;
    collectedModel.user.nickname = cdCollectedModel.nickname;
    collectedModel.user.username = cdCollectedModel.username;
    collectedModel.user.avatar = cdCollectedModel.avatar;
    collectedModel.user.email = cdCollectedModel.email;
    collectedModel.user.mobile = cdCollectedModel.mobile;
    collectedModel.user.realname = cdCollectedModel.realname;
    collectedModel.user.tj_rentHouse_num = cdCollectedModel.tj_rentHouse_num;
    collectedModel.user.tj_secondHouse_num = cdCollectedModel.tj_secondHouse_num;
    collectedModel.user.web = cdCollectedModel.web;
    collectedModel.user.qq = cdCollectedModel.qq;
    collectedModel.user.sex = cdCollectedModel.sex;
    collectedModel.user.vocation = cdCollectedModel.vocation;
    collectedModel.user.age = cdCollectedModel.age;
    collectedModel.user.idcard = cdCollectedModel.idcard;
    collectedModel.user.tel = cdCollectedModel.tel;
    collectedModel.user.developer_intro = cdCollectedModel.developer_intro;
    collectedModel.user.developer_name = cdCollectedModel.developer_name;
    
    ///具体某一期的信息
    collectedModel.loupan_building.id_ = cdCollectedModel.phase_id;
    collectedModel.loupan_building.user_id = cdCollectedModel.phase_user_id;
    collectedModel.loupan_building.introduce = cdCollectedModel.phase_introduce;
    collectedModel.loupan_building.title = cdCollectedModel.phase_title;
    collectedModel.loupan_building.title_second = cdCollectedModel.phase_title_second;
    collectedModel.loupan_building.address = cdCollectedModel.phase_address;
    collectedModel.loupan_building.floor_num = cdCollectedModel.phase_floor_num;
    collectedModel.loupan_building.property_type = cdCollectedModel.phase_property_type;
    collectedModel.loupan_building.used_year = cdCollectedModel.phase_used_year;
    collectedModel.loupan_building.installation = cdCollectedModel.phase_installation;
    collectedModel.loupan_building.features = cdCollectedModel.phase_features;
    collectedModel.loupan_building.view_count = cdCollectedModel.phase_view_count;
    collectedModel.loupan_building.provinceid = cdCollectedModel.phase_provinceid;
    collectedModel.loupan_building.cityid = cdCollectedModel.phase_cityid;
    collectedModel.loupan_building.areaid = cdCollectedModel.phase_areaid;
    collectedModel.loupan_building.street = cdCollectedModel.phase_street;
    collectedModel.loupan_building.commend = cdCollectedModel.phase_commend;
    collectedModel.loupan_building.attach_file = cdCollectedModel.phase_attach_file;
    collectedModel.loupan_building.attach_thumb = cdCollectedModel.phase_attach_thumb;
    collectedModel.loupan_building.favorite_count = cdCollectedModel.phase_favorite_count;
    collectedModel.loupan_building.attention_count = cdCollectedModel.phase_attention_count;
    collectedModel.loupan_building.status = cdCollectedModel.phase_status;
    collectedModel.loupan_building.house_no = cdCollectedModel.phase_house_no;
    collectedModel.loupan_building.loupan_id = cdCollectedModel.phase_loupan_id;
    collectedModel.loupan_building.loupan_periods = cdCollectedModel.phase_loupan_periods;
    collectedModel.loupan_building.building_no = cdCollectedModel.phase_house_no;
    collectedModel.loupan_building.open_time = cdCollectedModel.phase_open_time;
    collectedModel.loupan_building.checkin_time = cdCollectedModel.phase_checkin_time;
    collectedModel.loupan_building.households_num = cdCollectedModel.phase_households_num;
    collectedModel.loupan_building.ladder = cdCollectedModel.phase_ladder;
    collectedModel.loupan_building.ladder_family = cdCollectedModel.phase_ladder_family;
    collectedModel.loupan_building.tel = cdCollectedModel.phase_tel;
    collectedModel.loupan_building.price_avg = cdCollectedModel.phase_price_avg;
    collectedModel.loupan_building.min_house_area = cdCollectedModel.phase_min_house_area;
    collectedModel.loupan_building.max_house_area = cdCollectedModel.phase_max_house_area;
    collectedModel.loupan_building.tj_condition = cdCollectedModel.phase_tj_condition;
    collectedModel.loupan_building.tj_environment = cdCollectedModel.phase_tj_environment;
    
    ///贷款信息
    collectedModel.loan.base_rate = cdCollectedModel.loan_base_rate;
    collectedModel.loan.first_rate = cdCollectedModel.loan_first_rate;
    collectedModel.loan.procedures_fee = cdCollectedModel.loan_procedures_fee;
    collectedModel.loan.loan_year = cdCollectedModel.loan_loan_year;
    
    ///图片信息
    if ([cdCollectedModel.photos count] > 0) {
        
        ///临时数组
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (QSCDHistoryNewHousePhotoDataModel *cdPhotoModel in cdCollectedModel.photos) {
            
            ///转换模型
            QSPhotoDataModel *photoModel = [[QSPhotoDataModel alloc] init];
            
            photoModel.id_ = cdPhotoModel.id_;
            photoModel.type = cdPhotoModel.type;
            photoModel.title = cdPhotoModel.title;
            photoModel.mark = cdPhotoModel.mark;
            photoModel.attach_file = cdPhotoModel.attach_file;
            photoModel.attach_thumb = cdPhotoModel.attach_thumb;
            
            ///加载图片集
            [tempArray addObject:photoModel];
            
        }
        
        collectedModel.loupanBuilding_photo = [NSArray arrayWithArray:tempArray];
        
    }
    
    ///推荐户型信息
    if ([cdCollectedModel.recommend_houses count] > 0) {
        
        ///临时数组
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (QSCDHistoryNewHouseRecommendHousesDataModel *cdHouseTypeModel in cdCollectedModel.recommend_houses) {
            
            ///转换模型
            QSHouseTypeDataModel *houseTypeModel = [[QSHouseTypeDataModel alloc] init];
            
            houseTypeModel.room_features = cdHouseTypeModel.room_features;
            houseTypeModel.attach_file = cdHouseTypeModel.attach_file;
            houseTypeModel.attach_thumb = cdHouseTypeModel.attach_thumb;
            houseTypeModel.building_no = cdHouseTypeModel.building_no;
            houseTypeModel.content = cdHouseTypeModel.content;
            houseTypeModel.house_area = cdHouseTypeModel.house_area;
            houseTypeModel.house_chufang = cdHouseTypeModel.house_chufang;
            houseTypeModel.house_shi = cdHouseTypeModel.house_shi;
            houseTypeModel.house_ting = cdHouseTypeModel.house_ting;
            houseTypeModel.house_wei = cdHouseTypeModel.house_wei;
            houseTypeModel.house_yangtai = cdHouseTypeModel.house_yangtai;
            houseTypeModel.id_ = cdHouseTypeModel.id_;
            houseTypeModel.introduce = cdHouseTypeModel.introduce;
            houseTypeModel.loupan_building_id = cdHouseTypeModel.loupan_building_id;
            houseTypeModel.loupan_id = cdHouseTypeModel.loupan_id;
            houseTypeModel.loupan_periods = cdHouseTypeModel.loupan_periods;
            houseTypeModel.title = cdHouseTypeModel.title;
            houseTypeModel.title_second = cdHouseTypeModel.title_second;
            houseTypeModel.user_id = cdHouseTypeModel.user_id;
            houseTypeModel.view_count = cdHouseTypeModel.view_count;
            
            ///加载图片集
            [tempArray addObject:houseTypeModel];
            
        }
        
        collectedModel.loupanHouse_commend = [NSArray arrayWithArray:tempArray];
        
    }
    
    ///所有户型信息
    if ([cdCollectedModel.all_houses count] > 0) {
        
        ///清空原信息
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (QSCDHistoryNewHouseAllHouseDataModel *cdHouseTypeModel in cdCollectedModel.all_houses) {
            
            ///转换模型
            QSHouseTypeDataModel *houseTypeModel = [[QSHouseTypeDataModel alloc] init];
            
            houseTypeModel.room_features = cdHouseTypeModel.room_features;
            houseTypeModel.attach_file = cdHouseTypeModel.attach_file;
            houseTypeModel.attach_thumb = cdHouseTypeModel.attach_thumb;
            houseTypeModel.building_no = cdHouseTypeModel.building_no;
            houseTypeModel.content = cdHouseTypeModel.content;
            houseTypeModel.house_area = cdHouseTypeModel.house_area;
            houseTypeModel.house_chufang = cdHouseTypeModel.house_chufang;
            houseTypeModel.house_shi = cdHouseTypeModel.house_shi;
            houseTypeModel.house_ting = cdHouseTypeModel.house_ting;
            houseTypeModel.house_wei = cdHouseTypeModel.house_wei;
            houseTypeModel.house_yangtai = cdHouseTypeModel.house_yangtai;
            houseTypeModel.id_ = cdHouseTypeModel.id_;
            houseTypeModel.introduce = cdHouseTypeModel.introduce;
            houseTypeModel.loupan_building_id = cdHouseTypeModel.loupan_building_id;
            houseTypeModel.loupan_id = cdHouseTypeModel.loupan_id;
            houseTypeModel.loupan_periods = cdHouseTypeModel.loupan_periods;
            houseTypeModel.title = cdHouseTypeModel.title;
            houseTypeModel.title_second = cdHouseTypeModel.title_second;
            houseTypeModel.user_id = cdHouseTypeModel.user_id;
            houseTypeModel.view_count = cdHouseTypeModel.view_count;
            
            ///加载图片集
            [tempArray addObject:houseTypeModel];
            
        }
        
        collectedModel.loupanHouse = [NSArray arrayWithArray:tempArray];
        
    }
    
    ///活动信息
    if ([cdCollectedModel.activities count] > 0) {
        
        ///清空原信息
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (QSCDHistoryNewHouseActivityDataModel *cdActivityModel in cdCollectedModel.activities) {
            
            ///转换模型
            QSActivityDataModel *activityModel = [[QSActivityDataModel alloc] init];
            
            activityModel.id_ = cdActivityModel.id_;
            activityModel.people_num = cdActivityModel.people_num;
            activityModel.user_id = cdActivityModel.user_id;
            activityModel.loupan_id = cdActivityModel.loupan_id;
            activityModel.loupan_building_id = cdActivityModel.loupan_building_id;
            activityModel.loupan_periods = cdActivityModel.loupan_periods;
            activityModel.title = cdActivityModel.title;
            activityModel.content = cdActivityModel.content;
            activityModel.start_time = cdActivityModel.start_time;
            activityModel.end_time = cdActivityModel.end_time;
            activityModel.view_count = cdActivityModel.view_count;
            activityModel.attach_file = cdActivityModel.attach_file;
            activityModel.attach_thumb = cdActivityModel.attach_thumb;
            
            ///加载图片集
            [tempArray addObject:activityModel];
            
        }
        
        collectedModel.loupan_activity = [NSArray arrayWithArray:tempArray];
        
    }
    
    return collectedModel;

}

#pragma mark - 二手房相关数据模型转换
+ (void)histtory_ChangeModel_SecondHandHouse_DetailMode_T_CDModel:(QSSecondHouseDetailDataModel *)collectedModel andCDModel:(QSCDHistorySecondHandHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{
    
    ///二手房信息
    cdCollectedModel.id_ = collectedModel.house.id_;
    cdCollectedModel.user_id = collectedModel.house.user_id;
    cdCollectedModel.introduce = collectedModel.house.introduce;
    cdCollectedModel.title = collectedModel.house.title;
    cdCollectedModel.title_second = collectedModel.house.title_second;
    cdCollectedModel.address = collectedModel.house.address;
    cdCollectedModel.floor_num = collectedModel.house.floor_num;
    cdCollectedModel.property_type = collectedModel.house.property_type;
    cdCollectedModel.used_year = collectedModel.house.used_year;
    cdCollectedModel.installation = collectedModel.house.installation;
    cdCollectedModel.features = collectedModel.house.features;
    cdCollectedModel.view_count = collectedModel.house.view_count;
    cdCollectedModel.provinceid = collectedModel.house.provinceid;
    cdCollectedModel.cityid = collectedModel.house.cityid;
    cdCollectedModel.areaid = collectedModel.house.areaid;
    cdCollectedModel.street = collectedModel.house.street;
    cdCollectedModel.commend = collectedModel.house.commend;
    cdCollectedModel.attach_file = collectedModel.house.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.house.attach_thumb;
    cdCollectedModel.favorite_count = collectedModel.house.favorite_count;
    cdCollectedModel.attention_count = collectedModel.house.attention_count;
    cdCollectedModel.status = collectedModel.house.status;
    cdCollectedModel.name = collectedModel.house.name;
    cdCollectedModel.tel = collectedModel.house.tel;
    cdCollectedModel.content = collectedModel.house.content;
    cdCollectedModel.village_id = collectedModel.house.village_id;
    cdCollectedModel.village_name = collectedModel.house.village_name;
    cdCollectedModel.building_structure = collectedModel.house.building_structure;
    cdCollectedModel.floor_which = collectedModel.house.floor_which;
    cdCollectedModel.house_face = collectedModel.house.house_face;
    cdCollectedModel.decoration_type = collectedModel.house.decoration_type;
    cdCollectedModel.house_area = collectedModel.house.house_area;
    cdCollectedModel.house_shi = collectedModel.house.house_shi;
    cdCollectedModel.house_ting = collectedModel.house.house_ting;
    cdCollectedModel.house_wei = collectedModel.house.house_wei;
    cdCollectedModel.house_chufang = collectedModel.house.house_chufang;
    cdCollectedModel.house_yangtai = collectedModel.house.house_yangtai;
    cdCollectedModel.cycle = collectedModel.house.cycle;
    cdCollectedModel.time_interval_start = collectedModel.house.time_interval_start;
    cdCollectedModel.time_interval_end = collectedModel.house.time_interval_end;
    cdCollectedModel.entrust = collectedModel.house.entrust;
    cdCollectedModel.entrust_company = collectedModel.house.entrust_company;
    cdCollectedModel.video_url = collectedModel.house.video_url;
    cdCollectedModel.negotiated = collectedModel.house.negotiated;
    cdCollectedModel.reservation_num = collectedModel.house.reservation_num;
    cdCollectedModel.house_no = collectedModel.house.house_no;
    cdCollectedModel.building_year = collectedModel.house.building_year;
    cdCollectedModel.house_price = collectedModel.house.house_price;
    cdCollectedModel.house_nature = collectedModel.house.house_nature;
    cdCollectedModel.elevator = collectedModel.house.elevator;
    cdCollectedModel.price_avg = collectedModel.house.price_avg;
    cdCollectedModel.coordinate_x = collectedModel.house.coordinate_x;
    cdCollectedModel.coordinate_y = collectedModel.house.coordinate_y;
    cdCollectedModel.tj_look_house_num = collectedModel.house.tj_look_house_num;
    cdCollectedModel.tj_wait_look_house_people = collectedModel.house.tj_wait_look_house_people;
    
    ///业主信息
    cdCollectedModel.user_type = collectedModel.user.user_type;
    cdCollectedModel.nickname = collectedModel.user.nickname;
    cdCollectedModel.username = collectedModel.user.username;
    cdCollectedModel.avatar = collectedModel.user.avatar;
    cdCollectedModel.email = collectedModel.user.email;
    cdCollectedModel.mobile = collectedModel.user.mobile;
    cdCollectedModel.realname = collectedModel.user.realname;
    cdCollectedModel.tj_rentHouse_num = collectedModel.user.tj_rentHouse_num;
    cdCollectedModel.tj_secondHouse_num = collectedModel.user.tj_secondHouse_num;
    
    ///价格变动信息
    cdCollectedModel.price_change_id_ = collectedModel.price_changes.id_;
    cdCollectedModel.price_change_type = collectedModel.price_changes.type;
    cdCollectedModel.price_change_obj_id = collectedModel.price_changes.obj_id;
    cdCollectedModel.price_change_title = collectedModel.price_changes.title;
    cdCollectedModel.price_change_before_price = collectedModel.price_changes.before_price;
    cdCollectedModel.price_change_revised_price = collectedModel.price_changes.revised_price;
    cdCollectedModel.price_change_update_time = collectedModel.price_changes.update_time;
    cdCollectedModel.price_change_create_time = collectedModel.price_changes.create_time;
    cdCollectedModel.price_changes_num = collectedModel.price_changes.price_changes_num;
    
    ///评论信息
    QSCommentListDataModel *tempCommentModel = collectedModel.comment.commentList[0];
    cdCollectedModel.comment_id_ = tempCommentModel.id_;
    cdCollectedModel.comment_user_id = tempCommentModel.evaluater_id;
    cdCollectedModel.comment_type = tempCommentModel.evaluater_type;
    cdCollectedModel.comment_content = tempCommentModel.desc;
    
    ///时间出戳
    cdCollectedModel.create_time = [NSDate date];
    
    ///图片
    if ([collectedModel.secondHouse_photo count] > 0) {
        
        ///清空原图片
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
        ///遍历添加
        for (QSPhotoDataModel *photoModel in collectedModel.secondHouse_photo) {
            
            QSCDHistorySecondHandHousePhotoDataModel *cdPhotoModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_HISTORY_PHOTO inManagedObjectContext:tempContext];
            
            cdPhotoModel.id_ = photoModel.id_;
            cdPhotoModel.type = photoModel.type;
            cdPhotoModel.title = photoModel.title;
            cdPhotoModel.mark = photoModel.mark;
            cdPhotoModel.attach_file = photoModel.attach_file;
            cdPhotoModel.attach_thumb = photoModel.attach_thumb;
            cdPhotoModel.second_hand_house = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addPhotosObject:cdPhotoModel];
            
        }
        
    } else {
        
        ///清空原图片
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
    }
    
}

+ (QSSecondHouseDetailDataModel *)histtory_ChangeModel_SecondHandHouse_CDModel_T_DetailMode:(QSCDHistorySecondHandHouseDataModel *)cdCollectedModel
{

    QSSecondHouseDetailDataModel *collectedModel = [[QSSecondHouseDetailDataModel alloc] init];
    collectedModel.house = [[QSWSecondHouseInfoDataModel alloc] init];
    collectedModel.user = [[QSUserSimpleDataModel alloc] init];
    collectedModel.price_changes = [[QSHousePriceChangesDataModel alloc] init];
    collectedModel.comment = [[QSDetailCommentListReturnData alloc] init];
    
    ///二手房信息
    collectedModel.house.id_ = cdCollectedModel.id_;
    collectedModel.house.user_id = cdCollectedModel.user_id;
    collectedModel.house.introduce = cdCollectedModel.introduce;
    collectedModel.house.title = cdCollectedModel.title;
    collectedModel.house.title_second = cdCollectedModel.title_second;
    collectedModel.house.address = cdCollectedModel.address;
    collectedModel.house.floor_num = cdCollectedModel.floor_num;
    collectedModel.house.property_type = cdCollectedModel.property_type;
    collectedModel.house.used_year = cdCollectedModel.used_year;
    collectedModel.house.installation = cdCollectedModel.installation;
    collectedModel.house.features = cdCollectedModel.features;
    collectedModel.house.view_count = cdCollectedModel.view_count;
    collectedModel.house.provinceid = cdCollectedModel.provinceid;
    collectedModel.house.cityid = cdCollectedModel.cityid;
    collectedModel.house.areaid = cdCollectedModel.areaid;
    collectedModel.house.street = cdCollectedModel.street;
    collectedModel.house.commend = cdCollectedModel.commend;
    collectedModel.house.attach_file = cdCollectedModel.attach_file;
    collectedModel.house.attach_thumb = cdCollectedModel.attach_thumb;
    collectedModel.house.favorite_count = cdCollectedModel.favorite_count;
    collectedModel.house.attention_count = cdCollectedModel.attention_count;
    collectedModel.house.status = cdCollectedModel.status;
    collectedModel.house.name = cdCollectedModel.name;
    collectedModel.house.tel = cdCollectedModel.tel;
    collectedModel.house.content = cdCollectedModel.content;
    collectedModel.house.village_id = cdCollectedModel.village_id;
    collectedModel.house.village_name = cdCollectedModel.village_name;
    collectedModel.house.building_structure = cdCollectedModel.building_structure;
    collectedModel.house.floor_which = cdCollectedModel.floor_which;
    collectedModel.house.house_face = cdCollectedModel.house_face;
    collectedModel.house.decoration_type = cdCollectedModel.decoration_type;
    collectedModel.house.house_area = cdCollectedModel.house_area;
    collectedModel.house.house_shi = cdCollectedModel.house_shi;
    collectedModel.house.house_ting = cdCollectedModel.house_ting;
    collectedModel.house.house_wei = cdCollectedModel.house_wei;
    collectedModel.house.house_chufang = cdCollectedModel.house_chufang;
    collectedModel.house.house_yangtai = cdCollectedModel.house_yangtai;
    collectedModel.house.cycle = cdCollectedModel.cycle;
    collectedModel.house.time_interval_start = cdCollectedModel.time_interval_start;
    collectedModel.house.time_interval_end = cdCollectedModel.time_interval_end;
    collectedModel.house.entrust = cdCollectedModel.entrust;
    collectedModel.house.entrust_company = cdCollectedModel.entrust_company;
    collectedModel.house.video_url = cdCollectedModel.video_url;
    collectedModel.house.negotiated = cdCollectedModel.negotiated;
    collectedModel.house.reservation_num = cdCollectedModel.reservation_num;
    collectedModel.house.house_no = cdCollectedModel.house_no;
    collectedModel.house.building_year = cdCollectedModel.building_year;
    collectedModel.house.house_price = cdCollectedModel.house_price;
    collectedModel.house.house_nature = cdCollectedModel.house_nature;
    collectedModel.house.elevator = cdCollectedModel.elevator;
    collectedModel.house.price_avg = cdCollectedModel.price_avg;
    collectedModel.house.coordinate_x = cdCollectedModel.coordinate_x;
    collectedModel.house.coordinate_y = cdCollectedModel.coordinate_y;
    collectedModel.house.tj_look_house_num = cdCollectedModel.tj_look_house_num;
    collectedModel.house.tj_wait_look_house_people = cdCollectedModel.tj_wait_look_house_people;
    
    ///业主信息
    collectedModel.user.id_ = cdCollectedModel.user_id;
    collectedModel.user.user_type = cdCollectedModel.user_type;
    collectedModel.user.nickname = cdCollectedModel.nickname;
    collectedModel.user.username = cdCollectedModel.username;
    collectedModel.user.avatar = cdCollectedModel.avatar;
    collectedModel.user.email = cdCollectedModel.email;
    collectedModel.user.mobile = cdCollectedModel.mobile;
    collectedModel.user.realname = cdCollectedModel.realname;
    collectedModel.user.tj_rentHouse_num = cdCollectedModel.tj_rentHouse_num;
    collectedModel.user.tj_secondHouse_num = cdCollectedModel.tj_secondHouse_num;
    
    ///价格变动信息
    collectedModel.price_changes.id_ = cdCollectedModel.price_change_id_;
    collectedModel.price_changes.type = cdCollectedModel.price_change_type;
    collectedModel.price_changes.obj_id = cdCollectedModel.price_change_obj_id;
    collectedModel.price_changes.title = cdCollectedModel.price_change_title;
    collectedModel.price_changes.before_price = cdCollectedModel.price_change_before_price;
    collectedModel.price_changes.revised_price = cdCollectedModel.price_change_revised_price;
    collectedModel.price_changes.update_time = cdCollectedModel.price_change_update_time;
    collectedModel.price_changes.create_time = cdCollectedModel.price_change_create_time;
    collectedModel.price_changes.price_changes_num = cdCollectedModel.price_changes_num;
    
    ///图片
    if ([cdCollectedModel.photos count] > 0) {
        
        ///临时容器
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        ///遍历添加
        for (QSCDHistorySecondHandHousePhotoDataModel *cdPhotoModel in cdCollectedModel.photos) {
            
            QSPhotoDataModel *photoModel = [[QSPhotoDataModel alloc] init];
            
            photoModel.id_ = cdPhotoModel.id_;
            photoModel.type = cdPhotoModel.type;
            photoModel.title = cdPhotoModel.title;
            photoModel.mark = cdPhotoModel.mark;
            photoModel.attach_file = cdPhotoModel.attach_file;
            photoModel.attach_thumb = cdPhotoModel.attach_thumb;
            
            ///加载图片集
            [tempArray addObject:photoModel];
            
        }
        
        collectedModel.secondHouse_photo = [NSArray arrayWithArray:tempArray];
        
    }
    
    return collectedModel;

}

#pragma mark - 出租房相关数据模型转换
+ (void)histtory_ChangeModel_RentHouse_DetailMode_T_CDModel:(QSRentHouseDetailDataModel *)collectedModel andCDModel:(QSCDHistoryRentHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{

    
    ///二手房信息
    cdCollectedModel.id_ = collectedModel.house.id_;
    cdCollectedModel.user_id = collectedModel.house.user_id;
    cdCollectedModel.introduce = collectedModel.house.introduce;
    cdCollectedModel.title = collectedModel.house.title;
    cdCollectedModel.title_second = collectedModel.house.title_second;
    cdCollectedModel.address = collectedModel.house.address;
    cdCollectedModel.floor_num = collectedModel.house.floor_num;
    cdCollectedModel.property_type = collectedModel.house.property_type;
    cdCollectedModel.used_year = collectedModel.house.used_year;
    cdCollectedModel.installation = collectedModel.house.installation;
    cdCollectedModel.features = collectedModel.house.features;
    cdCollectedModel.view_count = collectedModel.house.view_count;
    cdCollectedModel.provinceid = collectedModel.house.provinceid;
    cdCollectedModel.cityid = collectedModel.house.cityid;
    cdCollectedModel.areaid = collectedModel.house.areaid;
    cdCollectedModel.street = collectedModel.house.street;
    cdCollectedModel.commend = collectedModel.house.commend;
    cdCollectedModel.attach_file = collectedModel.house.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.house.attach_thumb;
    cdCollectedModel.favorite_count = collectedModel.house.favorite_count;
    cdCollectedModel.attention_count = collectedModel.house.attention_count;
    cdCollectedModel.status = collectedModel.house.status;
    cdCollectedModel.name = collectedModel.house.name;
    cdCollectedModel.tel = collectedModel.house.tel;
    cdCollectedModel.village_id = collectedModel.house.village_id;
    cdCollectedModel.village_name = collectedModel.house.village_name;
    cdCollectedModel.floor_which = collectedModel.house.floor_which;
    cdCollectedModel.house_face = collectedModel.house.house_face;
    cdCollectedModel.decoration_type = collectedModel.house.decoration_type;
    cdCollectedModel.house_area = collectedModel.house.house_area;
    cdCollectedModel.elevator = collectedModel.house.elevator;
    cdCollectedModel.house_shi = collectedModel.house.house_shi;
    cdCollectedModel.house_ting = collectedModel.house.house_ting;
    cdCollectedModel.house_wei = collectedModel.house.house_wei;
    cdCollectedModel.house_chufang = collectedModel.house.house_chufang;
    cdCollectedModel.house_yangtai = collectedModel.house.house_yangtai;
    cdCollectedModel.fee = collectedModel.house.fee;
    cdCollectedModel.cycle = collectedModel.house.cycle;
    cdCollectedModel.time_interval_start = collectedModel.house.time_interval_start;
    cdCollectedModel.time_interval_end = collectedModel.house.time_interval_end;
    cdCollectedModel.entrust = collectedModel.house.entrust;
    cdCollectedModel.entrust_company = collectedModel.house.entrust_company;
    cdCollectedModel.video_url = collectedModel.house.video_url;
    cdCollectedModel.negotiated = collectedModel.house.negotiated;
    cdCollectedModel.reservation_num = collectedModel.house.reservation_num;
    cdCollectedModel.house_no = collectedModel.house.house_no;
    cdCollectedModel.house_status = collectedModel.house.house_status;
    cdCollectedModel.rent_price = collectedModel.house.rent_price;
    cdCollectedModel.payment = collectedModel.house.payment;
    cdCollectedModel.rent_property = collectedModel.house.rent_property;
    cdCollectedModel.lead_time = collectedModel.house.lead_time;
    cdCollectedModel.content = collectedModel.house.content;
    cdCollectedModel.decoration = collectedModel.house.decoration;
    cdCollectedModel.update_time = collectedModel.house.update_time;
    cdCollectedModel.tj_look_house_num = collectedModel.house.tj_look_house_num;
    cdCollectedModel.tj_wait_look_house_people = collectedModel.house.tj_wait_look_house_people;
    cdCollectedModel.price_avg = collectedModel.house.price_avg;
    cdCollectedModel.is_syserver = collectedModel.house.is_syserver;
    
    ///业主信息
    cdCollectedModel.user_type = collectedModel.user.user_type;
    cdCollectedModel.nickname = collectedModel.user.nickname;
    cdCollectedModel.username = collectedModel.user.username;
    cdCollectedModel.avatar = collectedModel.user.avatar;
    cdCollectedModel.email = collectedModel.user.email;
    cdCollectedModel.mobile = collectedModel.user.mobile;
    cdCollectedModel.realname = collectedModel.user.realname;
    cdCollectedModel.tj_rentHouse_num = collectedModel.user.tj_rentHouse_num;
    cdCollectedModel.tj_secondHouse_num = collectedModel.user.tj_secondHouse_num;
    
    ///价格变动信息
    cdCollectedModel.price_id_ = collectedModel.price_changes.id_;
    cdCollectedModel.price_type = collectedModel.price_changes.type;
    cdCollectedModel.price_obj_id = collectedModel.price_changes.obj_id;
    cdCollectedModel.price_title = collectedModel.price_changes.title;
    cdCollectedModel.price_before_price = collectedModel.price_changes.before_price;
    cdCollectedModel.price_revised_price = collectedModel.price_changes.revised_price;
    cdCollectedModel.price_update_time = collectedModel.price_changes.update_time;
    cdCollectedModel.price_create_time = collectedModel.price_changes.create_time;
    cdCollectedModel.price_changes_num = collectedModel.price_changes.price_changes_num;
    
    ///时间出戳
    cdCollectedModel.create_time = [NSDate date];
    
    ///图片
    if ([collectedModel.rentHouse_photo count] > 0) {
        
        ///清空原图片
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
        ///遍历添加
        for (QSPhotoDataModel *photoModel in collectedModel.rentHouse_photo) {
            
            QSCDHistoryRentHousePhotoDataModel *cdPhotoModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_RENTHOUSE_HISTORY_PHOTO inManagedObjectContext:tempContext];
            
            cdPhotoModel.id_ = photoModel.id_;
            cdPhotoModel.type = photoModel.type;
            cdPhotoModel.title = photoModel.title;
            cdPhotoModel.mark = photoModel.mark;
            cdPhotoModel.attach_file = photoModel.attach_file;
            cdPhotoModel.attach_thumb = photoModel.attach_thumb;
            cdPhotoModel.rent_house = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addPhotosObject:cdPhotoModel];
            
        }
        
    } else {
        
        ///清空原图片
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
    }
    
}

+ (QSRentHouseDetailDataModel *)histtory_ChangeModel_RentHouse_CDModel_T_DetailMode:(QSCDHistoryRentHouseDataModel *)cdCollectedModel
{

    QSRentHouseDetailDataModel *collectedModel = [[QSRentHouseDetailDataModel alloc] init];
    collectedModel.house = [[QSWRentHouseInfoDataModel alloc] init];
    collectedModel.user = [[QSUserSimpleDataModel alloc] init];
    collectedModel.price_changes = [[QSHousePriceChangesDataModel alloc] init];
    collectedModel.comment = [[QSDetailCommentListReturnData alloc] init];
    
    ///二手房信息
    collectedModel.house.id_ = cdCollectedModel.id_;
    collectedModel.house.user_id = cdCollectedModel.user_id;
    collectedModel.house.introduce = cdCollectedModel.introduce;
    collectedModel.house.title = cdCollectedModel.title;
    collectedModel.house.title_second = cdCollectedModel.title_second;
    collectedModel.house.address = cdCollectedModel.address;
    collectedModel.house.floor_num = cdCollectedModel.floor_num;
    collectedModel.house.property_type = cdCollectedModel.property_type;
    collectedModel.house.used_year = cdCollectedModel.used_year;
    collectedModel.house.installation = cdCollectedModel.installation;
    collectedModel.house.features = cdCollectedModel.features;
    collectedModel.house.view_count = cdCollectedModel.view_count;
    collectedModel.house.provinceid = cdCollectedModel.provinceid;
    collectedModel.house.cityid = cdCollectedModel.cityid;
    collectedModel.house.areaid = cdCollectedModel.areaid;
    collectedModel.house.street = cdCollectedModel.street;
    collectedModel.house.commend = cdCollectedModel.commend;
    collectedModel.house.attach_file = cdCollectedModel.attach_file;
    collectedModel.house.attach_thumb = cdCollectedModel.attach_thumb;
    collectedModel.house.favorite_count = cdCollectedModel.favorite_count;
    collectedModel.house.attention_count = cdCollectedModel.attention_count;
    collectedModel.house.status = cdCollectedModel.status;
    collectedModel.house.name = cdCollectedModel.name;
    collectedModel.house.tel = cdCollectedModel.tel;
    collectedModel.house.village_id = cdCollectedModel.village_id;
    collectedModel.house.village_name = cdCollectedModel.village_name;
    collectedModel.house.floor_which = cdCollectedModel.floor_which;
    collectedModel.house.house_face = cdCollectedModel.house_face;
    collectedModel.house.decoration_type = cdCollectedModel.decoration_type;
    collectedModel.house.house_area = cdCollectedModel.house_area;
    collectedModel.house.elevator = cdCollectedModel.elevator;
    collectedModel.house.house_shi = cdCollectedModel.house_shi;
    collectedModel.house.house_ting = cdCollectedModel.house_ting;
    collectedModel.house.house_wei = cdCollectedModel.house_wei;
    collectedModel.house.house_chufang = cdCollectedModel.house_chufang;
    collectedModel.house.house_yangtai = cdCollectedModel.house_yangtai;
    collectedModel.house.fee = cdCollectedModel.fee;
    collectedModel.house.cycle = cdCollectedModel.cycle;
    collectedModel.house.time_interval_start = cdCollectedModel.time_interval_start;
    collectedModel.house.time_interval_end = cdCollectedModel.time_interval_end;
    collectedModel.house.entrust = cdCollectedModel.entrust;
    collectedModel.house.entrust_company = cdCollectedModel.entrust_company;
    collectedModel.house.video_url = cdCollectedModel.video_url;
    collectedModel.house.negotiated = cdCollectedModel.negotiated;
    collectedModel.house.reservation_num = cdCollectedModel.reservation_num;
    collectedModel.house.house_no = cdCollectedModel.house_no;
    collectedModel.house.house_status = cdCollectedModel.house_status;
    collectedModel.house.rent_price = cdCollectedModel.rent_price;
    collectedModel.house.payment = cdCollectedModel.payment;
    collectedModel.house.rent_property = cdCollectedModel.rent_property;
    collectedModel.house.lead_time = cdCollectedModel.lead_time;
    collectedModel.house.content = cdCollectedModel.content;
    collectedModel.house.decoration = cdCollectedModel.decoration;
    collectedModel.house.update_time = cdCollectedModel.update_time;
    collectedModel.house.tj_look_house_num = cdCollectedModel.tj_look_house_num;
    collectedModel.house.tj_wait_look_house_people = cdCollectedModel.tj_wait_look_house_people;
    collectedModel.house.price_avg = cdCollectedModel.price_avg;
    collectedModel.house.is_syserver = cdCollectedModel.is_syserver;
    
    ///业主信息
    collectedModel.user.id_ = cdCollectedModel.user_id;
    collectedModel.user.user_type = cdCollectedModel.user_type;
    collectedModel.user.nickname = cdCollectedModel.nickname;
    collectedModel.user.username = cdCollectedModel.username;
    collectedModel.user.avatar = cdCollectedModel.avatar;
    collectedModel.user.email = cdCollectedModel.email;
    collectedModel.user.mobile = cdCollectedModel.mobile;
    collectedModel.user.realname = cdCollectedModel.realname;
    collectedModel.user.tj_rentHouse_num = cdCollectedModel.tj_rentHouse_num;
    collectedModel.user.tj_secondHouse_num = cdCollectedModel.tj_secondHouse_num;
    
    ///价格变动信息
    collectedModel.price_changes.id_ = cdCollectedModel.price_id_;
    collectedModel.price_changes.type = cdCollectedModel.price_type;
    collectedModel.price_changes.obj_id = cdCollectedModel.price_obj_id;
    collectedModel.price_changes.title = cdCollectedModel.price_title;
    collectedModel.price_changes.before_price = cdCollectedModel.price_before_price;
    collectedModel.price_changes.revised_price = cdCollectedModel.price_revised_price;
    collectedModel.price_changes.update_time = cdCollectedModel.price_update_time;
    collectedModel.price_changes.create_time = cdCollectedModel.price_create_time;
    collectedModel.price_changes.price_changes_num = cdCollectedModel.price_changes_num;
    
    ///图片
    if ([cdCollectedModel.photos count] > 0) {
        
        ///临时容器
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        ///遍历添加
        for (QSCDHistoryRentHousePhotoDataModel *cdPhotoModel in cdCollectedModel.photos) {
            
            QSPhotoDataModel *photoModel = [[QSPhotoDataModel alloc] init];
            
            photoModel.id_ = cdPhotoModel.id_;
            photoModel.type = cdPhotoModel.type;
            photoModel.title = cdPhotoModel.title;
            photoModel.mark = cdPhotoModel.mark;
            photoModel.attach_file = cdPhotoModel.attach_file;
            photoModel.attach_thumb = cdPhotoModel.attach_thumb;
            
            ///加载图片集
            [tempArray addObject:photoModel];
            
        }
        
        collectedModel.rentHouse_photo = [NSArray arrayWithArray:tempArray];
        
    }
    
    return collectedModel;

}

@end
