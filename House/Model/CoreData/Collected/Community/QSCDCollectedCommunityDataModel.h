//
//  QSCDCollectedCommunityDataModel.h
//  House
//
//  Created by ysmeng on 15/3/19.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 *  @author yangshengmeng, 15-03-19 12:03:22
 *
 *  @brief  小区关注本地保存数据模型
 *
 *  @since  1.0.0
 */
@class QSCDCollectedCommunityHouseDataModel, QSCDCollectedCommunityPhotoDataModel;
@interface QSCDCollectedCommunityDataModel : NSManagedObject

@property (nonatomic, retain) NSString * id_;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * floor_num;
@property (nonatomic, retain) NSString * title_second;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * introduce;
@property (nonatomic, retain) NSString * property_type;
@property (nonatomic, retain) NSString * used_year;
@property (nonatomic, retain) NSString * installation;
@property (nonatomic, retain) NSString * features;
@property (nonatomic, retain) NSString * view_count;
@property (nonatomic, retain) NSString * provinceid;
@property (nonatomic, retain) NSString * cityid;
@property (nonatomic, retain) NSString * areaid;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * commend;
@property (nonatomic, retain) NSString * attach_file;
@property (nonatomic, retain) NSString * attach_thumb;
@property (nonatomic, retain) NSString * favorite_count;
@property (nonatomic, retain) NSString * attention_count;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * web;
@property (nonatomic, retain) NSString * vocation;
@property (nonatomic, retain) NSString * qq;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * idcard;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * developer_name;
@property (nonatomic, retain) NSString * developer_intro;
@property (nonatomic, retain) NSString * user_type;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * realname;
@property (nonatomic, retain) NSString * tj_secondHouse_num;
@property (nonatomic, retain) NSString * tj_rentHouse_num;
@property (nonatomic, retain) NSString * is_syserver;
@property (nonatomic, retain) NSString * catalog_id;
@property (nonatomic, retain) NSString * building_structure;
@property (nonatomic, retain) NSString * heating;
@property (nonatomic, retain) NSString * company_property;
@property (nonatomic, retain) NSString * company_developer;
@property (nonatomic, retain) NSString * fee;
@property (nonatomic, retain) NSString * water;
@property (nonatomic, retain) NSString * open_time;
@property (nonatomic, retain) NSString * area_covered;
@property (nonatomic, retain) NSString * areabuilt;
@property (nonatomic, retain) NSString * volume_rate;
@property (nonatomic, retain) NSString * green_rate;
@property (nonatomic, retain) NSString * licence;
@property (nonatomic, retain) NSString * parking_lot;
@property (nonatomic, retain) NSString * checkin_time;
@property (nonatomic, retain) NSString * households_num;
@property (nonatomic, retain) NSString * ladder;
@property (nonatomic, retain) NSString * ladder_family;
@property (nonatomic, retain) NSString * building_year;
@property (nonatomic, retain) NSString * traffic_bus;
@property (nonatomic, retain) NSString * traffic_subway;
@property (nonatomic, retain) NSString * reply_count;
@property (nonatomic, retain) NSString * reply_allow;
@property (nonatomic, retain) NSString * buildings_num;
@property (nonatomic, retain) NSString * price_avg;
@property (nonatomic, retain) NSString * tj_last_month_price_avg;
@property (nonatomic, retain) NSString * tj_one_shi_price_avg;
@property (nonatomic, retain) NSString * tj_two_shi_price_avg;
@property (nonatomic, retain) NSString * tj_three_shi_price_avg;
@property (nonatomic, retain) NSString * tj_four_shi_price_avg;
@property (nonatomic, retain) NSString * tj_five_shi_price_avg;
@property (nonatomic, retain) NSString * community_secondHouse_num;
@property (nonatomic, retain) NSString * community_rentHouse_num;
@property (nonatomic, retain) NSString * tj_condition;
@property (nonatomic, retain) NSString * tj_environment;
@property (nonatomic, retain) NSString * isSelectedStatus;
@property (nonatomic, retain) NSString * collected_id;

@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *houses;

@end

@interface QSCDCollectedCommunityDataModel (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(QSCDCollectedCommunityPhotoDataModel *)value;
- (void)removePhotosObject:(QSCDCollectedCommunityPhotoDataModel *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addHousesObject:(QSCDCollectedCommunityHouseDataModel *)value;
- (void)removeHousesObject:(QSCDCollectedCommunityHouseDataModel *)value;
- (void)addHouses:(NSSet *)values;
- (void)removeHouses:(NSSet *)values;

@end
