//
//  QSRentHouseDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRentHouseDetailDataModel.h"
#import "QSHouseCommentDataModel.h"
#import "QSHousePriceChangesDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSWRentHouseInfoDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSReleaseRentHouseDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+House.h"

#import "QSBaseConfigurationDataModel.h"

#import "NSString+Calculation.h"

@implementation QSRentHouseDetailDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///房子信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house" toKeyPath:@"house" withMapping:[QSWRentHouseInfoDataModel objectMapping]]];
   
    ///业主
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[QSUserSimpleDataModel objectMapping]]];
    
   ///价格变动
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price_changes" toKeyPath:@"price_changes" withMapping:[QSHousePriceChangesDataModel objectMapping]]];
    
    ///评论
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comment" toKeyPath:@"comment" withMapping:[QSHouseCommentDataModel objectMapping]]];
    
    ///图片
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rentHouse_photo" toKeyPath:@"rentHouse_photo" withMapping:[QSPhotoDataModel objectMapping]]];
    
    ///扩展信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"expand_msg" toKeyPath:@"expandInfo" withMapping:[QSRentHouseDetailExpandInfoDataModel objectMapping]]];
    
    return shared_mapping;
    
}

/**
 *  @author yangshengmeng, 15-04-17 12:04:40
 *
 *  @brief  将服务端的出租物业数据模型，转为发布物业时使用的临时数据模型
 *
 *  @return 返回发布物业的数据模型
 *
 *  @since  1.0.0
 */
