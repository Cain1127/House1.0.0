//
//  QSCoreDataManager+Collected.m
//  House
//
//  Created by ysmeng on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Collected.h"

#import "QSYAppDelegate.h"

#import "QSWCommunityDataModel.h"
#import "QSCommunityHouseDetailDataModel.h"
#import "QSUserBaseInfoDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSHouseInfoDataModel.h"

#import "QSCDCollectedCommunityDataModel.h"
#import "QSCDCollectedCommunityHouseDataModel.h"
#import "QSCDCollectedCommunityPhotoDataModel.h"

///收藏CoreData实体名
#define COREDATA_ENTITYNAME_COMMUNITY_COLLECTED @"QSCDCollectedCommunityDataModel"
#define COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_PHOTO @"QSCDCollectedCommunityPhotoDataModel"
#define COREDATA_ENTITYNAME_COMMUNITY_COLLECTED_HOUSE @"QSCDCollectedCommunityHouseDataModel.h"

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
+ (NSArray *)getLocalCollectedDataSource
{
    
//    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
//    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
//        
//        QSCollectedCommunityDataModel *tempModel = [[QSCollectedCommunityDataModel alloc] init];
//        tempModel.collected_id = obj.collected_id;
//        tempModel.collected_time = obj.collected_time;
//        tempModel.collected_type = obj.collected_type;
//        tempModel.collectid_title = obj.collectid_title;
//        tempModel.collected_status = obj.collected_status;
//        tempModel.collected_old_price = obj.collected_old_price;
//        tempModel.collected_new_price = obj.collected_new_price;
//        
//        [tempResultArray addObject:tempModel];
//        
//    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

+ (NSArray *)getLocalCollectedDataSourceWithType:(FILTER_MAIN_TYPE)type
{

    switch (type) {
            ///新房
        case fFilterMainTypeNewHouse:
            
            return nil;
            
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
            
            return [self getLocalCollectedCommunityWith];
            
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            break;
            
        default:
            break;
    }
    
    return nil;

}

///返回收藏的小区列表
+ (NSArray *)getLocalCollectedCommunityWith
{

    NSArray *tempArray = [self getEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
        
        QSCommunityHouseDetailDataModel *tempModel = [self changeModel_Community_CDModel_T_DetailMode:obj];
        [tempResultArray addObject:tempModel];
        
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
    
//    NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldKey:@"collected_status" andSearchKey:@"0"];
    
    ///转换模型
    NSMutableArray *tempResultArray = [[NSMutableArray alloc] init];
//    for (QSCDCollectedCommunityDataModel *obj in tempArray) {
//        
//        QSCollectedCommunityDataModel *tempModel = [[QSCollectedCommunityDataModel alloc] init];
//        tempModel.collected_id = obj.collected_id;
//        tempModel.collected_time = obj.collected_time;
//        tempModel.collected_type = obj.collected_type;
//        tempModel.collectid_title = obj.collectid_title;
//        tempModel.collected_status = obj.collected_status;
//        tempModel.collected_old_price = obj.collected_old_price;
//        tempModel.collected_new_price = obj.collected_new_price;
//        
//        [tempResultArray addObject:tempModel];
//        
//    }
    
    return [NSArray arrayWithArray:tempResultArray];
    
}

+ (NSArray *)getUncommitedCollectedDataSource:(FILTER_MAIN_TYPE)type
{

    return nil;

}

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

    switch (collectedType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldKey:@"id_" andSearchKey:collectedID];
            if ([tempArray count] > 0) {
                
                return YES;
                
            }
            
            return NO;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
            
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldKey:@"id_" andSearchKey:collectedID];
            if ([tempArray count] > 0) {
                
                NSString *status = [tempArray[0] valueForKey:@"is_syserver"];
                return (([status intValue] == 1) || ([status intValue] == 0)) ? YES : NO;
                
            }
            
            return NO;
            
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
            break;
            
        default:
            break;
    }
    
    return NO;

}

