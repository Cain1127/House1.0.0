//
//  QSReleaseRentHouseDataModel.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSReleaseRentHouseDataModel.h"
#import "QSCoreDataManager+App.h"
#import "QSBaseConfigurationDataModel.h"

@implementation QSReleaseRentHouseDataModel

#pragma mark - 初始化
///初始化：同时初始化窗口类对象
- (instancetype)init
{
    
    if (self = [super init]) {
        
        ///配套信息数组
        self.installationList = [[NSMutableArray alloc] init];
        
        ///图片集
        self.imagesList = [[NSMutableArray alloc] init];
        
        ///星期几
        self.weekInfos = [[NSMutableArray alloc] init];
        
    }
    
    return self;
    
}

- (NSArray *)getCurrentPickedImages
{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.imagesList count]; i++) {
        
        QSReleaseRentHousePhotoDataModel *tempModel = self.imagesList[i];
        [tempArray addObject:tempModel.image];
        
    }
    
    return [NSArray arrayWithArray:tempArray];
    
}

#pragma mark - 生成发布出租物业的参数
- (NSDictionary *)createReleaseRentHouseParams
{
    
    ///图片参数
    NSMutableArray *photosArray = [[NSMutableArray alloc] init];
    if ([self.imagesList count] > 0) {
        
        for (int i = 0; i < [self.imagesList count]; i++) {
            
            QSReleaseRentHousePhotoDataModel *tempPhotoModel = self.imagesList[i];
            NSDictionary *tempPhotoParam = @{@"attach_file" : APPLICATION_NSSTRING_SETTING(tempPhotoModel.originalImageURL, @""),
                                             @"attach_thumb" : APPLICATION_NSSTRING_SETTING(tempPhotoModel.smallImageURL, @""),
                                             @"type" : [NSString stringWithFormat:@"%d",fFilterMainTypeRentalHouse]};
            [photosArray addObject:tempPhotoParam];
            
        }
        
    }
    
    NSString *cityKey = [QSCoreDataManager getCityKeyWithDitrictKey:self.districtKey];
    NSDictionary *houseParams = @{
          @"cityid" : APPLICATION_NSSTRING_SETTING(cityKey, @""),
          @"areaid" : APPLICATION_NSSTRING_SETTING(self.districtKey, @""),
          @"street" : APPLICATION_NSSTRING_SETTING(self.streetKey, @""),
          @"village_name" : APPLICATION_NSSTRING_SETTING(self.community, @""),
          @"village_id" : APPLICATION_NSSTRING_SETTING(self.communityKey,@""),
          @"address" : APPLICATION_NSSTRING_SETTING(self.address, @""),
          @"house_shi" : APPLICATION_NSSTRING_SETTING(self.houseTypeKey, @""),
          @"house_area" : APPLICATION_NSSTRING_SETTING(self.areaKey, @""),
          @"rent_price" : APPLICATION_NSSTRING_SETTING(self.rentPrice, @""),
          @"payment" : APPLICATION_NSSTRING_SETTING(self.rentPaytypeKey, @""),
          @"negotiated" : APPLICATION_NSSTRING_SETTING(self.whetherBargainingKey, @""),
          @"house_status" : APPLICATION_NSSTRING_SETTING(self.houseStatusKey, @""),
          @"lead_time" : APPLICATION_NSSTRING_SETTING(self.leadTimeKey, @""),
          @"rent_property" : APPLICATION_NSSTRING_SETTING(self.rentTypeKey, @""),
          @"limited" : APPLICATION_NSSTRING_SETTING(self.limitedKey, @""),
          @"floor_which" : APPLICATION_NSSTRING_SETTING(self.floorKey, @""),
          @"house_face" : APPLICATION_NSSTRING_SETTING(self.faceKey, @""),
          @"decoration_type" : APPLICATION_NSSTRING_SETTING(self.decorationKey, @""),
          @"installation" : APPLICATION_NSSTRING_SETTING([self getInstallationPostParams], @""),
          @"fee" : APPLICATION_NSSTRING_SETTING(self.feeKey, @""),
          @"title" : APPLICATION_NSSTRING_SETTING(self.title, @""),
          @"content" : APPLICATION_NSSTRING_SETTING(self.detailComment, @""),
          @"video_url" : APPLICATION_NSSTRING_SETTING(self.video_url, @""),
          @"name" : APPLICATION_NSSTRING_SETTING(self.userName, @""),
          @"tel" : APPLICATION_NSSTRING_SETTING(self.phone, @""),
          @"verCode" : APPLICATION_NSSTRING_SETTING(self.verCode, @""),
          @"cycle" : APPLICATION_NSSTRING_SETTING([self getAppointDatePostParams], @""),
          @"time_interval_start" : APPLICATION_NSSTRING_SETTING(self.starTime, @""),
          @"time_interval_end" : APPLICATION_NSSTRING_SETTING(self.endTime, @""),
          @"entrust" : (self.exclusiveCompany ? @"Y" : @"N"),
          @"entrust_company" : APPLICATION_NSSTRING_SETTING([self.exclusiveCompany valueForKey:@"title"], @"")};
    
    ///返回发布出租房参数
    return @{@"rentHouse_photo" : [NSArray arrayWithArray:photosArray],
             @"rentHouse" : houseParams};
    
}

///可预约周期
- (NSString *)getAppointDatePostParams
{

    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (QSBaseConfigurationDataModel *obj in self.weekInfos) {
        
        [tempString appendString:obj.key];
        [tempString appendString:@","];
        
    }
    
    ///删除最后的分号
    [tempString deleteCharactersInRange:NSMakeRange([tempString length] - 1, 1)];
    
    return [NSString stringWithString:tempString];

}

///返回配置的请求参数
- (NSString *)getInstallationPostParams
{

    NSMutableString *tempString = [[NSMutableString alloc] init];
    for (QSBaseConfigurationDataModel *obj in self.installationList) {
        
        [tempString appendString:obj.key];
        [tempString appendString:@","];
        
    }
    
    ///删除最后的分号
    [tempString deleteCharactersInRange:NSMakeRange([tempString length] - 1, 1)];
    
    return [NSString stringWithString:tempString];

}

@end

@implementation QSReleaseRentHousePhotoDataModel



@end