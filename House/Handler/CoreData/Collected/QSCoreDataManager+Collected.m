//
//  QSCoreDataManager+Collected.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Collected.h"

#import "QSYAppDelegate.h"

#import "QSCoreDataManager+User.h"

#import "QSWCommunityDataModel.h"
#import "QSCommunityHouseDetailDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSHouseInfoDataModel.h"

#import "QSCDCollectedCommunityDataModel.h"
#import "QSCDCollectedCommunityHouseDataModel.h"
#import "QSCDCollectedCommunityPhotoDataModel.h"
#import "QSCDCollectedCommunityRentHouseDataModel.h"

#import "QSCDCollectedSecondHandHouseDataModel.h"
#import "QSCDCollectedSecondHandHousePhotoDataModel.h"
#import "QSSecondHouseDetailDataModel.h"
#import "QSHouseCommentDataModel.h"
#import "QSHousePriceChangesDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"
#import "QSPhotoDataModel.h"

#import "QSCDCollectedRentHouseDataModel.h"
#import "QSCDCollectedRentHousePhotoDataModel.h"
#import "QSRentHouseDetailDataModel.h"
#import "QSHouseCommentDataModel.h"
#import "QSWRentHouseInfoDataModel.h"

#import "QSCDCollectedNewHouseDataModel.h"
#import "QSCDCollectedNewHouseActivityDataModel.h"
#import "QSCDCollectedNewHouseAllHousesDataModel.h"
#import "QSCDCollectedNewHousePhotoDataModel.h"
#import "QSCDCollectedNewHouseRecommendHousesDataModel.h"
#import "QSNewHouseDetailDataModel.h"
#import "QSLoupanInfoDataModel.h"
#import "QSLoupanPhaseDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSRateDataModel.h"
#import "QSActivityDataModel.h"
#import "QSHouseTypeDataModel.h"
#import "QSNewHouseInfoDataModel.h"

///收藏CoreData实体名
#define COREDATA_ENTITYNAME_COMMUNITY_COLLECTED @"QSCDCollectedCommunityDataModel"
#define COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_PHOTO @"QSCDCollectedCommunityPhotoDataModel"
#define COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_HOUSE @"QSCDCollectedCommunityHouseDataModel"
#define COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_RENTHOUSE @"QSCDCollectedCommunityRentHouseDataModel"

#define COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED @"QSCDCollectedSecondHandHouseDataModel"
#define COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED_PHOTO @"QSCDCollectedSecondHandHousePhotoDataModel"

#define COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED @"QSCDCollectedRentHouseDataModel"
#define COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED_PHOTO @"QSCDCollectedRentHousePhotoDataModel"

#define COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED @"QSCDCollectedNewHouseDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_PHOTO @"QSCDCollectedNewHousePhotoDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_RECOMMEND @"QSCDCollectedNewHouseRecommendHousesDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_ALLHOUSE @"QSCDCollectedNewHouseAllHousesDataModel"
#define COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_ACTIVITY @"QSCDCollectedNewHouseActivityDataModel"

@implementation QSCoreDataManager (Collected)

#pragma mark - 查询数据
/**
 *  @author yangshengmeng, 15-03-12 14:03:09
 *
 *  @brief  返回本地保存的数据列表
 *
 *  @return 返回本地保存的数据列表
 *
 *  @since  1.0.0
 */