+ (QSCommunityHouseDetailDataModel *)searchCollectedDataWithID:(NSString *)collectedID andCollectedType:(FILTER_MAIN_TYPE)collectedType
{

    switch (collectedType) {
            ///新房
        case fFilterMainTypeNewHouse:
        {
            
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldKey:@"id_" andSearchKey:collectedID];
            if ([tempArray count] > 0) {
                
                return [self changeModel_Community_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
            
        }
            break;
            
            ///小区
        case fFilterMainTypeCommunity:
        {
        
            NSArray *tempArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldKey:@"id_" andSearchKey:collectedID];
            if ([tempArray count] > 0) {
                
                return [self changeModel_Community_CDModel_T_DetailMode:tempArray[0]];
                
            }
            
            return nil;
        
        }
            break;
            
            ///二手房
        case fFilterMainTypeSecondHouse:
            
            break;
            
            ///出租房
        case fFilterMainTypeRentalHouse:
            
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
    
    ///根据不同的类型，保存不同的数据
    if (fFilterMainTypeCommunity == dataType) {
        
        [self saveCommunityCollectedData:collectedModel andCallBack:callBack];
        
    } else {
    
        [self saveHouseCollectedData:collectedModel andType:dataType andCallBack:callBack];
    
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

///根据列表中添加的小区关注数据模型，保存关注信息
+ (void)saveCollectedCommunityWithListModel:(QSCommunityDataModel *)collectedModel andCallBack:(void(^)(BOOL flag))callBack
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@",collectedModel.id_];
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
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedCommunityDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_Community_ListMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
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

///根据详情中添加的小区关注数据模型，保存关注信息
+ (void)saveCollectedCommunityWithDetailModel:(QSCommunityHouseDetailDataModel *)collectedModel  andCallBack:(void(^)(BOOL flag))callBack
{
    
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_ == %@",collectedModel.village.id_];
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
        [tempContext save:&error];
        
    } else {
        
        QSCDCollectedCommunityDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED inManagedObjectContext:tempContext];
        [self changeModel_Community_DetailMode_T_CDModel:collectedModel andCDModel:cdCollectedModel andOperationContext:tempContext];
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

///保存房源信息
+ (void)saveHouseCollectedData:(id)model andType:(FILTER_MAIN_TYPE)type andCallBack:(void(^)(BOOL flag))callBack
{

    

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

    switch (dataType) {
            ///删除小区关注
        case fFilterMainTypeCommunity:
        {
        
            ///获取本地模型
            QSCDCollectedCommunityDataModel *localModel = [self searchEntityWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldName:@"id_" andFieldSearchKey:collectedID];
            
            ///判断本地是否存在
            if (localModel) {
                
                ///判断当前收藏是否已上传服务端：未上传，直接删除
                if ([localModel.is_syserver intValue] == 0) {
                    
                    [self deleteEntityWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                    
                    if (callBack) {
                        
                        callBack(YES);
                        
                    }
                    
                } else {
                
                    ///判断是否已联网删除
                    if (isSyserver) {
                        
                        [self deleteEntityWithKey:COREDATA_ENTITYNAME_COMMUNITY_COLLECTED andFieldName:@"id_" andFieldValue:collectedID andCallBack:callBack];
                        
                        if (callBack) {
                            
                            callBack(YES);
                            
                        }
                        
                    } else {
                    
                        ///将本地的状态改为3
                        QSCommunityHouseDetailDataModel *tempModel = [self changeModel_Community_CDModel_T_DetailMode:localModel];
                        tempModel.is_syserver = @"3";
                        
                        ///保存本地
                        [self saveCollectedCommunityWithDetailModel:tempModel andCallBack:callBack];
                    
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
    
    if ([collectedModel.village_photo count] > 0) {
        
        ///清空原记录
        [cdCollectedModel removePhotos:cdCollectedModel.photos];
        
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
    
    if (collectedModel.house_commend) {
        
        ///清空原记录
        [cdCollectedModel removeHouses:cdCollectedModel.houses];
        
        for (QSHouseInfoDataModel *houseModel in collectedModel.house_commend) {
            
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
        for (QSCDCollectedCommunityHouseDataModel *cdHouseModel in collectedModel.house_commend) {
            
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
        collectedModel.house_commend = [NSArray arrayWithArray:tempArray];
        
    }
    
    return collectedModel;

}

///将房子的详情数据模型转换为本地保存的数据模型
+ (void)changeModel_House_DetailMode_T_CDModel:(QSCommunityDataModel *)collectedModel andCDModel:(QSCDCollectedCommunityDataModel *)cdCollectedModel
{
    
    cdCollectedModel.id_ = collectedModel.id_;
    cdCollectedModel.user_id = collectedModel.user_id;
    cdCollectedModel.floor_num = collectedModel.user_id;
    cdCollectedModel.title_second = collectedModel.id_;
    cdCollectedModel.title = collectedModel.user_id;
    cdCollectedModel.introduce = collectedModel.id_;
    cdCollectedModel.property_type = collectedModel.user_id;
    cdCollectedModel.used_year = collectedModel.id_;
    cdCollectedModel.installation = collectedModel.user_id;
    cdCollectedModel.features = collectedModel.id_;
    cdCollectedModel.view_count = collectedModel.user_id;
    cdCollectedModel.provinceid = collectedModel.id_;
    cdCollectedModel.cityid = collectedModel.user_id;
    cdCollectedModel.areaid = collectedModel.id_;
    cdCollectedModel.street = collectedModel.user_id;
    cdCollectedModel.commend = collectedModel.id_;
    cdCollectedModel.attach_file = collectedModel.user_id;
    cdCollectedModel.attach_thumb = collectedModel.id_;
    cdCollectedModel.favorite_count = collectedModel.user_id;
    cdCollectedModel.attention_count = collectedModel.id_;
    cdCollectedModel.status = collectedModel.user_id;
    cdCollectedModel.sex = collectedModel.id_;
    cdCollectedModel.web = collectedModel.user_id;
    cdCollectedModel.vocation = collectedModel.id_;
    cdCollectedModel.qq = collectedModel.user_id;
    cdCollectedModel.age = collectedModel.user_id;
    cdCollectedModel.idcard = collectedModel.id_;
    cdCollectedModel.tel = collectedModel.user_id;
    cdCollectedModel.developer_name = collectedModel.id_;
    cdCollectedModel.developer_intro = collectedModel.user_id;
    cdCollectedModel.user_type = collectedModel.user_id;
    cdCollectedModel.nickname = collectedModel.id_;
    cdCollectedModel.username = collectedModel.user_id;
    cdCollectedModel.avatar = collectedModel.id_;
    cdCollectedModel.email = collectedModel.user_id;
    cdCollectedModel.mobile = collectedModel.id_;
    cdCollectedModel.realname = collectedModel.user_id;
    cdCollectedModel.tj_secondHouse_num = collectedModel.user_id;
    cdCollectedModel.tj_rentHouse_num = collectedModel.id_;
    cdCollectedModel.is_syserver = collectedModel.user_id;
    
    cdCollectedModel.catalog_id = collectedModel.user_id;
    cdCollectedModel.building_structure = collectedModel.user_id;
    cdCollectedModel.heating = collectedModel.user_id;
    cdCollectedModel.company_property = collectedModel.user_id;
    cdCollectedModel.company_developer = collectedModel.user_id;
    cdCollectedModel.fee = collectedModel.user_id;
    cdCollectedModel.water = collectedModel.user_id;
    cdCollectedModel.open_time = collectedModel.user_id;
    cdCollectedModel.area_covered = collectedModel.user_id;
    cdCollectedModel.areabuilt = collectedModel.user_id;
    cdCollectedModel.volume_rate = collectedModel.user_id;
    cdCollectedModel.green_rate = collectedModel.user_id;
    cdCollectedModel.licence = collectedModel.user_id;
    cdCollectedModel.parking_lot = collectedModel.user_id;
    cdCollectedModel.checkin_time = collectedModel.user_id;
    cdCollectedModel.households_num = collectedModel.user_id;
    cdCollectedModel.ladder = collectedModel.user_id;
    cdCollectedModel.ladder_family = collectedModel.user_id;
    cdCollectedModel.building_year = collectedModel.user_id;
    cdCollectedModel.traffic_bus = collectedModel.user_id;
    cdCollectedModel.traffic_subway = collectedModel.user_id;
    cdCollectedModel.reply_count = collectedModel.user_id;
    cdCollectedModel.reply_allow = collectedModel.user_id;
    cdCollectedModel.buildings_num = collectedModel.user_id;
    cdCollectedModel.price_avg = collectedModel.user_id;
    cdCollectedModel.tj_last_month_price_avg = collectedModel.user_id;
    cdCollectedModel.tj_one_shi_price_avg = collectedModel.user_id;
    cdCollectedModel.tj_two_shi_price_avg = collectedModel.user_id;
    cdCollectedModel.tj_three_shi_price_avg = collectedModel.user_id;
    cdCollectedModel.tj_four_shi_price_avg = collectedModel.user_id;
    cdCollectedModel.tj_five_shi_price_avg = collectedModel.user_id;
    cdCollectedModel.community_rentHouse_num = collectedModel.user_id;
    cdCollectedModel.community_secondHouse_num = collectedModel.user_id;
    cdCollectedModel.tj_condition = collectedModel.user_id;
    cdCollectedModel.tj_environment = collectedModel.user_id;
//    cdCollectedModel.isSelected = collectedModel.user_id;
    
//    cdCollectedModel.photos = collectedModel.id_;
//    cdCollectedModel.houses = collectedModel.user_id;
    
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

@end
