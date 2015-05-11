//
//  QSCoreDataManager.m
//  House
//
//  Created by ysmeng on 15/1/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager.h"
#import "QSYAppDelegate.h"
#import "QSCDFilterDataModel.h"

static QSCoreDataManager *_coredataManager = nil;
@interface QSCoreDataManager ()

///服务端返回的token信息
@property (nonatomic,copy) NSString *tokenString;

///服务端授权的tokenID
@property (nonatomic,copy) NSString *tokenIDString;

///小区关注数据有变动时的回调block
@property (nonatomic,copy) COREDATACHANGEBLOCK communityIntentionChangeCallBack;

///保存出租房浏览记录时的回调
@property (nonatomic,copy) COREDATACHANGEBLOCK addRentHouseHistoryHouseCallBack;

///保存二手房浏览记录时的回调
@property (nonatomic,copy) COREDATACHANGEBLOCK addSecondHandHouseHistoryHouseCallBack;

///个人中心基于用户信息更新后的回调
@property (nonatomic,copy) COREDATACHANGEBLOCK myZoneUserInfoUpdateCallBack;

///个人中心:小区关注变动时回调
@property (nonatomic,copy) COREDATACHANGEBLOCK myZoneIntentionCommunityChangeCallBack;

///个人中心:房源收藏变动时回调
@property (nonatomic,copy) COREDATACHANGEBLOCK myZoneHouseCollectedChangeCallBack;

///联系人列表:登录账号或状态改变时的监听
@property (nonatomic,copy) COREDATACHANGEBLOCK chatLoginCountChangeContactCallBack;

@end

@implementation QSCoreDataManager

#pragma mark - 数据操作管理器的单例
/**
 *  @author yangshengmeng, 15-03-26 23:03:04
 *
 *  @brief  返回Coredata管理器的单例对象
 *
 *  @return 返回当前创建的管理器单例
 *
 *  @since  1.0.0
 */
+ (instancetype)shareCoreDataManager
{

    if (nil == _coredataManager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _coredataManager = [[QSCoreDataManager alloc] init];
            
        });
        
    }
    
    return _coredataManager;

}

#pragma mark - 注册相关数据变动时的回调
/**
 *  @author                 yangshengmeng, 15-03-26 23:03:30
 *
 *  @brief                  注册数据变动时的回调，用来监测本地数据变化时的事件
 *
 *  @param dataType         数据类型
 *  @param changeCallBack   对应数据变动时的回调block
 *
 *  @since                  1.0.0
 */
+ (void)setCoredataChangeCallBack:(COREDATA_DATA_TYPE)dataType andCallBack:(COREDATACHANGEBLOCK)changeCallBack
{

    switch (dataType) {
            ///小区关注改变时的回调
        case cCoredataDataTypeCommunityIntention:
            
            if (changeCallBack) {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.communityIntentionChangeCallBack = changeCallBack;
                
            } else {
            
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.communityIntentionChangeCallBack = nil;
            
            }
            
            break;
            
            ///二手房浏览记录改变时的回调
        case cCoredataDataTypeAddSecondHandHouseHistory:
            
            if (changeCallBack) {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.addSecondHandHouseHistoryHouseCallBack = changeCallBack;
                
            } else {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.addSecondHandHouseHistoryHouseCallBack = nil;
                
            }
            
            break;
            
            ///出租房浏览记录改变时的回调
        case cCoredataDataTypeAddRentHouseHistory:
            
            if (changeCallBack) {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.addRentHouseHistoryHouseCallBack = changeCallBack;
                
            } else {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.addRentHouseHistoryHouseCallBack = nil;
                
            }
            
            break;
            
            ///当前用户的信息刷新时，回调通知myzone，用以更新UI
        case cCoredataDataTypeMyZoneUserInfoChange:
            
            if (changeCallBack) {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.myZoneUserInfoUpdateCallBack = changeCallBack;
                
            } else {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.myZoneUserInfoUpdateCallBack = nil;
                
            }
            
            break;
            
            ///个人中心：小区关注改变
        case cCoredataDataTypeMyzoneCommunityIntention:
            
            if (changeCallBack) {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.myZoneIntentionCommunityChangeCallBack = changeCallBack;
                
            } else {
            
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.myZoneIntentionCommunityChangeCallBack = nil;
            
            }
            
            break;
            
            ///个人中心：收藏房源改变
        case cCoredataDataTypeMyzoneCollectedChange:
            
            if (changeCallBack) {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.myZoneHouseCollectedChangeCallBack = changeCallBack;
                
            } else {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.myZoneHouseCollectedChangeCallBack = nil;
                
            }
            
            break;
            
            ///登录状态改变时，回调通知刷新联系人列表
        case cCoredataDataTypeChatUserLoginChange:
            
            if (changeCallBack) {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.chatLoginCountChangeContactCallBack = changeCallBack;
                
            } else {
                
                QSCoreDataManager *coredataManager = [self shareCoreDataManager];
                coredataManager.chatLoginCountChangeContactCallBack = nil;
                
            }
            
            break;
            
        default:
            break;
            
    }

}

