//
//  QSRentHouseInfoDataModel.m
//  House
//
//  Created by ysmeng on 15/3/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSRentHouseInfoDataModel.h"
#import "QSReleaseRentHouseDataModel.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+House.h"

#import "QSBaseConfigurationDataModel.h"

@implementation QSRentHouseInfoDataModel

///解析规则
+ (RKObjectMapping *)objectMapping
{
    
    RKObjectMapping *shared_mapping = [super objectMapping];
    
    ///在超类的mapping规则之上添加子类mapping
    [shared_mapping addAttributeMappingsFromArray:@[@"name",
                                                    @"tel",
                                                    @"village_id",
                                                    @"village_name",
                                                    @"floor_which",
                                                    
                                                    @"house_face",
                                                    @"decoration_type",
                                                    @"house_area",
                                                    @"elevator",
                                                    @"house_shi",
                                                    @"house_ting",
                                                    @"house_wei",
                                                    @"house_chufang",
                                                    @"house_yangtai",
                                                    @"fee",
                                                    @"cycle",
                                                    @"time_interval_start",
                                                    @"time_interval_end",
                                                    
                                                    @"entrust",
                                                    @"entrust_company",
                                                    @"video_url",
                                                    @"negotiated",
                                                    @"reservation_num",
                                                    @"house_no",
                                                    @"house_status",
                                                    
                                                    @"rent_price",
                                                    @"payment",
                                                    @"rent_property",
                                                    @"lead_time"
                                                    ]];
    
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
    
    tempModel.propertyStatus = rReleasePropertyStatusUpdate;
    tempModel.district = [QSCoreDataManager getDistrictValWithDistrictKey:self.areaid];
    tempModel.districtKey = self.areaid;
    tempModel.street = [QSCoreDataManager getStreetValWithStreetKey:self.street];
    tempModel.streetKey = self.street;
    tempModel.address = self.address;
    tempModel.community = self.village_name;
    tempModel.communityKey = self.village_id;
    tempModel.houseType = [QSCoreDataManager getHouseTypeValueWithKey:self.house_shi];
    tempModel.houseTypeKey = self.house_shi;
    tempModel.area = self.house_area;
    tempModel.areaKey = self.house_area;
    tempModel.rentType = [QSCoreDataManager getHouseRentTypeWithKey:self.rent_property];
    tempModel.rentTypeKey = self.rent_property;
    tempModel.rentPrice = self.rent_price;
    tempModel.rentPriceKey = self.rent_price;
    tempModel.rentPaytype = [QSCoreDataManager getHouseRentTypeWithKey:self.payment];
    tempModel.rentPaytypeKey = self.payment;
    tempModel.leadTime = [QSCoreDataManager getRentHouseLeadTimeTypeWithKey:self.lead_time];
    tempModel.leadTimeKey = self.lead_time;
    tempModel.whetherBargaining = [QSCoreDataManager getHouseIsNegotiatedPriceTypeWithKey:self.negotiated];
    
    tempModel.whetherBargainingKey = self.negotiated;
    tempModel.houseStatus = [QSCoreDataManager getRentHouseStatusTypeValueWithKey:self.house_status];
    tempModel.houseStatusKey = self.house_status;
    tempModel.limited = [QSCoreDataManager getRentHouseLimitedTypeWithKey:self.limited];
    tempModel.limitedKey = self.limited;
    tempModel.floor = [QSCoreDataManager getHouseFloorTypeWithKey:self.floor_which];
    tempModel.floorKey = self.floor_which;
    tempModel.face = [QSCoreDataManager getHouseFaceTypeWithKey:self.house_face];
    tempModel.faceKey = self.house_face;
    tempModel.decoration = [QSCoreDataManager getHouseDecorationTypeWithKey:self.decoration_type];
    tempModel.decorationKey = self.decoration_type;
    
    tempModel.fee = [QSCoreDataManager getHousePropertyManagementFeeValueWithKey:self.fee];
    tempModel.feeKey = self.fee;
    tempModel.title = self.title;
    tempModel.detailComment = self.introduce;
    tempModel.userName = self.name;
    tempModel.phone = self.tel;
    tempModel.verCode = nil;
    tempModel.starTime = self.time_interval_start;
    tempModel.endTime = self.time_interval_end;
    tempModel.video_url = self.video_url;
    
    ///配置
    if ([self.installation length] > 0) {
        
        if (!tempModel.installationList) {
            
            tempModel.installationList = [[NSMutableArray alloc] init];
            
        }
        
        ///切分配置
        NSMutableString *tempString = [NSMutableString string];
        NSArray *installKeyList = [self.installation componentsSeparatedByString:@","];
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
    if ([self.cycle length] > 0) {
        
        if (!tempModel.weekInfos) {
            
            tempModel.weekInfos = [[NSMutableArray alloc] init];
            
        }
        
        NSString *tempString = [NSMutableString string];
        NSArray *weekKeyList = [self.cycle componentsSeparatedByString:@","];
        for (int i = 0; i < [weekKeyList count]; i++) {
            
            
            
        }
        
    }
    
    return tempModel;

}

@end