+ (NSArray *)getLocalCollectedDataSourceWithType:(FILTER_MAIN_TYPE)type
{

    switch (type) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            return [self getLocalCollectedNewHouse];
            
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
            
            return [self getLocalCollectedCommunityWith];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            return [self getLocalCollectedSecondHandHouse];
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            return [self getLocalCollectedRentHouse];
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

///返回收藏的小区列表
+ (NSArray *)getLocalCollectedCommunityWith
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    ///过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collected_id = %@",userID];
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0 ||
            [obj.is_syserver intValue] == 1) {
            
            QSCommunityHouseDetailDataModel *tempModel = [self changeModel_Community_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏的新房列表
+ (NSArray *)getLocalCollectedNewHouse
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    ///过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collected_id = %@",userID];
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedNewHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0 ||
            [obj.is_syserver intValue] == 1) {
            
            QSNewHouseDetailDataModel *tempModel = [self changeModel_NewHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏的二手房列表
+ (NSArray *)getLocalCollectedSecondHandHouse
{
    
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    ///过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collected_id = %@",userID];
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedSecondHandHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0 ||
            [obj.is_syserver intValue] == 1) {
            
            QSSecondHouseDetailDataModel *tempModel = [self changeModel_SecondHandHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏的出租房列表
+ (NSArray *)getLocalCollectedRentHouse
{

    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    ///过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"collected_id = %@",userID];
    
    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedRentHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据：is_syserver == 0 || 1
        if ([obj.is_syserver intValue] == 0 ||
            [obj.is_syserver intValue] == 1) {
            
            QSRentHouseDetailDataModel *tempModel = [self changeModel_RentHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];

}

#pragma mark - 返回本地添加未上传服务端的记录
/**
 *  @author yangshengmeng, 15-03-12 14:03:30
 *
 *  @brief  查询未上传服务端的收藏记录
 *
 *  @return 返回本地保存中，未上传服务端的收藏记录
 *
 *  @since  1.0.0
 */
+ (NSArray *)getUncommitedCollectedDataSource:(FILTER_MAIN_TYPE)type
{

    switch (type) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            return [self getLocalUnCommitCollectedNewHouse];
            
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
            
            return [self getLocalUnCommitCollectedCommunity];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            return [self getLocalUnCommitCollectedSecondHandHouse];
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            return [self getLocalUnCommitCollectedRentHouse];
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

///返回收藏中，未上传服务端的小区列表
+ (NSArray *)getLocalUnCommitCollectedCommunity
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
        
        ///只返回未上传服务端的数据
        if ([obj.is_syserver intValue] == 0) {
            
            QSCommunityHouseDetailDataModel *tempModel = [self changeModel_Community_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏中，未上传服务端的新房列表
+ (NSArray *)getLocalUnCommitCollectedNewHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedNewHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0) {
            
            QSNewHouseDetailDataModel *tempModel = [self changeModel_NewHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏中，未上传服务端的二手房列表
+ (NSArray *)getLocalUnCommitCollectedSecondHandHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedSecondHandHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0) {
            
            QSSecondHouseDetailDataModel *tempModel = [self changeModel_SecondHandHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回收藏中，未上传服务端的出租房列表
+ (NSArray *)getLocalUnCommitCollectedRentHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedRentHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 0) {
            
            QSRentHouseDetailDataModel *tempModel = [self changeModel_RentHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

#pragma mark - 查询本地已删除，未上传服务端的数据
/**
 *  @author     yangshengmeng, 15-03-19 23:03:11
 *
 *  @brief      根据类型，查询删除的收藏或/分享，并且未同步服务端的记录
 *
 *  @param type 类型
 *
 *  @return     返回未同步服务端删除的数据
 *
 *  @since      1.0.0
 */
+ (NSArray *)getDeleteUnCommitedCollectedDataSoucre:(FILTER_MAIN_TYPE)type
{
    
    switch (type) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            return [self getLocalUnCommitDeletedCollectedNewHouse];
            
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
            
            return [self getLocalUnCommitDeletedCollectedCommunity];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            return [self getLocalUnCommitDeletedCollectedSecondHandHouse];
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            return [self getLocalUnCommitDeletedCollectedRentHouse];
            
            break;
            
        default:
            break;
    }
    
    return nil;
    
}

///返回本地已删除，未同步服务端小区列表
+ (NSArray *)getLocalUnCommitDeletedCollectedCommunity
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
        
        ///只返回未上传服务端的数据
        if ([obj.is_syserver intValue] == 3) {
            
            QSCommunityHouseDetailDataModel *tempModel = [self changeModel_Community_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回本地已删除，未同步服务端的新房列表
+ (NSArray *)getLocalUnCommitDeletedCollectedNewHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedNewHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 3) {
            
            QSNewHouseDetailDataModel *tempModel = [self changeModel_NewHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回本地已删除，未同步服务端的二手房列表
+ (NSArray *)getLocalUnCommitDeletedCollectedSecondHandHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedSecondHandHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 3) {
            
            QSSecondHouseDetailDataModel *tempModel = [self changeModel_SecondHandHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

///返回本地已删除，未同步服务端的出租房列表
+ (NSArray *)getLocalUnCommitDeletedCollectedRentHouse
{
    
    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedRentHouseDataModel *obj in tempArray) {
        
        ///只返回可用的数据
        if ([obj.is_syserver intValue] == 3) {
            
            QSRentHouseDetailDataModel *tempModel = [self changeModel_RentHouse_CDModel_T_DetailMode:obj];
            [tempResultArray addObject:tempModel];
            
        }
        
    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

#pragma mark - 查询本地是否收藏
/**
 *  @author                 yangshengmeng, 15-03-19 15:03:27
 *
 *  @brief                  查询给定类型和ID的收藏/分享是否存在，存在-YES
 *
 *  @param collectedID      收藏/分享的ID
 *  @param collectedType    收藏/分享类型
 *
 *  @return                 存在-YES
 *
 *  @since                  1.0.0
 */
+ (BOOL)checkCollectedDataWithID:(NSString *)collectedID andCollectedType:(FILTER_MAIN_TYPE)collectedType;
{
    
    ///用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }

    switch (collectedType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            ///设置查询过滤
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                NSString *status = [tempArray[0] valueForKey:@"is_syserver"];
                return (([status intValue] == 1) || ([status intValue] == 0)) ? YES : NO;
                
            }
            
            return NO;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                NSString *status = [tempArray[0] valueForKey:@"is_syserver"];
                return (([status intValue] == 1) || ([status intValue] == 0)) ? YES : NO;
                
            }
            
            return NO;
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                NSString *status = [tempArray[0] valueForKey:@"is_syserver"];
                return (([status intValue] == 1) || ([status intValue] == 0)) ? YES : NO;
                
            }
            
            return NO;
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                NSString *status = [tempArray[0] valueForKey:@"is_syserver"];
                return (([status intValue] == 1) || ([status intValue] == 0)) ? YES : NO;
                
            }
            
            return NO;
            
        }
            break;
            
        default:
            break;
    }
    
    return NO;

}

///查找对应收藏记录
+ (id)searchCollectedDataWithID:(NSString *)collectedID andCollectedType:(FILTER_MAIN_TYPE)collectedType
{

    ///用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    switch (collectedType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_NewHouse_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
        
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_Community_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
        
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_SecondHandHouse_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_RentHouse_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

+ (id)searchCollectedDataUnLimitedIDWithID:(NSString *)collectedID andCollectedType:(FILTER_MAIN_TYPE)collectedType
{
    
    switch (collectedType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@",collectedID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_NewHouse_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@",collectedID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_Community_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@",collectedID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_SecondHandHouse_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
        {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@",collectedID];
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED andCustomPredicate:predicate andCustomSort:nil];
            if ([tempArray count] > 0) {
                
                return [self changeModel_RentHouse_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

#pragma mark - 添加收藏/分享
/**
 *  @author             yangshengmeng, 15-03-19 11:03:29
 *
 *  @brief              保存给定的关注或收藏数据信息
 *
 *  @param dataSource   数据的集合
 *  @param dataType     类型
 *  @param callBack     保存后的回调
 *
 *
 *  @since              1.0.0
 */
+ (void)saveCollectedDataSource:(NSArray *)dataSource  andCollectedType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack
{
    
    for (QSBaseModel *obj in dataSource) {
        
        [self saveCollectedDataWithModel:obj andCollectedType:dataType andCallBack:callBack];
        
    }
    
}

/**
 *  @author                 yangshengmeng, 15-03-19 11:03:24
 *
 *  @brief                  保存收藏/关注信息
 *
 *  @param collectedModel   数据模型
 *  @param dataType         数据分类：小区、新房、二手房等
 *  @param callBack         保存后的回调
 *
 *
 *  @since                  1.0.0
 */
+ (void)saveCollectedDataWithModel:(id)collectedModel andCollectedType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///校验
    if (nil == collectedModel) {
        
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    switch (dataType) {
            ///保存新房
        case fFilterMainTypeNewHouse:
            
            [self saveNewHouseCollectedData:collectedModel andCallBack:callBack];
            
            break;
            
            ///保存小区
        case fFilterMainTypeCommunity:
            
            [self saveCommunityCollectedData:collectedModel andCallBack:callBack];
            
            break;
            
            ///保存二手房
        case fFilterMainTypeSecondHouse:
            
            [self saveSecondHandHouseCollectedData:collectedModel andCallBack:callBack];
            
            break;
            
            ///保存出租房
        case fFilterMainTypeRentalHouse:
            
            [self saveRentHouseCollectedData:collectedModel andCallBack:callBack];
            
            break;
            
        default:
            break;
    }
    
}

///保存小区信息
+ (void)saveCommunityCollectedData:(id)model andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///根据传进来的数据模型，调用不同的保存接口
    if ([model isKindOfClass:[QSCommunityDataModel class]]) {
        
        [self saveCollectedCommunityWithListModel:(QSCommunityDataModel *)model andCallBack:callBack];
        
    }
    
    if ([model isKindOfClass:[QSCommunityHouseDetailDataModel class]]) {
        
        [self saveCollectedCommunityWithDetailModel:(QSCommunityHouseDetailDataModel *)model andCallBack:callBack];
        
    }

}

///保存新房信息
+ (void)saveNewHouseCollectedData:(id)model andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///根据传进来的数据模型，调用不同的保存接口
    if ([model isKindOfClass:[QSNewHouseInfoDataModel class]]) {
        
        [self saveCollectedNewHouseWithListModel:(QSNewHouseInfoDataModel *)model andCallBack:callBack];
        
    }
    
    if ([model isKindOfClass:[QSNewHouseDetailDataModel class]]) {
        
        [self saveCollectedNewHouseWithDetailModel:(QSNewHouseDetailDataModel *)model andCallBack:callBack];
        
    }
    
}

///保存二手房信息
+ (void)saveSecondHandHouseCollectedData:(id)model andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///根据传进来的数据模型，调用不同的保存接口
    if ([model isKindOfClass:[QSHouseInfoDataModel class]]) {
        
        [self saveCollectedSecondHandHouseWithListModel:(QSHouseInfoDataModel *)model andCallBack:callBack];
        
    }
    
    if ([model isKindOfClass:[QSSecondHouseDetailDataModel class]]) {
        
        [self saveCollectedSecondHandHouseWithDetailModel:(QSSecondHouseDetailDataModel *)model andCallBack:callBack];
        
    }
    
}

///保存出租房信息
+ (void)saveRentHouseCollectedData:(id)model andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///根据传进来的数据模型，调用不同的保存接口
    if ([model isKindOfClass:[QSRentHouseInfoDataModel class]]) {
        
        [self saveCollectedRentHouseWithListModel:(QSRentHouseInfoDataModel *)model andCallBack:callBack];
        
    }
    
    if ([model isKindOfClass:[QSRentHouseDetailDataModel class]]) {
        
        [self saveCollectedRentHouseWithDetailModel:(QSRentHouseDetailDataModel *)model andCallBack:callBack];
        
    }
    
}

///根据列表中的新房收藏数据模型，保存收藏信息
+ (void)saveCollectedNewHouseWithListModel:(QSNewHouseInfoDataModel *)collectedModel andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.id_,userID];
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
        
        QSCDCollectedNewHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_NewHouse_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedNewHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_NewHouse_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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

///根据列表中添加的小区关注数据模型，保存关注信息
+ (void)saveCollectedCommunityWithListModel:(QSCommunityDataModel *)collectedModel andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.id_,userID];
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
        
        QSCDCollectedCommunityDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_Community_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedCommunityDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_Community_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCommunityIntention andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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
    
    ///回调改动
    [self performCoredataChangeCallBack:cCoredataDataTypeCommunityIntention andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }

}

///根据列表中的二手房收藏数据模型，保存收藏信息
+ (void)saveCollectedSecondHandHouseWithListModel:(QSHouseInfoDataModel *)collectedModel andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.id_,userID];
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
        
        QSCDCollectedSecondHandHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_SecondHandHouse_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedSecondHandHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_SecondHandHouse_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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

///根据列表中的出租房收藏数据模型，保存收藏信息
+ (void)saveCollectedRentHouseWithListModel:(QSRentHouseInfoDataModel *)collectedModel andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.id_,userID];
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
        
        QSCDCollectedRentHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_RentHouse_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedRentHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_RentHouse_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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

///根据详情中添加的小区关注数据模型，保存关注信息
+ (void)saveCollectedCommunityWithDetailModel:(QSCommunityHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.village.id_,userID];
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
        
        QSCDCollectedCommunityDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_Community_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedCommunityDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_Community_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCommunityIntention andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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
    
    ///回调改动
    [self performCoredataChangeCallBack:cCoredataDataTypeCommunityIntention andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }
    
}

///添加新房收藏
+ (void)saveCollectedNewHouseWithDetailModel:(QSNewHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.loupan.id_,userID];
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
        
        QSCDCollectedNewHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_NewHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedNewHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_NewHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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

///添二手房收藏
+ (void)saveCollectedSecondHandHouseWithDetailModel:(QSSecondHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.house.id_,userID];
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
        
        QSCDCollectedSecondHandHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_SecondHandHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedSecondHandHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_SecondHandHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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

///添加出租房收藏
+ (void)saveCollectedRentHouseWithDetailModel:(QSRentHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@ && collected_id == %@",collectedModel.house.id_,userID];
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
        
        QSCDCollectedRentHouseDataModel *cdCollectedModel = fetchResultArray[0];
        [self changeModel_RentHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedRentHouseDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_RentHouse_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
        cdCollectedModel.collected_id = userID;
        [tempContext save:&error];
        
        ///回调变动
        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeIncrease andParamsID:nil andParams:nil];
        
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

#pragma mark - 删除收藏/分享
/**
 *  @author                 yangshengmeng, 15-03-19 19:03:11
 *
 *  @brief                  删除给定的收藏/分享数据
 *
 *  @param collectedModel   收藏的数据模型
 *  @param dataType         类型
 *  @param callBack         删除后的回调
 *
 *  @since                  1.0.0
 */
+ (void)deleteCollectedDataWithID:(NSString *)collectedID isSyServer:(BOOL)isSyserver andCollectedType:(FILTER_MAIN_TYPE)dataType andCallBack:(void(^)(BOOL flag))callBack
{
    
    ///当前用户ID
    NSString *userID = [QSCoreDataManager getUserID];
    if ([userID length] <= 0) {
        
        userID = @"-1";
        
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ = %@ and collected_id = %@",collectedID,userID];

    switch (dataType) {
            ///删除小区关注
        case fFilterMainTypeCommunity:
        {
        
            ///获取本地模型
            QSCDCollectedCommunityDataModel *localModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andCustomPredicate:predicate];
            
            ///判断本地是否存在
            if (localModel) {
                
                ///判断当前收藏是否已上传服务端：未上传，直接删除
                if ([localModel.is_syserver intValue] == 0) {
                    
                    [self deleteEntityWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                    
                    ///回调关注变动
                    [self performCoredataChangeCallBack:cCoredataDataTypeCommunityIntention andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                    
                    ///回调关注变动
                    [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCommunityIntention andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                    
                } else {
                
                    ///判断是否已联网删除
                    if (isSyserver) {
                        
                        [self deleteEntityWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeCommunityIntention andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCommunityIntention andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                    } else {
                    
                        ///将本地的状态改为3
                        QSCommunityHouseDetailDataModel *tempModel = [self changeModel_Community_CDModel_T_DetailMode:localModel];
                        tempModel.is_syserver = @"3";
                        
                        ///保存本地
                        [self saveCollectedCommunityWithDetailModel:tempModel andCallBack:^(BOOL flag) {
                            
                            if (flag) {
                                
                                ///回调关注变动
                                [self performCoredataChangeCallBack:cCoredataDataTypeCommunityIntention andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                                
                                ///回调关注变动
                                [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCommunityIntention andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                                
                                ///回调
                                callBack(YES);
                                
                            }
                            
                        }];
                    
                    }
                
                }
                
            } else {
            
                if (callBack) {
                    
                    callBack(NO);
                    
                }
            
            }
        
        }
            break;
            
            ///删除新房收藏
        case fFilterMainTypeNewHouse:
        {
            
            ///获取本地模型
            QSCDCollectedNewHouseDataModel *localModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED andCustomPredicate:predicate];
            
            ///判断本地是否存在
            if (localModel) {
                
                ///判断当前收藏是否已上传服务端：未上传，直接删除
                if ([localModel.is_syserver intValue] == 0) {
                    
                    [self deleteEntityWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                    
                    ///回调关注变动
                    [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                    
                } else {
                    
                    ///判断是否已联网删除
                    if (isSyserver) {
                        
                        [self deleteEntityWithKey:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                    } else {
                        
                        ///将本地的状态改为3
                        QSNewHouseDetailDataModel *tempModel = [self changeModel_NewHouse_CDModel_T_DetailMode:localModel];
                        tempModel.is_syserver = @"3";
                        
                        ///保存本地
                        [self saveCollectedNewHouseWithDetailModel:tempModel andCallBack:callBack];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                    }
                    
                }
                
            } else {
                
                if (callBack) {
                    
                    callBack(NO);
                    
                }
                
            }
            
        }
            break;
            
            ///删除二手房收藏
        case fFilterMainTypeSecondHouse:
        {
            
            ///获取本地模型
            QSCDCollectedSecondHandHouseDataModel *localModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED andCustomPredicate:predicate];
            
            ///判断本地是否存在
            if (localModel) {
                
                ///判断当前收藏是否已上传服务端：未上传，直接删除
                if ([localModel.is_syserver intValue] == 0) {
                    
                    [self deleteEntityWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                    
                    ///回调关注变动
                    [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                    
                    if (callBack) {
                        
                        callBack(YES);
                        
                    }
                    
                } else {
                    
                    ///判断是否已联网删除
                    if (isSyserver) {
                        
                        [self deleteEntityWithKey:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                    } else {
                        
                        ///将本地的状态改为3
                        QSSecondHouseDetailDataModel *tempModel = [self changeModel_SecondHandHouse_CDModel_T_DetailMode:localModel];
                        tempModel.is_syserver = @"3";
                        
                        ///保存本地
                        [self saveCollectedSecondHandHouseWithDetailModel:tempModel andCallBack:callBack];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                    }
                    
                }
                
            } else {
                
                if (callBack) {
                    
                    callBack(NO);
                    
                }
                
            }
            
        }
            break;
            
            ///删除出租房收藏
        case fFilterMainTypeRentalHouse:
        {
            
            ///获取本地模型
            QSCDCollectedRentHouseDataModel *localModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED andCustomPredicate:predicate];
            
            ///判断本地是否存在
            if (localModel) {
                
                ///判断当前收藏是否已上传服务端：未上传，直接删除
                if ([localModel.is_syserver intValue] == 0) {
                    
                    [self deleteEntityWithKey:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                    
                    ///回调关注变动
                    [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                    
                } else {
                    
                    ///判断是否已联网删除
                    if (isSyserver) {
                        
                        [self deleteEntityWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                    } else {
                        
                        ///将本地的状态改为3
                        QSRentHouseDetailDataModel *tempModel = [self changeModel_RentHouse_CDModel_T_DetailMode:localModel];
                        tempModel.house.is_syserver = @"3";
                        
                        ///保存本地
                        [self saveCollectedRentHouseWithDetailModel:tempModel andCallBack:callBack];
                        
                        ///回调关注变动
                        [self performCoredataChangeCallBack:cCoredataDataTypeMyzoneCollectedChange andChangeType:dDataChangeTypeReduce andParamsID:nil andParams:nil];
                        
                    }
                    
                }
                
            } else {
                
                if (callBack) {
                    
                    callBack(NO);
                    
                }
                
            }
            
        }
            break;
            
        default:
            break;
    }

}

#pragma mark - 数据模型转换
///普通数据模型和CoreData数据模型转换
+ (void)changeModel_Community_DetailMode_T_CDModel:(QSCommunityHouseDetailDataModel *)collectedModel andCDModel:(QSCDCollectedCommunityDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{
    
    cdCollectedModel.id_ = collectedModel.village.id_;
    cdCollectedModel.user_id = collectedModel.village.user_id;
    cdCollectedModel.floor_num = collectedModel.village.floor_num;
    cdCollectedModel.title_second = collectedModel.village.title_second;
    cdCollectedModel.title = collectedModel.village.title;
    cdCollectedModel.introduce = collectedModel.village.introduce;
    cdCollectedModel.property_type = collectedModel.village.property_type;
    cdCollectedModel.used_year = collectedModel.village.used_year;
    cdCollectedModel.installation = collectedModel.village.installation;
    cdCollectedModel.features = collectedModel.village.features;
    cdCollectedModel.view_count = collectedModel.village.view_count;
    cdCollectedModel.provinceid = collectedModel.village.provinceid;
    cdCollectedModel.cityid = collectedModel.village.cityid;
    cdCollectedModel.areaid = collectedModel.village.areaid;
    cdCollectedModel.street = collectedModel.village.street;
    cdCollectedModel.commend = collectedModel.village.commend;
    cdCollectedModel.attach_file = collectedModel.village.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.village.attach_thumb;
    cdCollectedModel.favorite_count = collectedModel.village.favorite_count;
    cdCollectedModel.attention_count = collectedModel.village.attention_count;
    cdCollectedModel.status = collectedModel.village.status;
    cdCollectedModel.sex = collectedModel.user.sex;
    cdCollectedModel.web = collectedModel.user.web;
    cdCollectedModel.vocation = collectedModel.user.vocation;
    cdCollectedModel.qq = collectedModel.user.qq;
    cdCollectedModel.age = collectedModel.user.age;
    cdCollectedModel.idcard = collectedModel.user.idcard;
    cdCollectedModel.tel = collectedModel.user.tel;
    cdCollectedModel.developer_name = collectedModel.user.developer_name;
    cdCollectedModel.developer_intro = collectedModel.user.developer_intro;
    cdCollectedModel.user_type = collectedModel.user.user_type;
    cdCollectedModel.nickname = collectedModel.user.nickname;
    cdCollectedModel.username = collectedModel.user.username;
    cdCollectedModel.avatar = collectedModel.user.avatar;
    cdCollectedModel.email = collectedModel.user.email;
    cdCollectedModel.mobile = collectedModel.user.mobile;
    cdCollectedModel.realname = collectedModel.user.realname;
    cdCollectedModel.tj_secondHouse_num = collectedModel.user.tj_secondHouse_num;
    cdCollectedModel.tj_rentHouse_num = collectedModel.user.tj_rentHouse_num;
    cdCollectedModel.is_syserver = collectedModel.is_syserver;
    
    cdCollectedModel.catalog_id = collectedModel.village.catalog_id;
    cdCollectedModel.building_structure = collectedModel.village.building_structure;
    cdCollectedModel.heating = collectedModel.village.heating;
    cdCollectedModel.company_property = collectedModel.village.company_property;
    cdCollectedModel.company_developer = collectedModel.village.company_developer;
    cdCollectedModel.fee = collectedModel.village.fee;
    cdCollectedModel.water = collectedModel.village.water;
    cdCollectedModel.open_time = collectedModel.village.open_time;
    cdCollectedModel.area_covered = collectedModel.village.area_covered;
    cdCollectedModel.areabuilt = collectedModel.village.areabuilt;
    cdCollectedModel.volume_rate = collectedModel.village.volume_rate;
    cdCollectedModel.green_rate = collectedModel.village.green_rate;
    cdCollectedModel.licence = collectedModel.village.licence;
    cdCollectedModel.parking_lot = collectedModel.village.parking_lot;
    cdCollectedModel.checkin_time = collectedModel.village.checkin_time;
    cdCollectedModel.households_num = collectedModel.village.households_num;
    cdCollectedModel.ladder = collectedModel.village.ladder;
    cdCollectedModel.ladder_family = collectedModel.village.ladder_family;
    cdCollectedModel.building_year = collectedModel.village.building_year;
    cdCollectedModel.traffic_bus = collectedModel.village.traffic_bus;
    cdCollectedModel.traffic_subway = collectedModel.village.traffic_subway;
    cdCollectedModel.reply_count = collectedModel.village.reply_count;
    cdCollectedModel.reply_allow = collectedModel.village.reply_allow;
    cdCollectedModel.buildings_num = collectedModel.village.buildings_num;
    cdCollectedModel.price_avg = collectedModel.village.price_avg;
    cdCollectedModel.tj_last_month_price_avg = collectedModel.village.tj_last_month_price_avg;
    cdCollectedModel.tj_one_shi_price_avg = collectedModel.village.tj_one_shi_price_avg;
    cdCollectedModel.tj_two_shi_price_avg = collectedModel.village.tj_two_shi_price_avg;
    cdCollectedModel.tj_three_shi_price_avg = collectedModel.village.tj_three_shi_price_avg;
    cdCollectedModel.tj_four_shi_price_avg = collectedModel.village.tj_four_shi_price_avg;
    cdCollectedModel.tj_five_shi_price_avg = collectedModel.village.tj_five_shi_price_avg;
    cdCollectedModel.community_rentHouse_num = collectedModel.village.tj_rentHouse_num;
    cdCollectedModel.community_secondHouse_num = collectedModel.village.tj_secondHouse_num;
    cdCollectedModel.tj_condition = collectedModel.village.tj_condition;
    cdCollectedModel.tj_environment = collectedModel.village.tj_environment;
    cdCollectedModel.isSelectedStatus = [NSString stringWithFormat:@"%d",collectedModel.village.isSelectedStatus];
    
    ///清空原记录
    [cdCollectedModel removePhotos:cdCollectedModel.photos];
    if ([collectedModel.village_photo count] > 0) {
        
        for (QSPhotoDataModel *photoModel in collectedModel.village_photo) {
            
            QSCDCollectedCommunityPhotoDataModel *cdPhotoModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_PHOTO inManagedObjectContext:tempContext];
            
            cdPhotoModel.id_ = photoModel.id_;
            cdPhotoModel.type = photoModel.type;
            cdPhotoModel.title = photoModel.title;
            cdPhotoModel.mark = photoModel.mark;
            cdPhotoModel.attach_file = photoModel.attach_file;
            cdPhotoModel.attach_thumb = photoModel.attach_thumb;
            cdPhotoModel.community = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addPhotosObject:cdPhotoModel];
            
        }
        
    }
    
    ///清空记录
    [cdCollectedModel removeHouses:cdCollectedModel.houses];
    if ([collectedModel.house_commend_apartment count] > 0) {
        
        for (QSHouseInfoDataModel *houseModel in collectedModel.house_commend_apartment) {
            
            QSCDCollectedCommunityHouseDataModel *cdHouseModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_HOUSE inManagedObjectContext:tempContext];
            
            cdHouseModel.id_ = houseModel.id_;
            cdHouseModel.user_id = houseModel.user_id;
            cdHouseModel.introduce = houseModel.introduce;
            cdHouseModel.title = houseModel.title;
            cdHouseModel.title_second = houseModel.title_second;
            cdHouseModel.address = houseModel.address;
            cdHouseModel.floor_num = houseModel.floor_num;
            cdHouseModel.property_type = houseModel.property_type;
            cdHouseModel.used_year = houseModel.used_year;
            cdHouseModel.installation = houseModel.installation;
            cdHouseModel.features = houseModel.features;
            cdHouseModel.view_count = houseModel.view_count;
            cdHouseModel.provinceid = houseModel.provinceid;
            cdHouseModel.cityid = houseModel.cityid;
            cdHouseModel.areaid = houseModel.areaid;
            cdHouseModel.street = houseModel.street;
            cdHouseModel.commend = houseModel.commend;
            cdHouseModel.attach_file = houseModel.attach_file;
            cdHouseModel.attach_thumb = houseModel.attach_thumb;
            cdHouseModel.favorite_count = houseModel.favorite_count;
            cdHouseModel.attention_count = houseModel.attention_count;
            cdHouseModel.status = houseModel.status;
            cdHouseModel.name = houseModel.name;
            cdHouseModel.tel = houseModel.tel;
            cdHouseModel.content = houseModel.content;
            cdHouseModel.village_id = houseModel.village_id;
            cdHouseModel.village_name = houseModel.village_name;
            cdHouseModel.building_structure = houseModel.building_structure;
            cdHouseModel.floor_which = houseModel.floor_which;
            cdHouseModel.house_face = houseModel.house_face;
            cdHouseModel.decoration_type = houseModel.decoration_type;
            cdHouseModel.house_area = houseModel.house_area;
            cdHouseModel.house_shi = houseModel.house_shi;
            cdHouseModel.house_ting = houseModel.house_ting;
            cdHouseModel.house_wei = houseModel.house_wei;
            cdHouseModel.house_chufang = houseModel.house_chufang;
            cdHouseModel.house_yangtai = houseModel.house_yangtai;
            cdHouseModel.cycle = houseModel.cycle;
            cdHouseModel.time_interval_start = houseModel.time_interval_start;
            cdHouseModel.time_interval_end = houseModel.time_interval_end;
            cdHouseModel.entrust = houseModel.entrust;
            cdHouseModel.entrust_company = houseModel.entrust_company;
            cdHouseModel.video_url = houseModel.video_url;
            cdHouseModel.negotiated = houseModel.negotiated;
            cdHouseModel.reservation_num = houseModel.reservation_num;
            cdHouseModel.house_no = houseModel.house_no;
            cdHouseModel.building_year = houseModel.building_year;
            cdHouseModel.house_price = houseModel.house_price;
            cdHouseModel.house_nature = houseModel.house_nature;
            cdHouseModel.elevator = houseModel.elevator;
            cdHouseModel.community = cdCollectedModel;
            
            [cdCollectedModel addHousesObject:cdHouseModel];
            
        }
        
    }
    
    ///清空记录
    [cdCollectedModel removeRent_houses:cdCollectedModel.rent_houses];
    if ([collectedModel.house_commend_rent count] > 0) {
        
        for (QSHouseInfoDataModel *houseModel in collectedModel.house_commend_rent) {
            
            QSCDCollectedCommunityRentHouseDataModel *cdHouseModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_RENTHOUSE inManagedObjectContext:tempContext];
            
            cdHouseModel.id_ = houseModel.id_;
            cdHouseModel.user_id = houseModel.user_id;
            cdHouseModel.introduce = houseModel.introduce;
            cdHouseModel.title = houseModel.title;
            cdHouseModel.title_second = houseModel.title_second;
            cdHouseModel.address = houseModel.address;
            cdHouseModel.floor_num = houseModel.floor_num;
            cdHouseModel.property_type = houseModel.property_type;
            cdHouseModel.used_year = houseModel.used_year;
            cdHouseModel.installation = houseModel.installation;
            cdHouseModel.features = houseModel.features;
            cdHouseModel.view_count = houseModel.view_count;
            cdHouseModel.provinceid = houseModel.provinceid;
            cdHouseModel.cityid = houseModel.cityid;
            cdHouseModel.areaid = houseModel.areaid;
            cdHouseModel.street = houseModel.street;
            cdHouseModel.commend = houseModel.commend;
            cdHouseModel.attach_file = houseModel.attach_file;
            cdHouseModel.attach_thumb = houseModel.attach_thumb;
            cdHouseModel.favorite_count = houseModel.favorite_count;
            cdHouseModel.attention_count = houseModel.attention_count;
            cdHouseModel.status = houseModel.status;
            cdHouseModel.name = houseModel.name;
            cdHouseModel.tel = houseModel.tel;
            cdHouseModel.content = houseModel.content;
            cdHouseModel.village_id = houseModel.village_id;
            cdHouseModel.village_name = houseModel.village_name;
            cdHouseModel.building_structure = houseModel.building_structure;
            cdHouseModel.floor_which = houseModel.floor_which;
            cdHouseModel.house_face = houseModel.house_face;
            cdHouseModel.decoration_type = houseModel.decoration_type;
            cdHouseModel.house_area = houseModel.house_area;
            cdHouseModel.house_shi = houseModel.house_shi;
            cdHouseModel.house_ting = houseModel.house_ting;
            cdHouseModel.house_wei = houseModel.house_wei;
            cdHouseModel.house_chufang = houseModel.house_chufang;
            cdHouseModel.house_yangtai = houseModel.house_yangtai;
            cdHouseModel.cycle = houseModel.cycle;
            cdHouseModel.time_interval_start = houseModel.time_interval_start;
            cdHouseModel.time_interval_end = houseModel.time_interval_end;
            cdHouseModel.entrust = houseModel.entrust;
            cdHouseModel.entrust_company = houseModel.entrust_company;
            cdHouseModel.video_url = houseModel.video_url;
            cdHouseModel.negotiated = houseModel.negotiated;
            cdHouseModel.reservation_num = houseModel.reservation_num;
            cdHouseModel.house_no = houseModel.house_no;
            cdHouseModel.building_year = houseModel.building_year;
            cdHouseModel.house_price = houseModel.house_price;
            cdHouseModel.house_nature = houseModel.house_nature;
            cdHouseModel.elevator = houseModel.elevator;
            cdHouseModel.community = cdCollectedModel;
            
            [cdCollectedModel addRent_housesObject:cdHouseModel];
            
        }
        
    }

}

///将本地保存的小区信息转换为页面端可用的数据模型
+ (QSCommunityHouseDetailDataModel *)changeModel_Community_CDModel_T_DetailMode:(QSCDCollectedCommunityDataModel *)cdCollectedModel
{
    
    QSCommunityHouseDetailDataModel *collectedModel = [[QSCommunityHouseDetailDataModel alloc] init];

    collectedModel.village.id_ = cdCollectedModel.id_;
    collectedModel.village.user_id = cdCollectedModel.user_id;
    collectedModel.village.floor_num = cdCollectedModel.floor_num;
    collectedModel.village.title_second = cdCollectedModel.title_second;
    collectedModel.village.title = cdCollectedModel.title;
    collectedModel.village.introduce = cdCollectedModel.introduce;
    collectedModel.village.property_type = cdCollectedModel.property_type;
    collectedModel.village.used_year = cdCollectedModel.used_year;
    collectedModel.village.installation = cdCollectedModel.installation;
    collectedModel.village.features = cdCollectedModel.features;
    collectedModel.village.view_count = cdCollectedModel.view_count;
    collectedModel.village.provinceid = cdCollectedModel.provinceid;
    collectedModel.village.cityid = cdCollectedModel.cityid;
    collectedModel.village.areaid = cdCollectedModel.areaid;
    collectedModel.village.street = cdCollectedModel.street;
    collectedModel.village.commend = cdCollectedModel.commend;
    collectedModel.village.attach_file = cdCollectedModel.attach_file;
    collectedModel.village.attach_thumb = cdCollectedModel.attach_thumb;
    collectedModel.village.favorite_count = cdCollectedModel.favorite_count;
    collectedModel.village.attention_count = cdCollectedModel.attention_count;
    collectedModel.village.status = cdCollectedModel.status;
    collectedModel.village.catalog_id = cdCollectedModel.catalog_id;
    collectedModel.village.building_structure = cdCollectedModel.building_structure;
    collectedModel.village.heating = cdCollectedModel.heating;
    collectedModel.village.company_property = cdCollectedModel.company_property;
    collectedModel.village.company_developer = cdCollectedModel.company_developer;
    collectedModel.village.fee = cdCollectedModel.fee;
    collectedModel.village.water = cdCollectedModel.water;
    collectedModel.village.open_time = cdCollectedModel.open_time;
    collectedModel.village.area_covered = cdCollectedModel.area_covered;
    collectedModel.village.areabuilt = cdCollectedModel.areabuilt;
    collectedModel.village.volume_rate = cdCollectedModel.volume_rate;
    collectedModel.village.green_rate = cdCollectedModel.green_rate;
    collectedModel.village.licence = cdCollectedModel.licence;
    collectedModel.village.parking_lot = cdCollectedModel.parking_lot;
    collectedModel.village.checkin_time = cdCollectedModel.checkin_time;
    collectedModel.village.households_num = cdCollectedModel.households_num;
    collectedModel.village.ladder = cdCollectedModel.ladder;
    collectedModel.village.ladder_family = cdCollectedModel.ladder_family;
    collectedModel.village.building_year = cdCollectedModel.building_year;
    collectedModel.village.traffic_bus = cdCollectedModel.traffic_bus;
    collectedModel.village.traffic_subway = cdCollectedModel.traffic_subway;
    collectedModel.village.reply_count = cdCollectedModel.reply_count;
    collectedModel.village.reply_allow = cdCollectedModel.reply_allow;
    collectedModel.village.buildings_num = cdCollectedModel.buildings_num;
    collectedModel.village.price_avg = cdCollectedModel.price_avg;
    collectedModel.village.tj_last_month_price_avg = cdCollectedModel.tj_last_month_price_avg;
    collectedModel.village.tj_one_shi_price_avg = cdCollectedModel.tj_one_shi_price_avg;
    collectedModel.village.tj_two_shi_price_avg = cdCollectedModel.tj_two_shi_price_avg;
    collectedModel.village.tj_three_shi_price_avg = cdCollectedModel.tj_three_shi_price_avg;
    collectedModel.village.tj_four_shi_price_avg = cdCollectedModel.tj_four_shi_price_avg;
    collectedModel.village.tj_five_shi_price_avg = cdCollectedModel.tj_five_shi_price_avg;
    collectedModel.village.tj_rentHouse_num = cdCollectedModel.community_rentHouse_num;
    collectedModel.village.tj_secondHouse_num = cdCollectedModel.community_secondHouse_num;
    collectedModel.village.tj_condition = cdCollectedModel.tj_condition;
    collectedModel.village.tj_environment = cdCollectedModel.tj_environment;
    collectedModel.village.isSelectedStatus = [cdCollectedModel.isSelectedStatus intValue];
    
    collectedModel.user.id_ = cdCollectedModel.user_id;
    collectedModel.user.sex = cdCollectedModel.sex;
    collectedModel.user.web = cdCollectedModel.web;
    collectedModel.user.vocation = cdCollectedModel.vocation;
    collectedModel.user.qq = cdCollectedModel.qq;
    collectedModel.user.age = cdCollectedModel.age;
    collectedModel.user.idcard = cdCollectedModel.idcard;
    collectedModel.user.tel = cdCollectedModel.tel;
    collectedModel.user.developer_name = cdCollectedModel.developer_name;
    collectedModel.user.developer_intro = cdCollectedModel.developer_intro;
    collectedModel.user.user_type = cdCollectedModel.user_type;
    collectedModel.user.nickname = cdCollectedModel.nickname;
    collectedModel.user.username = cdCollectedModel.username;
    collectedModel.user.avatar = cdCollectedModel.avatar;
    collectedModel.user.email = cdCollectedModel.email;
    collectedModel.user.mobile = cdCollectedModel.mobile;
    collectedModel.user.realname = cdCollectedModel.realname;
    collectedModel.user.tj_secondHouse_num = cdCollectedModel.tj_secondHouse_num;
    collectedModel.user.tj_rentHouse_num = cdCollectedModel.tj_rentHouse_num;
    
    collectedModel.is_syserver = cdCollectedModel.is_syserver;
    
    if ([cdCollectedModel.photos count] > 0) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (QSCDCollectedCommunityPhotoDataModel *cdPhotoModel in collectedModel.village_photo) {
            
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
        
        collectedModel.village_photo = [NSArray arrayWithArray:tempArray];
        
    }
    
    if ([cdCollectedModel.houses count] > 0) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (QSCDCollectedCommunityHouseDataModel *cdHouseModel in cdCollectedModel.houses) {
            
            QSHouseInfoDataModel *houseModel = [[QSHouseInfoDataModel alloc] init];
            
            houseModel.id_ = cdHouseModel.id_;
            houseModel.user_id = cdHouseModel.user_id;
            houseModel.introduce = cdHouseModel.introduce;
            houseModel.title = cdHouseModel.title;
            houseModel.title_second = cdHouseModel.title_second;
            houseModel.address = cdHouseModel.address;
            houseModel.floor_num = cdHouseModel.floor_num;
            houseModel.property_type = cdHouseModel.property_type;
            houseModel.used_year = cdHouseModel.used_year;
            houseModel.installation = cdHouseModel.installation;
            houseModel.features = cdHouseModel.features;
            houseModel.view_count = cdHouseModel.view_count;
            houseModel.provinceid = cdHouseModel.provinceid;
            houseModel.cityid = cdHouseModel.cityid;
            houseModel.areaid = cdHouseModel.areaid;
            houseModel.street = cdHouseModel.street;
            houseModel.commend = cdHouseModel.commend;
            houseModel.attach_file = cdHouseModel.attach_file;
            houseModel.attach_thumb = cdHouseModel.attach_thumb;
            houseModel.favorite_count = cdHouseModel.favorite_count;
            houseModel.attention_count = cdHouseModel.attention_count;
            houseModel.status = cdHouseModel.status;
            houseModel.name = cdHouseModel.name;
            houseModel.tel = cdHouseModel.tel;
            houseModel.content = cdHouseModel.content;
            houseModel.village_id = cdHouseModel.village_id;
            houseModel.village_name = cdHouseModel.village_name;
            houseModel.building_structure = cdHouseModel.building_structure;
            houseModel.floor_which = cdHouseModel.floor_which;
            houseModel.house_face = cdHouseModel.house_face;
            houseModel.decoration_type = cdHouseModel.decoration_type;
            houseModel.house_area = cdHouseModel.house_area;
            houseModel.house_shi = cdHouseModel.house_shi;
            houseModel.house_ting = cdHouseModel.house_ting;
            houseModel.house_wei = cdHouseModel.house_wei;
            houseModel.house_chufang = cdHouseModel.house_chufang;
            houseModel.house_yangtai = cdHouseModel.house_yangtai;
            houseModel.cycle = cdHouseModel.cycle;
            houseModel.time_interval_start = cdHouseModel.time_interval_start;
            houseModel.time_interval_end = cdHouseModel.time_interval_end;
            houseModel.entrust = cdHouseModel.entrust;
            houseModel.entrust_company = cdHouseModel.entrust_company;
            houseModel.video_url = cdHouseModel.video_url;
            houseModel.negotiated = cdHouseModel.negotiated;
            houseModel.reservation_num = cdHouseModel.reservation_num;
            houseModel.house_no = cdHouseModel.house_no;
            houseModel.building_year = cdHouseModel.building_year;
            houseModel.house_price = cdHouseModel.house_price;
            houseModel.house_nature = cdHouseModel.house_nature;
            houseModel.elevator = cdHouseModel.elevator;
            
            [tempArray addObject:houseModel];
            
        }
        collectedModel.house_commend_apartment = [NSArray arrayWithArray:tempArray];
        
    }
    
    if ([cdCollectedModel.rent_houses count] > 0) {
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (QSCDCollectedCommunityRentHouseDataModel *cdHouseModel in cdCollectedModel.rent_houses) {
            
            QSHouseInfoDataModel *houseModel = [[QSHouseInfoDataModel alloc] init];
            
            houseModel.id_ = cdHouseModel.id_;
            houseModel.user_id = cdHouseModel.user_id;
            houseModel.introduce = cdHouseModel.introduce;
            houseModel.title = cdHouseModel.title;
            houseModel.title_second = cdHouseModel.title_second;
            houseModel.address = cdHouseModel.address;
            houseModel.floor_num = cdHouseModel.floor_num;
            houseModel.property_type = cdHouseModel.property_type;
            houseModel.used_year = cdHouseModel.used_year;
            houseModel.installation = cdHouseModel.installation;
            houseModel.features = cdHouseModel.features;
            houseModel.view_count = cdHouseModel.view_count;
            houseModel.provinceid = cdHouseModel.provinceid;
            houseModel.cityid = cdHouseModel.cityid;
            houseModel.areaid = cdHouseModel.areaid;
            houseModel.street = cdHouseModel.street;
            houseModel.commend = cdHouseModel.commend;
            houseModel.attach_file = cdHouseModel.attach_file;
            houseModel.attach_thumb = cdHouseModel.attach_thumb;
            houseModel.favorite_count = cdHouseModel.favorite_count;
            houseModel.attention_count = cdHouseModel.attention_count;
            houseModel.status = cdHouseModel.status;
            houseModel.name = cdHouseModel.name;
            houseModel.tel = cdHouseModel.tel;
            houseModel.content = cdHouseModel.content;
            houseModel.village_id = cdHouseModel.village_id;
            houseModel.village_name = cdHouseModel.village_name;
            houseModel.building_structure = cdHouseModel.building_structure;
            houseModel.floor_which = cdHouseModel.floor_which;
            houseModel.house_face = cdHouseModel.house_face;
            houseModel.decoration_type = cdHouseModel.decoration_type;
            houseModel.house_area = cdHouseModel.house_area;
            houseModel.house_shi = cdHouseModel.house_shi;
            houseModel.house_ting = cdHouseModel.house_ting;
            houseModel.house_wei = cdHouseModel.house_wei;
            houseModel.house_chufang = cdHouseModel.house_chufang;
            houseModel.house_yangtai = cdHouseModel.house_yangtai;
            houseModel.cycle = cdHouseModel.cycle;
            houseModel.time_interval_start = cdHouseModel.time_interval_start;
            houseModel.time_interval_end = cdHouseModel.time_interval_end;
            houseModel.entrust = cdHouseModel.entrust;
            houseModel.entrust_company = cdHouseModel.entrust_company;
            houseModel.video_url = cdHouseModel.video_url;
            houseModel.negotiated = cdHouseModel.negotiated;
            houseModel.reservation_num = cdHouseModel.reservation_num;
            houseModel.house_no = cdHouseModel.house_no;
            houseModel.building_year = cdHouseModel.building_year;
            houseModel.house_price = cdHouseModel.house_price;
            houseModel.house_nature = cdHouseModel.house_nature;
            houseModel.elevator = cdHouseModel.elevator;
            
            [tempArray addObject:houseModel];
            
        }
        collectedModel.house_commend_rent = [NSArray arrayWithArray:tempArray];
        
    }
    
    return collectedModel;

}

///将小区列表的数据模型转换为本地保存的数据模型
+ (void)changeModel_Community_ListMode_T_CDModel:(QSCommunityDataModel *)collectedModel andCDModel:(QSCDCollectedCommunityDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{
    
    cdCollectedModel.id_ = collectedModel.id_;
    cdCollectedModel.user_id = collectedModel.user_id;
    cdCollectedModel.floor_num = collectedModel.floor_num;
    cdCollectedModel.title_second = collectedModel.title_second;
    cdCollectedModel.title = collectedModel.title;
    cdCollectedModel.introduce = collectedModel.introduce;
    cdCollectedModel.property_type = collectedModel.property_type;
    cdCollectedModel.used_year = collectedModel.used_year;
    cdCollectedModel.installation = collectedModel.installation;
    cdCollectedModel.features = collectedModel.features;
    cdCollectedModel.view_count = collectedModel.view_count;
    cdCollectedModel.provinceid = collectedModel.provinceid;
    cdCollectedModel.cityid = collectedModel.cityid;
    cdCollectedModel.areaid = collectedModel.areaid;
    cdCollectedModel.street = collectedModel.street;
    cdCollectedModel.commend = collectedModel.commend;
    cdCollectedModel.attach_file = collectedModel.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.attach_thumb;
    cdCollectedModel.favorite_count = collectedModel.favorite_count;
    cdCollectedModel.attention_count = collectedModel.attention_count;
    cdCollectedModel.status = collectedModel.status;
    cdCollectedModel.catalog_id = collectedModel.catalog_id;
    cdCollectedModel.building_structure = collectedModel.building_structure;
    cdCollectedModel.heating = collectedModel.heating;
    cdCollectedModel.company_property = collectedModel.company_property;
    cdCollectedModel.company_developer = collectedModel.company_developer;
    cdCollectedModel.fee = collectedModel.fee;
    cdCollectedModel.water = collectedModel.water;
    cdCollectedModel.open_time = collectedModel.open_time;
    cdCollectedModel.area_covered = collectedModel.area_covered;
    cdCollectedModel.areabuilt = collectedModel.areabuilt;
    cdCollectedModel.volume_rate = collectedModel.volume_rate;
    cdCollectedModel.green_rate = collectedModel.green_rate;
    cdCollectedModel.licence = collectedModel.licence;
    cdCollectedModel.parking_lot = collectedModel.parking_lot;
    cdCollectedModel.checkin_time = collectedModel.checkin_time;
    cdCollectedModel.households_num = collectedModel.households_num;
    cdCollectedModel.ladder = collectedModel.ladder;
    cdCollectedModel.ladder_family = collectedModel.ladder_family;
    cdCollectedModel.building_year = collectedModel.building_year;
    cdCollectedModel.traffic_bus = collectedModel.traffic_bus;
    cdCollectedModel.traffic_subway = collectedModel.traffic_subway;
    cdCollectedModel.reply_count = collectedModel.reply_count;
    cdCollectedModel.reply_allow = collectedModel.reply_allow;
    cdCollectedModel.buildings_num = collectedModel.buildings_num;
    cdCollectedModel.price_avg = collectedModel.price_avg;
    cdCollectedModel.tj_last_month_price_avg = collectedModel.tj_last_month_price_avg;
    cdCollectedModel.tj_one_shi_price_avg = collectedModel.tj_one_shi_price_avg;
    cdCollectedModel.tj_two_shi_price_avg = collectedModel.tj_two_shi_price_avg;
    cdCollectedModel.tj_three_shi_price_avg = collectedModel.tj_three_shi_price_avg;
    cdCollectedModel.tj_four_shi_price_avg = collectedModel.tj_four_shi_price_avg;
    cdCollectedModel.tj_five_shi_price_avg = collectedModel.tj_five_shi_price_avg;
    cdCollectedModel.community_rentHouse_num = collectedModel.tj_rentHouse_num;
    cdCollectedModel.community_secondHouse_num = collectedModel.tj_secondHouse_num;
    cdCollectedModel.tj_condition = collectedModel.tj_condition;
    cdCollectedModel.tj_environment = collectedModel.tj_environment;
    cdCollectedModel.isSelectedStatus = [NSString stringWithFormat:@"%d",collectedModel.isSelectedStatus];
    cdCollectedModel.is_syserver = collectedModel.is_syserver;
    
}

///将新房的详情数据模型转换为本地保存的数据模型
+ (void)changeModel_NewHouse_DetailMode_T_CDModel:(QSNewHouseDetailDataModel *)collectedModel andCDModel:(QSCDCollectedNewHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
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
    cdCollectedModel.is_syserver = collectedModel.is_syserver;
    
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
    
    ///图片信息
    if ([collectedModel.loupanBuilding_photo count] > 0) {
        
        ///清空原信息
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
        for (QSPhotoDataModel *photoModel in collectedModel.loupanBuilding_photo) {
            
            ///转换模型
            QSCDCollectedNewHousePhotoDataModel *cdPhotoModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_PHOTO inManagedObjectContext:tempContext];
            
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
            QSCDCollectedNewHouseRecommendHousesDataModel *cdHouseTypeModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_RECOMMEND inManagedObjectContext:tempContext];
            
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
            QSCDCollectedNewHouseAllHousesDataModel *cdHouseTypeModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_ALLHOUSE inManagedObjectContext:tempContext];
            
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
            QSCDCollectedNewHouseActivityDataModel *cdActivityModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_NEWHOUSE_COLLECTED_ACTIVITY inManagedObjectContext:tempContext];
            
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

///将本地保存的新房信息，转为页面端显示使用的数据模型
+ (QSNewHouseDetailDataModel *)changeModel_NewHouse_CDModel_T_DetailMode:(QSCDCollectedNewHouseDataModel *)cdCollectedModel
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
    collectedModel.is_syserver = cdCollectedModel.is_syserver;
    
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
        for (QSCDCollectedNewHousePhotoDataModel *cdPhotoModel in cdCollectedModel.photos) {
            
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
        for (QSCDCollectedNewHouseRecommendHousesDataModel *cdHouseTypeModel in cdCollectedModel.recommend_houses) {
            
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
        for (QSCDCollectedNewHouseAllHousesDataModel *cdHouseTypeModel in cdCollectedModel.all_houses) {
            
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
        for (QSCDCollectedNewHouseActivityDataModel *cdActivityModel in cdCollectedModel.activities) {
            
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

///将小区列表的数据模型转换为本地保存的数据模型
+ (void)changeModel_NewHouse_ListMode_T_CDModel:(QSNewHouseInfoDataModel *)collectedModel andCDModel:(QSCDCollectedNewHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{
    
    ///楼盘本身信息
    cdCollectedModel.id_ = collectedModel.loupan_id;
    cdCollectedModel.title = collectedModel.title;
    cdCollectedModel.address = collectedModel.address;
    cdCollectedModel.property_type = collectedModel.property_type;
    cdCollectedModel.used_year = collectedModel.used_year;
    cdCollectedModel.features = collectedModel.features;
    cdCollectedModel.provinceid = collectedModel.provinceid;
    cdCollectedModel.cityid = collectedModel.cityid;
    cdCollectedModel.areaid = collectedModel.areaid;
    cdCollectedModel.street = collectedModel.street;
    cdCollectedModel.attach_file = collectedModel.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.attach_thumb;
    cdCollectedModel.building_structure = collectedModel.building_structure;
    cdCollectedModel.decoration_type = collectedModel.decoration_type;
    cdCollectedModel.is_syserver = collectedModel.is_syserver;
    
    ///具体某一期的信息
    cdCollectedModel.phase_id = collectedModel.loupan_building_id;
    cdCollectedModel.phase_title = collectedModel.title;
    cdCollectedModel.phase_address = collectedModel.address;
    cdCollectedModel.phase_property_type = collectedModel.property_type;
    cdCollectedModel.phase_used_year = collectedModel.used_year;
    cdCollectedModel.phase_features = collectedModel.features;
    cdCollectedModel.phase_provinceid = collectedModel.provinceid;
    cdCollectedModel.phase_cityid = collectedModel.cityid;
    cdCollectedModel.phase_areaid = collectedModel.areaid;
    cdCollectedModel.phase_street = collectedModel.street;
    cdCollectedModel.phase_attach_file = collectedModel.attach_file;
    cdCollectedModel.phase_attach_thumb = collectedModel.attach_thumb;
    cdCollectedModel.phase_loupan_id = collectedModel.loupan_id;
    cdCollectedModel.phase_loupan_periods = collectedModel.loupan_periods;
    cdCollectedModel.phase_price_avg = collectedModel.price_avg;
    cdCollectedModel.phase_min_house_area = collectedModel.min_house_area;
    cdCollectedModel.phase_max_house_area = collectedModel.max_house_area;
    
}

///将显示端的二手房数据转换为本地化的数据模型
+ (void)changeModel_SecondHandHouse_DetailMode_T_CDModel:(QSSecondHouseDetailDataModel *)collectedModel andCDModel:(QSCDCollectedSecondHandHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
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
    cdCollectedModel.is_syserver = collectedModel.is_syserver;
    
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
    cdCollectedModel.comment_id_ = collectedModel.comment.id_;
    cdCollectedModel.comment_user_id = collectedModel.comment.user_id;
    cdCollectedModel.comment_type = collectedModel.comment.type;
    cdCollectedModel.comment_obj_id = collectedModel.comment.obj_id;
    cdCollectedModel.comment_title = collectedModel.comment.title;
    cdCollectedModel.comment_content = collectedModel.comment.content;
    cdCollectedModel.comment_update_time = collectedModel.comment.update_time;
    cdCollectedModel.comment_status = collectedModel.comment.status;
    cdCollectedModel.comment_create_time = collectedModel.comment.create_time;
    cdCollectedModel.comment_num = collectedModel.comment.num;
    cdCollectedModel.comment_user_type = collectedModel.comment.user_type;
    cdCollectedModel.comment_email = collectedModel.comment.email;
    cdCollectedModel.comment_mobile = collectedModel.comment.mobile;
    cdCollectedModel.comment_realname = collectedModel.comment.realname;
    cdCollectedModel.comment_sex = collectedModel.comment.sex;
    cdCollectedModel.comment_avatar = collectedModel.comment.avatar;
    cdCollectedModel.comment_nickname = collectedModel.comment.nickname;
    cdCollectedModel.comment_username = collectedModel.comment.username;
    cdCollectedModel.comment_sign = collectedModel.comment.sign;
    cdCollectedModel.comment_web = collectedModel.comment.web;
    cdCollectedModel.comment_qq = collectedModel.comment.qq;
    cdCollectedModel.comment_age = collectedModel.comment.age;
    cdCollectedModel.comment_idcard = collectedModel.comment.idcard;
    cdCollectedModel.comment_vocation = collectedModel.comment.vocation;
    cdCollectedModel.comment_tj_secondHouse_num = collectedModel.comment.tj_secondHouse_num;
    cdCollectedModel.comment_tj_rentHouse_num = collectedModel.comment.tj_rentHouse_num;
    
    ///图片
    if ([collectedModel.secondHouse_photo count] > 0) {
        
        ///清空原图片
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
        ///遍历添加
        for (QSPhotoDataModel *photoModel in collectedModel.secondHouse_photo) {
            
            QSCDCollectedSecondHandHousePhotoDataModel *cdPhotoModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_SECONDHANDHOUSE_COLLECTED_PHOTO inManagedObjectContext:tempContext];
            
            cdPhotoModel.id_ = photoModel.id_;
            cdPhotoModel.type = photoModel.type;
            cdPhotoModel.title = photoModel.title;
            cdPhotoModel.mark = photoModel.mark;
            cdPhotoModel.attach_file = photoModel.attach_file;
            cdPhotoModel.attach_thumb = photoModel.attach_thumb;
            cdPhotoModel.second_house = cdCollectedModel;
            
            ///加载图片集
            [cdCollectedModel addPhotosObject:cdPhotoModel];
            
        }
        
    } else {
    
        ///清空原图片
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
    
    }

}

///将本地保存的二手房信息，转为页面端显示使用的数据模型
+ (QSSecondHouseDetailDataModel *)changeModel_SecondHandHouse_CDModel_T_DetailMode:(QSCDCollectedSecondHandHouseDataModel *)cdCollectedModel
{
    
    QSSecondHouseDetailDataModel *collectedModel = [[QSSecondHouseDetailDataModel alloc] init];
    collectedModel.house = [[QSWSecondHouseInfoDataModel alloc] init];
    collectedModel.user = [[QSUserSimpleDataModel alloc] init];
    collectedModel.price_changes = [[QSHousePriceChangesDataModel alloc] init];
    collectedModel.comment = [[QSHouseCommentDataModel alloc] init];

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
    collectedModel.is_syserver = cdCollectedModel.is_syserver;
    
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
    
    ///评论信息
    collectedModel.comment.id_ = cdCollectedModel.comment_id_;
    collectedModel.comment.user_id = cdCollectedModel.comment_user_id;
    collectedModel.comment.type = cdCollectedModel.comment_type;
    collectedModel.comment.obj_id = cdCollectedModel.comment_obj_id;
    collectedModel.comment.title = cdCollectedModel.comment_title;
    collectedModel.comment.content = cdCollectedModel.comment_content;
    collectedModel.comment.update_time = cdCollectedModel.comment_update_time;
    collectedModel.comment.status = cdCollectedModel.comment_status;
    collectedModel.comment.create_time = cdCollectedModel.comment_create_time;
    collectedModel.comment.num = cdCollectedModel.comment_num;
    collectedModel.comment.user_type = cdCollectedModel.comment_user_type;
    collectedModel.comment.email = cdCollectedModel.comment_email;
    collectedModel.comment.mobile = cdCollectedModel.comment_mobile;
    collectedModel.comment.realname = cdCollectedModel.comment_realname;
    collectedModel.comment.sex = cdCollectedModel.comment_sex;
    collectedModel.comment.avatar = cdCollectedModel.comment_avatar;
    collectedModel.comment.nickname = cdCollectedModel.comment_nickname;
    collectedModel.comment.username = cdCollectedModel.comment_username;
    collectedModel.comment.sign = cdCollectedModel.comment_sign;
    collectedModel.comment.web = cdCollectedModel.comment_web;
    collectedModel.comment.qq = cdCollectedModel.comment_qq;
    collectedModel.comment.age = cdCollectedModel.comment_age;
    collectedModel.comment.idcard = cdCollectedModel.comment_idcard;
    collectedModel.comment.vocation = cdCollectedModel.comment_vocation;
    collectedModel.comment.tj_secondHouse_num = cdCollectedModel.comment_tj_secondHouse_num;
    collectedModel.comment.tj_rentHouse_num = cdCollectedModel.comment_tj_rentHouse_num;
    
    ///图片
    if ([cdCollectedModel.photos count] > 0) {
        
        ///临时容器
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        ///遍历添加
        for (QSCDCollectedSecondHandHousePhotoDataModel *cdPhotoModel in cdCollectedModel.photos) {
            
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

///将小区列表的数据模型转换为本地保存的数据模型
+ (void)changeModel_SecondHandHouse_ListMode_T_CDModel:(QSHouseInfoDataModel *)collectedModel andCDModel:(QSCDCollectedSecondHandHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{
    
    ///二手房信息
    cdCollectedModel.id_ = collectedModel.id_;
    cdCollectedModel.user_id = collectedModel.user_id;
    cdCollectedModel.introduce = collectedModel.introduce;
    cdCollectedModel.title = collectedModel.title;
    cdCollectedModel.title_second = collectedModel.title_second;
    cdCollectedModel.address = collectedModel.address;
    cdCollectedModel.floor_num = collectedModel.floor_num;
    cdCollectedModel.property_type = collectedModel.property_type;
    cdCollectedModel.used_year = collectedModel.used_year;
    cdCollectedModel.installation = collectedModel.installation;
    cdCollectedModel.features = collectedModel.features;
    cdCollectedModel.view_count = collectedModel.view_count;
    cdCollectedModel.provinceid = collectedModel.provinceid;
    cdCollectedModel.cityid = collectedModel.cityid;
    cdCollectedModel.areaid = collectedModel.areaid;
    cdCollectedModel.street = collectedModel.street;
    cdCollectedModel.commend = collectedModel.commend;
    cdCollectedModel.attach_file = collectedModel.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.attach_thumb;
    cdCollectedModel.favorite_count = collectedModel.favorite_count;
    cdCollectedModel.attention_count = collectedModel.attention_count;
    cdCollectedModel.status = collectedModel.status;
    cdCollectedModel.name = collectedModel.name;
    cdCollectedModel.tel = collectedModel.tel;
    cdCollectedModel.content = collectedModel.content;
    cdCollectedModel.village_id = collectedModel.village_id;
    cdCollectedModel.village_name = collectedModel.village_name;
    cdCollectedModel.building_structure = collectedModel.building_structure;
    cdCollectedModel.floor_which = collectedModel.floor_which;
    cdCollectedModel.house_face = collectedModel.house_face;
    cdCollectedModel.decoration_type = collectedModel.decoration_type;
    cdCollectedModel.house_area = collectedModel.house_area;
    cdCollectedModel.house_shi = collectedModel.house_shi;
    cdCollectedModel.house_ting = collectedModel.house_ting;
    cdCollectedModel.house_wei = collectedModel.house_wei;
    cdCollectedModel.house_chufang = collectedModel.house_chufang;
    cdCollectedModel.house_yangtai = collectedModel.house_yangtai;
    cdCollectedModel.cycle = collectedModel.cycle;
    cdCollectedModel.time_interval_start = collectedModel.time_interval_start;
    cdCollectedModel.time_interval_end = collectedModel.time_interval_end;
    cdCollectedModel.entrust = collectedModel.entrust;
    cdCollectedModel.entrust_company = collectedModel.entrust_company;
    cdCollectedModel.video_url = collectedModel.video_url;
    cdCollectedModel.negotiated = collectedModel.negotiated;
    cdCollectedModel.reservation_num = collectedModel.reservation_num;
    cdCollectedModel.house_no = collectedModel.house_no;
    cdCollectedModel.building_year = collectedModel.building_year;
    cdCollectedModel.house_price = collectedModel.house_price;
    cdCollectedModel.house_nature = collectedModel.house_nature;
    cdCollectedModel.elevator = collectedModel.elevator;
    cdCollectedModel.is_syserver = collectedModel.is_syserver;
    
}

///将显示端的出租房数据转换为本地化的数据模型
+ (void)changeModel_RentHouse_DetailMode_T_CDModel:(QSRentHouseDetailDataModel *)collectedModel andCDModel:(QSCDCollectedRentHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
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
    
    ///评论信息
    cdCollectedModel.comment_id_ = collectedModel.comment.id_;
    cdCollectedModel.comment_user_id = collectedModel.comment.user_id;
    cdCollectedModel.comment_type = collectedModel.comment.type;
    cdCollectedModel.comment_obj_id = collectedModel.comment.obj_id;
    cdCollectedModel.comment_title = collectedModel.comment.title;
    cdCollectedModel.comment_content = collectedModel.comment.content;
    cdCollectedModel.comment_update_time = collectedModel.comment.update_time;
    cdCollectedModel.comment_status = collectedModel.comment.status;
    cdCollectedModel.comment_create_time = collectedModel.comment.create_time;
    cdCollectedModel.comment_num = collectedModel.comment.num;
    cdCollectedModel.comment_user_type = collectedModel.comment.user_type;
    cdCollectedModel.comment_email = collectedModel.comment.email;
    cdCollectedModel.comment_mobile = collectedModel.comment.mobile;
    cdCollectedModel.comment_realname = collectedModel.comment.realname;
    cdCollectedModel.comment_sex = collectedModel.comment.sex;
    cdCollectedModel.comment_avatar = collectedModel.comment.avatar;
    cdCollectedModel.comment_nickname = collectedModel.comment.nickname;
    cdCollectedModel.comment_username = collectedModel.comment.username;
    cdCollectedModel.comment_sign = collectedModel.comment.sign;
    cdCollectedModel.comment_web = collectedModel.comment.web;
    cdCollectedModel.comment_qq = collectedModel.comment.qq;
    cdCollectedModel.comment_age = collectedModel.comment.age;
    cdCollectedModel.comment_idcard = collectedModel.comment.idcard;
    cdCollectedModel.comment_vocation = collectedModel.comment.vocation;
    cdCollectedModel.comment_tj_secondHouse_num = collectedModel.comment.tj_secondHouse_num;
    cdCollectedModel.comment_tj_rentHouse_num = collectedModel.comment.tj_rentHouse_num;
    
    ///图片
    if ([collectedModel.rentHouse_photo count] > 0) {
        
        ///清空原图片
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
        ///遍历添加
        for (QSPhotoDataModel *photoModel in collectedModel.rentHouse_photo) {
            
            QSCDCollectedRentHousePhotoDataModel *cdPhotoModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_RENTHOUSE_COLLECTED_PHOTO inManagedObjectContext:tempContext];
            
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

///将本地保存的二手房信息，转为页面端显示使用的数据模型
+ (QSRentHouseDetailDataModel *)changeModel_RentHouse_CDModel_T_DetailMode:(QSCDCollectedRentHouseDataModel *)cdCollectedModel
{
    
    QSRentHouseDetailDataModel *collectedModel = [[QSRentHouseDetailDataModel alloc] init];
    collectedModel.house = [[QSWRentHouseInfoDataModel alloc] init];
    collectedModel.user = [[QSUserSimpleDataModel alloc] init];
    collectedModel.price_changes = [[QSHousePriceChangesDataModel alloc] init];
    collectedModel.comment = [[QSHouseCommentDataModel alloc] init];
    
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
    
    ///评论信息
    collectedModel.comment.id_ = cdCollectedModel.comment_id_;
    collectedModel.comment.user_id = cdCollectedModel.comment_user_id;
    collectedModel.comment.type = cdCollectedModel.comment_type;
    collectedModel.comment.obj_id = cdCollectedModel.comment_obj_id;
    collectedModel.comment.title = cdCollectedModel.comment_title;
    collectedModel.comment.content = cdCollectedModel.comment_content;
    collectedModel.comment.update_time = cdCollectedModel.comment_update_time;
    collectedModel.comment.status = cdCollectedModel.comment_status;
    collectedModel.comment.create_time = cdCollectedModel.comment_create_time;
    collectedModel.comment.num = cdCollectedModel.comment_num;
    collectedModel.comment.user_type = cdCollectedModel.comment_user_type;
    collectedModel.comment.email = cdCollectedModel.comment_email;
    collectedModel.comment.mobile = cdCollectedModel.comment_mobile;
    collectedModel.comment.realname = cdCollectedModel.comment_realname;
    collectedModel.comment.sex = cdCollectedModel.comment_sex;
    collectedModel.comment.avatar = cdCollectedModel.comment_avatar;
    collectedModel.comment.nickname = cdCollectedModel.comment_nickname;
    collectedModel.comment.username = cdCollectedModel.comment_username;
    collectedModel.comment.sign = cdCollectedModel.comment_sign;
    collectedModel.comment.web = cdCollectedModel.comment_web;
    collectedModel.comment.qq = cdCollectedModel.comment_qq;
    collectedModel.comment.age = cdCollectedModel.comment_age;
    collectedModel.comment.idcard = cdCollectedModel.comment_idcard;
    collectedModel.comment.vocation = cdCollectedModel.comment_vocation;
    collectedModel.comment.tj_secondHouse_num = cdCollectedModel.comment_tj_secondHouse_num;
    collectedModel.comment.tj_rentHouse_num = cdCollectedModel.comment_tj_rentHouse_num;
    
    ///图片
    if ([cdCollectedModel.photos count] > 0) {
        
        ///临时容器
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        ///遍历添加
        for (QSCDCollectedRentHousePhotoDataModel *cdPhotoModel in cdCollectedModel.photos) {
            
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

///将小区列表的数据模型转换为本地保存的数据模型
+ (void)changeModel_RentHouse_ListMode_T_CDModel:(QSRentHouseInfoDataModel *)collectedModel andCDModel:(QSCDCollectedRentHouseDataModel *)cdCollectedModel andOperationContext:(NSManagedObjectContext *)tempContext
{
    
    ///二手房信息
    cdCollectedModel.id_ = collectedModel.id_;
    cdCollectedModel.user_id = collectedModel.user_id;
    cdCollectedModel.introduce = collectedModel.introduce;
    cdCollectedModel.title = collectedModel.title;
    cdCollectedModel.title_second = collectedModel.title_second;
    cdCollectedModel.address = collectedModel.address;
    cdCollectedModel.floor_num = collectedModel.floor_num;
    cdCollectedModel.property_type = collectedModel.property_type;
    cdCollectedModel.used_year = collectedModel.used_year;
    cdCollectedModel.installation = collectedModel.installation;
    cdCollectedModel.features = collectedModel.features;
    cdCollectedModel.view_count = collectedModel.view_count;
    cdCollectedModel.provinceid = collectedModel.provinceid;
    cdCollectedModel.cityid = collectedModel.cityid;
    cdCollectedModel.areaid = collectedModel.areaid;
    cdCollectedModel.street = collectedModel.street;
    cdCollectedModel.commend = collectedModel.commend;
    cdCollectedModel.attach_file = collectedModel.attach_file;
    cdCollectedModel.attach_thumb = collectedModel.attach_thumb;
    cdCollectedModel.favorite_count = collectedModel.favorite_count;
    cdCollectedModel.attention_count = collectedModel.attention_count;
    cdCollectedModel.status = collectedModel.status;
    cdCollectedModel.name = collectedModel.name;
    cdCollectedModel.tel = collectedModel.tel;
    cdCollectedModel.village_id = collectedModel.village_id;
    cdCollectedModel.village_name = collectedModel.village_name;
    cdCollectedModel.floor_which = collectedModel.floor_which;
    cdCollectedModel.house_face = collectedModel.house_face;
    cdCollectedModel.decoration_type = collectedModel.decoration_type;
    cdCollectedModel.house_area = collectedModel.house_area;
    cdCollectedModel.elevator = collectedModel.elevator;
    cdCollectedModel.house_shi = collectedModel.house_shi;
    cdCollectedModel.house_ting = collectedModel.house_ting;
    cdCollectedModel.house_wei = collectedModel.house_wei;
    cdCollectedModel.house_chufang = collectedModel.house_chufang;
    cdCollectedModel.house_yangtai = collectedModel.house_yangtai;
    cdCollectedModel.fee = collectedModel.fee;
    cdCollectedModel.cycle = collectedModel.cycle;
    cdCollectedModel.time_interval_start = collectedModel.time_interval_start;
    cdCollectedModel.time_interval_end = collectedModel.time_interval_end;
    cdCollectedModel.entrust = collectedModel.entrust;
    cdCollectedModel.entrust_company = collectedModel.entrust_company;
    cdCollectedModel.video_url = collectedModel.video_url;
    cdCollectedModel.negotiated = collectedModel.negotiated;
    cdCollectedModel.reservation_num = collectedModel.reservation_num;
    cdCollectedModel.house_no = collectedModel.house_no;
    cdCollectedModel.house_status = collectedModel.house_status;
    cdCollectedModel.rent_price = collectedModel.rent_price;
    cdCollectedModel.payment = collectedModel.payment;
    cdCollectedModel.rent_property = collectedModel.rent_property;
    cdCollectedModel.lead_time = collectedModel.lead_time;
    cdCollectedModel.update_time = collectedModel.update_time;
    cdCollectedModel.is_syserver = collectedModel.is_syserver;
    
}

@end