/**
 *  @author         yangshengmeng, 15-03-26 23:03:28
 *
 *  @brief          回调给定的数据变动block
 *
 *  @param dataType 数据类型
 *
 *  @since          1.0.0
 */
+ (void)performCoredataChangeCallBack:(COREDATA_DATA_TYPE)dataType andChangeType:(DATA_CHANGE_TYPE)changeType andParamsID:(NSString *)changeKey andParams:(id)param
{

    switch (dataType) {
            ///小区关注改变时的回调
        case cCoredataDataTypeCommunityIntention:
        {
            
            QSCoreDataManager *coredataManager = [self shareCoreDataManager];
            if (coredataManager.communityIntentionChangeCallBack) {
                
                coredataManager.communityIntentionChangeCallBack(cCoredataDataTypeCommunityIntention,changeType,nil,nil);
                
            }
            
        }
            break;
            
            ///二手房浏览记录改变时的回调
        case cCoredataDataTypeAddSecondHandHouseHistory:
        {
            
            QSCoreDataManager *coredataManager = [self shareCoreDataManager];
            if (coredataManager.addSecondHandHouseHistoryHouseCallBack) {
                
                coredataManager.addSecondHandHouseHistoryHouseCallBack(cCoredataDataTypeAddSecondHandHouseHistory,changeType,changeKey,nil);
                
            }
            
        }
            break;
            
            ///出租房浏览记录改变时的回调
        case cCoredataDataTypeAddRentHouseHistory:
        {
            
            QSCoreDataManager *coredataManager = [self shareCoreDataManager];
            if (coredataManager.addRentHouseHistoryHouseCallBack) {
                
                coredataManager.addRentHouseHistoryHouseCallBack(cCoredataDataTypeAddRentHouseHistory,changeType,changeKey,nil);
                
            }
            
        }
            
            break;
            
            ///当前用户的信息刷新时，回调通知myzone，用以更新UI
        case cCoredataDataTypeMyZoneUserInfoChange:
        {
            
            QSCoreDataManager *coredataManager = [self shareCoreDataManager];
            if (coredataManager.myZoneUserInfoUpdateCallBack) {
                
                coredataManager.myZoneUserInfoUpdateCallBack(cCoredataDataTypeMyZoneUserInfoChange,changeType,nil,nil);
                
            }
            
        }
            
            break;
            
            ///个人中心：收藏房源改变
        case cCoredataDataTypeMyzoneCommunityIntention:
        {
        
            QSCoreDataManager *coredataManager = [self shareCoreDataManager];
            if (coredataManager.myZoneIntentionCommunityChangeCallBack) {
                
                coredataManager.myZoneIntentionCommunityChangeCallBack(cCoredataDataTypeMyzoneCommunityIntention,changeType,nil,nil);
                
            }
        
        }
            break;
            
            ///个人中心：收藏房源改变
        case cCoredataDataTypeMyzoneCollectedChange:
        {
            
            QSCoreDataManager *coredataManager = [self shareCoreDataManager];
            if (coredataManager.myZoneHouseCollectedChangeCallBack) {
                
                coredataManager.myZoneHouseCollectedChangeCallBack(cCoredataDataTypeMyzoneCollectedChange,changeType,nil,nil);
                
            }
            
        }
            break;
            
        default:
            break;
            
    }

}

#pragma mark - 实体数据查询
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

///返回指定实体中的所有数据，并按给定的字段排序查询
+ (NSArray *)getEntityListWithKey:(NSString *)entityName andSortKeyWord:(NSString *)keyword andAscend:(BOOL)isAscend
{
    
    ///查询成功
    return [self searchEntityListWithKey:entityName andFieldKey:keyword andSearchKey:nil andAscend:isAscend];

}

///查询给定实体中，指定关键字的数据，并返回
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey
{

    return [self searchEntityListWithKey:entityName andFieldKey:keyword andSearchKey:searchKey andAscend:YES];

}

