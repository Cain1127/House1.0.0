//
//  QSSecondHouseDetailDataModel.m
//  House
//
//  Created by 王树朋 on 15/3/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSecondHouseDetailDataModel.h"
#import "QSHousePriceChangesDataModel.h"
#import "QSUserSimpleDataModel.h"
#import "QSWSecondHouseInfoDataModel.h"
#import "QSPhotoDataModel.h"
#import "QSDetailCommentListReturnData.h"
#import "QSRateDataModel.h"

#import "NSString+Calculation.h"

#import "QSReleaseSaleHouseDataModel.h"
#import "QSBaseConfigurationDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+House.h"

@implementation QSSecondHouseDetailDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = nil;
    shared_mapping = [RKObjectMapping mappingForClass:[self class]];
    
    ///房子信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"house" toKeyPath:@"house" withMapping:[QSWSecondHouseInfoDataModel objectMapping]]];
    
    
    ///业主
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[QSUserSimpleDataModel objectMapping]]];
    
    ///价格变动
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"price_changes" toKeyPath:@"price_changes" withMapping:[QSHousePriceChangesDataModel objectMapping]]];
    
    ///评论
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"comment" toKeyPath:@"comment" withMapping:[QSDetailCommentListReturnData objectMapping]]];
    
    ///图片
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"secondHouse_photo" toKeyPath:@"secondHouse_photo" withMapping:[QSPhotoDataModel objectMapping]]];
    
    ///扩展信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"expand_msg" toKeyPath:@"expandInfo" withMapping:[QSSecondHandHouseDetailExpandInfoDataModel objectMapping]]];
    
    ///贷款时，利率相关信息
    [shared_mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"loan" toKeyPath:@"loan" withMapping:[QSRateDataModel objectMapping]]];
    
    return shared_mapping;
    
}

/**
 *  @author yangshengmeng, 15-04-21 16:04:45
 *
 *  @brief  将二手房详情模型，转换为发布物业的数据模型
 *
 *  @since  1.0.0
 */
- (QSReleaseSaleHouseDataModel *)changeToReleaseDataModel
{

    QSReleaseSaleHouseDataModel *tempModel = [[QSReleaseSaleHouseDataModel alloc] init];
    
    tempModel.propertyID = self.house.id_;
    tempModel.propertyStatus = rReleasePropertyStatusUpdate;
    tempModel.trandType = [QSCoreDataManager getHouseTradeTypeWithKey:self.house.property_type];
    tempModel.trandTypeKey = self.house.property_type;
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
    tempModel.salePrice = [NSString stringWithFormat:@"%.2f",[self.house.house_price floatValue] / 10000];
    tempModel.salePriceKey = [NSString stringWithFormat:@"%.2f",[self.house.house_price floatValue] / 10000];
    tempModel.negotiatedPrice = [QSCoreDataManager getHouseIsNegotiatedPriceTypeWithKey:self.house.negotiated];
    tempModel.negotiatedPriceKey = self.house.negotiated;
    tempModel.buildingYear = [NSString stringWithFormat:@"%@年",self.house.building_year];
    tempModel.buildingYearKey = self.house.building_year;
    tempModel.propertyRightYear = [QSCoreDataManager getHousePropertyRightValueWithKey:self.house.used_year];
    tempModel.propertyRightYearKey = self.house.used_year;
    
    tempModel.floor = [QSCoreDataManager getHouseFloorTypeWithKey:self.house.floor_which];
    tempModel.floorKey = self.house.floor_which;
    tempModel.face = [QSCoreDataManager getHouseFaceTypeWithKey:self.house.house_face];
    tempModel.faceKey = self.house.house_face;
    tempModel.decoration = [QSCoreDataManager getHouseDecorationTypeWithKey:self.house.decoration_type];
    tempModel.decorationKey = self.house.decoration_type;
    
    tempModel.title = self.house.title;
    tempModel.detailComment = self.house.introduce;
    tempModel.userName = self.house.name;
    tempModel.phone = self.house.tel;
    tempModel.verCode = nil;
    tempModel.starTime = self.house.time_interval_start;
    tempModel.endTime = self.house.time_interval_end;
    tempModel.video_url = self.house.video_url;
    
    ///房屋性质
    if ([self.house.house_nature length] > 0) {
        
        if (!tempModel.natureList) {
            
            tempModel.natureList = [NSMutableArray array];
            
        }
        
        ///切分配置
        NSMutableString *tempString = [NSMutableString string];
        NSArray *installKeyList = [self.house.house_nature componentsSeparatedByString:@","];
        for (int i = 0;i < [installKeyList count]; i++) {
            
            QSBaseConfigurationDataModel *installationModel = [QSCoreDataManager getHouseNatureModelWithKey:installKeyList[i]];
            [tempString appendString:installationModel.val];
            [tempString appendString:@","];
            [tempModel.natureList addObject:installationModel];
            
        }
        
        if ([tempString length] > 0) {
            
            [tempString deleteCharactersInRange:NSMakeRange(tempString.length - 1, 1)];
            
        }
        tempModel.natureString = [NSString stringWithString:tempString];
        
    }
    
    ///配套
    if ([self.house.installation length] > 0) {
        
        if (!tempModel.installationList) {
            
            tempModel.installationList = [[NSMutableArray alloc] init];
            
        }
        
        ///切分配套
        NSMutableString *tempString = [NSMutableString string];
        NSArray *installKeyList = [self.house.installation componentsSeparatedByString:@","];
        for (int i = 0;i < [installKeyList count]; i++) {
            
            QSBaseConfigurationDataModel *installationModel = [QSCoreDataManager getHouseInstallationModelWithKey:installKeyList[i] andHouseType:fFilterMainTypeSecondHouse];
            [tempString appendString:installationModel.val];
            [tempString appendString:@","];
            [tempModel.installationList addObject:installationModel];
            
        }
        
        if ([tempString length] > 0) {
            
            [tempString deleteCharactersInRange:NSMakeRange(tempString.length - 1, 1)];
            
        }
        tempModel.installationString = [NSString stringWithString:tempString];
        
    }
    
    ///标签
    if ([self.house.features length] > 0) {
        
        if (!tempModel.featuresList) {
            
            tempModel.featuresList = [NSMutableArray array];
            
        }
        
        ///切分标签
        NSArray *installKeyList = [self.house.installation componentsSeparatedByString:@","];
        for (int i = 0;i < [installKeyList count]; i++) {
            
            QSBaseConfigurationDataModel *installationModel = [QSCoreDataManager getHouseFeatureModelWithKey:installKeyList[i] andFilterType:fFilterMainTypeSecondHouse];
            [tempModel.featuresList addObject:installationModel];
            
        }
        
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
    if ([self.secondHouse_photo count] > 0) {
        
        if (!tempModel.imagesList) {
            
            tempModel.imagesList = [[NSMutableArray alloc] init];
            
        }
        
        ///转换模型半保存
        for (int i = 0; i < [self.secondHouse_photo count]; i++) {
            
            QSReleaseSaleHousePhotoDataModel *photoModel = [[QSReleaseSaleHousePhotoDataModel alloc] init];
            QSPhotoDataModel *detailPhotoModel = self.secondHouse_photo[i];
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

@implementation QSSecondHandHouseDetailExpandInfoDataModel

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