- (QSReleaseRentHouseDataModel *)changeToReleaseDataModel
{
    
    QSReleaseRentHouseDataModel *tempModel = [[QSReleaseRentHouseDataModel alloc] init];
    
    tempModel.propertyID = self.house.id_;
    tempModel.propertyStatus = rReleasePropertyStatusUpdate;
    tempModel.district = [QSCoreDataManager getDistrictValWithDistrictKey:self.house.areaid];
    tempModel.districtKey = self.house.areaid;
    tempModel.street = [QSCoreDataManager getStreetValWithStreetKey:self.house.street];
    tempModel.streetKey = self.house.street;
    tempModel.address = self.house.address;
    tempModel.community = self.house.village_name;
    tempModel.communityKey = self.house.village_id;
    tempModel.houseType = [QSCoreDataManager getHouseTypeValueWithKey:self.house.house_shi];
    tempModel.houseTypeKey = self.house.house_shi;
    tempModel.area = self.house.house_area;
    tempModel.areaKey = self.house.house_area;
    tempModel.rentType = [QSCoreDataManager getHouseRentTypeWithKey:self.house.rent_property];
    tempModel.rentTypeKey = self.house.rent_property;
    tempModel.rentPrice = self.house.rent_price;
    tempModel.rentPriceKey = self.house.rent_price;
    tempModel.rentPaytype = [QSCoreDataManager getHouseRentTypeWithKey:self.house.payment];
    tempModel.rentPaytypeKey = self.house.payment;
    tempModel.leadTime = [QSCoreDataManager getRentHouseLeadTimeTypeWithKey:self.house.lead_time];
    tempModel.leadTimeKey = self.house.lead_time;
    tempModel.whetherBargaining = [QSCoreDataManager getHouseIsNegotiatedPriceTypeWithKey:self.house.negotiated];
    
    tempModel.whetherBargainingKey = self.house.negotiated;
    tempModel.houseStatus = [QSCoreDataManager getRentHouseStatusTypeValueWithKey:self.house.house_status];
    tempModel.houseStatusKey = self.house.house_status;
    tempModel.limited = [QSCoreDataManager getRentHouseLimitedTypeWithKey:self.house.limited];
    tempModel.limitedKey = self.house.limited;
    tempModel.floor = [QSCoreDataManager getHouseFloorTypeWithKey:self.house.floor_which];
    tempModel.floorKey = self.house.floor_which;
    tempModel.face = [QSCoreDataManager getHouseFaceTypeWithKey:self.house.house_face];
    tempModel.faceKey = self.house.house_face;
    tempModel.decoration = [QSCoreDataManager getHouseDecorationTypeWithKey:self.house.decoration_type];
    tempModel.decorationKey = self.house.decoration_type;
    
    tempModel.fee = self.house.fee;
    tempModel.feeKey = self.house.fee;
    tempModel.title = self.house.title;
    tempModel.detailComment = self.house.introduce;
    tempModel.userName = self.house.name;
    tempModel.phone = self.house.tel;
    tempModel.verCode = nil;
    tempModel.starTime = self.house.time_interval_start;
    tempModel.endTime = self.house.time_interval_end;
    tempModel.video_url = self.house.video_url;
    
    ///配置
    if ([self.house.installation length] > 0) {
        
        if (!tempModel.installationList) {
            
            tempModel.installationList = [[NSMutableArray alloc] init];
            
        }
        
        ///切分配置
        NSMutableString *tempString = [NSMutableString string];
        NSArray *installKeyList = [self.house.installation componentsSeparatedByString:@","];
        for (int i = 0;i < [installKeyList count]; i++) {
            
            QSBaseConfigurationDataModel *installationModel = [QSCoreDataManager getHouseInstallationModelWithKey:installKeyList[i] andHouseType:fFilterMainTypeRentalHouse];
            [tempString appendString:installationModel.val];
            [tempString appendString:@","];
            [tempModel.installationList addObject:installationModel];
            
        }
        
        if ([tempString length] > 0) {
            
            [tempString deleteCharactersInRange:NSMakeRange(tempString.length - 1, 1)];
            
        }
        tempModel.installationString = [NSString stringWithString:tempString];
        
    }
    
    ///可以预约日期信息
    if ([self.house.cycle length] > 0) {
        
        if (!tempModel.weekInfos) {
            
            tempModel.weekInfos = [[NSMutableArray alloc] init];
            
        }
        
        NSMutableString *tempString = [NSMutableString string];
        NSArray *weekKeyList = [self.house.cycle componentsSeparatedByString:@","];
        for (int i = 0; i < [weekKeyList count]; i++) {
            
            QSBaseConfigurationDataModel *weekModel = [QSCoreDataManager getWeekPickedModelWithKey:weekKeyList[i]];
            [tempString appendString:weekModel.val];
            [tempString appendString:@","];
            [tempModel.weekInfos addObject:weekModel];
            
        }
        
        if ([tempString length] > 0) {
            
            [tempString deleteCharactersInRange:NSMakeRange(tempString.length - 1, 1)];
            
        }
        tempModel.weekInfoString = [NSString stringWithString:tempString];
        
    }
    
    ///图片
    if ([self.rentHouse_photo count] > 0) {
        
        if (!tempModel.imagesList) {
            
            tempModel.imagesList = [[NSMutableArray alloc] init];
            
        }
        
        ///转换模型半保存
        for (int i = 0; i < [self.rentHouse_photo count]; i++) {
            
            QSReleaseRentHousePhotoDataModel *photoModel = [[QSReleaseRentHousePhotoDataModel alloc] init];
            QSPhotoDataModel *detailPhotoModel = self.rentHouse_photo[i];
            photoModel.originalImageURL = detailPhotoModel.attach_file;
            photoModel.smallImageURL = detailPhotoModel.attach_thumb;
            
            ///请求图片
            NSData *tempData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[detailPhotoModel.attach_file getImageURL]] returningResponse:nil error:nil];
            photoModel.image = [UIImage imageWithData:tempData];
            
            [tempModel.imagesList addObject:photoModel];
            
        }
        
    }
    
    return tempModel;
    
}

@end

@implementation QSRentHouseDetailExpandInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    [shared_mapping addAttributeMappingsFromArray:@[@"total_common_num",
                                                    @"is_book",
                                                    @"is_store"]];
    
    return shared_mapping;
    
}

@end