///查询指定实体中，指定字段满足指定查询条件的数据集合
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andFieldKey:(NSString *)keyword andSearchKey:(NSString *)searchKey andAscend:(BOOL)isAscend
{
    
    ///设置查询过滤
    NSPredicate *predicate = nil;
    NSSortDescriptor *sort = nil;
    
    if (keyword) {
        
        if (searchKey) {
            
            ///过滤条件
            predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",keyword] stringByAppendingString:@"%@"],searchKey];
            
        }
        
        ///排序
        sort = [[NSSortDescriptor alloc] initWithKey:keyword ascending:isAscend];
        
    }
    
    return [self searchEntityListWithKey:entityName andCustomPredicate:predicate andCustomSort:sort];

}

///根据给定的predicate和排序，查找实体中的对应数据，并以数组返回
+ (NSArray *)searchEntityListWithKey:(NSString *)entityName andCustomPredicate:(NSPredicate *)predicate andCustomSort:(NSSortDescriptor *)sort
{

    QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    NSEntityDescription *enty = [NSEntityDescription entityForName:entityName inManagedObjectContext:mainContext];
    
    ///设置查找
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:enty];
    
    ///设置查询过滤
    if (predicate) {
        
        [request setPredicate:predicate];
        
    }
    
    ///设置排序
    if (sort) {
        
        [request setSortDescriptors:@[sort]];
        
    }
    
    __block NSError *error;
    __block NSArray *resultList = nil;
    
    if ([NSThread isMainThread]) {
        
        resultList = [mainContext executeFetchRequest:request error:&error];
        
    } else {
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            resultList = [mainContext executeFetchRequest:request error:&error];
            
        });
    
    }
    
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

#pragma mark - 单个实体数据查询
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
+ (id)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey
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
    return resultModel;
    
}

///按给定的两个条件查询对应记录
+ (id)searchEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldSearchKey:(NSString *)searchKey andSecondFieldName:(NSString *)secondFieldName andSecndFieldValue:(NSString *)secondFieldValue
{
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[[NSString stringWithFormat:@"%@ == ",fieldName] stringByAppendingString:@"%@ AND "] stringByAppendingString:[[NSString stringWithFormat:@"%@ == ",secondFieldName] stringByAppendingString:@"%@"]],searchKey,secondFieldValue];
    
    return [self searchEntityWithKey:entityName andCustomPredicate:predicate];

}

///根据给定的predecate查询对应的实体
+ (id)searchEntityWithKey:(NSString *)entityName andCustomPredicate:(NSPredicate *)predicate
{

    NSArray *resultList = [self searchEntityListWithKey:entityName andCustomPredicate:predicate andCustomSort:nil];
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    return [resultList firstObject];

}

#pragma mark - 更新操作
/**
 *  @author                     yangshengmeng, 15-02-05 09:02:15
 *
 *  @brief                      更新指定记录中的指定字段信息
 *
 *  @param entityName           实体名
 *  @param filterFieldName      指定记录的指定字段
 *  @param filterValue          指定字段的值
 *  @param updateFieldName      需要更新的字段名
 *  @param updateFieldNewValue  需要更新的字段新值
 *
 *  @return                     返回是否更新成功
 *
 *  @since                      1.0.0
 */
+ (BOOL)updateFieldWithKey:(NSString *)entityName andFilterFieldName:(NSString *)filterFieldName andFilterFieldValue:(NSString *)filterValue andUpdateFieldName:(NSString *)updateFieldName andUpdateFieldNewValue:(NSString *)updateFieldNewValue
{
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",filterFieldName] stringByAppendingString:@"%@"],filterValue];
    
    return [self updateFieldWithKey:entityName andPredicate:predicate andUpdateFieldName:updateFieldName andNewValue:updateFieldNewValue];
    
}

///根据给定的查询条件，更新指定字段信息
+ (BOOL)updateFieldWithKey:(NSString *)entityName andPredicate:(NSPredicate *)predicate andUpdateFieldName:(NSString *)fieldName andNewValue:(NSString *)newValue
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///判断是否存在过滤器
    if (predicate) {
        
        [fetchRequest setPredicate:predicate];
        
    }
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///判断读取出来的原数据
    if (nil == fetchResultArray) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///遍历更新
    if ([fetchResultArray count] > 0) {
        
        for (int i = 0; i < [fetchResultArray count]; i++) {
            
            ///获取模型后更新保存
            QSCDFilterDataModel *model = fetchResultArray[i];
            [model setValue:newValue forKey:fieldName];
            [tempContext save:&error];
            
            ///判断保存是否成功
            if (error) {
                
                break;
                
            }
            
        }
        
    }
    
    if (error) {
        
        NSLog(@"=====================更新指定记录某字段信息出错========================");
        NSLog(@"entity anme : %@    error:%@",entityName,error);
        NSLog(@"=====================更新指定记录某字段信息出错========================");
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

#pragma mark - 单记录的实体数据操作
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
+ (id)getUnirecordFieldWithKey:(NSString *)entityName andKeyword:(NSString *)keyword
{
    
    NSArray *resultList = [NSArray arrayWithArray:[self getEntityListWithKey:entityName andSortKeyWord:keyword andAscend:YES]];
    
    ///判断是否查询失败
    if (nil == resultList) {
        
        return nil;
        
    }
    
    ///如果获取返回的个数为0也直接返回nil
    if (0 >= [resultList count]) {
        
        return nil;
        
    }
    
    ///查询成功
    NSManagedObject *resultModel = [resultList firstObject];
    id tempResult = [resultModel valueForKey:keyword];
    return tempResult ? tempResult : nil;

}

///更新单记录表中，指定字段的信息
+ (BOOL)updateUnirecordFieldWithKey:(NSString *)entityName andUpdateField:(NSString *)fieldName andFieldNewValue:(id)newValue
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///查询条件
    NSPredicate* predicate = [NSPredicate predicateWithValue:YES];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///判断读取出来的原数据
    if (nil == fetchResultArray) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        return NO;
        
    }
    
    ///检测原来是否已有数据
    if (0 >= [fetchResultArray count]) {
        
        ///插入数据
        NSObject *model = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:tempContext];
        [model setValue:newValue forKey:fieldName];
        [tempContext save:&error];
        
    } else {
    
        ///获取模型后更新保存
        NSObject *model = fetchResultArray[0];
        [model setValue:newValue forKey:fieldName];
        [tempContext save:&error];
    
    }
    
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

#pragma mark - 删除记录
///删除给定记录
+ (void)deleteEntityWithKey:(NSString *)entityName andFieldName:(NSString *)fieldName andFieldValue:(NSString *)value andCallBack:(void(^)(BOOL flag))callBack
{

    ///过滤条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",fieldName] stringByAppendingString:@"%@"],value];
    [self deleteEntityWithKey:entityName andPredicate:predicate andCallBack:callBack];

}

+ (void)deleteEntityWithKey:(NSString *)entityName andPredicate:(NSPredicate *)predicate andCallBack:(void(^)(BOOL flag))callBack
{
    
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    ///添加过滤
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    ///查询失败
    if (error) {
        
        NSLog(@"CoreData.GetData.Error:%@",error);
        
        if (callBack) {
            
            callBack(NO);
            
        }
        
        return;
        
    }
    
    ///如果本身数据就为0，则直接返回YES
    if (0 >= [resultArray count]) {
        
        if (callBack) {
            
            callBack(YES);
            
        }
        return;
        
    }
    
    ///遍历删除
    for (NSManagedObject *obj in resultArray) {
        
        [tempContext deleteObject:obj];
        
    }
    
    ///确认删除结果
    BOOL isChangeSuccess = [tempContext save:&error];
    if (!isChangeSuccess) {
        
        NSLog(@"CoreData.DeleteData.Error:%@",error);
        
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
    
    if (callBack) {
        
        callBack(YES);
        
    }
    
}

#pragma mark - 清空实体记录API
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

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *resultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
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
        
        [tempContext deleteObject:obj];
        
    }
    
    ///确认删除结果
    BOOL isChangeSuccess = [tempContext save:&error];
    if (!isChangeSuccess) {
        
        NSLog(@"CoreData.DeleteData.Error:%@",error);
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
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

    ///获取主线程上下文
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有上下文
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:tempContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setIncludesPropertyValues:NO];
    [fetchRequest setEntity:entity];
    
    ///设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString stringWithFormat:@"%@ == ",fieldKey] stringByAppendingString:@"%@"],deleteKey];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *resultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
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
        
        [tempContext deleteObject:obj];
        
    }
    
    ///确认删除结果
    BOOL isChangeSuccess = [tempContext save:&error];
    if (!isChangeSuccess) {
        
        NSLog(@"CoreData.DeleteData.Error:%@",error);
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    return isChangeSuccess;

}

@end
